function Start_Chapter2()
    chapterID = 2
    chapterText = "Wiederaufbau von Reynivellir @cr Varg muss das Dorf wieder aufbauen und das Leuchtfeuer entzünden."
    DestroyEntity(GetID("block1"))
    DestroyEntity(GetID("block2"))
    ResetQuestBook(1)
    varg = Logic.CreateEntity(Entities.CU_Barbarian_Hero, GetPosition("varg_chapter2").X, GetPosition("varg_chapter2").Y, 0, 1)
    trupp1 = Logic.CreateEntity(Entities.CU_VeteranLieutenant, GetPosition("helgar_chapter2").X,GetPosition("helgar_chapter2").Y,0, 1)
    trupp2 = Logic.CreateEntity(Entities.CU_VeteranLieutenant, GetPosition("wolfgang_chapter2").X,GetPosition("wolfgang_chapter2").Y,0, 1)
    trupp3 = Logic.CreateEntity(Entities.CU_VeteranLieutenant, GetPosition("ruediger_chapter2").X,GetPosition("ruediger_chapter2").Y,0, 1)
    guard = Logic.CreateEntity(Entities.CU_VeteranLieutenant, GetPosition("mijoern_chapter2").X,GetPosition("mijoern_chapter2").Y,0, 1)
    RefreshDisplayNames()
    StartBriefingChapter2()
end

----------------------------------------------------------------------------Quest1-----------------------------------------------------------------------------------
function StartHelgarQuest()
    scientist = Logic.CreateEntity(Entities.CU_AssistentLeoIdle, GetPosition("scientist_pos1").X, GetPosition("scientist_pos1").Y,0,3)
    jobPatrolScientist = StartSimpleJob("PatrolScientist")
    CreateScientistBriefing()
end

function PatrolScientist()
    if GetDistance(GetPosition(scientist),GetPosition(GetID("scientist_pos1"))) <= 200 then
        Move(scientist,GetID("scientist_pos2"),100)
    elseif GetDistance(GetPosition(scientist),GetPosition(GetID("scientist_pos2"))) <= 200 then
        Move(scientist,GetID("scientist_pos1"),100)
    end
end

