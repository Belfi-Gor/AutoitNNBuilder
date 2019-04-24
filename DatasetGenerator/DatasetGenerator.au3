Opt('GUIOnEventMode', 1)
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <ScreenCapture.au3>
#include <WinAPIHObj.au3>
#include "GUI.isf"
GUISetState(@SW_SHOW)

While 1
	Sleep(100)
Wend

Example()

Func Example()
	Local Const $iLeft = -268, $iTop = 226
	Local Const $iWidth = $iLeft + 21, $iHeight = $iTop + 19
    _GDIPlus_Startup() ;initialize GDI+
	For  $i = 0 To Int(GUICtrlRead($idInput_Counter)) -1 Step 1
		
		Local $iColor = 0
		Local $hHBmp = _ScreenCapture_Capture("", $iLeft, $iTop, $iWidth, $iHeight) ;create a GDI bitmap by capturing an area on desktop
		Local $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBmp) ;convert GDI to GDI+ bitmap
		_WinAPI_DeleteObject($hHBmp) ;release GDI bitmap resource because not needed anymore

		Local $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI) ;create a graphics object from a window handle
		_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap, 150, 150) ;copy negative bitmap to graphics object (GUI)


;~ 		_GDIPlus_ImageSaveToFile ( $hBitmap, Int(GUICtrlRead($idInput_ObjectID)) & $i & '.bmp' )

		Local $iR, $iG, $iB, $iGrey
		For $iY = 0 To $iHeight - $iTop - 1
			For $iX = 0 To $iWidth - $iLeft - 1
				$iColor = _GDIPlus_BitmapGetPixel($hBitmap, $iX, $iY) ;get current pixel color
				$iR = BitShift(BitAND($iColor, 0x00FF0000), 16) ;extract red color channel
				$iG = BitShift(BitAND($iColor, 0x0000FF00), 8) ;extract green color channel
				$iB = BitAND($iColor, 0x000000FF) ;;extract blue color channel
				$iGrey = Hex(Int(($iR + $iG + $iB) / 3), 2) ;convert pixels to average greyscale color format
				_GDIPlus_BitmapSetPixel($hBitmap, $iX, $iY, "0xFF" & $iGrey & $iGrey & $iGrey) ;set greyscaled pixel
			Next
		Next
	;~     Local $hGUI = GUICreate("GDI+ Example (" & @ScriptName & ")", $iWidth, $iHeight) ;create a test GUI
		
		Local $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI) ;create a graphics object from a window handle
		_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap, 150 + 21 + 10, 150) ;copy negative bitmap to graphics object (GUI)
		_GDIPlus_ImageSaveToFile ( $hBitmap, Int(GUICtrlRead($idInput_ObjectID)) &"-"&  $i & '.bmp' )
	;~     Do
	;~     Until GUIGetMsg() = $GUI_EVENT_CLOSE

		;cleanup GDI+ resources
		_GDIPlus_GraphicsDispose($hGraphics)
		Sleep(1000)
	Next 
    _GDIPlus_Shutdown()
;~     GUIDelete($hGUI)
EndFunc   ;==>Example
