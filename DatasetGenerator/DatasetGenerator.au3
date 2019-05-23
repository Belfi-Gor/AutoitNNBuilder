Opt('GUIOnEventMode', 1)
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <ScreenCapture.au3>
#include <WinAPIHObj.au3>
#include "GUI.isf"
#include <Debug.au3>
#include <Misc.au3>
GUISetState(@SW_SHOW)

While 1
	Sleep(100)
	If _IsChecked($idCheckbox_AutoUpdateImage) Then 
		ProcessArea()
	EndIf
Wend

ProcessArea()

Func ProcessArea()
;~ 	Local Const $iLeft = 383, $iTop = 642 ;Левый верхний угол области захвата
	Local $iLeft 	= Int(GUICtrlRead($idInput_PointX))
	Local $iTop 	= Int(GUICtrlRead($idInput_PointY)) ;Левый верхний угол области захвата
	Local $iWidth 	= $iLeft + Int(GUICtrlRead($idInput_PointWidth)) -1
	Local $iHeight 	= $iTop + Int(GUICtrlRead($idInput_PointHeight)) -1;Ширина и высота области захвата
	GUICtrlSetData($idInput_RawImageZoom, GUICtrlRead($idSlider_RawImageZoom))
	GUICtrlSetData($idInput_FilteredImageScale, GUICtrlRead($idSlider_FilteredImageScale) / 10)
	GUICtrlSetData($idInput_FilteredImageZoom, GUICtrlRead($idSlider_FilteredImageZoom))
    _GDIPlus_Startup()
;~ 	For  $i = 0 To Int(GUICtrlRead($idInput_Counter)) -1 Step 1 ;Узнаем id для которого генерируем изображения
		
		Local $iColor = 0 ;Переменная куда сохранится текущий цвет пикселя
		Local $hHBmp = _ScreenCapture_Capture("", $iLeft, $iTop, $iWidth, $iHeight) ;create a GDI bitmap by capturing an area on desktop
		Local $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBmp) ;convert GDI to GDI+ bitmap
		_WinAPI_DeleteObject($hHBmp) ;release GDI bitmap resource because not needed anymore

;~ 		Local $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI) ;create a graphics object from a window handle
;~ 		_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap, 150, 150) ;copy negative bitmap to graphics object (GUI)
		
		$quality = $GDIP_INTERPOLATIONMODE_NearestNeighbor
		
;~ $GDIP_INTERPOLATIONMODE_LowQuality
;~ $GDIP_INTERPOLATIONMODE_HighQuality
;~ $GDIP_INTERPOLATIONMODE_Bilinear
;~ $GDIP_INTERPOLATIONMODE_Bicubic
;~ $GDIP_INTERPOLATIONMODE_NearestNeighbor
;~ $GDIP_INTERPOLATIONMODE_HighQualityBilinear
;~ $GDIP_INTERPOLATIONMODE_HighQualityBicubic
		
		;Работаем с оригинальным изображением, которое нужно только чтобы посмотреть что там ваще есть
		Local $iScale = GUICtrlRead($idSlider_RawImageZoom)
		$hBitmap1 = _GDIPlus_ImageScale($hBitmap, $iScale, $iScale, $quality) ;scale image by 275% (magnify)
;~ 		MsgBox(0, 0, $idLabel_RawImage)
		_DrawImage($hBitmap1, $idLabel_RawImage) ;Отображаем оригинальное изображение
;~ 		_GDIPlus_ImageSaveToFile ( $hBitmap, Int(GUICtrlRead($idInput_ObjectID)) & $i & '.bmp' )

