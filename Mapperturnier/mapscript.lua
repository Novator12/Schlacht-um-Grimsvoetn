--------------------------------------------------------------------------------
-- MapName: XXX
--
-- Author: XXX
--
--------------------------------------------------------------------------------
-- Include main function

Script.Load("data/script/maptools/main.lua");
Script.Load("data/script/maptools/mapeditortools.lua");
Script.Load("data/maps/externalmap/mainmapscript.lua");

gvBasePath = Folders.Map;
Script.Load(gvBasePath.."\\s5CommunityLib\\packer\\devLoad.lua")
table.insert(mcbPacker.Paths, {"data\\maps\\user\\"..Framework.GetCurrentMapName().."\\", ".lua"})
Script.Load(gvBasePath.."\\s5CommunityLib\\lib\\UnlimitedArmySpawnGenerator.lua")
Script.Load(gvBasePath.."\\extraGUI.lua")
Script.Load(gvBasePath.."\\barb_tower.lua")
Script.Load(gvBasePath.."\\modus.lua")
Script.Load(gvBasePath.."\\blende.lua")
Script.Load(gvBasePath.."\\chapter1.lua")
Script.Load(gvBasePath.."\\briefings.lua")
Script.Load(gvBasePath.."\\buildingSelection.lua")
Script.Load(gvBasePath.."\\Debug.lua")



--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the diplomacy states
function InitDiplomacy()
	-- Friendly = 1
	-- Hostile = 3
	-- Neutral = 2
	--Logic.SetDiplomacyState(_player1, _player2, _diplSat)

	Logic.SetDiplomacyState(1, 6, 3)
end


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to init all resources for player(s)
function InitResources()
    -- set some resources
    AddGold  (1000)
    AddSulfur(1000)
    AddIron  (1000)
    AddWood  (1000)	
    AddStone (1000)	
    AddClay  (1000)	
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called to setup Technology states on mission start
function InitTechnologies()
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game is loaded, setup your weather gfx
-- sets here
function InitWeatherGfxSets()

	--InstallS5Hook()
    CppLogic_ResetGlobal()
    GUI_Initialize()
    

	SetupNormalWeatherGfxSet()

	CppLogic.Logic.SetStringTableText("names/CB_Barbarian_Castle1", "Burg")
	CppLogic.Logic.SetStringTableText("names/CB_Barbarian_Castle2", "Festung")
	CppLogic.Logic.SetStringTableText("names/CB_Barbarian_Castle3", "Zitadelle")
    CppLogic.Logic.SetStringTableText("names/CB_Signalfire_Base", "Signalfeuer")
    CppLogic.Logic.SetStringTableText("names/CB_Signalfire_Fire", "Entzündetes Signalfeuer")
    CppLogic.Logic.SetStringTableText("names/PB_VillageCenterBarbarian", "Barbarenlager")
    CppLogic.Logic.SetStringTableText("names/XD_VillageCenter_Building", "Siedlungsbaustelle")
    CppLogic.Logic.SetStringTableText("names/PB_Watchtower_Barb", "Wachturm")
    CppLogic.Logic.SetStringTableText("names/PB_Watchtower_Barb2", "Grenzposten")
    CppLogic.Logic.SetStringTableText("names/XD_WoodPit1", "Holzvorkommen")
    CppLogic.Logic.SetStringTableText("names/PB_WoodMine1", "Holzwerk")
    CppLogic.Logic.SetStringTableText("names/PB_WoodMine2", "Holzwerkstatt")
    CppLogic.Logic.SetStringTableText("names/PB_WoodMine3", "Holzmanufaktur")
	CppLogic.Logic.SetStringTableText("names/CB_Barbarian_Arena", "Barbarenarena")
	
	CppLogic.ModLoader.ReloadGUITexture("data\\graphics\\textures\\gui\\b_select_varg.png")
    CppLogic.ModLoader.ReloadGUITexture("data\\graphics\\textures\\gui\\b_statistics.png")
	CppLogic.ModLoader.ReloadGUITexture("data\\graphics\\textures\\gui\\bg_bottom.dds")
	CppLogic.ModLoader.ReloadGUITexture("data\\graphics\\textures\\gui\\bg_bottom_left.dds")
	CppLogic.ModLoader.ReloadGUITexture("data\\graphics\\textures\\gui\\bg_top.png")
	CppLogic.ModLoader.ReloadGUITexture("data\\graphics\\textures\\gui\\bg_top_heros.png")

    BarbName1 = "Helgar der Barbar"
    BarbName2 = "Wolfgang der Barbar"
    BarbName3 = "Rüdiger der Barbar"
    
    for i=1,3,1 do
        if IsExisting(_G["trupp"..i]) then
        CppLogic.Entity.SetDisplayName(_G["trupp"..i], _G["BarbName"..i])
        end
    end

    if IsExisting(guard) then
    CppLogic.Entity.SetDisplayName(guard, "Mijörn")
    SetEntityOverheadWidget(guard,1)

    XGUIEng.ShowWidget("ChapterInfo", 0)
    XGUIEng.ShowWidget("ChapterInfo_BG", 0)

    end
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start you should setup your weather periods here
function InitWeather()
	AddPeriodicSummer(10)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game to initialize player colors
