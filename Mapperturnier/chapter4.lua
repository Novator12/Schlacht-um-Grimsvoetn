function Start_Chapter4()
    chapterID = 4
    chapterText = "Schlacht um Grimsvötn @cr Der Anführer der Schattenkrieger ist geflohen. Findet einen Weg die Schattenfeste zu zerstören."
    ResetQuestBook(1)
    EndJob("DefeatJob1")
    Logic.AddQuest(1, 1, MAINQUEST_OPEN, "@color:255,0,0 Die Feste im Schatten", "@cr Der Anführer der Schattenkrieger ist geflohen. Sucht einen Weg zur Schattenfeste!", 1)  
    varg = Logic.CreateEntity(Entities.CU_Barbarian_Hero, GetPosition("varg_chap4").X, GetPosition("varg_chap4").Y, 0, 1)
    trupp1 = Logic.CreateEntity(Entities.CU_VeteranLieutenant, GetPosition("trupp1_chap4").X,GetPosition("trupp1_chap4").Y,0, 1)
    trupp2 = Logic.CreateEntity(Entities.CU_VeteranLieutenant, GetPosition("trupp2_chap4").X,GetPosition("trupp2_chap4").Y,0, 1)
    trupp3 = Logic.CreateEntity(Entities.CU_VeteranLieutenant, GetPosition("trupp3_chap4").X,GetPosition("trupp3_chap4").Y,0, 1)
    guard = Logic.CreateEntity(Entities.CU_VeteranLieutenant, GetPosition("guard_chap4").X,GetPosition("guard_chap4").Y,0, 1)
    theodor = Logic.CreateEntity(Entities.PU_Thief,GetPosition("theodor_spawn").X,GetPosition("theodor_spawn").Y,0,2)
    DefeatJob1 = StartSimpleJob("AllHerosDead")
    RefreshDisplayNames()
    MakeDefInvulnerable()
    SetupAI(SetupPlayer4)
    StartBriefingChapter4()
    ActivateTributesChapter4()
end


SetupPlayer4 = {
    id = 4,
    name = "Schattenfeste",
    headquarters = "hq_id4",
    color = "grey",
    strength = 4,
    range = 100000,
    techlevel = 4,
    aggressiveness = 8,
    extracting = false,
    repairing = true,
    friends = false,
    enemies = {1,2},
    explore = false,
}

function MakeDefInvulnerable()
    for i = 1,4,1 do
        Logic.SetEntityInvulnerabilityFlag(GetID("inv_tower"..i),1)
    end
end