;~ 		MsgBox(0, 0, GUICtrlRead($idRadio_FilterRed))


		; Обрабатываем изображение
		Local $iR, $iG, $iB, $iGrey ;Переменные куда будут записаны результаты обработки текущего пикселя
		Local $sRow = GUICtrlRead($idInput_ObjectID); Массив в который будет записываться id результата сохраненного на изображении, так же как в датасэте MNIST
		For $iY = 0 To $iHeight - $iTop - 1 ;Вертикально проходим по изображению
			For $iX = 0 To $iWidth - $iLeft - 1 ;Горизонтально проходим по изображению
				$iColor = _GDIPlus_BitmapGetPixel($hBitmap, $iX, $iY) ;Определяем цвет текущего пикселя
				$iR = BitShift(BitAND($iColor, 0x00FF0000), 16) ;Извлекаем красный цвет
				$iG = BitShift(BitAND($iColor, 0x0000FF00), 8) ;Извлекаем зеленый зцвет
				$iB = BitAND($iColor, 0x000000FF) ;Извлекаем синий цвет
				$iGrey = Hex(Int(($iR + $iG + $iB) / 3), 2) ;Получаем из RGB оттенок серого
				
				If GUICtrlRead($idRadio_FilterRed) = 1 Then 
					If int($iR) > Int(GUICtrlRead($idInput_FilterTrigger)) Then 
						_GDIPlus_BitmapSetPixel($hBitmap, $iX, $iY, "0xFF" & $iR & "00" & "00") ;Перезаписываем RGB пиксель изображения на оттенок красного
						$sRow &= "," & $iR
					Else 
						_GDIPlus_BitmapSetPixel($hBitmap, $iX, $iY, "0xFF" & "00" & "00" & "00") ;Перезаписываем RGB пиксель изображения на оттенок красного
						$sRow &= ",0"
					EndIf 
				ElseIf GUICtrlRead($idRadio_FilterGreen) = 1 Then 
					If int($iG) > Int(GUICtrlRead($idInput_FilterTrigger)) Then 
						_GDIPlus_BitmapSetPixel($hBitmap, $iX, $iY, "0xFF" & "00" & $iG & "00") ;Перезаписываем RGB пиксель изображения на оттенок зелёного
						$sRow &= "," & $iG
					Else 
						_GDIPlus_BitmapSetPixel($hBitmap, $iX, $iY, "0xFF" & "00" & "00" & "00") ;Перезаписываем RGB пиксель изображения на оттенок зелёного
						$sRow &= ",0"
					EndIf 
				ElseIf GUICtrlRead($idRadio_FilterBlue) = 1 Then 
					If int($iB) > Int(GUICtrlRead($idInput_FilterTrigger)) Then 
						_GDIPlus_BitmapSetPixel($hBitmap, $iX, $iY, "0xFF" & "00" & "00" & $iB) ;Перезаписываем RGB пиксель изображения на оттенок синего
						$sRow &= "," & $iB
					Else 
						_GDIPlus_BitmapSetPixel($hBitmap, $iX, $iY, "0xFF" & "00" & "00" & "00") ;Перезаписываем RGB пиксель изображения на оттенок синего
						$sRow &= ",0"
					EndIf 
				ElseIf GUICtrlRead($idRadio_FilterShade) = 1 Then 
					If int($iGrey) > Int(GUICtrlRead($idInput_FilterTrigger)) Then 
						_GDIPlus_BitmapSetPixel($hBitmap, $iX, $iY, "0xFF" & $iGrey & $iGrey & $iGrey) ;Перезаписываем RGB пиксель изображения на оттенок серого
						$sRow &= "," & $iGrey
					Else 
						_GDIPlus_BitmapSetPixel($hBitmap, $iX, $iY, "0xFF" & "00" & "00" & "00") ;Перезаписываем RGB пиксель изображения на оттенок серого
						$sRow &= ",0"
					EndIf 
				EndIf
			Next
		Next
		
		ConsoleWrite($sRow & @cr)
		
		;Работаем с изображением которое используем для датасета
		Local $iScale = GUICtrlRead($idSlider_FilteredImageScale) / 10
		$hBitmap = _GDIPlus_ImageScale($hBitmap, $iScale, $iScale, $quality) ;scale image by 275% (magnify)
		
		Local $iZoom = GUICtrlRead($idSlider_FilteredImageZoom)
		$hBitmap = _GDIPlus_ImageScale($hBitmap, $iZoom, $iZoom, $quality) ;scale image by 275% (magnify)
		
;~ 		  ModeInvalid,


;~ $GDIP_INTERPOLATIONMODE_LowQuality
;~ $GDIP_INTERPOLATIONMODE_HighQuality
;~ $GDIP_INTERPOLATIONMODE_Bilinear
;~ $GDIP_INTERPOLATIONMODE_Bicubic
;~ $GDIP_INTERPOLATIONMODE_NearestNeighbor
;~ $GDIP_INTERPOLATIONMODE_HighQualityBilinear
;~ $GDIP_INTERPOLATIONMODE_HighQualityBicubic
	
