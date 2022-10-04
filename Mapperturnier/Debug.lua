--Debug Alle Techs freischalten
function DebugTech()
    Logic.SetTechnologyState(1,Technologies.GT_Alchemy,3)
    Logic.SetTechnologyState(1,Technologies.GT_Alloying,3)
    Logic.SetTechnologyState(1,Technologies.GT_Architecture,3)
    Logic.SetTechnologyState(1,Technologies.GT_Banking,3)
    Logic.SetTechnologyState(1,Technologies.GT_Binocular,3)
    Logic.SetTechnologyState(1,Technologies.GT_ChainBlock,3)
    Logic.SetTechnologyState(1,Technologies.GT_Chemistry,3)
    Logic.SetTechnologyState(1,Technologies.GT_Construction,3)
    Logic.SetTechnologyState(1,Technologies.GT_GearWheel,3)
    Logic.SetTechnologyState(1,Technologies.GT_Gilds,3)
    Logic.SetTechnologyState(1,Technologies.GT_Laws,3)
    Logic.SetTechnologyState(1,Technologies.GT_Library,3)
    Logic.SetTechnologyState(1,Technologies.GT_Matchlock,3)
    Logic.SetTechnologyState(1,Technologies.GT_Mathematics,3)
    Logic.SetTechnologyState(1,Technologies.GT_Mercenaries,3)
    Logic.SetTechnologyState(1,Technologies.GT_Metallurgy,3)
    Logic.SetTechnologyState(1,Technologies.GT_Printing,3)
    Logic.SetTechnologyState(1,Technologies.GT_PulledBarrel,3)
    Logic.SetTechnologyState(1,Technologies.GT_StandingArmy,3)
    Logic.SetTechnologyState(1,Technologies.GT_Strategies,3)
    Logic.SetTechnologyState(1,Technologies.GT_Tactics,3)
    Logic.SetTechnologyState(1,Technologies.GT_Taxation,3)
    Logic.SetTechnologyState(1,Technologies.GT_Trading,3)
    Logic.SetTechnologyState(1,Technologies.GT_Literacy,3)
end


--Debug SpawnSerf
function DebugSerf()
    CreateEntity(1,Entities.PU_Serf,GetPosition("spawn_trupp1"),"debug_serf")
end

--Debug StartNV
function Debug1()
    nvStartArmy:KillAllLeaders()
    nvStartArmy:Destroy()
end

--Debug Banditcamp1
function Debug2()
    for i=1,2,1 do
        DestroyEntity("bandit"..i)  
    end
    for i=1,2,1 do
        _G["BanditArmy"..i]:KillAllLeaders()
        _G["BanditArmy"..i]:Destroy()
    end
end


--Debug Banditcamp2
function Debug3()
    for i=3,4,1 do
        DestroyEntity("bandit"..i)  
    end
    for i=3,4,1 do
        _G["BanditArmy"..i]:KillAllLeaders()
        _G["BanditArmy"..i]:Destroy()
    end
end

--Debug NVCamp

function Debug4()
   DestroyEntity("nv_spawner1") 
   DestroyEntity("nv_spawner2") 
   DestroyEntity("evil_tower1")
   DestroyEntity("evil_tower2")
   DestroyEntity("evil_tower3")
   DestroyEntity("evil_tower4")
   DestroyEntity("evil_tower5")
   DestroyEntity("evil_tower6")
   for i=1,2,1 do
    _G["NvCampArmy"..i]:KillAllLeaders()
    _G["NvCampArmy"..i]:Destroy()
end
end