function StartBriefingChapter4()
    Move(theodor,varg,200)
    StartSimpleJob("TheodorNearVarg")
    Logic.EntityLookAt(trupp1,varg)
    Logic.EntityLookAt(trupp2,varg)
    Logic.EntityLookAt(trupp3,varg)
    Logic.EntityLookAt(guard,varg)
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    local page2
    local page1 = AP{
        title	= "@color:255,0,0 Varg",
        text	= "@color:255,136,0 ...also, Ihr wisst was zu tun ist. Gebt die Befehle an die Hauptmänner weiter. Wir müssen einen Weg über die Zugbrücken finden.",
        position = GetPosition(varg),
        explore = 2000,
        action = function()
            page2.npc = { id = GetEntityId(theodor),isObserved = true }
        end
    }
    page2 = AP{
        title	= "Mentor",
        text	= "Seht Herr, ein fremder betritt den Burghof. Was er wohl will?",
        npc = { id = GetEntityId(theodor),
            isObserved = true },
    }
    local page3 = AP{
        title	= "@color:255,0,0 Fremder",
        text	= "@color:255,136,0 Guten Tag, eure Lordschaft. Darf ich mich vorstellen. Meine Name ist Theodor Eisenklaue.",
        position = GetPosition(varg)
    }
    local page4 = AP{
        title	= "@color:255,0,0 Varg",
        text	= "@color:255,136,0 Ahhh... einer von den Eisenklauen. Alles Diebe, Vergewaltiger und Mörder. Verschwindet sofort aus meiner Burg.",
        position = GetPosition(varg)
    }
    local page5 = AP{
        title	= "@color:255,0,0 Eisenklaue",
        text	= "@color:255,136,0 So wartet doch. Ich kann euch helfen. Ich habe mich lange Zeit in der Schattenfeste eingeschleust und kenne einen Weg hinein. Wäre das nicht lukrativ für euch?",
        position = GetPosition(varg)
    }
    local page6 = AP{
        title	= "@color:255,0,0 Varg",
        text	= "@color:255,136,0 Hmm..sprecht weiter!",
        position = GetPosition(varg)
    }
    local page7 = AP{
        title	= "@color:255,0,0 Eisenklaue",
        text	= "@color:255,136,0 Ich konnte verschiedene Schwachstellen in den Anlagen Ihrer Verteidigung ausmachen und könnte euch behilflich sein, diese auszuschalten.",
        position = GetPosition(varg)
    }
    local page8 = AP{
        title	= "@color:255,0,0 Eisenklaue",
        text	= "@color:255,136,0 Es gibt hier eine Dampfmaschine, welche das süd-östliche Tor und dessen Verteidigungstürme unbesiegbar macht,...",
        position = GetPosition("gate_protector"),
        explore = 300,
        action = function() GUI.CreateMinimapMarker(GetPosition("gate_protector").X,GetPosition("gate_protector").Y,3) end
    }
    local page9 = AP{
        title	= "@color:255,0,0 Eisenklaue",
        text	= "@color:255,136,0 ...hier gibt es ein Wärterhäuschen, mit dem die Brücke für die nördliche Passage abgesenkt werden kann...",
        position = GetPosition("bridge_north"),
        explore = 300,
        action = function() GUI.CreateMinimapMarker(GetPosition("bridge_north").X,GetPosition("bridge_north").Y,3) end
    }
    local page10 = AP{
        title	= "@color:255,0,0 Eisenklaue",
        text	= "@color:255,136,0 ...und zu guter letzt das Haupthäuschen, welches die Brücken über die Lavaflüsse steuert.",
        position = GetPosition("bridge_lava"),
        explore = 300,
        action = function() GUI.CreateMinimapMarker(GetPosition("bridge_lava").X,GetPosition("bridge_lava").Y,3) end
    }
    local page11 = AP{
        title	= "@color:255,0,0 Varg",
        text	= "@color:255,136,0 Danke für diese Informationen, nur wie soll uns das weiterhelfen, wenn wir nicht in Ihre Feste gelangen?",
        position = GetPosition(varg)
    }
    local page12 = AP{
        title	= "@color:255,0,0 Eisenklaue",
        text	= "@color:255,136,0 Da komme ich ins Spiel. Diese Mistkerle habe meine Frau hingerichtet und ich will mich rächen. Ich kann euch, solange ich es überlebe, Ihre Verteidigungsmechaniken deaktivieren.",
        position = GetPosition(varg)
    }
    local page13 = AP{
        title	= "@color:255,0,0 Leonardo",
        text	= "@color:255,136,0 BAHMMMMM...Sagte jemand Explosionen?",
        position = GetPosition(varg),
        action = function()
            if IsExisting(leonardo) then
                DestroyEntity(leonardo)
            end
            leonardo = Logic.CreateEntity(Entities.CU_Leonardo,GetPosition("leonardo_chap4").X,GetPosition("leonardo_chap4").Y,0,3 )
            Logic.CreateEffect(GGL_Effects.FXExplosion, GetPosition("leonardo_chap4").X, GetPosition("leonardo_chap4").Y, 1)
            Sound.Play2DSound(1071,0,150)
            Logic.EntityLookAt(leonardo,theodor)
            Logic.EntityLookAt(theodor,leonardo)
            Logic.EntityLookAt(varg,leonardo)
            Logic.EntityLookAt(trupp1,leonardo)
            Logic.EntityLookAt(trupp2,leonardo)
            Logic.EntityLookAt(trupp3,leonardo)
            Logic.EntityLookAt(guard,leonardo)
        end
    }
    local page14 = AP{
        title	= "@color:255,0,0 Eisenklaue",
        text	= "@color:255,136,0 Ähmm..nein..wir sprachen über Sabotage.",
        position = GetPosition(varg)
    }
    local page15 = AP{
        title	= "@color:255,0,0 Leonardo",
        text	= "@color:255,136,0 Auch gut! Ich habe ein Mittel entwickelt, um eine Dampfmaschine zu zerstören. Ihr braucht dafür jedoch ein paar Materialien, welche Ihr nur in der Feste der Schattenkrieger auftreiben könnt.",
        position = GetPosition(varg)
    }
    local page16 = AP{
        title	= "@color:255,0,0 Eisenklaue",
        text	= "@color:255,136,0 Und was wäre das für komisches Zeug?",
        position = GetPosition(varg)
    }
    local page17 = AP{
        title	= "@color:255,0,0 Leonardo",
        text	= "@color:255,136,0 Ganz einfach: Vulkanwasser aus einem Brunnen, Glut aus einem Geysir, die Haare eines Schafes und ein paar Schrottteile. Mixt dies alles zusammen und kippt es auf die Dampfmaschine.",
        position = GetPosition(varg)
    }
    local page18 = AP{
        title	= "@color:255,0,0 Eisenklaue",
        text	= "@color:255,136,0 Na super...Dann mache ich mich wohl besser auf den Weg.",
        position = GetPosition(varg)
    }
    local page19 = AP{
        title	= "@color:255,0,0 Varg",
        text	= "@color:255,136,0 Viel Erfolg Theodor Eisenklaue!",
        position = GetPosition(varg)
    }
    local page20 = AP{
        title	= "Mentor",
        text	= "Eisenklaue berichtete mir, dass er sich zum Geheimgang hierhin begeben wird.",
        position = GetPosition("thief_pos1"),
        explore = 300,
        action = function()
            GUI.CreateMinimapMarker(GetPosition("thief_pos1").X,GetPosition("thief_pos1").Y,0)
        end
    }
    briefing.finished = function()  
        ThiefQuest = true
        ResolveBriefing(page1);
        ResolveBriefing(page2);
        Logic.SetOnScreenInformation(theodor,0)
        DestroyEntity("barrier_lava2")
        ActivateThiefQuest()
        StartSimpleJob("TheodorNearSecretEntrance")
        Logic.AddQuest(2, 1, MAINQUEST_OPEN, "@color:255,0,0 Die Intrige", "Eisenklaue soll die Verteidigungsanlagen der Schattenfeste schwächen. Diese Mission unterteilt sich in zwei Bereiche: @cr @cr 1) Die Kontrolle über die Zugbrückenmechanismen @cr @cr 2) Die Sabotage der Dampfmaschine der süd-östlichen Verteidigungsanlage", 1) 
        Logic.AddQuest(2, 2, SUBQUEST_OPEN, "@color:255,0,0 Zugbrücken", "Findet in der Feste die Zugbrückenkurbeln und bringt Sie in die dafür vorgesehnen Kontrollhäuschen.", 1) 
        Logic.AddQuest(2, 3, SUBQUEST_OPEN, "@color:255,0,0 Dampfmaschine", "Sammelt folgende Materialien: @cr @cr 1) Vulkanwasser aus einem Brunnen @cr 2) Glut aus einem Geysir @cr 3) Haare von einem Schaf @cr 4) Schrottteile @cr @cr Habt Ihr alles gesammelt geht zur Dampfmaschine.", 1) 
    end;
    NormalSpeedInBriefing()
    StartBriefing(briefing)
    
