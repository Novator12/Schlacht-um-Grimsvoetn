function Start_Chapter3()
    chapterID = 3
    chapterText = "Erkundung von Grimsvötn @cr Varg und seine Mitstreiter müssen das umliegende Land erkunden."
    ResetQuestBook(1)
    varg = Logic.CreateEntity(Entities.CU_Barbarian_Hero, GetPosition("varg_canon").X, GetPosition("varg_canon").Y, 0, 1)
    trupp1 = Logic.CreateEntity(Entities.CU_VeteranLieutenant, GetPosition("helgar_chapter3").X,GetPosition("helgar_chapter3").Y,0, 1)
    trupp2 = Logic.CreateEntity(Entities.CU_VeteranLieutenant, GetPosition("wolfgang_chapter3").X,GetPosition("wolfgang_chapter3").Y,0, 1)
    trupp3 = Logic.CreateEntity(Entities.CU_VeteranLieutenant, GetPosition("ruediger_chapter3").X,GetPosition("ruediger_chapter3").Y,0, 1)
    guard = Logic.CreateEntity(Entities.CU_VeteranLieutenant, GetPosition("mijoern_chapter3").X,GetPosition("mijoern_chapter3").Y,0, 1)
    Scout = Logic.CreateEntity(Entities.PU_Scout,GetPosition("scout_spawn").X,GetPosition("scout_spawn").Y,0,1)
    DefeatJob1 = StartSimpleJob("AllHerosDead")
    RefreshDisplayNames()
    StartBriefingChapter3()
end


