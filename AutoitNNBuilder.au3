#include <Array.au3>
#include <File.au3>
#include "Include\myArray.au3"
#include "Include\myDebug.au3"
#include "Include\myFile.au3"
#include "temp_area.au3"
#cs Описание проекта
	Проект носит исключительно академический характер
	Проект будет реализовываться на AutoIt т.к. данный язык очен прост для освоения и хорошо
		подходит для начала изучения программирования
	При реализации проекта будут использоваться только встроенные команды AutoIt и UDF идущие в
		стандартной поставке
	При реализации проекта НЕ будут использоваться сторонние библиотеки, даже нейросетевые т.к.
		это может затруднить понимание пользователями базовых принципов работы нейросетей.
	Т.к. проект будет реализовываться на чистом AutoIt, код будет работать на многие порядки медленнее
		чем точно такие же аналоги реализованные на специально предназначенных для математических
		расчетов библиотеках
	Данный проект будет AutoIt реализацией алгоритмов описываемых в книге Терика Рашида "Создаем нейронную сеть"
		https://www.ozon.ru/context/detail/id/141796497/?_bctx=CAUQqN_tIQ
		Это без преувеличений - САМАЯ лучшая книга для старта изучений нейронных сетей
#ce
Opt("MustDeclareVars", 1)

_DebugSetup(@ScriptName, True,2)
_DebugOut("Запуск " & @ScriptName)
my_Debug("Модуль отладки включен")
temp_test()

Func Init($input_nodes, $hidden_nodes, $output_nodes, $learning_rate)
	#cs Инициализирует трехслойную нейронную сеть.
		Принимает на вход:
			$input_nodes - Количество нейронов первого слоя
			$hidden_nodes - Количество нейронов скрытого слоя
			$output_nodes - Количество нейронов выходного слоя
			$learning_rate - Коэффициент обучения	
	#ce
	my_Debug("Init - Start", 1)
	my_Debug("На вход получены значения: ", 1)
	my_Debug("$input_nodes = " & $input_nodes)
	my_Debug("$hidden_nodes = " & $hidden_nodes)
	my_Debug("$output_nodes = " & $output_nodes)
	my_Debug("$learning_rate = " & $learning_rate)
	
	my_Debug("Создаю массивы связей", -1)
	;Создаем массивы с весами связей нейронов
	;WIH - Weights Input Layer to Hidden Layer - Веса связей между входным слоем и скрытым
	;WHO - Weights Hidden Layer to Output Layer - Веса связей между скрытым слоем и выходным
	Global $WIH = my_ArrayCreate($hidden_nodes, $input_nodes) ;Создаем массив заполненный случайными числами
	Global $WHO = my_ArrayCreate($output_nodes, $hidden_nodes) ;Создаем массив заполненный случайными числами
	
	;Обозначяем ключевые параметры в глобальных переменных
	Global $LR = $learning_rate
;~ 	Global Const $I_NODES = $input_nodes
;~ 	Global Const $H_NODES = $hidden_nodes
;~ 	Global Const $O_NODES = $output_nodes

	my_Debug("Init - End", -1)
EndFunc

