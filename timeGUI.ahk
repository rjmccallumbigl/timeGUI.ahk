; Use a popup window to convert time zones and save to clipboard
; Inspiration: https://www.autohotkey.com/boards/viewtopic.php?t=36691

; Build GUI
Gui, Add, DateTime, vMyEdit gformatDates choose%A_NowUTC%, MMM. d @ h:mmtt 'UTC'
Gui, Add, Edit, w200 vDate1
Gui, Add, Edit, w200 vDate2
Gui, Add, Edit, w200 vDate3
Gui, Add, Edit, w200 vDate4
Gui, Add, Button, Default, &Send All to Clipboard
Gui +MinimizeBox

; CTRL + ` builds GUI
^`::
    ; Winget, Active_Window, ID, A
    Active_Window := WinExist("A")
    Gui, Show, , Insert Specified Time
return

; Press Enter to send to clipboard and close
ButtonSendAlltoClipboard(){
    global dateEST
    global datePST
    global dateUTC
    global dateIST
    string := dateEST . " [" . datePST . " | " . dateUTC . " | " . dateIST . "]"
    Clipboard := string
    WinClose, Insert Specified Time
    WinActivate, ahk_id %Active_Window%
    Send, ^v
return
}

; Format date + time
ButtonConvertTime:
formatDates:
    GuiControlGet, MyEdit
    utcTime := MyEdit
    backupString := utcTime
    ; estOffset := -5
    ; pstOffset := -8
    estObject := time("America/New_York")
    estOffset := estObject.utc_offset
    pstObject := time("PST8PDT")
    pstOffset := pstObject.utc_offset
    istOffset := 5.5
    FormatTime, dateUTC, %utcTime%, MMM. d @ h:mmtt UTC
    GuiControl, Text, Date1, %dateUTC%
    utcTime += estOffset, hours
    FormatTime, dateEST, %utcTime%, MMM. d @ h:mmtt EST
    GuiControl, Text, Date2, %dateEST%
    utcTime := backupString

    utcTime += pstOffset, hours
    FormatTime, datePST, %utcTime%, MMM. d @ h:mmtt PST
    GuiControl, Text, Date3, %datePST%
    utcTime := backupString

    utcTime += istOffset, hours
    FormatTime, dateIST, %utcTime%, MMM. d @ h:mmtt IST
    GuiControl, Text, Date4, %dateIST%
    utcTime := backupString
return

; https://www.autohotkey.com/boards/viewtopic.php?t=95931
; Return time object from API
time(area) {
    WinHttp := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WinHttp.Open("GET", "https://worldtimeapi.org/api/timezone/" . area, false), WinHttp.Send()
    timeObject := JsonToAHK(WinHttp.ResponseText) 
Return timeObject
}

; https://www.autohotkey.com/boards/viewtopic.php?t=67583
; Convert JSON to AHK object
JsonToAHK(json, rec := false) { 
    static doc := ComObjCreate("htmlfile") 
    , __ := doc.write("<meta http-equiv=""X-UA-Compatible"" content=""IE=9"">") 
    , JS := doc.parentWindow 
    if !rec 
        obj := %A_ThisFunc%(JS.eval("(" . json . ")"), true) 
    else if !IsObject(json) 
        obj := json 
    else if JS.Object.prototype.toString.call(json) == "[object Array]" { 
        obj := [] 
        Loop % json.length 
            obj.Push( %A_ThisFunc%(json[A_Index - 1], true) ) 
    } 
    else { 
        obj := {} 
        keys := JS.Object.keys(json) 
        Loop % keys.length { 
            k := keys[A_Index - 1] 
            obj[k] := %A_ThisFunc%(json[k], true) 
        } 
    } 
Return obj 
} 
