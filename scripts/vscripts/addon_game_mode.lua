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
	--[[print('[RANDOM OMG] Precaching ...')
	-- looks like this isn't working
	--PrecacheUnitByNameSync("npc_precache_everything", context)
	PrecacheUnitByNameSync("npc_dota_hero_abaddon", context)
	PrecacheUnitByNameSync("npc_dota_hero_alchemist", context)
	PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
	PrecacheUnitByNameSync("npc_dota_hero_antimage", context)
	PrecacheUnitByNameSync("npc_dota_hero_axe", context)
	PrecacheUnitByNameSync("npc_dota_hero_bane", context)
	PrecacheUnitByNameSync("npc_dota_hero_batrider", context)
	PrecacheUnitByNameSync("npc_dota_hero_beastmaster", context)
	PrecacheUnitByNameSync("npc_dota_hero_bloodseeker", context)
	PrecacheUnitByNameSync("npc_dota_hero_bounty_hunter", context)
	PrecacheUnitByNameSync("npc_dota_hero_brewmaster", context)
	PrecacheUnitByNameSync("npc_dota_hero_bristleback", context)
	PrecacheUnitByNameSync("npc_dota_hero_broodmother", context)
	PrecacheUnitByNameSync("npc_dota_hero_centaur", context)
	PrecacheUnitByNameSync("npc_dota_hero_chaos_knight", context)
	PrecacheUnitByNameSync("npc_dota_hero_chen", context)
	PrecacheUnitByNameSync("npc_dota_hero_clinkz", context)
	PrecacheUnitByNameSync("npc_dota_hero_crystal_maiden", context)
	PrecacheUnitByNameSync("npc_dota_hero_dark_seer", context)
	PrecacheUnitByNameSync("npc_dota_hero_dazzle", context)
	PrecacheUnitByNameSync("npc_dota_hero_death_prophet", context)
	PrecacheUnitByNameSync("npc_dota_hero_disruptor", context)
	PrecacheUnitByNameSync("npc_dota_hero_doom_bringer", context)
	PrecacheUnitByNameSync("npc_dota_hero_dragon_knight", context)
	PrecacheUnitByNameSync("npc_dota_hero_drow_ranger", context)
	PrecacheUnitByNameSync("npc_dota_hero_earth_spirit", context)
	PrecacheUnitByNameSync("npc_dota_hero_earthshaker", context)
	PrecacheUnitByNameSync("npc_dota_hero_elder_titan", context)
	PrecacheUnitByNameSync("npc_dota_hero_ember_spirit", context)
	PrecacheUnitByNameSync("npc_dota_hero_enchantress", context)
	PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
	PrecacheUnitByNameSync("npc_dota_hero_faceless_void", context)
	PrecacheUnitByNameSync("npc_dota_hero_furion", context)
	PrecacheUnitByNameSync("npc_dota_hero_gyrocopter", context)
	PrecacheUnitByNameSync("npc_dota_hero_huskar", context)
	PrecacheUnitByNameSync("npc_dota_hero_invoker", context)
	PrecacheUnitByNameSync("npc_dota_hero_jakiro", context)
	PrecacheUnitByNameSync("npc_dota_hero_juggernaut", context)
	PrecacheUnitByNameSync("npc_dota_hero_keeper_of_the_light", context)
	PrecacheUnitByNameSync("npc_dota_hero_kunkka", context)
	PrecacheUnitByNameSync("npc_dota_hero_legion_commander", context)
	PrecacheUnitByNameSync("npc_dota_hero_leshrac", context)
	PrecacheUnitByNameSync("npc_dota_hero_lich", context)
	PrecacheUnitByNameSync("npc_dota_hero_life_stealer", context)
	PrecacheUnitByNameSync("npc_dota_hero_lina", context)
	PrecacheUnitByNameSync("npc_dota_hero_lion", context)
	PrecacheUnitByNameSync("npc_dota_hero_lone_druid", context)
	PrecacheUnitByNameSync("npc_dota_hero_luna", context)
	PrecacheUnitByNameSync("npc_dota_hero_lycan", context)
	PrecacheUnitByNameSync("npc_dota_hero_magnataur", context)
	PrecacheUnitByNameSync("npc_dota_hero_medusa", context)
	PrecacheUnitByNameSync("npc_dota_hero_meepo", context)
	PrecacheUnitByNameSync("npc_dota_hero_mirana", context)
	PrecacheUnitByNameSync("npc_dota_hero_morphling", context)
	PrecacheUnitByNameSync("npc_dota_hero_naga_siren", context)
	PrecacheUnitByNameSync("npc_dota_hero_necrolyte", context)
	PrecacheUnitByNameSync("npc_dota_hero_nevermore", context)
	PrecacheUnitByNameSync("npc_dota_hero_night_stalker", context)
	PrecacheUnitByNameSync("npc_dota_hero_nyx_assassin", context)
	PrecacheUnitByNameSync("npc_dota_hero_obsidian_destroyer", context)
	PrecacheUnitByNameSync("npc_dota_hero_ogre_magi", context)
	PrecacheUnitByNameSync("npc_dota_hero_omniknight", context)
	PrecacheUnitByNameSync("npc_dota_hero_phantom_assassin", context)
	PrecacheUnitByNameSync("npc_dota_hero_phantom_lancer", context)
	PrecacheUnitByNameSync("npc_dota_hero_phoenix", context)
	PrecacheUnitByNameSync("npc_dota_hero_puck", context)
	PrecacheUnitByNameSync("npc_dota_hero_pudge", context)
	PrecacheUnitByNameSync("npc_dota_hero_pugna", context)
	PrecacheUnitByNameSync("npc_dota_hero_queenofpain", context)
	PrecacheUnitByNameSync("npc_dota_hero_rattletrap", context)
	PrecacheUnitByNameSync("npc_dota_hero_razor", context)
	PrecacheUnitByNameSync("npc_dota_hero_riki", context)
	PrecacheUnitByNameSync("npc_dota_hero_rubick", context)
	PrecacheUnitByNameSync("npc_dota_hero_sand_king", context)
	PrecacheUnitByNameSync("npc_dota_hero_shadow_demon", context)
	PrecacheUnitByNameSync("npc_dota_hero_shadow_shaman", context)
	PrecacheUnitByNameSync("npc_dota_hero_shredder", context)
	PrecacheUnitByNameSync("npc_dota_hero_silencer", context)
	PrecacheUnitByNameSync("npc_dota_hero_skeleton_king", context)
	PrecacheUnitByNameSync("npc_dota_hero_skywrath_mage", context)
	PrecacheUnitByNameSync("npc_dota_hero_slardar", context)
	PrecacheUnitByNameSync("npc_dota_hero_slark", context)
	PrecacheUnitByNameSync("npc_dota_hero_sniper", context)
	PrecacheUnitByNameSync("npc_dota_hero_spectre", context)
	PrecacheUnitByNameSync("npc_dota_hero_spirit_breaker", context)
	PrecacheUnitByNameSync("npc_dota_hero_storm_spirit", context)
	PrecacheUnitByNameSync("npc_dota_hero_sven", context)
	PrecacheUnitByNameSync("npc_dota_hero_templar_assassin", context)
	PrecacheUnitByNameSync("npc_dota_hero_terrorblade", context)
	PrecacheUnitByNameSync("npc_dota_hero_tidehunter", context)
	PrecacheUnitByNameSync("npc_dota_hero_tinker", context)
	PrecacheUnitByNameSync("npc_dota_hero_tiny", context)
	PrecacheUnitByNameSync("npc_dota_hero_treant", context)
	PrecacheUnitByNameSync("npc_dota_hero_troll_warlord", context)
	PrecacheUnitByNameSync("npc_dota_hero_tusk", context)
	PrecacheUnitByNameSync("npc_dota_hero_undying", context)
	PrecacheUnitByNameSync("npc_dota_hero_ursa", context)
	PrecacheUnitByNameSync("npc_dota_hero_vengefulspirit", context)
	PrecacheUnitByNameSync("npc_dota_hero_venomancer", context)
	PrecacheUnitByNameSync("npc_dota_hero_viper", context)
	PrecacheUnitByNameSync("npc_dota_hero_visage", context)
	PrecacheUnitByNameSync("npc_dota_hero_warlock", context)
	PrecacheUnitByNameSync("npc_dota_hero_weaver", context)
	PrecacheUnitByNameSync("npc_dota_hero_windrunner", context)
	PrecacheUnitByNameSync("npc_dota_hero_wisp", context)
	PrecacheUnitByNameSync("npc_dota_hero_witch_doctor", context)
	PrecacheUnitByNameSync("npc_dota_hero_zuus", context)
	PrecacheUnitByNameSync("npc_dota_hero_techies", context)
	print('[RANDOM OMG] Done precaching!')]]
end

-- disable 'wtf-mode' by default
local wtf_mode = 0

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

	-- store if a hero is already precached
	self.isPrecached = {}
	
	self.respawnHero = {}
	
	self.hasCourier = {}

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
	elseif newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
	elseif newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
		self:PostLoadPrecache()
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
	end
end

function DotaPvP:PostLoadPrecache()
	print('[RANDOM OMG] PostLoadPrecaching ...')
	for _,heroName in pairs( self.heroList ) do
		if not self.isPrecached[heroName] then
			PrecacheUnitByNameAsync(heroName, function(...) end)
			self.isPrecached[heroName] = true
		end
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
		self.needHero[playerID] = true
		
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
	local hero = self.heroList[math.random(1, #self.heroList)]
	-- Precache the hero if needed	
	if not self.isPrecached[hero] then
		print('[RANDOM OMG] Precache', hero)
		PrecacheUnitByNameAsync(hero, function(...) end)
		self.isPrecached[hero] = true
	end
	return hero
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