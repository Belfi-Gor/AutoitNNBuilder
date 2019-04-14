Func _Matrix_Product($aArray1, $aArray2)
    #cs	Осуществляет произведение матриц
		Вообще вся суть нейросетей - это перемножение матриц. Просто иногда эти матрицы достигают колосальных размеров и занимают терробайты оперативной памяти.
		https://ru.wikipedia.org/wiki/%D0%A3%D0%BC%D0%BD%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D0%B5_%D0%BC%D0%B0%D1%82%D1%80%D0%B8%D1%86
	#ce
	Local $rows = 	UBound($aArray1, 1) ;Максимальное количество строк
	Local $cols = 	UBound($aArray2, 2) ;максимальное количество стобцов
	Local $depth = 	UBound($aArray1, 2) ;"глубина"
    Local $aResult[$rows][$cols] ;Результирующий массив
	Local $x ;Переменная куда будет формироваться результат умножения
    For $row = 0 To $rows - 1 ;Перебираем строки
        For $col = 0 To $cols - 1 ;Перебираем колонки
            $x = 0 
            For $z = 0 To $depth - 1
                $x += ($aArray1[$row][$z] * $aArray2[$z][$col])
            Next
            $aResult[$row][$col] = $x
        Next
    Next
    Return $aResult
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