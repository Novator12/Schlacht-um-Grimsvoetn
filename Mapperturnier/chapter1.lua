

function Start_Chapter1()
    chapterID = 1
    chapterText = "Willkommen in Reynivellir @cr Varg ist an den Ufern von Grimsvötn gelandet und erkundigt sich nach dem Rechten in seiner Heimat."
    StartBlende(
        "@center @color:255,0,0 Schlacht um Grimsvötn", 
        "@center @color:255,255,255 @cr @cr Nach den Ereignissen in Darios Königreich landete Varg mit seinen verbliebenen Truppen in seiner Heimat am Vulkan Grimsvötn in Island. Er und seine Begleiter wollen nun Vargs Geburtsort Reynivellir aufsuchen und sich dort zur Ruhe setzen.", 
        function() ActivateShips() end, 
        2)--muss später höher

    EnableLavaDamage = false; --Schaden in Lava nehmen = AUS
end

function ActivateShips()
    AnfangsBriefing()
    Logic.SetTechnologyState(1,Technologies.B_BarbVillage,0)
    Logic.SetTechnologyState(1,Technologies.B_BarbTower,0)
    Logic.SetTechnologyState(1,Technologies.B_BarbArena,0)
    Logic.SetTechnologyState(1,Technologies.B_Residence,0)
    Logic.SetTechnologyState(1,Technologies.B_Farm,0)
    Logic.SetTechnologyState(1,Technologies.B_University,0)
    Logic.SetTechnologyState(1,Technologies.B_Claymine,0)
    Logic.SetTechnologyState(1,Technologies.B_Woodmine,0)
    Logic.SetTechnologyState(1,Technologies.B_Village,0)
    -- mit Logic.SetTechnologyState(1,Technologies.B_BarbVillage,3) wieder erlaubt
end

function ActivateStartingFog()
    ChangeDynamicFog("Nebel", 3, 5 );
end

---Schwierigkeit
function ModeSelection()
    XGUIEng.ShowWidget("Normal", 0)
    XGUIEng.ShowWidget("Modus", 1)
    mode_text2 = "Willkommen bei Schlacht um Grimsvötn @cr @cr Wählt eure Schwierigkeit, indem ihr auf einen der Punkte auf der Karte zu eurer linken klickt und wählt anschließend den Starten-Knopf."
    mode_text3 = "@center Schwierigkeit @color:0,255,255 -None- @cr @color:255,255,255 Wählt eine Schwierigkeit!"
    GUITextUpdate_RightText()
    GUITextUpdate_BottomText()
    XGUIEng.ShowWidget("ChapterInfo", 1)
    XGUIEng.ShowWidget("ChapterInfo_BG", 1)
end

--Nebelvolk zum Start 

SetupNV = {
    id = 6,
    name = "Nebelkrieger",
    headquarters = "",
    color = "green",
    strength = 4,
    range = 2000,
    techlevel = 4,
    aggressiveness = 4,
    extracting = false,
    repairing = false,
    friends = false,
    enemies = {1},
    explore = false,
}

function CreateNVStart()

    SetupAI(SetupNV)

    nvStartArmy = UnlimitedArmy:New({					
			-- benötigt
			Player = 6,
			Area = 4000,
			-- optional
			AutoDestroyIfEmpty = true,
			TransitAttackMove = true,
			Formation = UnlimitedArmy.Formations.Chaotic,
			--PrepDefense,
			DestroyBridges = false,
			--LeaderFormation,
			AIActive = false,
			--DefendDoNotHelpHeroes,
			AutoRotateRange = 100000,
			--DoNotNormalizeSpeed,
			--IgnoreFleeing,
			--HiResJob,
		})
    nvTypeCounter = 0
    for i = 1, mode, 1 do
            if nvTypeCounter == 0 or nvTypeCounter == 2 then
                nvType = Entities.CU_Evil_LeaderBearman1
            else
                nvType = Entities.CU_Evil_LeaderSkirmisher1
            end
        nvStartArmy:CreateLeaderForArmy(nvType, 16, GetPosition("nv_start_trupp"..i), 0)
        nvTypeCounter = nvTypeCounter+1
    end
    nvStartArmy:AddCommandMove(GetPosition("nv_start_patrol1"), true)
    nvStartArmy:AddCommandWaitForIdle(true)
    nvStartArmy:AddCommandMove(GetPosition("nv_start_patrol2"), true)
    nvStartArmy:AddCommandWaitForIdle(true)
    nvStartArmy:AddCommandMove(GetPosition("nv_start_trupp3"), true)
    nvStartArmy:AddCommandWaitForIdle(true)

   
    
    Logic.AddQuest(1, 1, MAINQUEST_OPEN, "@color:255,0,0 Dorf Reynivellir", "@cr Schaut im Dorf nach dem rechten. Seid jedoch vorsichtig.", 1)
    --Logic.AddQuest(_playerId, _questId, _type, _title, _text, _info)
    --Logic.RemoveQuest(_player, _questId, _info) 
    StartSimpleJob("StartNVAlive")
    StartSimpleJob("VargNearGuard")
    CppLogic.Entity.SetDisplayName(GetID("guard"), "Mijörn")
    SetEntityOverheadWidget(GetID("guard"),1)