function CreateScientistBriefing()
    local callback = function()
        local briefing = {};
        local AP = function(_page) table.insert(briefing, _page); return _page; end;
        local page1 = AP{
                            title = "@color:255,0,0 Wissenschaftler",
                            text = "@color:255,136,0 Na schau mal einer an. Wen haben wir denn da...Ihr seid nicht Varg, das ist ganz klar.",
                            npc = { id = GetEntityId(scientist),
                                    isObserved = true }, 
                            action = function() 
                                Logic.EntityLookAt(GetID(scientist), GetID(trupp1)) 
                                Logic.EntityLookAt(GetID(trupp1), GetID(scientist)) 
                            end
                        };
                    local page2 = AP{
                        title = "@color:255,0,0 Helgar",
                        text = "@color:255,136,0 Das habt Ihr gut erkannt. Ich bin Helgar, Sohn von Tamrin. Ich wurde von unserem Oberhaupt Varg beauftragt die Minen frei zu legen. Könnt Ihr mir dabei behilflich sein?",
                        position = GetPosition(trupp1),
                        explore = 2000    
                        }; 
                    local page3 = AP{
                        title = "@color:255,0,0 Wissenschaftler",
                        text = "@color:255,136,0 Hilfe..mhmm..jaaa...Ich helfe euch wenn Ihr mir helft!",
                        position = GetPosition(scientist),
                        action = function() 
                            if mode == 1 then
                                wolftable = {}
                                for i=1,5,1 do
                                    _G["wolf"..i] = Logic.CreateEntity(Entities.CU_AggressiveWolf, GetPosition("wolf"..i).X, GetPosition("wolf"..i).Y,0,7)
                                    table.insert(wolftable,_G["wolf"..i])
                                end
                                Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, nil, "WolfsDead",1,nil,nil)
                            elseif mode ==2 then
                                wolftable = {}
                                for i=1,5,1 do
                                    _G["wolf1_"..i] = Logic.CreateEntity(Entities.CU_AggressiveWolf, GetPosition("wolf"..i).X, GetPosition("wolf"..i).Y,0,7)
                                    _G["wolf2_"..i] = Logic.CreateEntity(Entities.CU_AggressiveWolf, GetPosition("wolf"..i).X, GetPosition("wolf"..i).Y,0,7)
                                    table.insert(wolftable,_G["wolf1_"..i])
                                    table.insert(wolftable,_G["wolf2_"..i])
                                end
                                Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, nil, "WolfsDead",1,nil,nil)
                            elseif mode == 3 then
                                wolftable = {}
                                for i=1,5,1 do
                                    _G["wolf1_"..i] = Logic.CreateEntity(Entities.CU_AggressiveWolf, GetPosition("wolf"..i).X, GetPosition("wolf"..i).Y,0,7)
                                    _G["wolf2_"..i] =  Logic.CreateEntity(Entities.CU_AggressiveWolf, GetPosition("wolf"..i).X, GetPosition("wolf"..i).Y,0,7)
                                    _G["wolf3_"..i] = Logic.CreateEntity(Entities.CU_AggressiveWolf, GetPosition("wolf"..i).X, GetPosition("wolf"..i).Y,0,7)
                                    table.insert(wolftable,_G["wolf1_"..i])
                                    table.insert(wolftable,_G["wolf2_"..i])
                                    table.insert(wolftable,_G["wolf3_"..i])
                                end
                                Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, nil, "WolfsDead",1,nil,nil)
                            end
                        end  
                        }; 
                    local page4 = AP{
                        title = "@color:255,0,0 Wissenschaflter",
                        text = "@color:255,136,0 Da oben im Wald haben sich ein paar Wölfe eingenistet. Die stören mich bei meinen Arbeiten. Erledigt Sie für mich.",
                        position = GetPosition("wolf3"),
                          
                        }; 
                    local page5 = AP{
                        title = "@color:255,0,0 Helgar",
                        text = "@color:255,136,0 Es ist mir ein Vergnügen.",
                        position = GetPosition(trupp1),  
                        }; 


    briefing.finished = function() 
        ResolveBriefing(page1); 
        ResolveBriefing(page2);  
    end

        EndJob(jobPatrolScientist)
        NormalSpeedInBriefing()
        StartBriefing(briefing)
        
    end;
        local npc = {
                    name = scientist,
                    callback = callback,
                    heroName = trupp1,
                    wrongHeroMessage = "Mhmhmhm, jaaaaa....BRATWURST..."
                };
        CreateNPC(npc);
end

function WolfsDead()
    local id = Event.GetEntityID()
    for i = 1, table.getn(wolftable),1 do
        if wolftable[i] == id then
            table.remove(wolftable,i)
        end
    end
    if not wolftable[1] then
        if IsDead(trupp1) then
			CppLogic.Entity.Settler.HeroResurrect(GetID(trupp1))
		end
        WolfsDeadBriefing()
        return true;
    end
end


function WolfsDeadBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    local page1 = AP{
        title	= "@color:255,0,0 Wissenschaftler",
        text	= "@color:255,136,0 Vielen Dank. Jetzt bringe ich dir die Grundlagen des Sprengens von Gegenständen bei...hehehehehee.",
        position = GetPosition(scientist),
        explore = 2000
    }
    local page2 = AP{
        title	= "",
        text	= "3 Stunden später...",
        position = GetPosition(""),
    }
    local page3 = AP{
        title	= "@color:255,0,0 Wissenschaftler",
        text	= "@color:255,136,0 So...jetzt kannst du alles was du willst in die Luft sprengen. Viel Spaß. Ich verzieh mich aus dieser tristen Gegend.",
        position = GetPosition(scientist),
        action = function() 
            MoveAndVanish(GetID(scientist), GetID("leoas_vanish")) 
        end
    }
    local page5
    local page4 = AP{
        title	= "@color:255,0,0 Helgar",
        text	= "@color:255,136,0 Har Har, ich bin unbesiegbar! Habt Dank werter Herr.",
        position = GetPosition(trupp1),
        explore = 2000,
        action = function() 
            if mode == 1 or mode ==2 then
                serf_iron = Logic.CreateEntity(Entities.PU_Thief,GetPosition("serf_nviron").X,GetPosition("serf_nviron").Y,0,3)
                ResearchTechnology(Technologies.T_ThiefSabotage,1)
            elseif mode ==3 then
                serf_iron = Logic.CreateEntity(Entities.PU_Serf,GetPosition("serf_nviron").X,GetPosition("serf_nviron").Y,0,3)
            end
            page5.npc = { id = GetEntityId(serf_iron),isObserved = true }
        end
    }
    page5 = AP{
        title	= "@color:255,0,0 Fremder",
        text	= "@color:255,136,0 Zu Hilfe...Rettet mich...AHHHHHHHHH. Sie sind hinter mir her...",
        npc = { id = GetEntityId(serf_iron),
                isObserved = true },
        action = function() 
            Move(serf_iron,trupp1,200)
            StartSimpleJob("SerfNearHelgar")
            Display.SetRenderFogOfWar(0)
        end
    }
    local page7
    local page6 = AP{
        title	= "@color:255,0,0 Helgar",
        text	= "@color:255,136,0 Was ist denn los? Hinter euch ist niemand!",
        position = GetPosition(trupp1),
        action = function() 
            page7.position = GetPosition(serf_iron)
            Display.SetRenderFogOfWar(1)
        end
    }
    page7 = AP{
        title	= "@color:255,0,0 Fremder",
        text	= "@color:255,136,0 Was? Echt? Oh Stimmt ihr habt recht. Ich bin vor diesen abscheulichen Höhlenmenschen geflohen.",
        position = GetPosition(serf_iron),
    }
    local page8 = AP{
        title	= "@color:255,0,0 Helgar",
        text	= "@color:255,136,0 Welche Höhlenmenschen? Wir haben vor ein paar Tagen ihr letztes Lager vernichtet!",
        position = GetPosition(trupp1),
    }
    local page9 = AP{
        title	= "@color:255,0,0 Fremder",
        text	= "@color:255,136,0 Da müsst Ihr euch irren. Sie haben oben auf dem Berg bei der verschütteten Eisenmine ein kleines Lager.",
        position = GetPosition("nv_spawn_iron"),
        explore = 1000
    }
    local page10 = AP{
        title	= "@color:255,0,0 Helgar",
        text	= "@color:255,136,0 Das gibt es doch nicht. Diese Dinger sind schlimmer als Zecken. Nun dann müssen wir uns wohl oder übel um dieses Pack kümmern.",
        position = GetPosition(trupp1),
    }
    local page11 = AP{
        title	= "@color:255,0,0 Fremder",
        text	= "@color:255,136,0 Seid dabei auf der Hut. Sie haben Kontrolle über das Tor. Es öffnet sich nur, wenn einer Ihrer Soldaten in der Nähe des Tores ist. Dann ist euer Zeitfenster gekommen, Truppen in das Lager einzuschleusen.",
        position = GetPosition("iron_gate"),
        explore = 1000
    }
    local page12 = AP{
        title	= "@color:255,0,0 Fremder",
        text	= "@color:255,136,0 Lasst mich euch wenigstens behilflich sein. Ein Helfer mehr sollte euch ja nicht schaden.",
        position = GetPosition(trupp1),
    }
    briefing.finished = function()  
        ResolveBriefing(page1);
        ResolveBriefing(page4);
        ResolveBriefing(page5);
        ResolveBriefing(page9);
        ResolveBriefing(page11);
        HelgarBombSelection()--Hier Bombenfähigkeit Widget einschalten.
        Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED,nil,"PitQuest",1,nil,nil)
        CreateNVIronPit()
        serf_iron = ChangePlayer(serf_iron,1)
    end;
    NormalSpeedInBriefing()
    StartBriefing(briefing)
end 


function SerfNearHelgar()
    if IsNear(serf_iron,trupp1,300) then
        Logic.EntityLookAt(serf_iron,trupp1)
        Logic.EntityLookAt(trupp1,serf_iron)
    end
end


---------NV bei der Eisenmine

