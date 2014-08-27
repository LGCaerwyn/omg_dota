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
	print('Precaching ...')
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
    print('Done precaching!')
end

local wtf_mode = 0

--------------------------------------------------------------------------------
-- INIT
--------------------------------------------------------------------------------
function DotaPvP:InitGameMode()
	local GameMode = GameRules:GetGameModeEntity()

	-- Enable the standard Dota PvP game rules
	GameRules:GetGameModeEntity():SetTowerBackdoorProtectionEnabled( true )
	GameRules:SetSameHeroSelectionEnabled( true )

	-- Register Think
	GameMode:SetContextThink( "DotaPvP:GameThink", function() return self:GameThink() end, 0.25 )

	-- Register Game Events
    ListenToGameEvent('player_connect_full', Dynamic_Wrap(DotaPvP, 'OnConnectFull'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(DotaPvP, 'OnNPCSpawned'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(DotaPvP, 'OnEntityKilled'), self)
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(DotaPvP, 'OnAbilityUsed'), self)
	
	 -- Register Commands
	Convars:RegisterCommand( "wtf", Dynamic_Wrap(DotaPvP, 'ToggleWTFMode'), "A console command to toggle the wtf mode", 0 )
	
    -- userID map
    self.vUserIDMap = {}
    self.nLowestUserID = 2

    -- Load initital Values
    self:_SetInitialValues()
			
	print( "Dota PvP game mode loaded." )
end

function DotaPvP:_SetInitialValues()
    -- Change random seed
    local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
    math.randomseed(tonumber(timeTxt))

    -- Load ability List
    self:LoadAbilityList()

    -- Stores the current skill list for each hero
    self.currentSkillList = {}
end

--------------------------------------------------------------------------------
function DotaPvP:GameThink()
	return 0.25
end

-- This is an example console command
function DotaPvP:ToggleWTFMode()
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer then
		local playerID = cmdPlayer:GetPlayerID()
		if playerID ~= nil and playerID ~= -1 then
			if GameRules:GetGameTime() > 30 then
				Say(nil, COLOR_RED..'You can modify wtf-mode only in the first 30 seconds.', false)
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
		if self:IsValidPlayerID(playerID) then
			local hero = self:ChangeHero(unit,self:ChooseRandomHero())
			if hero == nil then
				self:ApplyBuild(unit, {
					[1] = self:GetRandomAbility(),
					[2] = self:GetRandomAbility(),
					[3] = self:GetRandomAbility(),
					[4] = self:GetRandomAbility('Ults')
				})
			end
		end
    end
end

function DotaPvP:OnAbilityUsed(keys)
    local playerID = EntIndexToHScript( keys.PlayerID )
	
	if wtf_mode == 1 then
		if self:IsValidPlayerID(playerID) then
			DotaPvP:RefreshAllSkills(PlayerResource:GetPlayer(playerID):GetAssignedHero())
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
		--TODO Check how to enable 'fast respawn'
		--print('GetTimeUntilRespawn()', killedUnit:GetTimeUntilRespawn())
		--killedUnit:SetTimeUntilRespawn(killedUnit:GetTimeUntilRespawn()/2)
		--print('GetTimeUntilRespawn()', killedUnit:GetTimeUntilRespawn())
    end
end

-- Loops over all players, return true to stop the loop
function DotaPvP:LoopOverPlayers(callback)
    for k, v in pairs(self.vUserIDMap) do
        -- Validate the player
        if IsValidEntity(v) then
            -- Run the callback
            if callback(v, v:GetPlayerID()) then
                break
            end
        end
    end
end

function DotaPvP:IsValidPlayerID(checkPlayerID)
    local isValid = false
    self:LoopOverPlayers(function(ply, playerID)
        if playerID == checkPlayerID then
            isValid = true
            return true
        end
    end)

    return isValid
end

function DotaPvP:GetPlayerList()
    local plyList = {}

    self:LoopOverPlayers(function(ply, playerID)
        table.insert(plyList, ply)
    end)

    return plyList
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

function DotaPvP:GetRandomAbility(sort)
    if not sort or not self.vAbListSort[sort] then
        sort = 'Abs'
    end

    return self.vAbListSort[sort][math.random(1, #self.vAbListSort[sort])]
end

function DotaPvP:GetHeroSkills(heroClass)
    local skills = {}

    -- Build list of abilities
    for heroName, values in pairs(self.heroListKV) do
        if heroName == heroClass then
            for i = 1, 16 do
                local ab = values["Ability"..i]
                if ab and ab ~= 'attribute_bonus' then
                    table.insert(skills, ab)
                end
            end
        end
    end

    return skills
end

function DotaPvP:RemoveAllSkills(hero)
    -- Check if we've touched this hero before
    if not self.currentSkillList[hero] then
        -- Grab the name of this hero
        local heroClass = hero:GetUnitName()

        local skills = self:GetHeroSkills(heroClass)

        -- Store it
        self.currentSkillList[hero] = skills
    end

    -- Remove all old skills
    for k,v in pairs(self.currentSkillList[hero]) do
        if hero:HasAbility(v) then
            hero:RemoveAbility(v)
        end
    end
end

function DotaPvP:RefreshAllSkills(hero)
	-- Refresh mana
	hero:GiveMana(99999)
    -- Refresh all skills
	for index = 0, 6, 1 do
		if hero:GetAbilityByIndex(index) ~= nil then
			hero:GetAbilityByIndex(index):EndCooldown()
		end
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
    if not self:IsValidPlayerID(playerID) then
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
        end

        -- Add to build
        hero:AddAbility(v)
        self.currentSkillList[hero][k] = v
    end

    -- Add missing abilities
    local i = #build+1
    for k,v in pairs(extraSkills) do
        -- Add the ability
        hero:AddAbility(k)

        -- Store that we have it
        self.currentSkillList[hero][i] = k

        -- Move onto the next slot
        i = i + 1
    end
end

function DotaPvP:ChangeHero(hero, newHeroName)
    local playerID = hero:GetPlayerID()
    local ply = PlayerResource:GetPlayer(playerID)
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
			-- Change skills
			self:ApplyBuild(newHero, {
				[1] = self:GetRandomAbility(),
				[2] = self:GetRandomAbility(),
				[3] = self:GetRandomAbility(),
				[4] = self:GetRandomAbility('Ults')
			})
			
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
    return self.heroList[math.random(1, #self.heroList)]
end