end




function TheodorNearVarg()
    if IsNear(theodor,varg,300) then
        Logic.EntityLookAt(theodor,varg)
        Logic.EntityLookAt(varg,theodor)
        Logic.EntityLookAt(trupp1,theodor)
        Logic.EntityLookAt(trupp2,theodor)
        Logic.EntityLookAt(trupp3,theodor)
        Logic.EntityLookAt(guard,theodor)
        return true
    end
end


function ActivateThiefQuest() --Wechselt zu Spieler 2
    GUI.SetControlledPlayer(2)
    Logic.ActivateUpdateOfExplorationForAllPlayers()
    StartPatrolKI4()

end

function StartPatrolKI4()


    if mode == 1 then
        KI4_Def = {
            [1] = 1, --Größe der Armee/ Leaderanzahl
            [2] = 160 --Respawnzeit
        }
    elseif mode == 2 then
        KI4_Def = {
            [1] = 2, --Größe der Armee/ Leaderanzahl
            [2] = 140 --Respawnzeit
        }
    elseif mode == 3 then
        KI4_Def = {
            [1] = 3, --Größe der Armee/ Leaderanzahl
            [2] = 120 --Respawnzeit
        }
    end



    function SoeldnerMove(self)
        if not self:IsIdle() then
            return false
        end
        local numbertable = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 }
        table.remove(numbertable, self.LastPoint)
        for k, v in pairs(numbertable) do
            if v == self.CurrentPoint then
                self.LastPoint = table.remove(numbertable, k)
                break;
            end
        end
        self.CurrentPoint = numbertable[math.random(1, 11)]
        return false, UnlimitedArmy.CreateCommandMove(self.Points[self.CurrentPoint], false)
    end

    KI4ArmyTable = {}

    for i = 1, 8, 1 do
        KI4ArmyTable[i] = {}
        KI4ArmyTable[i][1] = LazyUnlimitedArmy:New({
            -- benötigt
            Player = 4,
            Area = 2000,
            -- optional
            AutoDestroyIfEmpty = true,
            TransitAttackMove = true,
            Formation = UnlimitedArmy.Formations.Chaotic,
            AIActive = true,
            AutoRotateRange = 100000,
            HiResJob = true
        }, 11 + i, NumberUA)

        --ArmyParolPoints
        KI4ArmyTable[i][1].Points = {
            GetPosition("id4_patrol1"),
            GetPosition("id4_patrol2"),
            GetPosition("id4_patrol3"),
            GetPosition("id4_patrol4"),
            GetPosition("id4_patrol5"),
            GetPosition("id4_patrol6"),
            GetPosition("id4_patrol7"),
            GetPosition("id4_patrol8"),
            GetPosition("id4_patrol9"),
            GetPosition("id4_patrol10"),
            GetPosition("id4_patrol11"),
            GetPosition("id4_patrol12"),
            GetPosition("id4_patrol13")
        }
        KI4ArmyTable[i][1].LastPoint = nil
        KI4ArmyTable[i][1].CurrentPoint = math.random(1, 13)


        KI4SpawnerTable = {
            [1] = { "barracks_id4", "spawn_barracks_id4", Entities.PU_LeaderSword4, 8 },
            [2] = { "archery_id4", "spawn_archery_id4", Entities.PU_LeaderBow4, 8 },
            [3] = { "foundry_id4", "spawn_foundry_id4", Entities.PV_Cannon4, 0 },
            [4] = { "stables_id4", "spawn_stables_id4", Entities.PU_LeaderCavalry2, 6 },
            [5] = { "tower1_id4", "spawn_tower1_id4", Entities.CU_BanditLeaderSword2, 8 },
            [6] = { "tower2_id4", "spawn_tower2_id4", Entities.CU_BanditLeaderBow2, 8 },
            [7] = { "hq_id4", "spawn_hq_id4", Entities.CU_VeteranMajor, 0 },
            [8] = { "inv_tower2", "spawn_inv_tower2", Entities.CU_VeteranMajor, 4 },
        }

        KI4ArmyTable[i][2] = UnlimitedArmySpawnGenerator:New(KI4ArmyTable[i][1], {
            -- benötigt:
            Position = GetPosition(KI4SpawnerTable[i][2]), --position
            ArmySize = KI4_Def[1], --armysize
            SpawnCounter = KI4_Def[2], --spawncounter
            SpawnLeaders = KI4_Def[1], --spawnleaders
            LeaderDesc = {
                { LeaderType = KI4SpawnerTable[i][3], SoldierNum = KI4SpawnerTable[i][4], SpawnNum = 1, Looped = true,
                    Experience = 3 },
            },
            -- optional:
            Generator = KI4SpawnerTable[i][1], --generator
        })

        KI4ArmyTable[i][1]:AddCommandMove(GetPosition("id4_patrol" .. KI4ArmyTable[i][1].CurrentPoint), false)
        KI4ArmyTable[i][1]:AddCommandWaitForIdle(false)
        local numbertable = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 }
        KI4ArmyTable[i][1].LastPoint = table.remove(numbertable, KI4ArmyTable[i][1].CurrentPoint)
        local nextpoint = numbertable[math.random(1, 12)]
        KI4ArmyTable[i][1]:AddCommandMove(GetPosition("id4_patrol" .. nextpoint), false)
        KI4ArmyTable[i][1].CurrentPoint = nextpoint
        KI4ArmyTable[i][1]:AddCommandLuaFunc(SoeldnerMove, true)
    end

