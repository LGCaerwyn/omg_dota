--[[
DotA OMG game mode
]]

if DotAOMG == nil then
	DotAOMG = class({})
end

--------------------------------------------------------------------------------
-- ACTIVATE
--------------------------------------------------------------------------------
function Activate()
	GameRules.DotAOMG = DotAOMG()
	GameRules.DotAOMG:InitGameMode()
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

--------------------------------------------------------------------------------
-- INIT
--------------------------------------------------------------------------------
function DotAOMG:InitGameMode()
	local GameMode = GameRules:GetGameModeEntity()

	-- Enable the standard Dota PvP game rules
	GameRules:SetCustomGameSetupTimeout( 30.0 )
	GameRules:GetGameModeEntity():SetTowerBackdoorProtectionEnabled( true )
	GameRules:SetSameHeroSelectionEnabled( true )
	GameRules:SetHeroSelectionTime( 5.0 )
	GameRules:SetStrategyTime( 10.0 )
	GameRules:SetPreGameTime( 70.0 )
	GameRules:GetGameModeEntity():SetFixedRespawnTime( -1 )
	GameRules:SetUseUniversalShopMode( true )
	--GameRules:SetGoldTickTime( 1.0 )
	GameRules:SetGoldPerTick( 5 )

	-- Register Think
	GameMode:SetContextThink( "DotAOMG:RespawnThink", function() return self:RespawnThink() end, 0.25 )

	-- Register Game Events
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(DotAOMG, 'OnConnectFull'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(DotAOMG, 'OnNPCSpawned'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(DotAOMG, 'OnEntityKilled'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(DotAOMG, 'OnGameRulesStateChange'), self)
	ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(DotAOMG, 'OnPlayerLearnedAbility'), self)

	-- userID map
	self.vUserIDMap = {}
	self.nLowestUserID = 2

	-- Change random seed
	local seed = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
	math.randomseed(tonumber(seed))

	-- Load ability List
	self:LoadAbilityList()

	-- list of players who need a new hero
	self.needHero = {}
	
	self.respawnHero = {}
	
	self.noChange = {}

	print('[RANDOM OMG] Random OMG loaded.')
end

function DotAOMG:RandomHeroPick ()
	print('[RANDOM OMG] RandomHeroPick')
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		if PlayerResource:IsValidPlayer(nPlayerID) then
			--PlayerResource:SetHasRepicked(nPlayerID)
			local player = PlayerResource:GetPlayer(nPlayerID)
			player:MakeRandomHeroSelection()
        end
	end
 end

function DotAOMG:RespawnThink()
	for playerID,hero in pairs( self.respawnHero ) do
		if PlayerResource:IsValidPlayerID(playerID) then
			if IsValidEntity(hero) then
				if hero:IsAlive() then
					table.remove(self.respawnHero, playerID)
					self:ChangeHero(hero,self:ChooseRandomHero())
				end
			end
		end
	end
	return 0.25
end

function DotAOMG:LoadAbilityList()
	local abs = LoadKeyValues("scripts/kv/abilities.kv")
	self.heroListKV = LoadKeyValues("scripts/npc/npc_heroes.txt")
	self.subAbilities = LoadKeyValues("scripts/kv/abilityDeps.kv")

	-- Build list of heroes
	self.heroList = {}
	self.heroListEnabled = {}
	for heroName, values in pairs(self.heroListKV) do
		-- Validate hero name
		if heroName ~= 'Version' and heroName ~= 'npc_dota_hero_base' then
			-- Make sure the hero is enabled
			if values.Enabled == 1 then
				-- Store this unit
				table.insert(self.heroList, heroName)
				self.heroListEnabled[heroName] = 1
			end
		end
	end

	-- Table containing every skill
	self.vAbList = {}
	self.vAbListSort = {}
	self.vAbListLookup = {}

	-- Build skill list
	for k,v in pairs(abs) do
		for kk, vv in pairs(v) do
			-- This comparison is really dodgy for some reason
			if tonumber(vv) == 1 then
				-- Attempt to find the owning hero of this ability
				local heroOwner = self:FindHeroOwner(kk)

				-- Store this skill
				table.insert(self.vAbList, {
					name = kk,
					sort = k,
					hero = heroOwner
				})

				-- Store into the sort container
				if not self.vAbListSort[k] then
					self.vAbListSort[k] = {}
				end

				-- Store the sort reference
				table.insert(self.vAbListSort[k], kk)

				-- Store the reverse lookup
				self.vAbListLookup[kk] = k
			end
		end
	end
end

function DotAOMG:FindHeroOwner(skillName)
	local heroOwner = ""
	for heroName, values in pairs(self.heroListKV) do
		if type(values) == "table" then
			for i = 1, 24 do
				if values["Ability"..i] == skillName then
					heroOwner = heroName
					goto foundHeroName
				end
			end
		end
	end

	::foundHeroName::
	return heroOwner
end

-- The overall game state has changed
function DotAOMG:OnGameRulesStateChange(keys)
	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_INIT then
		print('[RANDOM OMG] DOTA_GAMERULES_STATE_INIT')
	elseif newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
		print('[RANDOM OMG] DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD')
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		print('[RANDOM OMG] DOTA_GAMERULES_STATE_HERO_SELECTION')
		self:RandomHeroPick()
	elseif newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		print('[RANDOM OMG] DOTA_GAMERULES_STATE_STRATEGY_TIME')
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
		print('[RANDOM OMG] DOTA_GAMERULES_STATE_PRE_GAME')
		self:PostLoadPrecache()
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		print('[RANDOM OMG] DOTA_GAMERULES_STATE_GAME_IN_PROGRESS')
	end
end

function DotAOMG:PostLoadPrecache()
	print('[RANDOM OMG] PostLoadPrecaching ...')
	Say(nil, 'PostLoadPrecaching ...', false)
	Say(nil, 'You can\'t enter the game until the precaching is finished!!!', false)
	for _,heroName in pairs( self.heroList ) do
		print('[RANDOM OMG] Precaching Hero: ', heroName)
		PrecacheUnitByNameAsync(heroName, function(unit) end)
	end
end

function DotAOMG:OnConnectFull(keys)
	-- Grab the entity index of this player
	local entIndex = keys.index+1
	local ply = EntIndexToHScript(entIndex)

	local playerID = ply:GetPlayerID()

	-- Store into our map
	self.vUserIDMap[keys.userid] = ply
	self.nLowestUserID = self.nLowestUserID + 1
	
	-- Init player
	self.needHero[playerID] = false
	self.noChange[playerID] = false
end

function DotAOMG:OnNPCSpawned(keys)
	local unit = EntIndexToHScript( keys.entindex )

	if unit and unit:IsRealHero() then
		local playerID = unit:GetPlayerOwnerID()
		if PlayerResource:IsValidPlayerID(playerID) then
			if not self.noChange[playerID] then
				if self.needHero[playerID] then
					self.needHero[playerID] = false
					self.respawnHero[playerID] = unit
				else
					-- Change skills
					self:ApplyBuild(unit)
					unit:SetAbilityPoints(unit:GetLevel())
				end
			else
				self.noChange[playerID] = false
			end
		end
	end
end

function DotAOMG:OnEntityKilled(keys)
	local killedUnit = EntIndexToHScript( keys.entindex_killed )

	if killedUnit and killedUnit:IsRealHero() then
		local playerID = killedUnit:GetPlayerOwnerID()

		-- no new hero if reincarnating
		if killedUnit:IsReincarnating() then
			self.noChange[playerID] = true
		else 
			self.needHero[playerID] = true
		end

		-- fast respawn
		killedUnit:SetTimeUntilRespawn(killedUnit:GetRespawnTime()/5)
	end
end

function DotAOMG:ApplyBuild(hero)
	if hero == nil then
		Say(nil, 'WARNING: Failed to apply a build!', false)
		return
	end

	-- Grab playerID
	local playerID = hero:GetPlayerID()
	if not PlayerResource:IsValidPlayerID(playerID) then
		return
	end

	-- Remove all modifier
	if hero:GetModifierCount() > 0 then
		for i = 0, (hero:GetModifierCount() - 1) do
			print('[RANDOM OMG] Remove modifier:', hero:GetModifierNameByIndex(i))
			hero:RemoveModifierByName(hero:GetModifierNameByIndex(i))
		end
	end
	
	local build = {}
	build[1] = self:GetRandomAbility()
	build[2] = self:GetRandomAbility()
	build[3] = self:GetRandomAbility()
	
	-- Don't use the same ability twice
	while build[1] == build[2] or self.subAbilities[build[2]] do
		 build[2] = self:GetRandomAbility()
	end
	while (build[1] == build[3]) or (build[2] == build[3]) or self.subAbilities[build[3]] do
		 build[3] = self:GetRandomAbility()
	end

	-- Remove all the skills from our hero
	self:RemoveAllSkills(hero)

	-- Give all the abilities in this build
	for k,v in ipairs(build) do
		-- Add to build
		hero:AddAbility(v)
	end

	-- Add spell dependencies
	if self.subAbilities[build[1]] then
		hero:AddAbility(self.subAbilities[build[1]])
	else
		hero:AddAbility('generic_hidden')
	end

	-- Add Ulti
	local ult = self:GetRandomAbility('Ults')
	-- Add spell dependencies
	if self.subAbilities[ult] then
		hero:AddAbility(self.subAbilities[ult])
	else
		hero:AddAbility('generic_hidden')
	end
	hero:AddAbility(ult)

	hero:AddAbility('generic_hidden')
	hero:AddAbility('generic_hidden')
	hero:AddAbility('generic_hidden')

	-- Add talents
	hero:AddAbility('special_bonus_movement_speed_20')
	hero:AddAbility('special_bonus_all_stats_5')
	hero:AddAbility('special_bonus_strength_10')
	hero:AddAbility('special_bonus_intelligence_10')
	hero:AddAbility('special_bonus_movement_speed_40')
	hero:AddAbility('special_bonus_all_stats_10')
	hero:AddAbility('special_bonus_attack_damage_160')
	hero:AddAbility('special_bonus_agility_100')

	-- print all abilities
	--[[
	print('[RANDOM OMG] Hero: ', hero:GetUnitName())
	for index = 0, 23 do
		if hero:GetAbilityByIndex(index) ~= nil then
			abilityName = hero:GetAbilityByIndex(index):GetAbilityName()
			print('[RANDOM OMG] ', index)
			print('[RANDOM OMG] ', abilityName)
		end
	end
	]]
end

function DotAOMG:ChangeHero(hero, newHeroName)
	local playerID = hero:GetPlayerOwnerID()
	local ply = PlayerResource:GetPlayer(playerID)
	if not PlayerResource:IsValidPlayerID(playerID) then
		print('[RANDOM OMG] Invalid playerID')
		return nil
	end
	if ply then
		-- Grab info
		local exp = hero:GetCurrentXP()
		local gold = hero:GetGold()

		local slots = {}
		for i=0, 15 do
			local item = hero:GetItemInSlot(i)
			if item then
				-- Workout purchaser
				local purchaser = -1
				if item:GetPurchaser() ~= hero then
					purchaser = item:GetPurchaser()
				end

				-- Store the item
				slots[i] = {
					purchaser = purchaser,
					purchaseTime = item:GetPurchaseTime(),
					currentCharges = item:GetCurrentCharges(),
					StacksWithOtherOwners = item:StacksWithOtherOwners(),
					cooldown = item:GetCooldownTimeRemaining(),
					sort = item:GetAbilityName()
				}

				-- Remove the item
				hero:RemoveItem(item)
			end
		end

		-- Change the owner of the items owned by the hero to the player
		local courier = PlayerResource:GetNthCourierForTeam(0, PlayerResource:GetTeam(playerID))
		if courier ~= nil then
			for i=0, 5 do
				local item = courier:GetItemInSlot(i)
				if item ~= nil then
					if item:GetPurchaser() == hero then
						item:SetPurchaser(ply)
					end
				end
			end
		end

		-- Replace the hero
		local newHero = PlayerResource:ReplaceHeroWith(playerID, newHeroName, gold, exp)

		-- Validate new hero
		if newHero then
			-- Set XP, because in ReplaceHeroWith it doesn't work
			newHero:AddExperience (exp, 0, false, false)

			-- Remove TP
			local item = newHero:GetItemInSlot(15)
			if item then
				newHero:RemoveItem(item)
			end

			-- Change the owner of the items back to the new hero
			local courier = PlayerResource:GetNthCourierForTeam(0, PlayerResource:GetTeam(playerID))
			if courier ~= nil then
				for i=0, 5 do
					local item = courier:GetItemInSlot(i)
					if item ~= nil then
						if item:GetPurchaser() == ply then
							item:SetPurchaser(newHero)
						end
					end
				end
			end
			local blockers = {}
			-- Give items
			for i=0, 15 do
				local item = slots[i]
				if item then
					local p = (item.purchaser == -1 and newHero) or item.purchaser
					local it = CreateItem(item.sort, p, p)
					it:SetPurchaseTime(item.purchaseTime)
					it:SetCurrentCharges(item.currentCharges)
					it:SetStacksWithOtherOwners(item.StacksWithOtherOwners)
					it:StartCooldown(item.cooldown)
					newHero:AddItem(it)
				else
					local it = CreateItem('item_blink', newHero, newHero)
					newHero:AddItem(it)
					table.insert(blockers, it)
				end
			end

			-- Remove blocks
			for k,v in pairs(blockers) do
				-- Remove this blocker
				newHero:RemoveItem(v)
			end

			-- Return their new hero
			return newHero
		end
	end
end

function DotAOMG:ChooseRandomHero()
	return self.heroList[math.random(1, #self.heroList)]
end

function DotAOMG:GetRandomAbility(sort)
	if not sort or not self.vAbListSort[sort] then
		sort = 'Abs'
	end

	return self.vAbListSort[sort][math.random(1, #self.vAbListSort[sort])]
end

function DotAOMG:RemoveAllSkills(hero)
	for index = 0, 23 do
		if hero:GetAbilityByIndex(index) ~= nil then
			abilityName = hero:GetAbilityByIndex(index):GetAbilityName()
			hero:RemoveAbility(abilityName)
		end
	end
end

function DotAOMG:OnPlayerLearnedAbility(keys)
	if not PlayerResource:IsValidPlayerID(keys.player - 1) then
		return
	end
	local player = PlayerResource:GetPlayer(keys.player - 1)
	local hero = player:GetAssignedHero()
	if hero or hero:IsRealHero() then
		if keys.abilityname == 'special_bonus_movement_speed_20' then
			hero:SetBaseMoveSpeed(hero:GetBaseMoveSpeed() + 20)
		elseif keys.abilityname == 'special_bonus_all_stats_5' then
			hero:ModifyAgility(5)
			hero:ModifyIntellect(5)
			hero:ModifyStrength(5)
		elseif keys.abilityname == 'special_bonus_strength_10' then
			hero:ModifyStrength(10)
		elseif keys.abilityname == 'special_bonus_intelligence_10' then
			hero:ModifyIntellect(10)
		elseif keys.abilityname == 'special_bonus_movement_speed_40' then
			hero:SetBaseMoveSpeed(hero:GetBaseMoveSpeed() + 40)
		elseif keys.abilityname == 'special_bonus_all_stats_10' then
			hero:ModifyAgility(10)
			hero:ModifyIntellect(10)
			hero:ModifyStrength(10)
		elseif keys.abilityname == 'special_bonus_attack_damage_160' then
			hero:SetBaseDamageMax(hero:GetBaseDamageMax() + 160)
			hero:SetBaseDamageMin(hero:GetBaseDamageMin() + 160)
		elseif keys.abilityname == 'special_bonus_agility_100' then
			hero:ModifyAgility(100)
		end
	end
end