function InitPlayerColorMapping()
    Logic.SetPlayerRawName(1, "Varg")
	Display.SetPlayerColorMapping(1,NEPHILIM_COLOR)
    Display.SetPlayerColorMapping(6, ROBBERS_COLOR)
    Display.SetPlayerColorMapping(7, KERBEROS_COLOR)
    Display.SetPlayerColorMapping(8, ENEMY_COLOR2)
end
	
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function FirstMapAction()
    
    TriggerFix.AllScriptsLoaded()
	Display.SetRenderLandscapeDebugInfo(0)   --Debug
    ActivateBriefingsExpansion()
    StartSimpleJob("BarbCounter")  --CounterJob für kaufbare Barbaren im BarbarenHQ

    InitBuildingSelection() --Aktivierung der Selectionsüberarbeitung für neue Gebäude
    InitalizeBarbTower()  --Aktivierung der Barbarentürme

	Input.KeyBindDown(Keys.Back, "GUI.SellBuilding(GUI.GetSelectedEntity())", 2); --Löschen mit Backspace Taste 
	
	--Logic.SetTechnologyState(1,Technologies.GT_BarbarianBuildings,3) --Aktivierung der Selektierbarkeit des Baumenüs von Serfs

    --Vulkanfeuer 
	x_vulc,y_vulc = Logic.EntityGetPos(GetID("vulc_middle"))

	local x 
	local y 
	for r = 200,800,100 do
		for a = 0,360, 10 do
		local x = r * math.cos(a) + x_vulc
		local y = r * math.sin(a) + y_vulc
		local id_fire =  GetID(Logic.CreateEntity(Entities.XD_Rock1, x,  y, 0, 0))
		Logic.SetModelAndAnimSet(id_fire ,Models.Effects_XF_HouseFire,nil);
		end
	end
	
	--Leonardos Hütte
	Logic.SetModelAndAnimSet(GetID("leo_hut") ,Models.CB_InventorsHut1,nil);


    --MapStart Funcs
    CreateDynamicFog("Nebel", 0 );
	CreateDynamicFog("fog", 0 );
    Start_Chapter1()
    StartSimpleJob("GetSystemTime")


	---Gebäude auf Spieler 0 
	Score.Player[0] = {buildings=0,all=0}
	MapTools.WallsToPlayerZero(Entities.XD_DarkWallStraightGate,
		Entities.XD_DarkWallStraightGate_Closed, 
		Entities.XD_DarkWallCorner, 
		Entities.XD_DarkWallStraight, 
		Entities.XD_DarkWallDistorted,
		Entities.XD_WallStraightGate,
		Entities.XD_WallStraightGate_Closed, 
		Entities.XD_WallCorner, 
		Entities.XD_WallStraight, 
		Entities.XD_WallDistorted)
    
end






function GetSystemTime()

    local Seconds = Logic.GetTime()
	
	local TotalMinutes = math.floor( Seconds / 60 )
	local Hours = math.floor( TotalMinutes / 60 )
	local Minutes = math.mod( TotalMinutes, 60 )
	local TotalSeconds = math.mod( math.floor(Seconds), 60 )
		
	local String = " "
	
	if Hours > 0 then		
		if Hours < 10 then
			String = String .. "0" .. Hours .. ":"
		else
			String = String .. Hours .. ":"
		end
	elseif Hours == 0 then
		String = String .. "00".. ":"
	end
	
	if Minutes == 0 then
		String = String .. "00" .. ":"
	else
		if Minutes <10 then
			String = String .. "0" .. Minutes .. ":"
		else
			String = String .. Minutes .. ":"
		end
	end
	
	
	if TotalSeconds < 10 then		
		String = String .. "0" .. TotalSeconds	
	else		
		String = String .. TotalSeconds	
	end
    systemtime = String
end




-- Quest data
MapEditor_QuestTitle				= "Yeet"
MapEditor_QuestDescription 	= "Juhu"









