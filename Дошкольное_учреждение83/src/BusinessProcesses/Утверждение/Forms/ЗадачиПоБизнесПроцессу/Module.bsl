
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("БизнесПроцесс", Параметры.БизнесПроцесс);
	Список.Параметры.УстановитьЗначениеПараметра("ТочкаОзнакомиться", БизнесПроцессы.Утверждение.ТочкиМаршрута.Ознакомиться);
	
	РаботаСБизнесПроцессами.УстановитьФорматДаты(Элементы.ДатаИсполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗадачаИзменена" ИЛИ ИмяСобытия = "ЗадачаВыполнена" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	БизнесПроцессыИЗадачиКлиент.СписокЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	БизнесПроцессыИЗадачиКлиент.СписокЗадачПередНачаломИзменения(Элемент, Отказ);
	
КонецПроцедуры