end


function VargNearGuard()
    if Logic.CheckEntitiesDistance(GetID(varg),GetID("guard"),4000) == 1 then
        Logic.SetDiplomacyState(8, 6, 3)
        Message("@color:255,0,0 Schlachtet sie alle ab!")
        Logic.GroupAttackMove(GetID("guard"), GetPosition("nv_start_patrol2").X, GetPosition("nv_start_patrol2").Y,0)
        return true;
    end
end


function StartNVAlive()
    if nvStartArmy:IsDead() == -1 then
        Logic.AddQuest(1, 1, MAINQUEST_CLOSED, "@color:255,0,0 Dorf Reynivellir", "@cr Schaut im Dorf nach dem rechten. Seid jedoch vorsichtig.", 1)
        if IsExisting("guard") then
            if IsDead("guard") then
                CppLogic.Entity.Settler.HeroResurrect(GetID("guard"))
            end
        end
        ChangeDynamicFog("Nebel", 0, 5 );
        Message("@color:255,0,0 Hey, ihr dadrüben. Kommt zu mir.") 
        Logic.SetDiplomacyState(8, 6, 2)
        Move(GetID("guard"),GetPosition("guard_pos"))
        GuardBriefing()
        return true;
    end
end



---Banditenlager

SetupBandits = {
    id = 7,
    name = "Banditen",
    headquarters = "",
    color = "black",
    strength = 4,
    range = 2000,
    techlevel = 4,
    aggressiveness = 4,
    extracting = false,
    repairing = false,
    friends = false,
    enemies = {1},
    explore = false,
}