end



SteamMachineDestroyed = false
AllBridgesActivated = false

function TheodorNearSecretEntrance()
    if IsNear(theodor,"thief_pos1",300) then
        GUI.DestroyMinimapPulse(GetPosition("thief_pos1").X,GetPosition("thief_pos1").Y)
        DestroyEntity(theodor)
        theodor = Logic.CreateEntity(Entities.PU_Thief,GetPosition("thief_pos2").X,GetPosition("thief_pos2").Y,0,2)
        Message("Tada...Da bin ich!")
        Camera.ScrollSetLookAt(GetPosition("thief_pos2").X,GetPosition("thief_pos2").Y)
        ThiefDeadJob = StartSimpleJob("ThiefIsDead")
        ThiefCollectable1Job = StartSimpleJob("ThiefCollectable1")
        ThiefCollectable2Job = StartSimpleJob("ThiefCollectable2")
        ThiefCollectable3Job = StartSimpleJob("ThiefCollectable3")
        ThiefCollectable4Job = StartSimpleJob("ThiefCollectable4")
        ThiefAllCollectedJob = StartSimpleJob("AllCollected")
        ThiefKurbelMainBridgeJob = StartSimpleJob("ThiefKurbelMainBridge")
        ThiefKurbelSideBridgeJob = StartSimpleJob("ThiefKurbelSideBridge")
        ThiefNearMainBridgeJob = StartSimpleJob("ThiefNearMainBridge")
        ThiefNearSideBridgeJob = StartSimpleJob("ThiefNearSideBridge")
        ThiefAllBridgesCompletedJob = StartSimpleJob("ThiefAllBridgesCompleted")
        ThiefQuestCompletedJob = StartSimpleJob("ThiefQuestCompleted")
        XGUIEng.ShowWidget("ThiefCollectables", 1)
        return true
    end