Func MNIST_PrepData(ByRef $ref_aInputs, ByRef $ref_aTargets, $aArray)
	;Это не универсальная функция. В зависимости от обрабатываемых изображений и получаемых результатов нужно реализовывать свои функции подготовки данных
	my_Debug("PrepData - Start", 1)
	#cs - Подготавливает массив учебных данных для обработки нейросетью
		Принимает на вход:
			ByRef $ref_aInputs - Ссылка на переменную в которую будет возвращен готовый для работы массив исходных данных
			ByRef $ref_aTargets - Ссылка на переменную в которую будет возвращен готовый для работы массив исходных целей
			$aArray - Массив содержащий данные для обучения сети
			
		Возвращает:
			Массивы подготовленные к обработке нейросетью
			
		Теория:
			В MNIST изображения хранятся в виде одномерных массивов размером 784 элемента. В свою очередь 784 элемента являют собой представление иконки шириной
				и высотой 28 пикселей. 28*28=784
			Так же в каждой строке в ячейке массива [row][0] в учебных данных хранится результат изображения и далее еще 784 ячейки самого изображения.
			Если подать на вход сети число 0, оно заблокирует обновление сети, поэтому нужно смасштабировать данные перед передачей в нейросеть в диапазон от 0.01 до 1.0
			В массиве данных MNIST изображения хранятся в виде яркостей каждого пикселя. Поэтому массив одной цифры MNIST представляет собой набор данных от 0 до 255.
			В MNIST хранятся изображения цифр. Результатом распознавания является цифра от 0 до 9. Значит массивом цели для числа например 3, должен быть массив:
				[0.01, 0.01, 0.01, 0.99, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01]
				А для например числа 9:
				[0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.99]
	#ce
	my_Debug("На вход получен массив $aArray[" &UBound($aArray, 1)& "][" &UBound($aArray, 2)& "]")

	;Нужно разделить массив на две части. Inputs и Targets. Где в Inpust - входные данные, а в Targets - результат который из этих данных должен получаться
	;Выделяем Targets в отдельный массив
	$ref_aTargets = _ArrayExtract($aArray, 0, UBound($aArray, 1) -1, 0, 0)
	;Приводим массив целей в необходимый для нейросети вид
	
	#cs Создаем временный массив где будем подготавливать данные в нужный вид. Количество строк массива = количеству строк массива $aArray а количество
			колонок = 10 где в колонку 0 будет записано 0.99 если целью будет являться 0, а в колонку 9 будет записано 0.99 если целью будет являться 9,
			1 и 8 - соответственно
	#ce
	Local $temp_aTargets[UBound($ref_aTargets, 1)][10] 
	
	;Построчно перебираем временный массив
	For $row = 0 To UBound($ref_aTargets, 1) -1 Step 1 ;Перебираем строки сверху вниз
		For $col = 0 To 10 -1 Step 1 ;Перебираем колонки слева направо
			$temp_aTargets[$row][$col] = 0.01 ;Заполняем ВСЕ колонки текущей строки значением 0.01 . 0.01 - значит неверный результат
		Next
		#cs На данный момент в массиве $ref_aTargets[$row] хранится целевое значение для каждой строки и это значение - целое число от 0 до 9
			И поэтому значение хранимое в текущем массиве целей мы легко можем использовать как индекс, при конвертации его в массив целей необходимый
			для обработки нейросетью.
			Для числа 3, нам надо чтобы в ячейке [row][3] было значение 0.99
			Сначала мы строку row заполняем значениями 0.01 и имеем строку вида
				0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01
			Потом мы приравниваем таргету значение 0.99
				$temp_aTargets[$row][$ref_aTargets[$row]] = 0.99
			Если в $ref_aTargets[$row] хранится число 3, то в упрощенном виде запись будет выглядеть как $temp_aTargets[$row][3] = 0.99
			И получаем в результате 
				0.01, 0.01, 0.01, 0.99, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01
		#ce
		$temp_aTargets[$row][$ref_aTargets[$row]] = 0.99
	Next 
	;Теперь во временном массиве aTargets хранятся данные готовые для передачи наружу, поэтому записываем их в ByRef переменную $ref_aTargets для передачи наружу 
	$ref_aTargets = $temp_aTargets
	;Подготовка массива таргетов завершена


	;Подготавливаем массив с входными данными
	_ArrayColDelete($aArray, 0) ;Удаляем из изначального массива колонку [0] т.к. в ней хранятся таргеты а их мы уже обработали.
	
	;Построчно поэлементно перебираем массив с входными данными масштабируя их до диапазона 0.01...1
	;В данный момент в массиве $aArray хранятся значения от 0 до 255
	For $row = 0 To UBound($aArray, 1) -1 Step 1
		For $col = 0 To UBound($aArray, 2) -1 Step 1
			$aArray[$row][$col] = $aArray[$row][$col] / 255 * 0.99 + 0.01
		Next
	Next
	;После масштабирования в массиве $aArray будут храниться значения от 0.01 до 0.99
	$ref_aInputs = $aArray
EndFunc

func _activation_Sigmoid($x)
	#cs - Функция активации. Сигмоида.
		В данном случае Логистическая функция. 
		Уравнение Ферхюльста, хуясебе как оно оказваца модно называется О_о
		https://ru.wikipedia.org/wiki/%D0%9B%D0%BE%D0%B3%D0%B8%D1%81%D1%82%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%BE%D0%B5_%D1%83%D1%80%D0%B0%D0%B2%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5
		Живет "в центре" нейрона. На вход получает входные данные поступившие на нейрон с предидущих нейронов и считает результат который будет выходом этого нейрона
	#ce Дебаг не добавлен ввиду высокой частоты использования этой функции. Если добавить дебаг она засрёт своими логами всё.
    Return 1 / (1 +  Exp($x * -1))
endfunc

