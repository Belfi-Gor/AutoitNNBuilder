Func _Matrix_Product($afMatrixA, $afMatrixB)
    #cs	Осуществляет произведение матриц
		Вообще вся суть нейросетей - это перемножение матриц. Просто иногда эти матрицы достигают колосальных размеров и занимают терробайты оперативной памяти.
		https://ru.wikipedia.org/wiki/%D0%A3%D0%BC%D0%BD%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D0%B5_%D0%BC%D0%B0%D1%82%D1%80%D0%B8%D1%86
	#ce
	Local $iRowsA = UBound($afMatrixA, 1) ;Максимальное количество строк 
	Local $iColsB = UBound($afMatrixB, 2) ;Максимальное количество стобцов
	Local $iColsA = UBound($afMatrixA, 2) ;"глубина"
    Local $afMatrixC[$iRowsA][$iColsB] ;Результирующий массив
	Local $fCurElement ;Переменная куда будет формироваться результат умножения
	
    For $iRowA = 0 To $iRowsA - 1 ;Перебираем строки
        For $iColB = 0 To $iColsB - 1 ;Перебираем колонки
            $fCurElement = 0 
            For $x = 0 To $iColsA - 1
                $fCurElement += ($afMatrixA[$iRowA][$x] * $afMatrixB[$x][$iColB])
            Next
            $afMatrixC[$iRow][$iCol] = $fCurElement
        Next
    Next
    Return $afMatrixC
EndFunc

Func _Matrix_element_Sub($mat1,  $mat2)
	#cs - Поэлементное вычитание матриц одинакового размера
	
	#ce
	Local $afMatrix[UBound($mat1, 1)][UBound($mat1, 2)]
	For $row = 0 To UBound($afMatrix, 1) -1 Step 1
		For $col = 0 To UBound($afMatrix, 2) -1 Step 1
			$afMatrix[$row][$col] = $mat1[$row][$col] - $mat2[$row][$col]
		Next
	Next
	Return $afMatrix
EndFunc

Func _Matrix_element_Sum($mat1, $mat2)
	#cs - Поэлементное сложение матриц одинакового размера
	
	#ce
	Local $afMatrix[UBound($mat1, 1)][UBound($mat1, 2)]
	For $row = 0 To UBound($afMatrix, 1) -1 Step 1
		For $col = 0 To UBound($afMatrix, 2) -1 Step 1
			$afMatrix[$row][$col] = $mat1[$row][$col] + $mat2[$row][$col]
		Next
	Next
	Return $afMatrix
EndFunc 
	
Func _Matrix_element_Mul($mat1,  $mat2)
	#cs - Поэлементное Умножение матриц одинакового размера
	
	#ce
	Local $afMatrix[UBound($mat1, 1)][UBound($mat1, 2)]
	For $row = 0 To UBound($afMatrix, 1) -1 Step 1
		For $col = 0 To UBound($afMatrix, 2) -1 Step 1
			$afMatrix[$row][$col] = $mat1[$row][$col] * $mat2[$row][$col]
		Next
	Next
	Return $afMatrix
EndFunc

Func _Matrix_applyLR($mat1, $num)
	#cs - Применяет к матрице Learning Rate
		Поэлементное Умножение матрицы на заданное число
	
	#ce
	Local $afMatrix[UBound($mat1, 1)][UBound($mat1, 2)]
	For $row = 0 To UBound($afMatrix, 1) -1 Step 1
		For $col = 0 To UBound($afMatrix, 2) -1 Step 1
			$afMatrix[$row][$col] = $mat1[$row][$col] * $num
		Next
	Next
	Return $afMatrix
EndFunc