------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Comfort function to setup AIs comfortable		Version 1.00						by Tenji
------------------------------------------------------------------------------------------------------------------------------------------------------------
function SetupAI(_aiTable)
 
	-- check input data:
	local ai = _aiTable;
	ai.position = ai.position or ai.headquarters or "";
	assert(ai.id and type(ai.id) == "number");
	assert(type(ai.headquarters) == "table" or "string");
 
	ai.strength = ai.strength or 0;
	ai.range = ai.range or 2500;
	ai.techlevel = ai.techlevel or 0;
	ai.aggressiveness = ai.aggressiveness or 0;
	ai.peacetime = ai.peacetime or 0;
 
	-- setup!
	MapEditor_SetupAI(ai.id, ai.strength, ai.range, ai.techlevel, ai.position, ai.aggressiveness, ai.peacetime);
	if ai.extracting then
		SetupPlayerAi(ai.id, {extracting = 1});
	end
	if _aiTable.repairing then
		SetupPlayerAi(ai.id, {repairing = 1});
	end
 
	-- relationships:
	local notNeutral = {};
	local settings = {};
	if ai.friends then
		table.insert(settings, {setRelation = SetFriendly, input = ai.friends});
	end
	if ai.enemies then
		table.insert(settings, {setRelation = SetHostile, input = ai.enemies});
	end
	if table.getn(settings) == 0 then
		SetNeutral(1, ai.id)
	end
 
	for i = 1, table.getn(settings) do
		if settings[i].input then
			if type(settings[i].input) == "table" then
				for p = 1, table.getn(settings[i].input) do
					settings[i].setRelation(ai.id, settings[i].input[p]);
					table.insert(notNeutral, settings[i].input[p]);
				end
			elseif type(settings[i].input) == "number" then
				settings[i].setRelation(ai.id, settings[i].input);
				table.insert(notNeutral, settings[i].input);
			else
				settings[i].setRelation(1, ai.id);
				table.insert(notNeutral, 1);
			end
		end
	end
	for i = 1, table.getn(notNeutral) do
		local neutral = true;
		for p = 1, 8 do
			if notNeutral[i] == p then
				neutral = false;
			end
		end
		if neutral then
			SetNeutral(ai.id, p);
		end
	end
 
	-- optical settings:
	if ai.name and type(ai.position) == "string" then 
		SetPlayerName(ai.id, ai.name); 
	end
	if ai.color then
		local colorTable = {
			blue = PLAYER_COLOR,
			orange = FRIENDLY_COLOR1, 
			yellow = FRIENDLY_COLOR2, 
			white = FRIENDLY_COLOR3, 
			violet = ENEMY_COLOR1, 
			cyan = ENEMY_COLOR2, 
			red = NEPHILIM_COLOR, 
			green = EVIL_GOVERNOR_COLOR, 
			grey = KERBEROS_COLOR, 
			black = ROBBERS_COLOR, 
			beige = NPC_COLOR,
		};
		local color = colorTable[ai.color] or ai.color;
		assert(type(color) == "number", "SetupAI(): color have to be type string! \n Please pay attention to correct spelling! Available Colors: blue, orange, yellow, white, violet, cyan, red, green, grey, black, beige. \n Or use the global variables if you like.");
		Display.SetPlayerColorMapping(ai.id, color);
	end
	if ai.explore then
		Logic.SetShareExplorationWithPlayerFlag(1, ai.id, 1);
	elseif ai.explore == false then
		Logic.SetShareExplorationWithPlayerFlag(1, ai.id, 0);
	end
 
end


function GetDistance(_a, _b)
	if type(_a) ~= "table" then
		_a = GetPosition(_a); 
	end
	if type(_b) ~= "table" then
		_b = GetPosition(_b); 
	end
	return math.sqrt((_a.X - _b.X)^2+(_a.Y - _b.Y)^2)
end



---Tools aus EMS

MapTools = {};

function MapTools.WallsToPlayerZero(...)
    for _,id in ipairs(CppLogic.Entity.EntityIteratorTableize(CppLogic.Entity.Predicates.OfAnyEntityType(unpack(arg)))) do
        MapTools.ReplaceEntity(id, Logic.GetEntityType(id), 0)
    end
end


function MapTools.ReplaceEntity(_eId, _replaceType, _playerId)
	local pos, ori, name, newEntity, player;
	pos = GetPosition(_eId);
	ori = Logic.GetEntityOrientation(_eId);
	name = Logic.GetEntityName(_eId);
	playerId = Logic.EntityGetPlayer(_eId);
	DestroyEntity(_eId);
	newEntity = Logic.CreateEntity(_replaceType, pos.X, pos.Y, ori, _playerId or playerId);
	if name then
		SetEntityName(newEntity, name);
	end
end