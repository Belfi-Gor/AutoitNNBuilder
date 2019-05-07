#include "recruit_bot.au3"
#include "GUI.isf"
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <ScreenCapture.au3>
#include <WinAPIHObj.au3>
#include <Array.au3>
#include <GuiComboBox.au3>
;~ Example()
;~ Exit
_GUICtrlComboBox_AddDir ( $idCombobox_DatasetList, @ScriptDir&"\..\*.csv")

GUISetState(@SW_SHOW)
While 1
	If GUICtrlRead($idCheckbox_DrawImage) = 1 Then 
		Example()
		Sleep(1000)
	EndIf
Wend

Func Example()
	Local $sLine = FileReadLine("../" & GUICtrlRead($idCombobox_DatasetList), GUICtrlRead($idUpdown_LineNumber))
	If @error Then  MsgBox(0, 0, @error)
;~ 	MsgBox(0, 0, $sLine)
;~ 	Exit 
	Local $aArray =  StringSplit($sLine, ",", 2)
	_ArrayDelete($aArray, 0)
	
;~ 	_ArrayDisplay($aArray)
	Local $counter = 0
	Local $newArray[28][28]
	For $y = 0 To 28 -1 Step 1
		For $x = 0 To 28 -1 Step 1
			$newArray[$x][$y] = $aArray[$counter]
			$counter += 1
		Next
	Next
;~ 	_ArrayDisplay($newArray)
	
	
	
	
;~ 	Exit 
	_GDIPlus_Startup() ;initialize GDI+
	Local Const $iWidth = 28, $iHeight = 28
	Local $iColor = 0
	Local $hHBmp = _ScreenCapture_Capture("", 0, @DesktopHeight - $iHeight, $iWidth, @DesktopHeight) ;create a GDI bitmap by capturing an area on desktop
	Local $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBmp) ;convert GDI to GDI+ bitmap
	_WinAPI_DeleteObject($hHBmp) ;release GDI bitmap resource because not needed anymore
	Local $iR, $iG, $iB, $iGrey
	For $iY = 0 To $iHeight - 1
		For $iX = 0 To $iWidth - 1
;~ 			$iColor = _GDIPlus_BitmapGetPixel($hBitmap, $iX, $iY) ;get current pixel color
;~ 			$iR = BitShift(BitAND($iColor, 0x00FF0000), 16) ;extract red color channel
;~ 			$iG = BitShift(BitAND($iColor, 0x0000FF00), 8) ;extract green color channel
;~ 			$iB = BitAND($iColor, 0x000000FF) ;;extract blue color channel
;~ 			$iGrey = Hex(Int(($iR + $iG + $iB) / 3), 2) ;convert pixels to average greyscale color format
			$iGrey = $newArray[$iX][$iY]
			_GDIPlus_BitmapSetPixel($hBitmap, $iX, $iY, "0xFF" & $iGrey & $iGrey & $iGrey) ;set greyscaled pixel
		Next
	Next
;~ 	Local $hGUI = GUICreate("GDI+ Example (" & @ScriptName & ")", $iWidth, $iHeight) ;create a test GUI
	

	Local $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI) ;create a graphics object from a window handle
;~ 	_GDIPlus_GraphicsScaleTransform($hGraphics, 2, 2)
;~ 	_GDIPlus_GraphicsScaleTransform($hGraphics, 2, 2, True)
	_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap, 250, 50) ;copy negative bitmap to graphics object (GUI)

;~ 	Do
;~ 	Until GUIGetMsg() = $GUI_EVENT_CLOSE

	;cleanup GDI+ resources
	_GDIPlus_GraphicsDispose($hGraphics)
	_GDIPlus_Shutdown()
;~ 	GUIDelete($hGUI)
EndFunc   ;==>Example
