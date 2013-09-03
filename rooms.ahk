#SingleInstance force
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