function StartBriefingChapter3()
    --SetupAI5 
    --KI5 aktivieren
    SetupAI(SetupPlayer5)
    ResCheatKI5()
    KI5RecruitSerfs()
    UpgradeKI5()
    if mode == 2 or mode == 3 then
        BuffKI5()
    end
    ActivateSpawnerKI5()
    ActivateRecruiterKI5()
    

    --SetupBrief
    Logic.EntityLookAt(varg,leonardo)
    Logic.EntityLookAt(leonardo,varg)
    Logic.EntityLookAt(trupp1,varg)
    Logic.EntityLookAt(trupp2,varg)
    Logic.EntityLookAt(trupp3,varg)
    Logic.EntityLookAt(guard,varg)
    local briefing = {}
        local AP = function(_page) table.insert(briefing, _page) return _page end
        local page1 = AP{
            title	= "@color:255,0,0 Leonardo",
            text	= "@color:255,136,0 Varg, ich befinde mich nun in den finalen Vorbereitungen zur Fertigstellung des Schutzserums.",
            position = GetPosition(leonardo),
            explore = 2000,
        }
        local page3
        local page2 = AP{
            title	= "@color:255,0,0 Varg",
            text	= "@color:255,136,0 Das ist hervorragend. Wie lange vermutet...",
            position = GetPosition(varg),
            explore = 2000,
            action = function()
                Move(Scout,varg,200)
                StartSimpleJob("ScoutNearVarg")
                page3.npc = { id = GetEntityId(Scout),isObserved = true }
            end
        }
        page3 = AP{
            title	= "@color:255,0,0 Kundschafter",
            text	= "@color:255,136,0 Herr...(Keuch, Schnauf). Herr!",
            npc = { id = GetEntityId(Scout),
                isObserved = true },  
        }
        local page4 = AP{
            title	= "@color:255,0,0 Varg",
            text	= "@color:255,136,0 So beruhigt euch doch. Was ist denn los, dass Ihr euch so abhetzen müsst.",
            position = GetPosition(varg),
        }
        local page5 = AP{
            title	= "@color:255,0,0 Scout",
            text	= "@color:255,136,0 Sie kommen! Eine riesige Armee von der Schattenseite des Vulkans.",
            position = GetPosition(varg),
        }
        local page6 = AP{
            title	= "@color:255,0,0 Varg",
            text	= "@color:255,136,0 Wie bitte? Wie kann das sein? Das Signalfeuer muss Sie wohl auf uns aufmerksam gemacht haben.",
            position = GetPosition(varg),
        }
        local page7 = AP{
            title	= "@color:255,0,0 Scout",
            text	= "@color:255,136,0 Ja Herr, ich war gerade an den Gebirgshängen die Gegend ausspähen und konnte Ihre Truppenbewegungen sichten.",
            position = GetPosition(varg),
        }
        local page8 = AP{
            title	= "@color:255,0,0 Varg",
            text	= "@color:255,136,0 Das ist nicht gut. Wir müssen unsere Truppe mobilisieren und Leonardo solange Zeit verschaffen, bis er das Schutzserum fertig hat und wir einen Gegenangriff starten können.",
            position = GetPosition(varg),
        }
        local page9 = AP{
            title	= "@color:255,0,0 Varg",
            text	= "@color:255,136,0 Aber wartet mal...Wie kann es sein, dass Ihre Truppen keinen Schaden durch die Hitze nehmen! Leonardo?",
            position = GetPosition(varg),
        }
        local page10 = AP{
            title	= "@color:255,0,0 Leonardo",
            text	= "@color:255,136,0 Mhmmmm...wahrlich erstaunlich...das ist mir selbst ein Rätsel.",
            position = GetPosition(leonardo),
        }
        local page11 = AP{
            title	= "@color:255,0,0 Scout",
            text	= "@color:255,136,0 Herr! Ich zeige euch einen Einblick in Ihr Lager. Vielleicht hilft uns das weiter, wie wir taktisch vorgehen sollten.",
            position = GetPosition(varg),
        }
        local page12 = AP{
            title	= "@color:255,0,0 Varg",
            text	= "@color:255,136,0 Das ist eine ausgezeichnete Idee. Leonardo spute dich mit dem Schutzserum.",
            position = GetPosition(varg),
        }
        local page13 = AP{
            title	= "@color:255,0,0 Leonardo",
            text	= "@color:255,136,0 Jawohl...ich beeile mich.",
            position = GetPosition(leonardo),
            action = function()
                Move(leonardo,GetPosition("spot_leo"),200)
            end
        }
        briefing.finished = function()  
            ResolveBriefing(page1);
            ResolveBriefing(page2);
            Logic.SetOnScreenInformation(Scout,0)
            headline_defendbar = "@center Forschung" --Überschrift Defendbar
            XGUIEng.SetText("DefendProgressBarText", headline_defendbar, 1)
            if mode == 1 then
                maxDefendBar = 60*10
            elseif mode == 2 then
                maxDefendBar = 60*20
            elseif mode == 3 then 
                maxDefendBar = 60*25
            end
            StartCutscene("vulcanenemie", VulkanEnemieCutsceneBrief)   
        end;
        NormalSpeedInBriefing()
        StartBriefing(briefing)
end

function ScoutNearVarg()
    if IsNear(Scout,varg,300) then
        Logic.EntityLookAt(Scout,varg)
        Logic.EntityLookAt(varg,Scout)
        return true
    end
end


SetupPlayer5 = {
    id = 5,
    name = "Schattenkrieger",
    headquarters = "hq_id5",
    color = "violet",
    strength = 4,
    range = 100000,
    techlevel = 4,
    aggressiveness = 8,
    extracting = false,
    repairing = true,
    friends = false,
    enemies = {1},
    explore = false,
}

function KI5RecruitSerfs()
    if IsExisting("hq_id5") then
        for i=1,8,1 do
            CppLogic.Entity.Building.HQBuySerf("hq_id5")
        end
        StartSimpleJob("KI5SerfChecker")
    end
end

function KI5SerfChecker()
    if Logic.GetPlayerEntities(5,Entities.PU_Serf,8) == 0 and IsExisting("hq_id5") then
        KI5RecruitSerfs()
        return true
    elseif IsDead("hq_id5") then
        return true
    end
end