Func _activation_SigmoidMatrix($aArray)
	#cs Функция активации применяемая ко всей матрице
		Матрицей в данном случае выступает двумерный массив с одной лишь колонкой
		В цикле проходит по нему вызывая функцию активации
		Принимает на вход:
			Двумерный массив с одной колонкой
		Возвращает:
			Двумерный массив с одной колонкой, пропущенный через функцию активации.
	#ce
	For $i = 0 To UBound($aArray) -1 Step 1
		$aArray[$i][0] = _activation_Sigmoid($aArray[$i][0])
	Next
	Return $aArray
EndFunc

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
	
Func _updateLinks($cur_level, $cur_errors, $cur_outputs, $prev_outputs)
	#cs - Обновляет связи между нейронами двух слоёв.
		Принимает на вход:
			$cur_level - переменная в которую пишется ссылка на $wih или $who чьи связи надо обновить
			Возможно имена $cur_outpiuts и $prev_outputs не верно отражают суть. Оставим так до времен ремастеринга.
	
	#ce
	Local $AllOneMatrix[UBound($cur_outputs, 1)][UBound($cur_outputs, 2)]
	For $row = 0 To UBound($AllOneMatrix, 1) -1 Step 1
		For $col = 0 To UBound($AllOneMatrix, 2) -1 Step 1
			$AllOneMatrix[$row][$col] = 1
		Next
	Next

	Local $uL_step1 =  _Matrix_element_Sub($AllOneMatrix, $cur_outputs)
	Local $uL_step2 =  _Matrix_element_Mul($uL_step1, $cur_outputs)
	Local $uL_step3 =  _Matrix_element_Mul($uL_step2, $cur_errors)
	_ArrayTranspose($prev_outputs)
	Local $uL_step4 =  _Matrix_Product($uL_step3, $prev_outputs)
	Local $uL_step5 =  _Matrix_applyLR($uL_step4, $lr)
	Return $uL_step5
EndFunc

Func Train($inputs, $targets)
	#cs - Производит один обучающий подход

		Принимает на вход:
			$inputs - Одну строку массива входных данных
			$targets - Одну строку массива целей

		Вносит изменения в нейросеть путем модификации переменных WHO и WIH	
	#ce
	my_Debug("Train - Start", 1)
	_ArrayTranspose($inputs)
	_ArrayTranspose($targets)
	Local $hidden_inputs = _Matrix_Product($wih, $inputs)
	Local $hidden_outputs =  _activation_SigmoidMatrix($hidden_inputs)
	Local $final_inputs = _Matrix_Product($who, $hidden_outputs)
	Local $final_outputs = _activation_SigmoidMatrix($final_inputs)
	Local $output_errors = _Matrix_element_Sub($targets, $final_outputs)
	Local $temp_who = $who
	_ArrayTranspose($who)
	Local $hidden_errors =  _Matrix_Product($who, $output_errors)

	$WHO =  $temp_who
	Local $temp = _updateLinks($who, $output_errors, $final_outputs, $hidden_outputs)

	$WHO = _Matrix_element_Sum($temp, $who)
	Local $temp2 = _updateLinks($wih, $hidden_errors, $hidden_outputs, $inputs)
	$WIH = _Matrix_element_Sum($temp2, $wih)
	my_Debug("Train - Stop", -1)
EndFunc

Func _trainNetwork()
	my_Debug("_trainNetwork - Start", 1)
	#cs Инициализирует однократное обучение нейросети по датасету (эпоху) 
	
	#ce
	;Загружаем тренировочные данные
	Local $trainsource = my_readTrainDataFromFile(@ScriptDir&"\mnist_train_100.csv") ;загружаем учебную подборку
	
	
	;Подготавливаем полученный массив, формируя массивы целевых и входных данных
	Local $aInputs, $aTargets
	MNIST_PrepData($aInputs, $aTargets, $trainsource) ;подготавливаем учебные данные перед передачей их в нейросеть
	If @error Then MsgBox(0, @error, @extended)

	;Циклично извлекает из целевого и входного массива по 1й строке за раз и осуществляет 1 подход обучения с использованием этих данных.
	Local $curTarget, $curInputs
	For $i = 0 To UBound($aTargets, 1) -1 Step 1
		my_Debug("Учу " & $i)
		$curTarget = _ArrayExtract($aTargets, $i, $i)
		$curInputs = _ArrayExtract($aInputs, $i, $i)
		Train($curInputs, $curTarget)
	Next
	my_Debug("_trainNetwork - Stop", -1)
EndFunc