end


BridgesActive = 0
Kurbeln = 0

function ThiefKurbelMainBridge()
    if IsNear(theodor,"Kurbel1_1",200) then
        for i=1,4,1 do
            DestroyEntity("Kurbel1_"..i)
        end
        XGUIEng.ShowWidget("KurbelADone",1)
        Message("Ah...eine der beiden Zugbrückenkurbeln.")
        Kurbeln = Kurbeln +1
        return true
    end
end

function ThiefNearMainBridge()
    if IsNear(theodor,"keeper_spot1",200) and Kurbeln > 0 then
        Message("(Klack)...(Knack)...So die Kurbel ist dran!")
        GUI.DestroyMinimapPulse(GetPosition("bridge_lava").X,GetPosition("bridge_lava").Y)
        Kurbeln = Kurbeln -1
        BridgesActive = BridgesActive +1
        return true
    elseif IsNear(theodor,"keeper_spot1",200) and Kurbeln == 0 then
        Message("Ich muss zuerst eine Kurbel finden!")
    end
end


function ThiefKurbelSideBridge()
    if IsNear(theodor,"Kurbel2_1",200) then
        for i=1,4,1 do
            DestroyEntity("Kurbel2_"..i)
        end
        XGUIEng.ShowWidget("KurbelBDone",1)
        Message("Ah...eine der beiden Zugbrückenkurbeln.")
        Kurbeln = Kurbeln +1
        return true
    end
end

function ThiefNearSideBridge()
    if IsNear(theodor,"keeper_spot2",200) and Kurbeln > 0 then
        Message("(Klack)...(Knack)...So die Kurbel ist dran!")
        GUI.DestroyMinimapPulse(GetPosition("bridge_north").X,GetPosition("bridge_north").Y)
        Kurbeln = Kurbeln -1
        BridgesActive = BridgesActive +1
        return true
    elseif IsNear(theodor,"keeper_spot2",200) and Kurbeln == 0 then
        Message("Ich muss zuerst eine Kurbel finden!")
    end
end

function ThiefAllBridgesCompleted()
    if BridgesActive == 2 then
        StartBriefingAllBridgesDone()
        return true
    end
end

