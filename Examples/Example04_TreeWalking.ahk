﻿;#include <UIA> ; Uncomment if you have moved UIA.ahk to your main Lib folder
#include ..\Lib\UIA.ahk

/*
    FindElement can only search through the children of the starting point element,
    to get to parent or sibling elements we need to use either FindByPath (easiest) or TreeWalkers (more difficult).
*/

Run "notepad.exe"
WinWaitActive "ahk_exe notepad.exe"
; Get the element for the Notepad window
npEl := UIA.ElementFromHandle("ahk_exe notepad.exe") 

/*
    With FindByPath, we need to supply a comma-separated path that defines the route of tree traversal:
        n: gets the nth child
        +n: gets the nth next sibling
        -n: gets the nth previous sibling
        pn: gets the nth parent
    Optionally we can also supply a condition for tree traversal that selects only elements that match the condition.
*/

; UIA path for the "Edit" MenuItem:
if VerCompare(A_OSVersion, ">=10.0.22000") ; Windows 11
    npEl[{T:33,CN:"Windows.UI.Input.InputSite.WindowClass"}, {T:10,A:"MenuBar"}, {T:11,CN:"Microsoft.UI.Xaml.Controls.MenuBarItem", i:2}].Highlight()
else
    npEl[{T:10,A:"MenuBar"}, {T:11,N:"Edit"}].Highlight()

; Equivalent:
; npEl.FindByPath({T:10,A:"MenuBar"}, {T:11,N:"Edit"}).Highlight()

; This should also get us to the "Edit" MenuItem in Windows 10, but to the Minimize button in Windows 11
editMenuItem := npEl.FindByPath("4,2").Highlight()
; Moving two sibling over, we should get to the "View" MenuItem, or in Windows 11 to "Close"
editMenuItem.FindByPath("+2").Highlight()

; We can also use the array notation, which accepts FindByPath paths and also conditions
npEl[4,1,"+2"].Highlight()
if VerCompare(A_OSVersion, ">=10.0.22000") ; Windows 11
    npEl["MenuBar",{Name:"File"}].HighLight()
else
    npEl["Pane", "MenuBar",{Name:"File"}].HighLight()