function VulkanEnemieCutsceneBrief()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    local page1 = AP{
        title	= "Mentor",
        text	= "Herr, rüstet eure Truppen. Der Feind wird bald eintreffen. Reynivellir darf unter keinen Umständen fallen.",
        position = GetPosition("barb_castle"),
        explore = 2000,
    }
    local page2 = AP{
        title	= "Mentor",
        text	= "Wir müssen Leonardo die nötige Zeit verschaffen!",
        position = GetPosition("barb_castle"),
    }
        briefing.finished = function()  
            ResolveBriefing(page1);
            LeonardoResearch = true
            XGUIEng.ShowWidget("DefendProgressContainer", 1)
            CountDefendJob = StartSimpleJob("StartDefendCounter")
            DefenseCompletedJob = StartSimpleJob("DefenseCompleted")
            Logic.AddQuest(1, 1, MAINQUEST_OPEN, "@color:255,0,0 Verteidigung von Reynivellir", "@cr Verteidigt das Dorf solange, bis Leonardo das Schutzserum fertig gestellt hat. Verliert ihr euer Burg oder alle eure Helden, habt Ihr das Spiel verloren.", 1)
            --KI5 startet Angriff
            for i = 1,4,1 do
                ReplaceEntity(GetID("gate"..i.."_id5"), Entities.XD_DarkWallStraightGate)
            end
            ActivateSpawnerBanditsKI5()
            StartSimpleJob("KI5Defeated")
            --Diebe-Angriff aktivieren
            if mode == 1 then
                Thiefticks = 10
            elseif mode == 2 then
                Thiefticks = 6
            elseif mode == 3 then
                Thiefticks = 3
            end
            EnableThiefAttack = true
            StartCountdown(60*2,InitThiefAttack,false)
        end;
        NormalSpeedInBriefing()
        StartBriefing(briefing)
end


function DefenseCompleted()
    if DefendCounter == maxDefendBar then
        LeonardoResearch = false
        XGUIEng.ShowWidget("DefendProgressContainer", 0)
        Logic.AddQuest(1, 1, MAINQUEST_CLOSED, "@color:255,0,0 Verteidigung von Reynivellir", "@cr Verteidigt das Dorf solange, bis Leonardo das Schutzserum fertig gestellt hat. Verliert ihr euer Burg oder alle eure Helden, habt Ihr das Spiel verloren.", 1)
        EnableLavaDamage = false; --Schaden in Lava nehmen = AUS
        LeoResearchDoneBrief()
        return true
    end
end

function LeoResearchDoneBrief()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    local page1 = AP{
        title	= "@color:255,0,0 Leonardo",
        text	= "@color:255,136,0 Es ist vollbracht. Ich habe das Schutzserum fertiggestellt. Eure Männer und Gebäude sollten nun in der Hitze der Lava geschützt sein.",
        position = GetPosition(leonardo),
        explore = 2000,
    }
    local page2 = AP{
        title	= "@color:255,0,0 Varg",
        text	= "@color:255,136,0 Na dann Männer. Auf in die Schlacht!",
        position = GetPosition(varg),
        explore = 2000,
        action = function()
            Sound.Play2DSound(1146,0,150) 
        end
    }
    briefing.finished = function()  
        ResolveBriefing(page1);
        ResolveBriefing(page2);
        --ActivateShortcut
        DestroyEntity("shortcut1")
        DestroyEntity("shortcut2")
        Logic.AddQuest(1, 2, MAINQUEST_OPEN, "@color:255,0,0 Angriff auf die Schattenkrieger", "@cr Bekämpft die Schattenkrieger und zerstört Ihre Militärgebäude und die Burg.", 1) 
    end;
    NormalSpeedInBriefing()
    StartBriefing(briefing)
end

function ResCheatKI5()
    Logic.AddToPlayersGlobalResource(5,ResourceType.ClayRaw,1000000)
    Logic.AddToPlayersGlobalResource(5,ResourceType.StoneRaw,1000000)
    Logic.AddToPlayersGlobalResource(5,ResourceType.GoldRaw,1000000)
    Logic.AddToPlayersGlobalResource(5,ResourceType.IronRaw,1000000)
    Logic.AddToPlayersGlobalResource(5,ResourceType.WoodRaw,1000000)
    Logic.AddToPlayersGlobalResource(5,ResourceType.SulfurRaw,1000000)
end

