Func my_ArrayCreate($iRows, $iColumns)
	#cs Создает массив и инициирует его случайными числами в диапазоне от -0.5 до 0.5
		Принимает на вход:
			$iRows - Количество строк массива
			$iColumns - Количество колонок массива
		Возвращает:
			Массив $aArray[$iRows][$iColumns] заполненный случайными числами от -0.5 до 0.5
	#ce
	my_Debug("my_ArrayCreate - Start", 1)
	my_Debug("Создаю массив с параметрами: $iRows=" & $iRows & ", $iColumns=" & $iColumns)
	Local $aArray[$iRows][$iColumns]
	For $row = 0 To $iRows -1 Step 1
		For $column = 0 To $iColumns -1 Step 1
			$aArray[$row][$column] = Round(Random(0, 1) - 0.5, 5)
		Next
	Next
	my_Debug("Создан массив $aArray[" &UBound($aArray, 1)& "][" &UBound($aArray, 2)& "]")
	my_Debug("my_ArrayCreate - End", -1)
	Return $aArray
EndFunc