function ActivateBandits()

    SetupAI(SetupBandits)

    if mode == 1 then
        bandit_table = {
            [1] = 1, --Größe der Armee/ Leaderanzahl
            [2] = 120 --Respawnzeit
        }
    elseif mode == 2 then
        bandit_table = {
            [1] = 2, --Größe der Armee/ Leaderanzahl
            [2] = 120 --Respawnzeit
        }
    elseif mode == 3 then
        bandit_table = {
            [1] = 3, --Größe der Armee/ Leaderanzahl
            [2] = 60 --Respawnzeit
        }
    end
    
    for i=1,4,1 do
        _G["BanditArmy"..i] = LazyUnlimitedArmy:New({					
            -- benötigt
            Player = 7,
            Area = 2700,
            -- optional
            AutoDestroyIfEmpty = true,
            TransitAttackMove = true,
            Formation = UnlimitedArmy.Formations.Lines,
            LeaderFormation = 4,
            AIActive = true,
            AutoRotateRange = 100000,
            HiResJob = true
        },i+0,NumberUA)
    

        _G["SpawnerBandit"..i] = UnlimitedArmySpawnGenerator:New(_G["BanditArmy"..i], {
            -- benötigt:
            Position = GetPosition("bandit"..i.."_spawn"), --position
            ArmySize = bandit_table[1], --armysize
            SpawnCounter = bandit_table[2],  --spawncounter
            SpawnLeaders = bandit_table[1],   --spawnleaders
            LeaderDesc = {
                {LeaderType = Entities.CU_BanditLeaderSword1, SoldierNum = 4 , SpawnNum = 1, Looped = true, Experience = 1},
                {LeaderType = Entities.CU_BanditLeaderBow1, SoldierNum = 6 , SpawnNum = 2, Looped = true, Experience = 1},
            },
            -- optional:
            Generator = "bandit"..i,  --generator
        })
    end

    ---Move-Befehle
    
        BanditArmy1: AddCommandMove(GetPosition("patrol_bandit1"), true);
        BanditArmy1: AddCommandWaitForIdle(true);
        BanditArmy1: AddCommandMove(GetPosition("bandit1_spawn"), true);
        BanditArmy1: AddCommandWaitForIdle(true);

        BanditArmy2: AddCommandMove(GetPosition("patrol_bandit1"), true);
        BanditArmy2: AddCommandWaitForIdle(true);
        BanditArmy2: AddCommandMove(GetPosition("bandit2_spawn"), true);
        BanditArmy2: AddCommandWaitForIdle(true);

        BanditArmy3: AddCommandMove(GetPosition("patrol_bandit2"), true);
        BanditArmy3: AddCommandWaitForIdle(true);
        BanditArmy3: AddCommandMove(GetPosition("bandit3_spawn"), true);
        BanditArmy3: AddCommandWaitForIdle(true);

        BanditArmy4: AddCommandMove(GetPosition("patrol_bandit2"), true);
        BanditArmy4: AddCommandWaitForIdle(true);
        BanditArmy4: AddCommandMove(GetPosition("bandit4_spawn"), true);
        BanditArmy4: AddCommandWaitForIdle(true);
  
        StartSimpleJob("CheckBanditCamp1")
        StartSimpleJob("CheckBanditCamp2")
end

mission_leoas_count = 0;
serfcamp = 0;
function CheckBanditCamp1()
    if 
        BanditArmy1:IsDead() == -1 
        and BanditArmy2:IsDead() == -1 
        and IsDestroyed("bandit1") 
        and IsDestroyed("bandit2") 
    then

        DestroyEntity("serf_gate")
        serfcamp = 1
        CheckLeoAssisstent()
        GUI.DestroyMinimapPulse(GetPosition("camp1").X, GetPosition("camp1").Y)
        mission_leoas_count = mission_leoas_count+1;
        CheckLeoMission()
        return true;
    end
end

leocamp = 0;
function CheckBanditCamp2()
    if 
    BanditArmy3:IsDead() == -1 
    and BanditArmy4:IsDead() == -1 
    and IsDestroyed("bandit3") 
    and IsDestroyed("bandit4") 
    then
        DestroyEntity("leo_gate")
        leocamp = 1
        CheckSerf()
        GUI.DestroyMinimapPulse(GetPosition("camp2").X, GetPosition("camp2").Y)
        mission_leoas_count = mission_leoas_count+1;
        CheckLeoMission()
        return true;
    end
end

function CheckLeoMission()
    if mission_leoas_count == 2 then
        Logic.AddQuest(1, 3, MAINQUEST_CLOSED, "@color:255,0,0 Befreiung", "@cr Befreit den Wissenschaftler und die Arbeiter aus den Lagern der Banditen", 1)
    end
end

function CheckLeoAssisstent()
    if leocamp == 1 then
        SerfBriefingTrue()
    else
        SerfBriefingFalse()
    end
end

function CheckSerf()
    if serfcamp == 1 then
        LeoAsBriefingTrue()
    else
        LeoAsBriefingFalse()
    end
end



