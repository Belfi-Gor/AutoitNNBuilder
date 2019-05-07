Opt('GUIOnEventMode', 1)
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <ScreenCapture.au3>
#include <WinAPIHObj.au3>
#include "GUI.isf"
#include <Debug.au3>
GUISetState(@SW_SHOW)

While 1
	Sleep(100)
Wend

Example()

Func Example()
;~ 	Local Const $iLeft = 383, $iTop = 642 ;Левый верхний угол области захвата
	Local Const $iLeft = 412, $iTop = 600 ;Левый верхний угол области захвата
	Local Const $iWidth = $iLeft + 45, $iHeight = $iTop + 45 ;Ширина и высота области захвата
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
		_DrawImage($hBitmap1, $idLabel_RawImage)
;~ 		_GDIPlus_ImageSaveToFile ( $hBitmap, Int(GUICtrlRead($idInput_ObjectID)) & $i & '.bmp' )





		Local $iR, $iG, $iB, $iGrey
		For $iY = 0 To $iHeight - $iTop - 1 ;Вертикально проходим по изображению
			For $iX = 0 To $iWidth - $iLeft - 1 ;Горизонтально проходим по изображению
				$iColor = _GDIPlus_BitmapGetPixel($hBitmap, $iX, $iY) ;Определяем цвет текущего пикселя
				$iR = BitShift(BitAND($iColor, 0x00FF0000), 16) ;Извлекаем красный цвет
				$iG = BitShift(BitAND($iColor, 0x0000FF00), 8) ;Извлекаем зеленый зцвет
				$iB = BitAND($iColor, 0x000000FF) ;Извлекаем синий цвет
				$iGrey = Hex(Int(($iR + $iG + $iB) / 3), 2) ;Получаем из RGB оттенок серого
;~ 				_GDIPlus_BitmapSetPixel($hBitmap, $iX, $iY, "0xFF" & $iGrey & $iGrey & $iGrey) ;Перезаписываем RGB пиксель изображения на оттенок серого
			Next
		Next
		
		
		
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
;~ 		_GDIPlus_ImageSaveToFile ( $hBitmap, Int(GUICtrlRead($idInput_ObjectID)) &"-"&  $i & '.bmp' )
	;~     Do
	;~     Until GUIGetMsg() = $GUI_EVENT_CLOSE

		;cleanup GDI+ resources
		
;~ 		Sleep(1000)
;~ 	Next 
    _GDIPlus_Shutdown()
;~     GUIDelete($hGUI)
EndFunc   ;==>Example

Func _DrawImage($hBitmap, $idBaseElement)
	;Получает на вход результат функции _GDIPlus_BitmapCreateFromHBITMAP и id элемента гуя который будет базовым для отрисовки изображения
	Local $aBaseElementPos = ControlGetPos("", "", $idBaseElement) ;Узнаем координаты и размеры базового элемента гуя
	Local $iPos_X = Int($aBaseElementPos[0] + $aBaseElementPos[2] / 2) ;Рассчитываем середину базового элемента по горизонтали
	Local $iPos_Y = Int($aBaseElementPos[1] + $aBaseElementPos[3] / 2) ;Рассчиывает середину базового элемента по вертикали
	;Теперь мы знаем центр базового элемента гуя


    Local $iOffset_X = _GDIPlus_ImageGetWidth($hBitmap) / 2 ;Из размера изображения рассчитываем смещение его левого верхнего угла относительно центра базового элемента
    Local $iOffset_Y = _GDIPlus_ImageGetHeight($hBitmap) / 2 ;аналогично только по вертикали
	;Теперь мы знаем отступ левого верхнего угла изображения относительно центра базового элемента

	;Теперь мы можем рисовать изображение по центру базового элемента независимо от его местоположения и размера изображения
	Local $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI) ;create a graphics object from a window handle
	_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap, $iPos_X - $iOffset_X, $iPos_Y - $iOffset_Y) ;copy negative bitmap to graphics object (GUI)
	_GDIPlus_GraphicsDispose($hGraphics)
EndFunc

Func _Exit()
	Exit -1
EndFunc