function StartBriefingAllBridgesDone()
        local briefing = {}
        local AP = function(_page) table.insert(briefing, _page) return _page end
        local page1 = AP{
            title	= "@color:255,0,0 Eisenklaue",
            text	= "@color:255,136,0 Jetzt sind beide Brücken wieder in Betrieb.",
            position = GetPosition(theodor),
            explore = 2000,
        }
            briefing.finished = function() 
                ResolveBriefing(page1) 
                AllBridgesActivated = true
                Logic.AddQuest(2, 2, SUBQUEST_CLOSED, "@color:255,0,0 Zugbrücken", "Findet in der Feste die Zugbrückenkurbeln und bringt Sie in die dafür vorgesehnen Kontrollhäuschen.", 1) 
            end;
            NormalSpeedInBriefing()
            StartBriefing(briefing)
end

function ThiefIsDead()
    if IsDestroyed(theodor) == true then
        Defeat()
        return true
    end
end

collectedCollectables = 0

function ThiefCollectable1()
    if IsNear(theodor,"vulc_water",200) then
        DestroyEntity("vulc_water")
        XGUIEng.ShowWidget("Collectable1Done", 1)
        Message("Hmmm...das muss das Vulkanwasser sein!")
        collectedCollectables = collectedCollectables + 1
        return true
    end
end

function ThiefCollectable2()
    if IsNear(theodor,"vulc_glut",200) then
        DestroyEntity("vulc_glut")
        XGUIEng.ShowWidget("Collectable2Done", 1)
        Message("Ahhh...das scheint die Glut zu sein!")
        collectedCollectables = collectedCollectables + 1
        return true
    end
end

function ThiefCollectable3()
    if IsNear(theodor,"sheep_hair",200) then
        DestroyEntity("sheep_hair")
        XGUIEng.ShowWidget("Collectable3Done", 1)
        Message("Tut mir leid, liebes Schafi.")
        collectedCollectables = collectedCollectables + 1
        return true
    end
end

function ThiefCollectable4()
    if IsNear(theodor,"scratch_parts",200) then
        DestroyEntity("scratch_parts")
        XGUIEng.ShowWidget("Collectable4Done", 1)
        Message("So viel Müll. Igitt!")
        collectedCollectables = collectedCollectables + 1
        return true
    end
end

function AllCollected()
    if collectedCollectables == 4 then
        Message("Jagen wir diese Dampfmaschine in die Luft!")
        StartSimpleJob("ThiefNearSteam")
        return true
    end
end

function ThiefNearSteam()
    if IsNear(theodor,"gate_protector",300) then
        GUI.DestroyMinimapPulse(GetPosition("gate_protector").X,GetPosition("gate_protector").Y)
        StartBriefingSteamMachine()
        return true
    end
end


function StartBriefingSteamMachine()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    local page1 = AP{
        title	= "@color:255,0,0 Eisenklaue",
        text	= "@color:255,136,0 So, jetzt mischen wir das alles zusammen...",
        position = GetPosition(theodor),
        explore = 2000,
    }
    local page2 = AP{
        title	= "@color:255,0,0 Eisenklaue",
        text	= "@color:255,136,0 ...und kippen es hier drauf.",
        position = GetPosition(theodor),
        action = function()
            Logic.CreateEffect(GGL_Effects.FXKalaPoison, GetPosition("gate_protector").X, GetPosition("gate_protector").Y, 1)
        end
    }
    local page3 = AP{
        title	= "",
        text	= "Die Maschine ächzte und explodiert.",
        position = GetPosition(theodor),
        action = function()
            Logic.CreateEffect(GGL_Effects.FXExplosion, GetPosition("gate_protector").X, GetPosition("gate_protector").Y, 1)
            Sound.Play2DSound(1071,0,150)
            DestroyEntity("gate_protector")
        end
    }
        briefing.finished = function()  
            ResolveBriefing(page1) 
            SteamMachineDestroyed = true
            Logic.AddQuest(2, 3, SUBQUEST_CLOSED, "@color:255,0,0 Dampfmaschine", "Sammelt folgende Materialien: @cr @cr 1) Vulkanwasser aus einem Brunnen @cr 2) Glut aus einem Geysir @cr 3) Haare von einem Schaf @cr 4) Schrottteile @cr @cr Habt Ihr alles gesammelt geht zur Dampfmaschine.", 1) 
            for i = 1,4,1 do
                Logic.SetEntityInvulnerabilityFlag(GetID("inv_tower"..i),0)
            end
        end;
        NormalSpeedInBriefing()
        StartBriefing(briefing)
