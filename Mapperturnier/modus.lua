function GUIActionButton_EasyMode()
    XGUIEng.ShowWidget("ModeSelection_StartGame", 1)
    mode = 1;
    mode_text1 = "@color:0,128,0 Einfach"
    mode_text2 = "Willkommen bei der Schlacht um Grimsvötn @cr @cr Eure gewählte Schwierigkeit ist: @cr @cr @cr @color:0,128,0 EINFACH"
    mode_text3 = "@center Schwierigkeit @color:0,128,0 Einfach @cr @color:255,255,255 Ihr startet mit vielen Ressourcen und eine geringe Menge an feindlichen Truppen werden zu bewältigen sein."
    XGUIEng.ShowWidget("Flag_Easy",1)
    XGUIEng.ShowWidget("Flag_Medium",0)
    XGUIEng.ShowWidget("Flag_Hard",0)
    GUITextUpdate_RightText()
    GUITextUpdate_BottomText() 
    
end

function GUIActionButton_MediumMode() 
    XGUIEng.ShowWidget("ModeSelection_StartGame", 1)
    mode = 2;
    mode_text1 = "@color:255,255,0 Mittel"
    mode_text2 = "Willkommen bei der Schlacht um Grimsvötn @cr @cr Eure gewählte Schwierigkeit ist: @cr @cr @cr @color:255,255,0 MITTEL"
    mode_text3 = "@center Schwierigkeit @color:255,255,0 Mittel @cr @color:255,255,255 Ihr startet mit mäßig Ressourcen und eine gute Menge an feindlichen Truppen werden zu bewältigen sein."
    XGUIEng.ShowWidget("Flag_Easy",0)
    XGUIEng.ShowWidget("Flag_Medium",1)
    XGUIEng.ShowWidget("Flag_Hard",0)
    GUITextUpdate_RightText()
    GUITextUpdate_BottomText() 

end

function GUIActionButton_HardMode() 
    XGUIEng.ShowWidget("ModeSelection_StartGame", 1)
    mode = 3;
    mode_text1 = "@color:255,0,0 Schwer"
    mode_text2 = "Willkommen bei der Schlacht um Grimsvötn @cr @cr Eure gewählte Schwierigkeit ist: @cr @cr @cr @color:255,0,0 SCHWER"
    mode_text3 = "@center Schwierigkeit @color:255,0,0 Schwer @cr @color:255,255,255 Ihr startet mit wenig Ressourcen und eine maßive Menge an feindlichen Truppen werden zu bewältigen sein."
    XGUIEng.ShowWidget("Flag_Easy",0)
    XGUIEng.ShowWidget("Flag_Medium",0)
    XGUIEng.ShowWidget("Flag_Hard",1)
    GUITextUpdate_RightText()
    GUITextUpdate_BottomText() 

end

function GUITextUpdate_RightText() 
    XGUIEng.SetText("ModeSelection_RightText", mode_text2)
end

function GUITextUpdate_BottomText() 
    XGUIEng.SetText("ModeSelection_Bottom_Info", mode_text3)
end

function GUIButtonAction_StartGame() 
    Logic.ResumeEntity(varg)
    Logic.ResumeEntity(trupp1)
    Logic.ResumeEntity(trupp2)
    Logic.ResumeEntity(trupp3)
    CppLogic.Entity.SetDisplayName(trupp1, "Helgar der Barbar")
    CppLogic.Entity.SetDisplayName(trupp2, "Wolfgang der Barbar")
    CppLogic.Entity.SetDisplayName(trupp3, "Rüdiger der Barbar")
    SetEntityOverheadWidget(varg,1)
    SetEntityOverheadWidget(trupp1,1)
    SetEntityOverheadWidget(trupp2,1)
    SetEntityOverheadWidget(trupp3,1)
    XGUIEng.ShowWidget("Normal", 1)
    XGUIEng.ShowWidget("Modus", 0)
    Message("@center @color:0,252,255 Schwierigkeit: "..mode_text1.." @color:0,252,255 wurde ausgewählt!")
    CreateNVStart()
end

---------------------------Comfort Funcs---------------------------------------


function SetEntityOverheadWidget(_entity,_flag) 
    local id = GetID(_entity)
    Logic.SetEntityScriptingValue(id,72,_flag)
end