function UpgradeKI5()
    if mode == 3 then
    for i=1,3,1 do --Schwert auf T4 upgraden
        GUI.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, 5)  
        GUI.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, 5)
    end

    for i=1,3,1 do --Bogen auf T4 upgraden
        GUI.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, 5)  
        GUI.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, 5)
    end

    for i=1,3,1 do --Speerträger auf T4 upgraden
        GUI.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, 5)  
        GUI.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, 5)
    end

    --Scharfschützen auf T2 upgraden
    GUI.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle, 5)  
    GUI.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle, 5)

    elseif mode<3 then
        for i=1,2,1 do --Schwert auf T3 upgraden
            GUI.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, 5)  
            GUI.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, 5)
        end
    
        for i=1,2,1 do --Bogen auf T3 upgraden
            GUI.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, 5)  
            GUI.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, 5)
        end
    
        for i=1,2,1 do --Speerträger auf T3 upgraden
            GUI.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, 5)  
            GUI.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, 5)
        end
    
        --Scharfschützen auf T2 upgraden
        GUI.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle, 5)  
        GUI.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle, 5)
    end

    
end

function BuffKI5()
    Logic.SetTechnologyState(5, Technologies.T_LeatherMailArmor, 3)
    Logic.SetTechnologyState(5, Technologies.T_ChainMailArmor, 3)
    Logic.SetTechnologyState(5, Technologies.T_PlateMailArmor, 3)
    Logic.SetTechnologyState(5, Technologies.T_SoftArcherArmor, 3)
    Logic.SetTechnologyState(5, Technologies.T_PaddedArcherArmor, 3)
    Logic.SetTechnologyState(5, Technologies.T_LeatherArcherArmor, 3)
    Logic.SetTechnologyState(5, Technologies.T_MasterOfSmithery, 3)
    Logic.SetTechnologyState(5, Technologies.T_IronCasting, 3)
    Logic.SetTechnologyState(5, Technologies.T_Fletching, 3)
    Logic.SetTechnologyState(5, Technologies.T_BodkinArrow, 3)
    Logic.SetTechnologyState(5, Technologies.T_WoodAging, 3)
    Logic.SetTechnologyState(5, Technologies.T_Turnery, 3)
    Logic.SetTechnologyState(5, Technologies.T_EnhancedGunPowder, 3)
    Logic.SetTechnologyState(5, Technologies.T_BlisteringCannonballs, 3)
    Logic.SetTechnologyState(5, Technologies.T_BetterTrainingBarracks, 3)
    Logic.SetTechnologyState(5, Technologies.T_BetterTrainingArchery, 3)
    Logic.SetTechnologyState(5, Technologies.T_Shoeing, 3)
    Logic.SetTechnologyState(5, Technologies.T_Masonry, 3)
    if mode == 3 then
        Logic.SetTechnologyState(5, Technologies.T_SuperTechnology, 3)
    end
    
    Logic.SetTechnologyState(5, Technologies.T_FleeceArmor, 3)
    Logic.SetTechnologyState(5, Technologies.T_FleeceLinedLeatherArmor, 3)
    Logic.SetTechnologyState(5, Technologies.T_LeadShot, 3)
    Logic.SetTechnologyState(5, Technologies.T_Sights, 3)
end


function ActivateSpawnerKI5()


    if mode == 1 then
        KI5_Spawner_Table = {
            [1] = 2, --Größe der Armee/ Leaderanzahl
            [2] = 120 --Respawnzeit
        }
    elseif mode == 2 then
        KI5_Spawner_Table = {
            [1] = 4, --Größe der Armee/ Leaderanzahl
            [2] = 120 --Respawnzeit
        }
    elseif mode == 3 then
        KI5_Spawner_Table = {
            [1] = 6, --Größe der Armee/ Leaderanzahl
            [2] = 160 --Respawnzeit
        }
    end
    
   
        KI5SpawnerArmy = LazyUnlimitedArmy:New({					
            -- benötigt
            Player = 5,
            Area = 4000,
            -- optional
            AutoDestroyIfEmpty = true,
            TransitAttackMove = true,
            Formation = UnlimitedArmy.Formations.Lines,
            LeaderFormation = 4,
            AIActive = true,
            AutoRotateRange = 100000,
            HiResJob = true
        },8,NumberUA)
    

        SpawnerKI5 = UnlimitedArmySpawnGenerator:New(KI5SpawnerArmy, {
            -- benötigt:
            Position = GetPosition("spawn_id5"), --position
            ArmySize = KI5_Spawner_Table[1], --armysize
            SpawnCounter = KI5_Spawner_Table[2],  --spawncounter
            SpawnLeaders = KI5_Spawner_Table[1],   --spawnleaders
            LeaderDesc = {
                {LeaderType = Entities.PU_LeaderHeavyCavalry2, SoldierNum = 3 , SpawnNum = 3, Looped = true, Experience = 3},
                {LeaderType = Entities.PU_LeaderCavalry2, SoldierNum = 6 , SpawnNum = 2, Looped = true, Experience = 3},
                {LeaderType = Entities.PU_LeaderSword1, SoldierNum = 0 , SpawnNum = 1, Looped = true, Experience = 3},
            },
            -- optional:
            Generator = "hq_id5",  --generator
        })

        KI5SpawnerArmy: AddCommandMove(GetPosition("barb_castle"), true);
        KI5SpawnerArmy: AddCommandWaitForIdle(true);
