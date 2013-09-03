; Program for calculating room usage in Gestbal Hotel program
; Made by Mivor

#SingleInstance force
SendMode, Input
StartX = 127
StartY = 163
MoveDiff = 34
MonthDays = 31
FilterControl = TDBFilterCombo1

F3::
CheckWindow()
CheckFilter()
SearchList()
ExitApp, 0

F4::
ExitApp, 1

F6::
CheckFilter()
return

F2::
GetControlList()
; GetWindowText()
return

SearchList()
{
    global
    MouseMove, %StartX%, %StartY%
    Loop, 20
    {
        Loop, % MonthDays - 1
        {
            Sleep, 20
            MouseMove, %MoveDiff%, 0,, R
        }
        Sleep, 500
        MouseMove, %StartX%, % StartY + (A_Index * MoveDiff)
    }
}

CheckWindow()
{
    IfWinExist, Gestbal Hotel - Rezervari ahk_class TTimeLine
    {
        WinActivate
        WinMaximize
        ; MsgBox, Window exists and is active
    }
    else
    {
        MsgBox, The program is not running!
        ExitApp, 1
    }
}

CheckFilter()
{
    global
    ControlGetText, FilterText, %FilterControl%, A
    IfNotInString, FilterText, Toate
    {
        ControlSend, %FilterControl%, {up}{up}{up}{up}, A
    }
}

GetMonthDays(){

}

GetControlList()
{
    #Persistent
    SetTimer, WatchActiveWindow, 200
    return
    WatchActiveWindow:
    WinGet, ControlList, ControlList, A
    Controls = CONTROLS`n
    ControlText := ""
    Loop, Parse, ControlList, `n
    {
        ControlGetText, ControlText, %A_LoopField%, A
        Controls := Controls . A_LoopField . "`t"
        Controls := Controls . "'" . ControlText . "'`n"
    }
    ToolTip, %Controls%
    ; MsgBox, %ControlList%
    return
}

GetControl()
{
    ; This working example will continuously update and display the
    ; name and position of the control currently under the mouse cursor:
    Loop
    {
        Sleep, 100
        MouseGetPos, , , WhichWindow, WhichControl
        ControlGetPos, x, y, w, h, %WhichControl%, ahk_id %WhichWindow%
        ControlGetText, ControlText, %WhichControl%, A
        ToolTip, %WhichControl%`nX%X%`tY%Y%`nW%W%`tH%H%`nText:%ControlText%
    }
}

