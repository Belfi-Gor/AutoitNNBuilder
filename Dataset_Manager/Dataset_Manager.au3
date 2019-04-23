Opt('MustDeclareVars', 1)
Opt("GUIOnEventMode", 1)
#include <Array.au3>
#include <File.au3>
#include "GUI.isf"
GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")

GUISetState(@SW_SHOW)

While 1
	For $i = 0 To 2 Step 1
		Sleep(1000)
	Next
	_redraw_graph()
Wend

Func SpecialEvents()
    Select
        Case @GUI_CtrlId = $GUI_EVENT_CLOSE
            GUIDelete()
            Exit

        Case @GUI_CtrlId = $GUI_EVENT_MINIMIZE

        Case @GUI_CtrlId = $GUI_EVENT_RESTORE

    EndSelect
EndFunc   ;==>SpecialEvents

Func _redraw_graph()
	Local $var
	_FileReadToArray("..\MNIST_test_15000_LR0.1__NNTestResults.txt",  $var)
	If @error Then MsgBox(0, 0, @error)
	ConsoleWrite(UBound($var)&@CR)

;~ 	ConsoleWrite(UBound($var)&@CR)
;~ 	For $i=UBound($var)-1 To 0 Step 2
;~ 		_ArrayDelete($var, $i)
;~ 	Next


	Local $aGraphPos = WinGetClientSize ($hGUI)

	GUICtrlDelete($idGraphic_graph)
	$idGraphic_graph = GUICtrlCreateGraphic(0, 0, $aGraphPos[0], $aGraphPos[1])
	GUICtrlSetBkColor($idGraphic_graph, 0xffffff) ;Задаем цвет фона всего графика
	Local $fMax = _ArrayMax($var)

	Local $last10[100]
	Local $avg10[UBound($var)]
	Local $avgsum = 0
	GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_COLOR, 0xff0000) ;Задаем цвет текущей линии
	GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_MOVE, -1, $aGraphPos[1]) ;Передвигаем курсор начала графика на первую координату
	Local $x=0
	For $i =  0 To UBound($var, 1) -1 Step 10 ;Проходим через весь массив curHP от начала и до конца\
		;Подгоняем текущее значение под высоту графика
	ConsoleWrite($i&@CR)
		;Local $var2 = $aGraphPos[1] - ($aGraphPos[1] / $fMax * $var[$i]) + 25
		Local $var2 = $aGraphPos[1]-$var[$i]
		GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_LINE, $i, $var2) ;Наносим хранящиеся в нем значения на график
;~ 		ConsoleWrite($var2 & @cr)
		_ArrayPush($last10, $var[$i])
		For $j=0 to UBound($last10)-1 Step 1
			$avgsum += $last10[$j]
		Next
		_ArrayPush($avg10, $avgsum/UBound($last10))
		$avgsum = 0
		$x += 1
	Next


	  GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_MOVE, -1, $aGraphPos[1]-100)
	 For $i =  0 To UBound($var, 1) -1 Step 100 ;Проходим через весь массив curHP от начала и до конца\
		;Подгоняем текущее значение под высоту графика

		;Local $var2 = $aGraphPos[1] - ($aGraphPos[1] / $fMax * $var[$i]) + 25
		Local $var2 = $aGraphPos[1]-100
		GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_LINE, $i, $var2) ;Наносим хранящиеся в нем значения на график
;~ 		ConsoleWrite($var2 & @cr)
	 Next

;~ 	GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_COLOR, 0x0000ff)
;~ 	GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_MOVE, -1, $aGraphPos[1])
;~ 	For $i =  0 To UBound($avg10, 1) -1 Step 1 ;Проходим через весь массив curHP от начала и до конца\
;~ 		;Подгоняем текущее значение под высоту графика

;~ 		;Local $var2 = $aGraphPos[1] - ($aGraphPos[1] / $fMax * $var[$i]) + 25
;~ 		Local $var2 = $aGraphPos[1]-$avg10[$i]
;~ 		GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_LINE, $i, $var2) ;Наносим хранящиеся в нем значения на график
;~ 		ConsoleWrite($var2 & @cr)
;~ 	Next

	GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_REFRESH) ;Обновляем график
EndFunc


Func rescan()
	
	Local $hSearch = FileFindFirstFile("..\*.perf")

    ; Check if the search was successful, if not display a message and return False.
    If $hSearch = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "Error: No files/directories matched the search pattern.")
        Return False
    EndIf

    ; Assign a Local variable the empty string which will contain the files names found.
    Local $sFileName = "", $iResult = 0
	
    While 1
        $sFileName = FileFindNextFile($hSearch)
        ; If there is no more file matching the search.
        If @error Then ExitLoop

        ; Display the file name.
		GUICtrlCreateListViewItem($sFileName, $idListview_Files)
    WEnd

    ; Close the search handle.
    FileClose($hSearch)
EndFunc 