end


function ActivateRecruiterKI5()


    if mode == 1 then
        ki5_table = {
            [1] = 10 --Größe der Armee/ Leaderanzahl
        }
    elseif mode == 2 then
        ki5_table = {
            [1] = 15 --Größe der Armee/ Leaderanzahl
        }
    elseif mode == 3 then
        ki5_table = {
            [1] = 20 --Größe der Armee/ Leaderanzahl
        }
    end


    KI5Army = LazyUnlimitedArmy:New({
        -- benötigt
        Player = 5,
        Area = 4000,
        -- optional
        AutoDestroyIfEmpty = true,
        TransitAttackMove = true,
        Formation = UnlimitedArmy.Formations.Lines,
        LeaderFormation = 4,
        AIActive = true,
        AutoRotateRange = 100000,
        HiResJob = true
    }, 9, NumberUA)


    RecruiterKI5 = UnlimitedArmyRecruiter:New(KI5Army, {
        Buildings = { GetID("archery_id5"), GetID("barracks_id5"), GetID("foundry_id5") }, -- mehr gebäude einfach hier rein
        ArmySize = ki5_table[1],
        UCats = {
            { UCat = UpgradeCategories.LeaderSword, SpawnNum = 3, Looped = true },
            { UCat = UpgradeCategories.Cannon4, SpawnNum = 1, Looped = true },
            { UCat = UpgradeCategories.LeaderBow, SpawnNum = 3, Looped = true },
            { UCat = UpgradeCategories.Cannon3, SpawnNum = 1, Looped = true },
            { UCat = UpgradeCategories.LeaderPoleArm, SpawnNum = 2, Looped = true },
            { UCat = UpgradeCategories.LeaderSword, SpawnNum = 1, Looped = true },
            { UCat = UpgradeCategories.LeaderRifle, SpawnNum = 2, Looped = true },
            { UCat = UpgradeCategories.LeaderBow, SpawnNum = 1, Looped = true },
            { UCat = UpgradeCategories.Cannon3, SpawnNum = 1, Looped = true },
            { UCat = UpgradeCategories.LeaderSword, SpawnNum = 3, Looped = true },
            { UCat = UpgradeCategories.LeaderBow, SpawnNum = 3, Looped = true },
            { UCat = UpgradeCategories.Cannon4, SpawnNum = 1, Looped = true },
            { UCat = UpgradeCategories.LeaderSword, SpawnNum = 3, Looped = true },
            { UCat = UpgradeCategories.LeaderBow, SpawnNum = 3, Looped = true },
        },
        ResCheat = true,
        ReorderAllowed = false,
        DoNotRemoveIfDeadOrEmpty = true
    })
end


