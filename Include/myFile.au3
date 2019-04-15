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

Func _loadNetwork()
	#cs - Загружает из файла нейросеть, выгруженную туда ранее командой _saveNetwork
		Помещает в глобальную область массивы wih и who с уже инициализированной нейросетью которую можно тут же применять в деле или же продолжать обучать
	#ce
	my_Debug("_loadNetwork - Start", 1)
	my_Debug("Загружаю файл" & @ScriptDir&"\"&$networkName&"\"&$networkName&" - wih.txt")
	Local $sWih = FileRead(@ScriptDir&"\"&$networkName&"\"&$networkName&" - wih.txt")
	Local $aRows = StringSplit($sWih, "@", 2)
	Local $aCols = StringSplit($aRows[0], "|", 2)
	my_Debug("Размер массива из файла: [" &UBound($aRows, 1)& "][" &UBound($aCols, 1)& "]")
;~ 	Global $__g_afWIH[UBound($aRows, 1)][UBound($aCols, 1)]
	For $row = 0 To UBound($__g_afWIH, 1) -1 Step 1
		Local $tempRow = StringSplit($aRows[$row], "|", 2)
		For $col = 0 To UBound($__g_afWIH, 2) -1 Step 1
			$__g_afWIH[$row][$col] = $tempRow[$col]
		Next
	Next
	_DebugArrayDisplay($__g_afWIH)
	my_Debug("Загружаю файл" & @ScriptDir&"\"&$networkName&"\"&$networkName&" - who.txt")
	Local $sWho = FileRead(@ScriptDir&"\"&$networkName&"\"&$networkName&" - who.txt")
	Local $aRows = StringSplit($sWho, "@", 2)
	Local $aCols = StringSplit($aRows[0], "|", 2)
	my_Debug("Размер массива из файла: [" &UBound($aRows, 1)& "][" &UBound($aCols, 1)& "]")
;~ 	Global $__g_afWHO[UBound($aRows, 1)][UBound($aCols, 1)]
	For $row = 0 To UBound($__g_afWHO, 1) -1 Step 1
		Local $tempRow = StringSplit($aRows[$row], "|", 2)
		For $col = 0 To UBound($__g_afWHO, 2) -1 Step 1
			$__g_afWHO[$row][$col] = $tempRow[$col]
		Next
	Next
	_DebugArrayDisplay($__g_afWHO)
	my_Debug("_loadNetwork - Stop", -1)
EndFunc
