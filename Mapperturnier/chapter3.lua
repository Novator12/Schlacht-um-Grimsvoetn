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
            position = GetPosition(Scout),
        }
        local page6 = AP{
            title	= "@color:255,0,0 Varg",
            text	= "@color:255,136,0 Wie bitte? Wie kann das sein? Das Signalfeuer muss Sie wohl auf uns aufmerksam gemacht haben.",
            position = GetPosition(varg),
        }
        local page7 = AP{
            title	= "@color:255,0,0 Scout",
            text	= "@color:255,136,0 Ja Herr, ich war gerade an den Gebirgshängen die Gegend ausspähen und konnte Ihre Truppenbewegungen sichten.",
            position = GetPosition(Scout),
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
            position = GetPosition(Scout),
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
            SetupAI(SetupPlayer5)
            headline_defendbar = "@center Forschung" --Überschrift Defendbar
            XGUIEng.SetText("DefendProgressBarText", headline_defendbar, 1)
            if mode == 1 then
                maxDefendBar = 60*10
            elseif mode == 2 then
                maxDefendBar = 60*20
            elseif mode == 3 then 
                maxDefendBar = 60*25
            end
            --KI5 aktivieren
            for i = 1,4,1 do
                ReplaceEntity(GetID("gate"..i.."_id5"), Entities.XD_DarkWallStraightGate)
            end
            ActivateSpawnerKI5()
            ActivateRecruiterKI5()
            if mode == 2 or mode == 3 then
                BuffKI5()
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
            XGUIEng.ShowWidget("DefendProgressContainer", 1)
            CountDefendJob = StartSimpleJob("StartDefendCounter")
            DefenseCompletedJob = StartSimpleJob("DefenseCompleted")
            Logic.AddQuest(1, 1, MAINQUEST_OPEN, "@color:255,0,0 Verteidigung von Reynivellir", "@cr Verteidigt das Dorf solange, bis Leonardo das Schutzserum fertig gestellt hat. Verliert ihr euer Burg oder alle eure Helden, habt Ihr das Spiel verloren.", 1)
        
        end;
        NormalSpeedInBriefing()
        StartBriefing(briefing)
end


function DefenseCompleted()
    if DefendCounter == maxDefendBar then
        XGUIEng.ShowWidget("DefendProgressContainer", 0)
        Logic.AddQuest(1, 1, MAINQUEST_CLOSED, "@color:255,0,0 Verteidigung von Reynivellir", "@cr Verteidigt das Dorf solange, bis Leonardo das Schutzserum fertig gestellt hat. Verliert ihr euer Burg oder alle eure Helden, habt Ihr das Spiel verloren.", 1)
        Message("Angriff!")
        EnableLavaDamage = false; --Schaden in Lava nehmen = AUS
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
            [2] = 60 --Respawnzeit
        }
    elseif mode == 2 then
        KI5_Spawner_Table = {
            [1] = 4, --Größe der Armee/ Leaderanzahl
            [2] = 30 --Respawnzeit
        }
    elseif mode == 3 then
        KI5_Spawner_Table = {
            [1] = 6, --Größe der Armee/ Leaderanzahl
            [2] = 10 --Respawnzeit
        }
    end
    
   
        KI5SpawnerArmy = LazyUnlimitedArmy:New({					
            -- benötigt
            Player = 5,
            Area = 100000,
            -- optional
            AutoDestroyIfEmpty = true,
            TransitAttackMove = true,
            Formation = UnlimitedArmy.Formations.Lines,
            AIActive = true,
            AutoRotateRange = 100000,
            HiResJob = true
        },7,10)
    

        SpawnerKI5 = UnlimitedArmySpawnGenerator:New(KI5SpawnerArmy, {
            -- benötigt:
            Position = GetPosition("spawn_id5"), --position
            ArmySize = KI5_Spawner_Table[1], --armysize
            SpawnCounter = KI5_Spawner_Table[2],  --spawncounter
            SpawnLeaders = KI5_Spawner_Table[1],   --spawnleaders
            LeaderDesc = {
                {LeaderType = Entities.PU_LeaderHeavyCavalry2, SoldierNum = 3 , SpawnNum = 3, Looped = true, Experience = 3},
                {LeaderType = Entities.PU_LeaderCavalry2, SoldierNum = 6 , SpawnNum = 3, Looped = true, Experience = 3},
            },
            -- optional:
            Generator = "hq_id5",  --generator
        })
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
            Area = 100000,
            -- optional
            AutoDestroyIfEmpty = true,
            TransitAttackMove = true,
            Formation = UnlimitedArmy.Formations.Lines,
            AIActive = true,
            AutoRotateRange = 100000,
            HiResJob = true
        },8,10)
    

        RecruiterKI5 = UnlimitedArmyRecruiter:New(KI5Army, {
            Buildings = {GetID("archery_id5"),GetID("baracks_id5"),GetID("foundry_id5")}, -- mehr gebäude einfach hier rein
            ArmySize = ki5_table[1],
            UCats = {
                {UCat=UpgradeCategories.LeaderSword, SpawnNum=2, Looped=true},
                {UCat=UpgradeCategories.LeaderBow, SpawnNum=2, Looped=true},
                {UCat=UpgradeCategories.LeaderPoleArm, SpawnNum=2, Looped=true},
                {UCat=UpgradeCategories.Cannon4, SpawnNum=2, Looped=true},
                {UCat=UpgradeCategories.Cannon3, SpawnNum=2, Looped=true},
                {UCat=UpgradeCategories.LeaderRifle, SpawnNum=2, Looped=true},
                 -- hier können noch mehr rein
            },
            ResCheat = true,
            ReorderAllowed = true,
            DoNotRemoveIfDeadOrEmpty = true
        })
end