function ActivateSpawnerBanditsKI5()


    if mode == 1 then
        KI5_SpawnerBandits_Table = {
            [1] = 1, --Größe der Armee/ Leaderanzahl
            [2] = 60 --Respawnzeit
        }
    elseif mode == 2 then
        KI5_SpawnerBandits_Table = {
            [1] = 2, --Größe der Armee/ Leaderanzahl
            [2] = 60 --Respawnzeit
        }
    elseif mode == 3 then
        KI5_SpawnerBandits_Table = {
            [1] = 3, --Größe der Armee/ Leaderanzahl
            [2] = 60 --Respawnzeit
        }
    end
    
    for i = 1,2,1 do
    _G["KI5SpawnerBanditArmy"..i] = LazyUnlimitedArmy:New({					
            -- benötigt
            Player = 5,
            Area = 4000,
            -- optional
            AutoDestroyIfEmpty = true,
            TransitAttackMove = true,
            Formation = UnlimitedArmy.Formations.Lines,
            LeaderFormation = 4,
            AIActive = true,
            AutoRotateRange = 100000,
            HiResJob = true
        },9+i,NumberUA)
    

        _G["SpawnerBanditKI5_"..i] = UnlimitedArmySpawnGenerator:New(_G["KI5SpawnerBanditArmy"..i], {
            -- benötigt:
            Position = GetPosition("spawn_bandit"..i.."_id5"), --position
            ArmySize = KI5_SpawnerBandits_Table[1], --armysize
            SpawnCounter = KI5_SpawnerBandits_Table[2],  --spawncounter
            SpawnLeaders = KI5_SpawnerBandits_Table[1],   --spawnleaders
            LeaderDesc = {
                {LeaderType = Entities.CU_BanditLeaderSword2, SoldierNum = 8 , SpawnNum = 1, Looped = true, Experience = 3},
                {LeaderType = Entities.CU_BanditLeaderBow2, SoldierNum = 8 , SpawnNum = 1, Looped = true, Experience = 3},
                {LeaderType = Entities.CU_BanditLeaderSword2, SoldierNum = 8 , SpawnNum = 1, Looped = true, Experience = 3},
                {LeaderType = Entities.CU_BanditLeaderBow2, SoldierNum = 8 , SpawnNum = 1, Looped = true, Experience = 3},
                {LeaderType = Entities.CU_BanditLeaderSword2, SoldierNum = 8 , SpawnNum = 1, Looped = true, Experience = 3},
                {LeaderType = Entities.CU_BanditLeaderBow2, SoldierNum = 8 , SpawnNum = 1, Looped = true, Experience = 3},
            },
            -- optional:
            Generator = "spawner_bandit"..i.."_id5",  --generator
        })

        _G["KI5SpawnerBanditArmy"..i]: AddCommandMove(GetPosition("barb_castle"), true);
        _G["KI5SpawnerBanditArmy"..i]: AddCommandWaitForIdle(true);
    end
end




ThiefTable = {}

function InitThiefAttack()
    if IsExisting("barb_castle") and EnableThiefAttack == true then
        local rand = GetRandom(1,6)
        for i =1,2,1 do
            _G["thief_id5_"..i] = Logic.CreateEntity(Entities.PU_Thief,GetPosition("thief_spawn"..rand).X,GetPosition("thief_spawn"..rand).Y,0,5)
            table.insert(ThiefTable,_G["thief_id5_"..i])
            if IsExisting(_G["thief_id5_"..i]) then
                CppLogic.Entity.Settler.CommandSabotage(_G["thief_id5_"..i], GetID("barb_castle"))
            end
        end
        CastleHurtTrigger = Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY,nil,"ThiefDestroiedCastle",1)
        ThiefAliveTrigger = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,nil,"ThiefAlive",1)
        
    end
end

Thiefticks = 5

function ThiefAlive()
    for n = table.getn(ThiefTable),1,-1 do
      if IsDead(ThiefTable[n]) then
        table.remove(ThiefTable,n)
      end
    end
    if table.getn(ThiefTable) == 0 then
          ThiefCountdown = StartCountdown(60*Thiefticks,InitThiefAttack,false)
          Trigger.UnrequestTrigger(CastleHurtTrigger)
          return true
    end
end

