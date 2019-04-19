Opt('MustDeclareVars', 1)
Opt("GUIOnEventMode", 1)
#include <Array.au3>
#include <File.au3>
#include "GUI.isf"
GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")

GUISetState(@SW_SHOW)

While 1
	Sleep(10)
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
	_FileReadToArray("..\__g_myPerf_1TrainLength.txt",  $var)
	If @error Then MsgBox(0, 0, @error)
	Local $aGraphPos = WinGetClientSize ($hGUI)
	
	GUICtrlDelete($idGraphic_graph)
	$idGraphic_graph = GUICtrlCreateGraphic(0, 0, $aGraphPos[0], $aGraphPos[1])
	GUICtrlSetBkColor($idGraphic_graph, 0xffffff) ;Задаем цвет фона всего графика
	Local $fMax = _ArrayMax($var)
	GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_COLOR, 0xff0000) ;Задаем цвет текущей линии
	GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_MOVE, -1, $aGraphPos[1]) ;Передвигаем курсор начала графика на первую координату
	For $i =  0 To UBound($var, 1) -1 Step 1 ;Проходим через весь массив curHP от начала и до конца\
		;Подгоняем текущее значение под высоту графика
		
		Local $var2 = $aGraphPos[1] - ($aGraphPos[1] / $fMax * $var[$i]) + 25
		GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_LINE, $i, $var2) ;Наносим хранящиеся в нем значения на график
		ConsoleWrite($var2 & @cr)
	Next
	
	GUICtrlSetGraphic($idGraphic_graph, $GUI_GR_REFRESH) ;Обновляем график
EndFunc