;~ 		Local $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI) ;create a graphics object from a window handle
;~ 		_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap, 150 + 21 + 10, 150) ;copy negative bitmap to graphics object (GUI)
		_DrawImage($hBitmap, $idLabel_FilteredImage)
		If _IsChecked($idCheckbox_AutoSaveResult) Then 
			Local $currentCounter = Int(GUICtrlRead($idInput_Counter))
			_GDIPlus_ImageSaveToFile ( $hBitmap, Int(GUICtrlRead($idInput_ObjectID)) &"-"&  $currentCounter & '.bmp' )
			FileWriteLine ( GUICtrlRead($idInput_FileName) & ".txt", $sRow & @CR )

			GUICtrlSetData($idInput_Counter, $currentCounter + 1)
		EndIf 
	;~     Do
	;~     Until GUIGetMsg() = $GUI_EVENT_CLOSE

		;cleanup GDI+ resources
		
;~ 		Sleep(1000)
;~ 	Next 
    _GDIPlus_Shutdown()
;~     GUIDelete($hGUI)
EndFunc   ;==>Example

Func _IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func _DrawImage($hBitmap, $idBaseElement)
	;Получает на вход результат функции _GDIPlus_BitmapCreateFromHBITMAP и id элемента гуя который будет базовым для отрисовки изображения
;~ 	MsgBox(0, "Текущий ControlID", $idBaseElement)
;~ 	GUICtrlDelete($idBaseElement)
	Local $aBaseElementPos = ControlGetPos($hGUI, "", $idBaseElement) ;Узнаем координаты и размеры базового элемента гуя
	If @error Then MsgBox(0, "ошибка", $idBaseElement)

;~ 	Sleep(10000)
	Local $iPos_X = Int($aBaseElementPos[0] + $aBaseElementPos[2] / 2) ;Рассчитываем середину базового элемента по горизонтали
	Local $iPos_Y = Int($aBaseElementPos[1] + $aBaseElementPos[3] / 2) ;Рассчиывает середину базового элемента по вертикали
	;Теперь мы знаем центр базового элемента гуя


    Local $iOffset_X = Round(_GDIPlus_ImageGetWidth($hBitmap) / 2) ;Из размера изображения рассчитываем смещение его левого верхнего угла относительно центра базового элемента
    Local $iOffset_Y = Round(_GDIPlus_ImageGetHeight($hBitmap) / 2) ;аналогично только по вертикали
	;Теперь мы знаем отступ левого верхнего угла изображения относительно центра базового элемента

	ConsoleWrite("Ширина:	" & _GDIPlus_ImageGetWidth($hBitmap) & @CR)
	ConsoleWrite("Высота:	" & _GDIPlus_ImageGetHeight($hBitmap) & @CR)

	;Теперь мы можем рисовать изображение по центру базового элемента независимо от его местоположения и размера изображения
	Local $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI) ;create a graphics object from a window handle
	_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap, $iPos_X - $iOffset_X, $iPos_Y - $iOffset_Y) ;copy negative bitmap to graphics object (GUI)
	_GDIPlus_GraphicsDispose($hGraphics)
EndFunc

Func _Test()
	Local $iWidth 	= Int(GUICtrlRead($idInput_PointWidth))
	Local $iHeight 	= Int(GUICtrlRead($idInput_PointHeight))
	Do 
		Local $var = MouseGetPos()
		GUICtrlSetData($idInput_PointX, $var[0] - $iHeight)
		GUICtrlSetData($idInput_PointY, $var[1])
		Local $test[5] = ['Point_', $var[0] -$iHeight, $var[1] -1, $iHeight + 1, $iWidth + 1]
		_myDraw_Rect($test)
		ProcessArea()
	Until _IsPressed("A0")
EndFunc

Func _myDraw_Rect($aArray) 	
							;											X							Y							H					W
	Local $aHorizontalTop[5] 		= [$aArray[0]&'HorizontalTop', 		$aArray[1], 				$aArray[2], 				1,					$aArray[4]]
	_myDraw_Line($aHorizontalTop)
	
	Local $aHorizontalBottom[5] 	= [$aArray[0]&'HorizontalBottom', 	$aArray[1], 				$aArray[2] + $aArray[3], 	1,					$aArray[4]]
	_myDraw_Line($aHorizontalBottom)
	
	Local $aVerticalLeft[5] 		= [$aArray[0]&'VerticalLeft', 		$aArray[1], 				$aArray[2], 				$aArray[3],			1]
	_myDraw_Line($aVerticalLeft)
	
	Local $aVerticalRight[5] 		= [$aArray[0]&'VerticalRight', 		$aArray[1] + $aArray[4],	$aArray[2],					$aArray[3] + 1,		1]
	_myDraw_Line($aVerticalRight)
EndFunc

