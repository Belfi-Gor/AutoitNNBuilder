; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: 	__myFile_FileReadToArray
; Description ...: 	Считывает содержимое файла в двумерный массив и перемешивает его строки если явно не указано обратное.
;					Внутри файла, каждая новая строка массива должна начинаться с новой строки в тексте.
;					Данные в массиве будут начинаться с [0]. Для определения его размера необходимо использовать UBound()
; Syntax.........: 	__myFile_FileReadToArray($sFileName[, $sDelimiter = ","[, $bShuffle = True]])
; Parameters ....:	$sFileName		- Строковая переменная, содержащая путь к файлу из которого нужно прочитать массив
;					$sDelimiter		- Строковая переменная, содержащая разделитель который будет использован для разделения
;									элементов внутри каждой строки массива
;					$bShuffle		- Булева переменная содержащая триггер к перемешиванию массива
; Return values .: 	Success			- Массив прочитанных из файла данных
;					Failure			- Возвращает False и устанавливает @error в значение:
;									|1 - Указанный в $sFileName файл не найден
;									|2 - Ошибка команды _FileReadToArray
;									----| Устанавливает в @extended значение @error команды _FileReadToArray
;										| Подробности в справке команды _FileReadToArray
;									|3 - Ошибка команды _ArrayShuffle
;									----| Устанавливает в @extended значение @error команды _ArrayShuffle
;										| Подробности в справке команды _ArrayShuffle
; Author ........:	Belfigor
; Modified.......: 	
; Remarks .......: 	
; Related .......: 	
; Link ..........: 	
; Example .......: 	No
; ===============================================================================================================================
Func __myFile_FileReadToArray($sFileName, $sDelimiter = ",", $bShuffle = True)
	my_Debug("__myFile_FileReadToArray - Start", 1)
	my_Debug("Получено на вход:", 1)
	my_Debug("$sFileName = " & $sFileName)
	my_Debug("$sDelimiter = " & $sDelimiter)
	my_Debug("$bShuffle = " & $bShuffle)
	my_Debug("Ищу файл", -1)
	;Проверяем существует ли файл, если нет - установить @error = 2 и вернуть False
	If Not FileExists($sFileName) Then Return SetError(1, 0,  False)
	
	my_Debug("Файл найден, считываю в массив")
	Local $afArray ;Создаём переменную куда будет считан целевой файл
	_FileReadToArray($sFileName, $afArray, 0, $sDelimiter) ;Считываем файл в массив
	;Если ошибка установить @error = 2, @extended = исходной @error от _FileReadToArray и вернуть False
	If @error Then Return SetError(2, @error,  False) 
	
	my_Debug("Файл считан. Размер массива = " & UBound($afArray))

	If $bShuffle Then 
		my_Debug("Перемешиваю массив")
		_ArrayShuffle($afArray)
		;Если ошибка - установить @error = 3; @extended = исходной @error от _ArrayShuffle и вернуть False
		If @error Then Return SetError(3, @error,  False)
	EndIf
	
	my_Debug("__myFile_FileReadToArray - Stop", -1)
	Return $afArray
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: 	_myFile_LoadNetwork
; Description ...: 	Считывает нейросеть из папки нейросети, ранее выгруженную в файлы командой _saveNetwork и заносит полученную
;					нейросеть, в переменные используемые для хранения нейросети. 
; Syntax.........: 	_myFile_LoadNetwork([$bValidate = False])
; Parameters ....:	$bValidate - Триггер валидации глобальных данных используемых для работы
; Return values .: 	Success			- Заполняет массивы содержащие нейросеть рабочими данными загруженной из файла нейросети
;					Failure			- Возвращает False и устанавливает @error в значение:
;									|1 - Не найден файл wih.txt
;									|2 - Не найден файл who.txt
;									|3 - Ошибка команды FileRead при чтении wih.txt
;									----| Устанавливает в @extended значение @error команды FileRead
;									|4 - Количество строк wih.txt не соотвутствует количеству строк инициализированной сети
;									|5 - Количество столбцов wih.txt не соотвутствует количеству стобцов инициализированной сети
;									|6 - Ошибка команды FileRead при чтении who.txt
;									----| Устанавливает в @extended значение @error команды FileRead
;									|7 - Количество строк wih.txt не соотвутствует количеству строк инициализированной сети
;									|8 - Количество столбцов wih.txt не соотвутствует количеству стобцов инициализированной сети
; Author ........:	Belfigor
; Modified.......: 	
; Remarks .......: 	
; Related .......: 	
; Link ..........: 	
; Example .......: 	No
; ===============================================================================================================================
Func _myFile_LoadNetwork($bValidate = False)
	my_Debug("_myFile_LoadNetwork - Start", 1)

	Local $sRowsDelimiter = "@"
	Local $sColsDelimiter = "|"
	Local $asRows = 0
	Local $asCols = 0
	Local $sWih = ''
	Local $sWho = ''
	Local $asTempRow = 0

	;Шаблон пути откуда загружаются нейросети захардкоден и задается тут.
	Local $sPathWIH = @ScriptDir&"\"&$g_iNeuralNetworkName&"\"&$g_iNeuralNetworkName&" - wih.txt"
	Local $sPathWHO = @ScriptDir&"\"&$g_iNeuralNetworkName&"\"&$g_iNeuralNetworkName&" - who.txt"
	If $bValidate Then 
		my_Debug("Произвожу валидацию входящих данных", 1)
		If  Not FileExists($sPathWIH) Then Return SetError(1, 0, False) ;Возвращаем False и @error = 1 если не найден файл WIH
		If  Not FileExists($sPathWHO) Then Return SetError(2, 0, False) ;Возвращаем False и @error = 2 если не найден файл WHO
		my_Debug("Произвожу валидацию входящих данных", -1)
	EndIf
	
	my_Debug("Загружаю файл" & $sPathWIH)
	;Считываем файл в переменную $sWih. В случае успеха мы получим одну сплошную строку, где строки массива будут 
	;отделены друг от друга знаком "@", а элементы внутри строк массива будут разделены знаком "|"
	$sWih = FileRead($sPathWIH) ;Считываем файл в переменную $sWih
	If @error Then Return SetError(3, @error, False) ;Возвращаем False и @error = FileRead @error, если функция FileRead сгенерировала ошибку
	
	$asRows = StringSplit($sWih, $sRowsDelimiter, 2) ;Разбиваем массив на строки
	$asCols = StringSplit($asRows[0], $sColsDelimiter, 2) ;Разбиваем первую строку на колонки (нужно для определения размера)
	my_Debug("Размер массива из файла: [" &UBound($asRows, 1)& "][" &UBound($asCols, 1)& "]")
	
	;Проверяем соответствует ли количество строк и количество столбцов массива из файла, этим же параметрам инициализированной сети
	If UBound($asRows, 1) <> UBound($__g_afWIH, 1) Then Return SetError(4, UBound($asRows, 1), False)
	If UBound($asCols, 1) <> UBound($__g_afWIH, 2) Then Return SetError(5, UBound($asCols, 1), False)

	For $iRow = 0 To UBound($__g_afWIH, 1) -1 Step 1 ;Построчно перебираем глобальный массив WIH
		$asTempRow = StringSplit($asRows[$iRow], "|", 2) ;На каждой строке WIH, берем соответствующую строку из файла и разбиваем её на элементы
		For $iCol = 0 To UBound($__g_afWIH, 2) -1 Step 1 ;Поэлементно перебираем каждый элемент глобального массива WIH
			$__g_afWIH[$iRow][$iCol] = $asTempRow[$iCol] ;И записываем в него соответствующий элемент загруженный ранее из файла
		Next
	Next

	my_Debug("Загружаю файл" & $sPathWHO)
	$sWho = FileRead($sPathWHO) ;Считываем в переменную $sWho файл
	If @error Then Return SetError(6, @error, False) ;Возвращаем False и @error = FileRead @error, если функция FileRead сгенерировала ошибку
	
	$asRows = StringSplit($sWho, $sRowsDelimiter, 2) ;Разбиваем массив на строки
	$asCols = StringSplit($asRows[0], $sColsDelimiter, 2);Разбиваем первую строку на колонки (нужно для определения размера)
	
	;Проверяем соответствует ли количество строк и количество столбцов массива из файла, этим же параметрам инициализированной сети
	If UBound($asRows, 1) <> UBound($__g_afWHO, 1) Then Return SetError(7, UBound($asRows, 1), False)
	If UBound($asCols, 1) <> UBound($__g_afWHO, 2) Then Return SetError(8, UBound($asCols, 1), False)
	my_Debug("Размер массива из файла: [" &UBound($asRows, 1)& "][" &UBound($asCols, 1)& "]")

	For $iRow = 0 To UBound($__g_afWHO, 1) -1 Step 1 ;Построчно перебираем глобальный массив WHO
		$asTempRow = StringSplit($asRows[$iRow], "|", 2) ;На каждой строке WHO, берем соответствующую строку из файла и разбиваем её на элементы
		For $iCol = 0 To UBound($__g_afWHO, 2) -1 Step 1 ;Поэлементно перебираем каждый элемент глобального массива WHO
			$__g_afWHO[$iRow][$iCol] = $asTempRow[$iCol] ;И записываем в него соответствующий элемент загруженный ранее из файла
		Next
	Next

	my_Debug("_myFile_LoadNetwork - Stop", -1)