function ActivateNVCamp()

    ChangeDynamicFog("fog", 2, 5 );

    if mode == 1 then
        nv_table = {
            [1] = 1, --Größe der Armee/ Leaderanzahl
            [2] = 120 --Respawnzeit
        }
        SetHealth("nv_spawner2", 20)
        for i=1,6,1 do 
            SetHealth("evil_tower"..i, 60)
        end
    elseif mode == 2 then
        nv_table = {
            [1] = 2, --Größe der Armee/ Leaderanzahl
            [2] = 120 --Respawnzeit
        }
        SetHealth("nv_spawner2", 35)
        for i=1,6,1 do 
            SetHealth("evil_tower"..i, 80)
        end
    elseif mode == 3 then
        nv_table = {
            [1] = 3, --Größe der Armee/ Leaderanzahl
            [2] = 90 --Respawnzeit
        }
        SetHealth("nv_spawner2", 50)
    end
    
    for i=1,2,1 do
        _G["NvCampArmy"..i] = LazyUnlimitedArmy:New({					
            -- benötigt
            Player = 6,
            Area = 2700,
            -- optional
            AutoDestroyIfEmpty = true,
            TransitAttackMove = true,
            Formation = UnlimitedArmy.Formations.Chaotic,
            AIActive = true,
            AutoRotateRange = 100000,
            HiResJob = true
        },i+4,NumberUA)
    

        _G["SpawnerNvCampArmy"..i] = UnlimitedArmySpawnGenerator:New(_G["NvCampArmy"..i], {
            -- benötigt:
            Position = GetPosition("nv_spawn"..i), --position
            ArmySize = nv_table[1], --armysize
            SpawnCounter = nv_table[2],  --spawncounter
            SpawnLeaders = nv_table[1],   --spawnleaders
            LeaderDesc = {
                {LeaderType = Entities.CU_Evil_LeaderBearman1, SoldierNum = 16 , SpawnNum = 1, Looped = true, Experience = 3},
                {LeaderType = Entities.CU_Evil_LeaderSkirmisher1, SoldierNum = 16 , SpawnNum = 1, Looped = true, Experience = 3},
            },
            -- optional:
            Generator = "nv_spawner"..i,  --generator
        })
    end

        NvCampArmy1: AddCommandMove(GetPosition("nv_patrol1"), true);
        NvCampArmy1: AddCommandWaitForIdle(true);
        NvCampArmy1: AddCommandMove(GetPosition("nv_patrol2"), true);
        NvCampArmy1: AddCommandWaitForIdle(true);
        NvCampArmy1: AddCommandMove(GetPosition("nv_patrol3"), true);
        NvCampArmy1: AddCommandWaitForIdle(true);

        NvCampArmy2: AddCommandMove(GetPosition("nv_patrol1"), true);
        NvCampArmy2: AddCommandWaitForIdle(true);
        NvCampArmy2: AddCommandMove(GetPosition("nv_patrol2"), true);
        NvCampArmy2: AddCommandWaitForIdle(true);
        NvCampArmy2: AddCommandMove(GetPosition("nv_patrol3"), true);
        NvCampArmy2: AddCommandWaitForIdle(true);

        StartSimpleJob("CheckNVCamp")
end


function CheckNVCamp()
    if 
        NvCampArmy1:IsDead() == -1 
        and NvCampArmy2:IsDead() == -1 
        and IsDestroyed("nv_spawner1") 
        and IsDestroyed("nv_spawner2") 
        and IsDestroyed("evil_tower1")
        and IsDestroyed("evil_tower2")
        and IsDestroyed("evil_tower3")
        and IsDestroyed("evil_tower4")
        and IsDestroyed("evil_tower5")
        and IsDestroyed("evil_tower6")
    then
            ChangeDynamicFog("fog", 0, 5 );
            if IsDead(guard) then
                CppLogic.Entity.Settler.HeroResurrect(GetID(guard))
            end
            StartSimpleJob("DelayResurrectBarb")
            chestNV = CreateEntity(0,Entities.XD_ChestClose,GetPosition("chest_nv"),"id_chest_nv")
            return true;
        end
    return false;
end


delayBarbCount1 = 0;
function DelayResurrectBarb()
    if delayBarbCount1 == 3 then
        guard = Logic.ChangeEntityPlayerID(GetID(guard), 8)
        CppLogic.Entity.SetDisplayName(guard, "Mijörn")
        SetEntityOverheadWidget(guard,1)
        Move(guard,"watch_jarg1")
        StartSimpleJob("JargDeadBody")
        return true;
    else
        delayBarbCount1 = delayBarbCount1 +1;
    end
end

function JargDeadBody()
    if IsNear(guard,"watch_jarg1",300) then
        Logic.EntityLookAt(GetID(guard), GetID("bone_jarg")) 
        ActivateDeadJargBrief()
        return true;
    end
    return false;
end

