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
    }
    local page4 = AP{
        title	= "@color:255,0,0 Helgar",
        text	= "@color:255,136,0 Har Har, ich bin unbesiegbar! Habt Dank werter Herr.",
        position = GetPosition(trupp1),
        explore = 2000
    }


    briefing.finished = function()  
        ResolveBriefing(page1);
        ResolveBriefing(page4);
        MoveAndVanish(GetID(scientist), GetID("leoas_vanish")) 
        --Hier Bombenfähigkeit Widget einschalten.
        
    end;
    NormalSpeedInBriefing()
    StartBriefing(briefing)
end 