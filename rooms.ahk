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
ExitApp, 0

F2::
; This working example will continuously update and display the
; name and position of the control currently under the mouse cursor:
Loop
{
    Sleep, 100
    MouseGetPos, , , WhichWindow, WhichControl
    ControlGetPos, x, y, w, h, %WhichControl%, ahk_id %WhichWindow%
    ToolTip, %WhichControl%`nX%X%`tY%Y%`nW%W%`tH%H%
}

CheckWindow()
{
    IfWinExist, Gestbal Hotel - Rezervari ahk_class TTimeLine
    {
        WinActivate
        MsgBox, Window exists and is active
    }
    else
    {
        MsgBox, The program is not running!
    }
}
