Func _myPerf_UpdateCounter($sCounterName, $fData)
	If Not IsDeclared($sCounterName) Then Return SetError(1, 0, False ) ;Если этот счетчик не объявлен глобально - возвращаем ошибку
	Switch $sCounterName
		Case "__g_myPerf_1TrainLength"
			_ArrayAdd($__g_myPerf_1TrainLength, Round($fData, 2))
;~ 			_ArrayDisplay($__g_myPerf_1TrainLength)
		Case "__g_myPerf_1ActivationLength"
			_ArrayAdd($__g_myPerf_1ActivationLength, Round($fData, 2))
;~ 			_ArrayDisplay($__g_myPerf_1ActivationLength)
		Case Else 
			Return SetError(2, 0, False)
	EndSwitch
EndFunc

Func _myPerf_UnloadCounters()
	_FileWriteFromArray("__g_myPerf_1TrainLength.txt", $__g_myPerf_1TrainLength)
	_FileWriteFromArray("__g_myPerf_1ActivationLength.txt", $__g_myPerf_1ActivationLength)
EndFunc