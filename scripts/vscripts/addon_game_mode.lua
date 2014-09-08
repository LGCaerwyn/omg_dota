--[[
Dota PvP game mode
]]
require( "util" )

if DotaPvP == nil then
	DotaPvP = class({})
end

--------------------------------------------------------------------------------
-- ACTIVATE
--------------------------------------------------------------------------------
function Activate()
	GameRules.DotaPvP = DotaPvP()
	GameRules.DotaPvP:InitGameMode()
end

function Precache( context )
	--[[
	This function is used to precache resources/units/items/abilities that will be needed
	for sure in your game and that cannot or should not be precached asynchronously or
	after the game loads.
	]]
	--[[
	print('[RANDOM OMG] Precaching ...')
	local wearables = LoadKeyValues("scripts/items/items_game.txt")
	
	local wearablesList = {}
	local precacheWearables = {}
	for k, v in pairs(wearables) do
		if k == 'items' then
			wearablesList = v
		end
	end
	
	for k, v in pairs(wearablesList) do
		for key, value in pairs(wearablesList[k]) do
			if key == 'model_player' then
				precacheWearables[value] = true
			end
		end
	end
	for wearable,_ in pairs( precacheWearables ) do
		PrecacheResource( "model", wearable, context )
	end
	print('[RANDOM OMG] Done precaching!')
	]]
end

-- disable 'wtf-mode' by default
local wtf_mode = 0
local precache = false