function CreateNVIronPit()

    if mode == 1 then
        nvIron_table = {
            [1] = 1, --Größe der Armee/ Leaderanzahl
            [2] = 60 --Respawnzeit
        }
        SetHealth("nv_spawner_iron", 40)
    elseif mode == 2 then
        nvIron_table = {
            [1] = 2, --Größe der Armee/ Leaderanzahl
            [2] = 30 --Respawnzeit
        }
    elseif mode == 3 then
        nvIron_table = {
            [1] = 4, --Größe der Armee/ Leaderanzahl
            [2] = 10 --Respawnzeit
        }
    end
    
    
        NVIronArmy = LazyUnlimitedArmy:New({					
            -- benötigt
            Player = 6,
            Area = 2000,
            -- optional
            AutoDestroyIfEmpty = true,
            TransitAttackMove = true,
            Formation = UnlimitedArmy.Formations.Chaotic,
            AIActive = true,
            AutoRotateRange = 100000,
            HiResJob = true
        }, 6,10)
    

        SpawnerNVIronArmy = UnlimitedArmySpawnGenerator:New(NVIronArmy, {
            -- benötigt:
            Position = GetPosition("nv_spawn_iron"), --position
            ArmySize = nvIron_table[1], --armysize
            SpawnCounter = nvIron_table[2],  --spawncounter
            SpawnLeaders = nvIron_table[1],   --spawnleaders
            LeaderDesc = {
                {LeaderType = Entities.CU_Evil_LeaderBearman1, SoldierNum = 16 , SpawnNum = 1, Looped = true, Experience = 3},
                {LeaderType = Entities.CU_Evil_LeaderSkirmisher1, SoldierNum = 16 , SpawnNum = 1, Looped = true, Experience = 3},
            },
            -- optional:
            Generator = "nv_spawner_iron",  --generator
        })
    

    ---Move-Befehle
    
    NVIronArmy: AddCommandMove(GetPosition("patrol_iron1"), true);
    NVIronArmy: AddCommandWaitForIdle(true);
    NVIronArmy: AddCommandMove(GetPosition("patrol_iron2"), true);
    NVIronArmy: AddCommandWaitForIdle(true);
    NVIronArmy: AddCommandMove(GetPosition("nv_spawn_iron"), true);
    NVIronArmy: AddCommandWaitForIdle(true);


    AddChangeGate("patrol_iron2",1000,Entities.CU_Evil_LeaderBearman1,Entities.CU_Evil_LeaderSkirmisher1, "Tor1")
    Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, nil, "NVIronSpawnerDead",1,nil,nil)

end

function NVIronSpawnerDead()
    if NVIronArmy:IsDead() == -1 and IsDestroyed("nv_spawner_iron") then
        RemoveChangeGate("Tor1")
        local _,gateClosedID = Logic.GetEntitiesInArea(Entities.XD_DarkWallStraightGate_Closed,GetPosition("patrol_iron2").X,GetPosition("patrol_iron2").Y,500,1)
        if Logic.GetEntityTypeName(Logic.GetEntityType(gateClosedID)) == "XD_DarkWallStraightGate_Closed" then
            ReplaceEntityOnNextTick(gateClosedID,Entities.XD_DarkWallStraightGate, nil)  --Tor zur Eisenmine
        end
        return true;
    end
end




pitCounter = 0

function PitQuest()
    local pitID = Event.GetEntityID()
    if Logic.GetEntityTypeName(Logic.GetEntityType(pitID)) == "XD_ClosedIronPit1" then
        pitCounter = pitCounter + 1
    elseif Logic.GetEntityTypeName(Logic.GetEntityType(pitID)) == "XD_ClosedSulfurPit1" then
        pitCounter = pitCounter + 1
    elseif Logic.GetEntityTypeName(Logic.GetEntityType(pitID)) == "XD_ClosedStonePit1" then
        pitCounter = pitCounter + 1
    elseif Logic.GetEntityTypeName(Logic.GetEntityType(pitID)) == "XD_ClosedClayPit1" then
        pitCounter = pitCounter + 1
    end

    if pitCounter >= 4 then
        Logic.AddQuest(1, 2, SUBQUEST_CLOSED, "@color:255,0,0 Minen", "@cr Helgar wurde damit beauftrag die Minen wieder freizulegen. Der Wissenschaflter könnte Ihm hierbei behilflich sein.", 1)
        return true;
    end

end