end


function ThiefQuestCompleted()
    if SteamMachineDestroyed == true and AllBridgesActivated == true then
        Logic.AddQuest(2, 1, MAINQUEST_CLOSED, "@color:255,0,0 Die Intrige", "Eisenklaue soll die Verteidigungsanlagen der Schattenfeste schwächen. Diese Mission unterteilt sich in zwei Bereiche: @cr @cr 1) Die Kontrolle über die Zugbrückenmechanismen @cr @cr 2) Die Sabotage der Dampfmaschine der süd-östlichen Verteidigungsanlage", 1) 
        StartBriefingThiefEscape()
        return true
    end
end


function StartBriefingThiefEscape()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    local page1 = AP{
        title	= "@color:255,0,0 Eisenklaue",
        text	= "@color:255,136,0 Alles geschafft. Jetzt muss ich mich nurnoch hier rausschleichen.",
        position = GetPosition(theodor),
        explore = 2000,
    }
    local page2 = AP{
        title	= "@color:255,0,0 Eisenklaue",
        text	= "@color:255,136,0 Auf zum Geheimgang!",
        position = GetPosition("thief_pos2"),
        explore = 2000,
        action = function()
            GUI.CreateMinimapMarker(GetPosition("thief_pos2").X,GetPosition("thief_pos2").Y,0)
        end
    }
        briefing.finished = function()
            ResolveBriefing(page1)
            ResolveBriefing(page2)
            StartSimpleJob("ThiefSecretEscape")
        end;
        NormalSpeedInBriefing()
        StartBriefing(briefing)
end

function ThiefSecretEscape()
    if IsNear(theodor,"thief_pos2",300) then
        XGUIEng.ShowWidget("ThiefCollectables",0)
        GUI.DestroyMinimapPulse(GetPosition("thief_pos2").X,GetPosition("thief_pos2").Y)
        EndJob(ThiefDeadJob)
        DestroyEntity(theodor)
        theodor = Logic.CreateEntity(Entities.PU_Thief,GetPosition("thief_pos1").X,GetPosition("thief_pos1").Y,0,2)
        Message("Ich sollte mich auf den Weg zu Varg machen!")
        Camera.ScrollSetLookAt(GetPosition("thief_pos1").X,GetPosition("thief_pos1").Y)
        StartSimpleJob("ThiefNearVarg")
        return true
    end
end


function ThiefNearVarg()
    if IsNear(theodor,varg,300) then
        TheodorVargBriefing2()
        Logic.EntityLookAt(theodor,varg)
        Logic.EntityLookAt(leonardo,theodor)
        Logic.EntityLookAt(trupp1,theodor)
        Logic.EntityLookAt(trupp2,theodor)
        Logic.EntityLookAt(trupp3,theodor)
        Logic.EntityLookAt(guard,theodor)
        return true
    end
end


