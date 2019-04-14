Func _myMath_MatrixProduct($afMatrixA, $afMatrixB)
	#cs	
		Осуществляет произведение матриц
		Вообще вся суть нейросетей - это перемножение матриц. Просто иногда эти матрицы достигают колосальных размеров и занимают терробайты оперативной памяти.
		https://ru.wikipedia.org/wiki/%D0%A3%D0%BC%D0%BD%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D0%B5_%D0%BC%D0%B0%D1%82%D1%80%D0%B8%D1%86
		
		Перемножает матрицы A и B получая матрицу C как результат работы функции
	#ce
	
	;Это ОЧЕНЬ важная, если не самая важная функция текущего проекта и всей теории нейросетей.
	;Понимание того как происходит перемножение матриц - 50% понимания нейронных сетей.
	;Матрицы используются для хранения и обновления состояний нейросети.
	;Нейросеть - это набор отдельных матриц, отражающих связи между всеми нейронами двух граничащих друг с другом слоёв
	;Если бы в нейросети было 5 слоёв: [Input, 1, 2, 3, Output]
	;Нейросеть состояла бы из 4х матриц отражающих связи слоёв:
	;	[Input	<>	1] 		- Входящий слой 	<>	Скрытый слой 1
	;	[1		<> 	2]		- Скрытый слой 1	<>	Скрытый слой 2
	;	[2		<> 	3]		- Скрытый слой 2	<>	Скрытый слой 3
	;	[3		<> 	Output]	- Скрытый слой 3	<>	Выходной слой
	
	;Тут типа по хорошему бы надо вставить валидацию полученных данных
	
	Local $iRowsA = UBound($afMatrixA, 1) ;Максимальное количество строк матрицы А
	Local $iColsB = UBound($afMatrixB, 2) ;Максимальное количество стобцов матрицы B
	Local $iColsA = UBound($afMatrixA, 2) ;Максимальное количество столбцов матрицы A
    Local $afMatrixC[$iRowsA][$iColsB] ;Результирующий массив куда будет сохранена полученная в процессе работы матрица C
	Local $fCurElement ;Переменная куда будет формироваться результат умножения и формироваться текущий обрабатываемый элемент матрицы C
	
    For $iRowA = 0 To $iRowsA - 1 ;Перебираем строки матрицы A
        For $iColB = 0 To $iColsB - 1 ;Перебираем колонки перебираем стобцы матрицы B
            $fCurElement = 0 ;В начале каждого нового столбца матрицы B обнуляем значение текущего элемента матрицы C
            For $x = 0 To $iColsA - 1 ;Непосредственно в этом цикле осуществляется расчет элемента C, два внешних цикла используются только для позиционирования
				;В матрице А столько же столбцов сколько строк в матрице B, поэтому используя только 1 цикл мы можем пройтись по всем их элементами и высчитать элемент матрицы C
                $fCurElement += ($afMatrixA[$iRowA][$x] * $afMatrixB[$x][$iColB])
            Next
            $afMatrixC[$iRowA][$iColB] = $fCurElement ;Сохраняем расчитанный элемент матрицы C в матрицу C
        Next
    Next
    Return $afMatrixC ;Возвращаем результат
EndFunc

Func _myMath_MatrixSub($afMatrixA,  $afMatrixB)
	#cs - Производит поэлементное вычитание матрицы A из матрицы B создавая матрицу C
		Принимает на вход:
			$afMatrixA - Матрица ИЗ которой необходимо вычитать
			$afMatrixB - Матрица КОТОРУЮ необходимо вычитать
		Результат работы:
			$afMatrixC - Результат вычитания матрицы B из матрицы A
	#ce
	Local $afMatrixC[UBound($afMatrixA, 1)][UBound($afMatrixA, 2)] ;Создаем новую матрицу, размер новой матрицы будет равен размеру матрицы A. При этом размер матрицы A должен быть равен размеру матрицы B
	For $iRow = 0 To UBound($afMatrixC, 1) -1 Step 1 ;Перебираем все строки
		For $iCol = 0 To UBound($afMatrixC, 2) -1 Step 1 ;Перебираем все колонки
			$afMatrixC[$iRow][$iCol] = $afMatrixA[$iRow][$iCol] - $afMatrixB[$iRow][$iCol] ;Вычитаем из элемента матрицы A, элемент матрицы B. Оба элемента находятся по адресу [iRow][iCol]
		Next
	Next
	Return $afMatrixC
EndFunc

Func _myMath_MatrixSum($afMatrixA, $afMatrixB)
	#cs - Производит поэлементное сложение матрицы A с матрицей B создавая матрицу C
		Принимает на вход:
			$afMatrixA - Матрица элементы которой необходимо сложить с матрицей B
			$afMatrixB - Матрица элементы которой необходимо сложить с матрицей A
		Результат работы:
			$afMatrixC - Результат сложения матриц A и B
	#ce
	Local $afMatrixC[UBound($afMatrixA, 1)][UBound($afMatrixA, 2)] ;Создаем новую матрицу, размер новой матрицы будет равен размеру матрицы A. При этом размер матрицы A должен быть равен размеру матрицы B
	For $iRow = 0 To UBound($afMatrixC, 1) -1 Step 1 ;Перебираем все строки
		For $iCol = 0 To UBound($afMatrixC, 2) -1 Step 1 ;Перебираем все колонки
			$afMatrixC[$iRow][$iCol] = $afMatrixA[$iRow][$iCol] + $afMatrixB[$iRow][$iCol] ;Вычитаем к элементу матрицы A, элемент матрицы B. Оба элемента находятся по адресу [iRow][iCol]
		Next
	Next
	Return $afMatrixC
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