; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: 	_myArray_Create2DWithRandomFill
; Description ...: 	Создает двумерный массив и заполняет его случайными числами в диапазоне от -0.5 до 0.5
; Syntax.........: 	__myArray_Create2DWithRandomFill($iRows, $iCols)
; Parameters ....:	$iRows			- Целое число задающее количество строк матрицы
;					$iCols			- Целое число здающее количество столбцов матрицы
; Return values .: 	Success			- Матрица(массив) с количеством строк iRows и количеством колонок iCols
;					Failure			- Возвращает False и устанавливает @error значение:
;									|1 - Параметр $iRows не является целым числом
;									|2 - Параметр $iCols не является целым числом
;									|3 - Параметр $iRows Должен быть >= 1
;									|4 - Параметр $iCols Должен быть >= 1
; Author ........:	Belfigor
; Modified.......: 	
; Remarks .......: 	
; Related .......: 	
; Link ..........: 	
; Example .......: 	No
; ===============================================================================================================================
Func __myArray_Create2DWithRandomFill($iRows, $iCols, $bValidate = False)
	my_Debug("my_ArrayCreate - Start", 1)
	If $bValidate Then ;Если bValidate = True
		my_Debug("Произвожу валидацию входящих данных", 1)
		If Not IsInt($iRows) Then Return SetError(1, 0, False) ;Проверяем что $iRows - целое число
		If Not $iRows >= 1 Then Return SetError(3, 0, False) ;Проверяем что $iRows >= 1
		my_Debug("Проверка iRows: OK")
		If Not IsInt($iCols) Then Return SetError(2, 0, False) ;Проверяем что $iCols - целое число
		If Not $iCols >= 1 Then Return SetError(4, 0, False) ;Проверяем что $iCols >= 1
		my_Debug("Проверка iCols: OK")
		my_Debug("Валидация данных успешно пройдена", -1)
	EndIf
	
	my_Debug("Создаю массив с параметрами: $iRows=" & $iRows & ", $iCols=" & $iCols)
	Local $afArray[$iRows][$iCols] ;Создаём массив нужного размера
	For $iRow = 0 To $iRows -1 Step 1 ;Перебираем строки
		For $iColumn = 0 To $iCols -1 Step 1 ;Перебираем колонки
			$afArray[$iRow][$iColumn] = Round(Random(0, 1) - 0.5, 5) ;Каждый элемент заполняем случайным значением от -0.5 до 0.5
		Next
	Next
	my_Debug("Создан массив $afArray[" & UBound($afArray, 1) & "][" & UBound($afArray, 2) & "]")
	my_Debug("my_ArrayCreate - End", -1)
	Return $afArray ;Возвращаем результат наружу
EndFunc