function TheodorVargBriefing2()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    local page1 = AP{
        title	= "@color:255,0,0 Eisenklaue",
        text	= "@color:255,136,0 Da bin ich wieder. Habt ihr mich vermisst?",
        position = GetPosition(theodor),
        explore = 2000,
    }
    local page2 = AP{
        title	= "@color:255,0,0 Varg",
        text	= "@color:255,136,0 Ich glaub es nicht... du hast es tatsächlich geschafft.",
        position = GetPosition(varg),
        explore = 2000,
    }
    local page3 = AP{
        title	= "@color:255,0,0 Eisenklaue",
        text	= "@color:255,136,0 Ein Klacks war es nict, aber ja, die Verteidigungsanlagen sind sabotiert. ",
        position = GetPosition(theodor)
    }
    local page4 = AP{
        title	= "@color:255,0,0 Eisenklaue",
        text	= "@color:255,136,0 Es liegt nun an euch, wie Ihr taktisch vorgehen wollt. Ihr habt die Kontrolle über die Zugänge.",
        position = GetPosition(theodor)
    }
    local page5 = AP{
        title	= "@color:255,0,0 Varg",
        text	= "@color:255,136,0 Dann lasst uns in den Krieg ziehen!",
        position = GetPosition(varg)
    }
        briefing.finished = function()  
            ResolveBriefing(page1) 
            ResolveBriefing(page2) 
            ResetQuestBook(2)
            GUI.SetControlledPlayer(1)
            Logic.ActivateUpdateOfExplorationForAllPlayers()
            theodor = ChangePlayer(theodor,1)
            Tools.ExploreArea(GetPosition("dw4").X,GetPosition("dw4").Y,600)
            Tools.ExploreArea(GetPosition("dw2").X,GetPosition("dw2").Y,600)
            Tools.ExploreArea(GetPosition("dw3").X,GetPosition("dw3").Y,600)
            Tools.ExploreArea(GetPosition("backdoor_player4").X,GetPosition("backdoor_player4").Y,600)
            AddTribute(Tribut_DrawBridgeNorth)
            AddTribute(Tribut_DrawBridgeLava)
            AddTribute(Tribut_BackdoorGate)
        end;
        NormalSpeedInBriefing()
        StartBriefing(briefing)
end

BridgesTable = {
    Gold = 0,
    Clay = 0,
    Wood = 0,
    Stone = 0,
    Iron = 0,
    Sulfur = 0,
    Silver = 0
}




function ActivateTributesChapter4()

    Tribut_DrawBridgeNorth = CreateATribute(1
    ,"@color:255,0,0 Zugbrücke: Norden @cr @color:255,255,255 Öffnet/ Schließt die Zugbrücke im Norden!",
    BridgesTable, 
    function() 
        ChangeBridgeNorth() 
        Tribut_DrawBridgeNorth.Tribute = nil
        AddTribute(Tribut_DrawBridgeNorth)
    end)

    Tribut_DrawBridgeLava = CreateATribute(1
    ,"@color:255,0,0 Zugbrücke: Lavagebiet @cr @color:255,255,255 Öffnet/ Schließt die Zugbrücke im Lavagebiet!",
    BridgesTable, 
    function() 
        ChangeBridgeLava() 
        Tribut_DrawBridgeLava.Tribute = nil
        AddTribute(Tribut_DrawBridgeLava)
    end)

    Tribut_BackdoorGate = CreateATribute(1
    ,"@color:255,0,0 Tor: Süd-Osten @cr @color:255,255,255 Öffnet/ Schließt das Tor im Süd-Osten!",
    BridgesTable, 
    function() 
        ChangeBackdoorGate() 
        Tribut_BackdoorGate.Tribute = nil
        AddTribute(Tribut_BackdoorGate)
    end)

end



function ChangeBridgeNorth()
    local bID = GetID("dw4")
    local type = Logic.GetEntityTypeName(Logic.GetEntityType(bID))
    if type == "PB_DrawBridgeClosed2" then
        ReplaceEntity(bID,Entities.XD_DrawBridgeOpen2)
    else
        ReplaceEntity(bID,Entities.PB_DrawBridgeClosed2)
    end
end



function ChangeBridgeLava()
    local bID1 = GetID("dw2")
    local bID2 = GetID("dw3")
    local type1 = Logic.GetEntityTypeName(Logic.GetEntityType(bID1))
    local type2 = Logic.GetEntityTypeName(Logic.GetEntityType(bID2))
    if type1 == "PB_DrawBridgeClosed2" and type2 == "PB_DrawBridgeClosed2" then
        ReplaceEntity(bID1,Entities.XD_DrawBridgeOpen2)
        ReplaceEntity(bID2,Entities.XD_DrawBridgeOpen2)
    else
        ReplaceEntity(bID1,Entities.PB_DrawBridgeClosed2)
        ReplaceEntity(bID2,Entities.PB_DrawBridgeClosed2)
    end
end


function ChangeBackdoorGate()
    local bID = GetID("backdoor_player4")
    local type = Logic.GetEntityTypeName(Logic.GetEntityType(bID))
    if type == "XD_DarkWallStraightGate_Closed" then
        ReplaceEntity(bID,Entities.XD_DarkWallStraightGate)
    else
        ReplaceEntity(bID,Entities.XD_DarkWallStraightGate_Closed)
    end
end