Func _myUpdate_Rect_From_Updown()
	Local $iLeft 	= Int(GUICtrlRead($idInput_PointX))
	Local $iTop 	= Int(GUICtrlRead($idInput_PointY)) ;Левый верхний угол области захвата
	Local $iWidth 	= Int(GUICtrlRead($idInput_PointWidth)) -1
	Local $iHeight 	= Int(GUICtrlRead($idInput_PointHeight)) -1;Ширина и высота области захвата	
							;											X							Y							H					W
	Local $aHorizontalTop[5] 		= ['Point_HorizontalTop', 		$iLeft, 				$iTop, 				1,					$iWidth]
	_myDraw_Line($aHorizontalTop)
	
	Local $aHorizontalBottom[5] 	= ['Point_HorizontalBottom', 	$iLeft, 				$iTop + $iHeight, 	1,					$iWidth]
	_myDraw_Line($aHorizontalBottom)
	
	Local $aVerticalLeft[5] 		= ['Point_VerticalLeft', 		$iLeft, 				$iTop, 				$iHeight,			1]
	_myDraw_Line($aVerticalLeft)
	
	Local $aVerticalRight[5] 		= ['Point_VerticalRight', 		$iLeft + $iWidth,	$iTop,					$iHeight + 1,		1]
	_myDraw_Line($aVerticalRight)
	
	ProcessArea()
EndFunc

Func _myDraw_Line($aArray)
	#cs - myDrawLine
		Создает линию в виде GUI шириной в 1 пиксель. При повторном вызове с хэндлом уже существующей линии, перемещает её в новое место.
		Автоматически вычисляет отступы от левого и верхнего угла окна, чтобы работать в режиме клиентской части
		$sWinName - состоит из двух частей. 1-я часть это стринг "EVE - ", Вторая часть - это имя персонажа. Получаемое от интеграционного ядра.
		На данный момент не предусматривается использование с несколькими окнами. Одно интеграционное ядро - одно окно.
	
		Логика работы:
		1) На вход подается массив: [Имя массива_line, x,y,height]
		2) Проверяется есть ли глобальная переменная "Имя массива_line"
		3) Если нету в эту переменную создается гуй с линией
		4) Если есть, то гуй с таким именем перемещается на новые координаты
	#ce
	
;~ 	my_Debug("myDrawLine - Start", 1)

	#Region - Пересохраняем массив в переменные с читабельными названиями
	Local $lineName = $aArray[0]&"_line"
	Local $iX = $aArray[1]-1
	Local $iY = $aArray[2]
	Local $iHeight = $aArray[3]
	Local $iWidth = $aArray[4]
	
	
	Dim $cnf_winHorizontalOffset = 8
	Dim $cnf_winVerticalOffset = 31
	#EndRegion - Пересохраняем массив в переменные с читабельными названиями
	ConsoleWrite("Рисую" & @CR)
	;;;;;;;;;;;;;;;;;;

;~ 	If $iX > 0 And $iY > 0  And $iHeight > 0 Then ;Если полученные значения больше чем 0
;~ 		Local $aWinPos = WinGetPos($sWinName) ;Ищим позицию окна
		If Not IsDeclared($lineName) Or Eval($lineName) = -1 Then ;Смотрим объявлена ли переменная с хэндлом этой линии
			ConsoleWrite("Создаю линию: "&$lineName & @CR)
			;Если нет - то создаем гуй и записываем его хендл в $var
			Local  $var = GUICreate("Scanline", $iWidth, $iHeight, $iX, $iY, $WS_POPUP, $WS_EX_TOPMOST)
			If Not Assign($lineName, $var, 2) Then ;Пытаемся создать переменную с именем хранимым в $lineName и записываем туда хендл хранимый в $var
;~ 				my_Debug("Не могу создать хэндл на линию "&$lineName)
				;В случае неудачи прерываем исполнение скрипта
				Exit
			EndIf
			GUISetBkColor(0xFF0000)
			GUISetState(@SW_SHOW,$var) ;Делаем линию видемой
		Else ;Если глобальная переменная с хендлом существует
			;Передвигаем эту линию в нужное место
			ConsoleWrite("Перемещаю линию: "&$lineName & @CR)
			WinMove(Eval($lineName), "", $iX, $iY, $iWidth, $iHeight)
		EndIf
;~ 	EndIf
;~ 	my_Debug("myDrawLine - End", -1)
EndFunc

Func myDrawDelete($sString)
	Local $lineName = $sString&"_line"
	GUIDelete(Eval($lineName))
	Assign($lineName, -1)
EndFunc

Func _Exit()
	Exit -1
EndFunc