function ThiefDestroiedCastle()
    local damageType = Event.AttackSource
    local bID = Event.GetEntityID2()
    if (Logic.GetEntityTypeName(Logic.GetEntityType(bID)) == "CB_Barbarian_Castle1" 
    or Logic.GetEntityTypeName(Logic.GetEntityType(bID)) == "CB_Barbarian_Castle2" 
    or  Logic.GetEntityTypeName(Logic.GetEntityType(bID)) == "CB_Barbarian_Castle3") 
    and damageType == AdvancedDealDamageSource.AbilitySabotageSingleTarget then
        for i = table.getn(ThiefTable),1,-1 do
            if IsAlive(ThiefTable[i]) then
                DestroyEntity(ThiefTable[i])
                return true
            end
        end
    end
end



function KI5Defeated()
    if IsDestroyed("archery_id5") and IsDestroyed("hq_id5") and IsDestroyed("foundry_id5") and IsDestroyed("barracks_id5") and IsDestroyed("village_id5") and IsDestroyed("spawner_bandit1_id5") and IsDestroyed("spawner_bandit2_id5") then
        EnableThiefAttack = false
        if ThiefCountdown then
            StopCountdown(ThiefCountdown)
        end
        garek = Logic.CreateEntity(Entities.CU_ChiefIdle,GetPosition("garek_pos1").X,GetPosition("garek_pos1").Y,0,3)
        Move(garek,"backdoor_player4",400)
        StartSimpleJob("GarekNearEscape")
        GarekFleeBrief()
        return true;
    end
end

function GarekNearEscape()
    if IsNear(garek,"backdoor_player4",500) then
        ReplaceEntity("backdoor_player4",Entities.XD_DarkWallStraightGate)
        Move(garek,"garek_pos2",100)
        StartCountdown(4,CloseBackdoorGate,false)
        return true
    end
end

function CloseBackdoorGate()
    ReplaceEntity("backdoor_player4",Entities.XD_DarkWallStraightGate_Closed)
end


function GarekFleeBrief()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    local page2
    local page1 = AP{
        title	= "Mentor",
        text	= "Seht nur Herr, Ihr Anführer will fliehen. Schnell. Ihm nach!",
        position = GetPosition(garek),
        explore = 2000,
        action = function()
            Display.SetRenderFogOfWar(0)
            page2.npc = { id = GetEntityId(garek),isObserved = true }
        end
    }
    page2 = AP{
        title	= "Mentor",
        text	= "Er flüchtet in den Norden. Noch höher in die rauen, kargen Berge im Schatten des Vulkans.",
        npc = { id = GetEntityId(garek),
            isObserved = true },
    }
    local page3 = AP{
        title	= "Mentor",
        text	= "Mist. Er ist entkommen. Wir müssen einen Weg durch dieses Tor finden oder einen andern zur Feste.",
        position = GetPosition("backdoor_player4"),
        explore = 2000
    }
    
    briefing.finished = function()  
        ResolveBriefing(page1);
        ResolveBriefing(page2);
        ResolveBriefing(page3);
        Display.SetRenderFogOfWar(1)
        Logic.SetOnScreenInformation(garek,0)
        StartCutscene("schattenfeste", SchattenfesteCutsceneEnd)   
    end;
    NormalSpeedInBriefing()
    StartBriefing(briefing)
end


function SchattenfesteCutsceneEnd()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    local page1 = AP{
        title	= "Mentor",
        text	= "Herr, Ihr nähert euch bald dem Endkampf. Macht euch bereit und rüstet eure Männer.",
        position = GetPosition("barb_castle"),
        explore = 2000
    }
    briefing.finished = function()  
        ResolveBriefing(page1);
        StartBlende(
            "@center @color:255,0,0 Schlacht um Grimsvötn", 
            "@center @color:255,255,255 @cr @cr Nach einem erbitternden Kampf gegen die Schattenkrieger konnte Ihr Anführer in die Schattenfeste im Gebirge des Vulkans fliehen. Varg und seine Mitstreiter versuchten Ihn zu verfolgen, wurden jedoch von den massiven Toren der Feste aufgehalten. Nun heißt es eine Belagerung auf die Feste zu vollführen und dem Schrecken ein Ende zu setzen. Wird es Varg, dem neuen Anführer der Barbaren gelingen? ", 
            function() Start_Chapter4() end, 
    
            2)--muss später höher
    end;
    NormalSpeedInBriefing()
    StartBriefing(briefing)
end