--------------------------------------------------------------------------------
-- INIT
--------------------------------------------------------------------------------
function DotaPvP:InitGameMode()
	local GameMode = GameRules:GetGameModeEntity()

	-- Enable the standard Dota PvP game rules
	GameRules:GetGameModeEntity():SetTowerBackdoorProtectionEnabled( true )
	GameRules:SetSameHeroSelectionEnabled( true )
	GameRules:SetHeroSelectionTime( 0.0 )
	GameRules:SetPreGameTime( 180.0 )
	GameRules:GetGameModeEntity():SetFixedRespawnTime( -1 )

	-- Register Think
	GameMode:SetContextThink( "DotaPvP:GameThink", function() return self:GameThink() end, 0.25 )
	GameMode:SetContextThink( "DotaPvP:RespawnThink", function() return self:RespawnThink() end, 1 )
	GameMode:SetContextThink( "DotaPvP:AdviceThink", function() return self:AdviceThink() end, 60 )

	-- Register Game Events
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(DotaPvP, 'OnConnectFull'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(DotaPvP, 'OnNPCSpawned'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(DotaPvP, 'OnEntityKilled'), self)
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(DotaPvP, 'OnAbilityUsed'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(DotaPvP, 'OnGameRulesStateChange'), self)

	-- Register Commands
	Convars:RegisterCommand( "wtf", Dynamic_Wrap(DotaPvP, 'ToggleWTFMode'), "A console command to toggle the wtf mode", 0 )

	-- userID map
	self.vUserIDMap = {}
	self.nLowestUserID = 2

	-- Change random seed
	local seed = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
	math.randomseed(tonumber(seed))

	-- Load ability List
	self:LoadAbilityList()

	-- list of players with heroes
	self.hasHero = {}

	-- list of players who need a new hero
	self.needHero = {}
	
	self.respawnHero = {}
	
	self.hasCourier = {}
	
	self.noChange = {}

	print( "Random OMG loaded." )
end

--------------------------------------------------------------------------------
function DotaPvP:GameThink()
	for _,ply in pairs( self.vUserIDMap ) do
		local playerID = ply:GetPlayerID()
		if PlayerResource:IsValidPlayerID(playerID) then
			if not self.hasHero[playerID] then
				print('[RANDOM OMG] Try to pick a hero for user:', playerID)
				--CreateHeroForPlayer(self:ChooseRandomHero(),ply)
				ply:MakeRandomHeroSelection()
				PlayerResource:SetHasRepicked(playerID)
				self.hasHero[playerID] = true
				self.needHero[playerID] = false
				print('[RANDOM OMG] Hero picked for user:', playerID)
			end
		end
	end
	return 0.25
end

function DotaPvP:RespawnThink()
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

function DotaPvP:AdviceThink()
	Say(nil, COLOR_DYELLOW..'Hint: If you die and had an item in the courier don\'t take it directly from the courier!!! Drop it to the ground and take it from there.', false)
	return 150
end

function DotaPvP:LoadAbilityList()
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

function DotaPvP:FindHeroOwner(skillName)
	local heroOwner = ""
	for heroName, values in pairs(self.heroListKV) do
		if type(values) == "table" then
			for i = 1, 16 do
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

-- This is an example console command
function DotaPvP:ToggleWTFMode()
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer then
		local playerID = cmdPlayer:GetPlayerID()
		if playerID ~= nil and playerID ~= -1 then
			if GameRules:GetGameTime() > 60 then
				Say(nil, COLOR_RED..'You can modify wtf-mode only in the first 60 seconds.', false)
			else
				if wtf_mode == 0 then
					wtf_mode = 1
					Say(nil, COLOR_BLUE..'WTF enabled!!!', false)
				else	
					wtf_mode = 0
					Say(nil, COLOR_BLUE..'WTF disabled!!!', false)
				end
			end
		end
	end
end

-- The overall game state has changed
function DotaPvP:OnGameRulesStateChange(keys)
	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_INIT then
		print('DOTA_GAMERULES_STATE_INIT')
	elseif newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
		print('DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD')
		precache = true
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		print('DOTA_GAMERULES_STATE_HERO_SELECTION')
	elseif newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		print('DOTA_GAMERULES_STATE_STRATEGY_TIME')
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
		print('DOTA_GAMERULES_STATE_PRE_GAME')
		if precache then
			self:PostLoadPrecache()
		end
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		print('DOTA_GAMERULES_STATE_GAME_IN_PROGRESS')
	end
end

function DotaPvP:PostLoadPrecache()
	print('[RANDOM OMG] PostLoadPrecaching ...')
	Say(nil, COLOR_RED..'PostLoadPrecaching ...', false)
	Say(nil, COLOR_RED..'You can\'t enter the game until the precaching is finished!!!', false)
	for _,heroName in pairs( self.heroList ) do
		PrecacheUnitByNameAsync(heroName, function(...) end)
	end
	print('[RANDOM OMG] Done postLoadPrecaching!')
end

function DotaPvP:OnConnectFull(keys)
	-- Grab the entity index of this player
	local entIndex = keys.index+1
	local ply = EntIndexToHScript(entIndex)

	local playerID = ply:GetPlayerID()

	-- Store into our map
	self.vUserIDMap[keys.userid] = ply
	self.nLowestUserID = self.nLowestUserID + 1
end

function DotaPvP:OnNPCSpawned(keys)
	local unit = EntIndexToHScript( keys.entindex )

	if unit and unit:IsRealHero() then
		local playerID = unit:GetPlayerOwnerID()
		if PlayerResource:IsValidPlayerID(playerID) then
			if not self.noChange[playerID] then
				if not self.hasCourier[unit:GetTeamNumber()] then
					self.hasCourier[unit:GetTeamNumber()] = true
					unit:AddItem(CreateItem('item_courier', unit, unit))
					for i = 0,5 do
						local item = unit:GetItemInSlot(i)
						if item:GetName() == 'item_courier' then
							item:CastAbility()
							break
						end
					end
				end
				if self.needHero[playerID] then
					self.needHero[playerID] = false
					self.respawnHero[playerID] = unit
				else
					-- Change skills
					self:ApplyBuild(unit, {
						[1] = self:GetRandomAbility(),
						[2] = self:GetRandomAbility(),
						[3] = self:GetRandomAbility(),
						[4] = self:GetRandomAbility('Ults')
					})
					unit:SetAbilityPoints(unit:GetLevel())
				end
			else
				self.noChange[playerID] = false
			end
		end
	end
end

function DotaPvP:OnAbilityUsed(keys)
	if wtf_mode == 1 then
		for _,ply in pairs( self.vUserIDMap ) do
			DotaPvP:RefreshAllSkills(ply:GetAssignedHero())
		end
	end
end

function DotaPvP:OnEntityKilled(keys)
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local killerEntity = nil

	if keys.entindex_attacker ~= nil then
		killerEntity = EntIndexToHScript( keys.entindex_attacker )
	end

	if killedUnit and killedUnit:IsRealHero() then
		local playerID = killedUnit:GetPlayerOwnerID()

		-- no new hero if reincarnating
		if killedUnit:IsReincarnating() then
			self.noChange[playerID] = true
		else 
			self.needHero[playerID] = true
		end

		--TODO Check how to enable 'fast respawn'
		--print('GetTimeUntilRespawn()', killedUnit:GetTimeUntilRespawn())
		--killedUnit:SetTimeUntilRespawn(killedUnit:GetTimeUntilRespawn()/2)
		--print('GetTimeUntilRespawn()', killedUnit:GetTimeUntilRespawn())
	end
end

function DotaPvP:ApplyBuild(hero, build)
	if hero == nil then
		if build == nil then
			Say(nil, COLOR_RED..'WARNING: Failed to apply a build!', false)
			return
		end
	end

	-- Grab playerID
	local playerID = hero:GetPlayerID()
	if not PlayerResource:IsValidPlayerID(playerID) then
		return
	end
	
	-- Don't use the same ability twice
	while build[1] == build[2] do
		 build[2] = self:GetRandomAbility()
	end
	while (build[1] == build[3]) or (build[2] == build[3]) do
		 build[3] = self:GetRandomAbility()
	end

	-- Remove all the skills from our hero
	self:RemoveAllSkills(hero)

	-- Table to store all the extra skills we need to give
	local extraSkills = {}

	-- Give all the abilities in this build
	for k,v in ipairs(build) do
		-- Check if this skill has sub abilities
		if self.subAbilities[v] then
			-- Store that we need this skill
			extraSkills[self.subAbilities[v]] = true
			-- TODO: Check if there is a better way to do this
			-- Check if this skill has sub abilities too
			if self.subAbilities[self.subAbilities[v]] then
				-- Store that we need this skill
				extraSkills[self.subAbilities[self.subAbilities[v]]] = true
			end
		end

		-- Add to build
		hero:AddAbility(v)
	end

	-- Add missing abilities
	local i = #build+1
	for k,v in pairs(extraSkills) do
		-- Add the ability
		hero:AddAbility(k)

		-- Move onto the next slot
		i = i + 1
	end

	-- Add skill 'attribute_bonus'
	hero:AddAbility('attribute_bonus')

	-- print all abilities
	--[[print('Hero:', hero:GetUnitName())
	for index = 0, 16 do
		if hero:GetAbilityByIndex(index) ~= nil then
			abilityName = hero:GetAbilityByIndex(index):GetAbilityName()
			print(abilityName)
		end
	end]]
end

function DotaPvP:ChangeHero(hero, newHeroName)
	local playerID = hero:GetPlayerOwnerID()
	local ply = PlayerResource:GetPlayer(playerID)
	if not PlayerResource:IsValidPlayerID(playerID) then
		print('Invalid playerID')
		return nil
	end
	if ply then
		-- Grab info
		local exp = hero:GetCurrentXP()
		local gold = hero:GetGold()

		local slots = {}
		for i=0, 11 do
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

		-- Replace the hero
		local newHero = PlayerResource:ReplaceHeroWith(playerID, newHeroName, gold, exp)

		-- Validate new hero
		if newHero then
			local blockers = {}
			-- Give items
			for i=0, 11 do
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

function DotaPvP:ChooseRandomHero()
	return self.heroList[math.random(1, #self.heroList)]
end

function DotaPvP:GetRandomAbility(sort)
	if not sort or not self.vAbListSort[sort] then
		sort = 'Abs'
	end

	return self.vAbListSort[sort][math.random(1, #self.vAbListSort[sort])]
end

function DotaPvP:RemoveAllSkills(hero)
	for index = 0, 16 do
		if hero:GetAbilityByIndex(index) ~= nil then
			abilityName = hero:GetAbilityByIndex(index):GetAbilityName()
			hero:RemoveAbility(abilityName)
		end
	end
end

function DotaPvP:RefreshAllSkills(hero)
	if hero == nil then
		return
	end

	-- Refresh mana
	hero:GiveMana(99999)
	-- Refresh all skills
	for index = 0, 16 do
		if hero:GetAbilityByIndex(index) ~= nil then
			hero:GetAbilityByIndex(index):EndCooldown()
		end
	end
end