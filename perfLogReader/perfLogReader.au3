Opt('MustDeclareVars', 1)
Opt("GUIOnEventMode", 1)
#include <Array.au3>
#include <File.au3>
#include <GuiImageList.au3>

#include "Forms/GUI.isf"
GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")

GUISetState(@SW_SHOW)

Global $aColors[11] = [0xFF1654, 0xFF9F1C, 0x5CA4A9,  0x00A8E8, 0x007EA7, 0x2B2D42, 0xB5838D, 0xE5989B, 0xED6A5A, 0x457B9D, 0x028090]

While 1
	If GUICtrlRead($idCheckbox_AutoRedraw) = 1 Then 
		_redraw_graph()
		Sleep(Int(GUICtrlRead($idInput_Frequency) * 1000))
	EndIf

	Sleep(100)

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
	Local $asLogToDraw[0]







	For  $i = 0 To _GUICtrlListView_GetItemCount($idListview_Files) -1 Step 1
 		If _GUICtrlListView_GetItemSelected($idListview_Files, $i) Then
;~ 			_GUICtrlListView_SetTextBkColor ( $idListview_Files, ] )
;~ 			MsgBox(0, 0, $aColors[UBound($asLogToDraw)])
			_ArrayAdd($asLogToDraw, _GUICtrlListView_GetItemText($idListview_Files, $i))
		Else
			_ArrayAdd($asLogToDraw, False)
		EndIf
	Next
;~ 	_ArrayDisplay($asLogToDraw)


	Local $var
	GUICtrlDelete($idGraphic_graph)
	Local $aGraphPos = WinGetClientSize ($hGUI) ;Узнаем размеры клиентской части гуя
	$idGraphic_graph = GUICtrlCreateGraphic(0, 0, $aGraphPos[0], $aGraphPos[1]) ;Создаем контрол графика на всю площадь клиентской части гуя
	GUICtrlSetBkColor($idGraphic_graph, 0xffffff) ;Задаем цвет фона всего графика
	For $k = 0 To UBound($asLogToDraw, 1) -1 Step 1
		If Not $asLogToDraw[$k] Then ContinueLoop

		$var =  0
		_FileReadToArray("..\" & $asLogToDraw[$k],  $var)
		If @error Then MsgBox(0, 0, @error)
;~ 		MsgBox(0, "Рисую лог", $asLogToDraw[$k], 1)



		GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_COLOR, $aColors[$k])
		GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_MOVE, -1, $aGraphPos[1])
		Local $XCounter = 0
		
		For $i = 0 To UBound($var) -1 Step Int(GUICtrlRead($idInput_XScale))
			ConsoleWrite($var[$i] & @CR)
			GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_LINE, $xCounter, $aGraphPos[1]-$var[$i])
			$XCounter += 1
		Next
	Next

	GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_MOVE, -1, $aGraphPos[1]) ;Передвигаем курсор начала графика на первую координату
	For $i =  0 To UBound($var, 1) -1 Step 1 ;Проходим через весь массив curHP от начала и до конца\
		;Подгоняем текущее значение под высоту графика
		;Local $var2 = $aGraphPos[1] - ($aGraphPos[1] / $fMax * $var[$i]) + 25
		Local $var2 = $aGraphPos[1]-100
		GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_LINE, $i, $var2) ;Наносим хранящиеся в нем значения на график
	Next

	GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_REFRESH) ;Обновляем график
EndFunc


Func rescan()
	_GUICtrlListView_DeleteAllItems($idListview_Files)
	Local $hImage = _GUIImageList_Create()
    _GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap(GUICtrlGetHandle($idListview_Files), $aColors[0], 16, 16))
    _GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap(GUICtrlGetHandle($idListview_Files), $aColors[1], 16, 16))
    _GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap(GUICtrlGetHandle($idListview_Files), $aColors[2], 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap(GUICtrlGetHandle($idListview_Files), $aColors[3], 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap(GUICtrlGetHandle($idListview_Files), $aColors[4], 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap(GUICtrlGetHandle($idListview_Files), $aColors[5], 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap(GUICtrlGetHandle($idListview_Files), $aColors[6], 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap(GUICtrlGetHandle($idListview_Files), $aColors[7], 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap(GUICtrlGetHandle($idListview_Files), $aColors[8], 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap(GUICtrlGetHandle($idListview_Files), $aColors[9], 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap(GUICtrlGetHandle($idListview_Files), $aColors[10], 16, 16))
    _GUICtrlListView_SetImageList($idListview_Files, $hImage, 1)

	Local $hSearch = FileFindFirstFile("..\*.perf")

    ; Check if the search was successful, if not display a message and return False.
    If $hSearch = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "Error: No files/directories matched the search pattern.")
        Return False
    EndIf

    ; Assign a Local variable the empty string which will contain the files names found.
    Local $sFileName = "", $iResult = 0
	Local $counter = 0
    While 1
        $sFileName = FileFindNextFile($hSearch)
        ; If there is no more file matching the search.
        If @error Then ExitLoop

        ; Display the file name.
		_GUICtrlListView_AddItem($idListview_Files, $sFileName, $counter)
		$counter += 1
    WEnd

    ; Close the search handle.
    FileClose($hSearch)
EndFunc
