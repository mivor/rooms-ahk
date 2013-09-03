; Program for calculating room usage in Gestbal Hotel program
; Made by Mivor

#SingleInstance force
SendMode, Input
StartX = 127
StartY = 163
MoveDiff = 34
MonthDays = 31
FilterControl = TDBFilterCombo1
DateControl = TDateTimePicker1
PersonNrControl = TStaticText1
NightNrControl = TStaticText5
RoomNrControl = TStaticText7
RoomNameControl = TStaticText10
DateArrivalControl = TStaticText13
DateLeaveControl = TStaticText12
ResNameControl = TStaticText15

F3::
Main()

F4::
ExitApp, 1

F9::
MonthDays := GetMonthDays(DateControl)
Msgbox, %MonthDays%
return

F2::
GetControlList()
; GetWindowText()
return

Main()
{
    global
    CheckWindow()
    CheckFilter()
    Sleep, 200
    MonthDays := GetMonthDays(DateControl)
    SearchList()
    ExitApp, 0
}

SearchList()
{
    global
    MouseClick,, %StartX%, %StartY%
    Loop, 20
    {
        Loop, % MonthDays - 1
        {
            Sleep, 250
            MouseClick,, %MoveDiff%, 0,,,, R
            ; MouseMove, %MoveDiff%, 0,, R
            if ( HasReservation() == 1 )
            {
                ; do stuff with reservation
            }

        }
        Sleep, 500
        MouseClick,, %StartX%, % StartY + (A_Index * MoveDiff)
    }
}

HasReservation()
{
    ControlGetText, ResName, %ResNameControl%, A
    IfExist, ResName
        return 1
    else
        return 0
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

GetMonthDays(p_DateControl){
    ControlGetText, DateText, %p_DateControl%, A
    Year := SubStr(DateText, -3 , 4)
    Month := SubStr(DateText, -6 , 2)
    FormatTime, DayStart, % Year . Month, YDay
    Month := Month + 1
    if (Month > 12)
    {
        Days := 31
    }
    else
    {
        FormatTime, DayEnd, % Year . Month, YDay
        Days := DayEnd - DayStart
    }
    return Days
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

