
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ МОДУЛЯ  

&НаКлиенте
Процедура ОбработатьВыборРеспондента(МассивВыбора)
	
	Оповестить("ВыборРеспондентов",Новый Структура("ОтобранныеРеспонденты",МассивВыбора));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(Параметры.ТипРеспондента)) Тогда
		
		Респонденты.ОсновнаяТаблица = Параметры.ТипРеспондента.Метаданные().ПолноеИмя();
		
	Иначе
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РеспондентыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	МассивДляПередачи = Новый Массив;
	
	Для каждого ЭлементМассива Из ВыбраннаяСтрока Цикл
		Если НЕ Элементы.Респонденты.ДанныеСтроки(ЭлементМассива).ЭтоГруппа Тогда
			МассивДляПередачи.Добавить(ЭлементМассива)
		КонецЕсли;
	КонецЦикла;
	
	ОбработатьВыборРеспондента(МассивДляПередачи);
	
КонецПроцедуры

&НаКлиенте
Процедура РеспондентыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ОбработатьВыборРеспондента(Значение);
	
КонецПроцедуры


 