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

Main() {
    global
    CheckWindow()
    CheckFilter()
    Sleep, 200
    MonthDays := GetMonthDays(DateControl)
    SearchList()
    ExitApp, 0
}

SearchList() {
    global
    MouseClick,, %StartX%, %StartY%
    Loop, 20 {
        Loop, % MonthDays - 1 {
            Sleep, 250
            ; MouseMove, %MoveDiff%, 0,, R
            if ( HasReservation(ResNameControl) && NotSameReservation(DateLeave,DateLeaveControl) ) {
                ; do stuff with reservation
                GetCellData()
                IsMonthEnd(MonthDays, DateArrival, NightNr)
                ; check if RoomNr > 1 then
                ;     check if room is already in ProcessedRes array
                ;         subtract 1 from array element
                ;     else
                ;         add room to ProcessedRes array
                ;         add PersonNr to CurrentSum [Rooms|Apartman|Manzard]
                ; else
                ;     add PersonNr to CurrentSum [Rooms|Apartman|Manzard]
                ;
                ; jump to end of reservation [NightNr * MoveDiff]
                MouseClick,, % NightNr * MoveDiff, 0,,,, R
            } else {
                MouseClick,, %MoveDiff%, 0,,,, R
            }
        }
        Sleep, 500
        MouseClick,, %StartX%, % StartY + (A_Index * MoveDiff)
    }
}

IsMonthEnd(DayMonth, ArrivalDate, ByRef Nights) {
    FormatTime, DayArrival, % ConvertDate(ArrivalDate), d
    Msgbox, DayMonth %DayMonth%`nArrivalDate %ArrivalDate%`nNights %Nights%`nDayArrival %DayArrival%
    if ( DayMonth < ( DayArrival + Nights ) ) {
        Nights := DayMonth - DayArrival + 1
        Msgbox, REACHED END OF MONTH!`n Nights: %Nights%
        return 1
    } else {
        Msgbox, Everything OK! %Nights%
        return 0
    }
}

GetCellData() {
    global
    ControlGetText, PersonNr, %PersonNrControl%
    ControlGetText, RoomNr, %RoomNrControl%
    ControlGetText, NightNr, %NightNrControl%
    ControlGetText, DateArrival, %DateArrivalControl%
    ControlGetText, DateLeave, %DateLeaveControl%
    ControlGetText, ResName, %ResNameControl%
    ControlGetText, RoomName, %RoomNameControl%
}

HasReservation(ResControl) {
    ControlGetText, ResName, %ResControl%, A
    if ( ResName != "" ) {
        return 1
    } else {
        return 0
    }
}

NotSameReservation(Date,DateControl) {
    ControlGetText, TempDate, %DateControl%, A
    If ( Date != TempDate ) {
        return 1
    } else {
        return 0
    }
}


CheckWindow() {
    If ( WinExist("Gestbal Hotel - Rezervari ahk_class TTimeLine") ) {
        WinActivate
        WinMaximize
        ; MsgBox, Window exists and is active
    } else {
        MsgBox, The program is not running!
        ExitApp, 1
    }
}

CheckFilter() {
    global
    ControlGetText, FilterText, %FilterControl%, A
    If ( ! InStr(FilterText, "Toate") ) {
        ControlSend, %FilterControl%, {up}{up}{up}{up}, A
    }
}

GetMonthDays(p_DateControl) {
    ControlGetText, DateText, %p_DateControl%, A
    Year := ConvertDate(DateText, "y")
    Month := ConvertDate(DateText, "m")
    FormatTime, DayStart, % Year . Month, YDay
    Month := Month + 1
    if (Month > 12) {
        Days := 31
    } else {
        FormatTime, DayEnd, % Year . Month, YDay
        Days := DayEnd - DayStart
    }
    return Days
}

ConvertDate(OrigDate,param = "ymd") {
    If ( InStr(param, "y") ) {
        Result := Result . SubStr(OrigDate, -3 , 4)
    }
    If ( InStr(param, "m") ) {
        Result := Result . SubStr(OrigDate, -6 , 2)
    }
    If ( InStr(param, "d") ) {
        Result := Result . SubStr(OrigDate, -9, 2)
    }
    return, Result
}

GetControlList() {
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

GetControl() {
    ; This working example will continuously update and display the
    ; name and position of the control currently under the mouse cursor:
    Loop {
        Sleep, 100
        MouseGetPos, , , WhichWindow, WhichControl
        ControlGetPos, x, y, w, h, %WhichControl%, ahk_id %WhichWindow%
        ControlGetText, ControlText, %WhichControl%, A
        ToolTip, %WhichControl%`nX%X%`tY%Y%`nW%W%`tH%H%`nText:%ControlText%
    }
}

