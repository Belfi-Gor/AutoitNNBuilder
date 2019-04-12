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
