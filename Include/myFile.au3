Func __myFile_FileReadToArray($sFileName, $bShuffle = True)
	#cs Считывает файл в массив и перемешивает его при необходимости
		Принимает на вход:
			$sFileName - string Строку с указанием пути к файлу
			$bShuffle - bool Необходимость перемешать массив
		Возвращает:
			Двумерный массив с содержимым файла где одна строка массива = одной строке файла, а каждый элемент строки разделенный "," - колонка массива
		В случае ошибки возвращает @error, описание ошибки в @extended и False
	#ce
	my_Debug("my_readTrainDataFromFile - Start", 1)
	my_Debug("Получено на вход:", 1)
	my_Debug("$sFileName = " & $sFileName)
	my_Debug("$bShuffle = " & $bShuffle)
	my_Debug("Ищу файл", -1)
	If Not FileExists($sFileName) Then Return SetError(1, "Файл не найден",  False)
	my_Debug("Файл найден, считываю в массив")
	Local $textArray
	_FileReadToArray($sFileName, $textArray, 0, ",")
	If @error Then Return SetError(@error, "Не могу прочитать файл, подробнее в описании _FileReadToArray",  False)
	my_Debug("Файл считан. Размер массива = " & UBound($textArray))
	If $bShuffle Then 
		my_Debug("Перемешиваю массив")
		_ArrayShuffle($textArray)
	EndIf
	my_Debug("my_readTrainDataFromFile - Stop", -1)
	Return $textArray
EndFunc