EndFunc

Func _myFile_SaveNetwork($lastRow)
	#cs - Сохраняет текущий прогресс обучения сети в файлы.
		На вход принимает:
			$iLastRow - номер следующей строки датасета с которой нужно будет продолжить обучение
		Берет из глобальной области:
			$g_iNeuralNetworkName - Имя текущей обрабатываемой нейронной сети
			$__g_afWIH - массив связей входного и скрытого слоёв
			$__g_afWHO - массив связей скрытого и выходного слоёв
		Создает в отдельной папке с именем нейросети файлы wih.txt, who.txt и settings.ini
	#ce
    FileCopy(@ScriptDir&"\"&$g_iNeuralNetworkName&"\"&$g_iNeuralNetworkName&" - settings.ini", @ScriptDir&"\"&$g_iNeuralNetworkName&"\bkp\", $FC_OVERWRITE + $FC_CREATEPATH)
	IniWrite(@ScriptDir&"\"&$g_iNeuralNetworkName&"\"&$g_iNeuralNetworkName&" - settings.ini", "startData", "lastRow", $lastRow)

	FileCopy(@ScriptDir&"\"&$g_iNeuralNetworkName&"\"&$g_iNeuralNetworkName&" - wih.txt", @ScriptDir&"\"&$g_iNeuralNetworkName&"\bkp\", $FC_OVERWRITE + $FC_CREATEPATH)
	FileDelete(@ScriptDir&"\"&$g_iNeuralNetworkName&"\"&$g_iNeuralNetworkName&" - wih.txt")
	Local $sWih = _ArrayToString($__g_afWIH, "|", -1, -1, "@")
	FileWrite(@ScriptDir&"\"&$g_iNeuralNetworkName&"\"&$g_iNeuralNetworkName&" - wih.txt", $sWih)

	FileCopy(@ScriptDir&"\"&$g_iNeuralNetworkName&"\"&$g_iNeuralNetworkName&" - who.txt", @ScriptDir&"\"&$g_iNeuralNetworkName&"\bkp\", $FC_OVERWRITE + $FC_CREATEPATH)
	FileDelete(@ScriptDir&"\"&$g_iNeuralNetworkName&"\"&$g_iNeuralNetworkName&" - who.txt")
	Local $sWho = _ArrayToString($__g_afWHO, "|", -1, -1, "@")
    FileWrite(@ScriptDir&"\"&$g_iNeuralNetworkName&"\"&$g_iNeuralNetworkName&" - who.txt", $sWho)
EndFunc