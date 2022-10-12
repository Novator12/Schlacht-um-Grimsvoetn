----------------------------------------------------------------------Cutscene VillageFlight-----------------------------------------------------------------------------



-- Start-Funktion für die Intro-Cutscene
function Cutscene_villageflight_Start()
 
    -- In der Start-Funktion muss immer der Kinomodus aktiviert werden,
    -- denn dieser ist nicht automatisch vorhanden
    Interface_SetCinematicMode(1)
 
end
 
-- Finished Funktion
function Cutscene_villageflight_Finished()
 
    -- Hier muss der Kinomodus wieder deaktiviert werden
    Interface_SetCinematicMode(0)
 
    -- Der Aufruf von CutsceneDone() ist ebenfalls zwingend erforderlich!
    CutsceneDone()
 
end
 
-- Cancel-Funktion
function Cutscene_villageflight_Cancel()
 
    -- Hier reicht es oft aus, einfach die Finished-Funktion aufzurufen
    Cutscene_villageflight_Finished()
 
end







-- Callback Funcs

function Cutscene_villageflight_Village_Page1()
    PrintBriefingHeadline("")
    PrintBriefingText("Nach mehreren Stunden Arbeit war die Arbeit vollbracht.")
end

function Cutscene_villageflight_Village_Page2()
    PrintBriefingHeadline("")
    PrintBriefingText("")
end

function Cutscene_villageflight_Village_Page3()
    PrintBriefingHeadline("")
    PrintBriefingText("Das Dorf war nun wie früher befestigt.")
end

function Cutscene_villageflight_Village_Page4()
    PrintBriefingHeadline("")
    PrintBriefingText("Jetzt wird es keinem mehr so leicht fallen Reynivellir nochmal zu zerstören.")
end

function Cutscene_villageflight_Village_Page5()
    PrintBriefingHeadline("")
    PrintBriefingText("")
end

function Cutscene_villageflight_Village_Page6()
    PrintBriefingHeadline("")
    PrintBriefingText("")
end

function Cutscene_villageflight_Village_Page7()
    PrintBriefingHeadline("")
    PrintBriefingText("")
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------