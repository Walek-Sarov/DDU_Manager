////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПолеHTMLДокумента = АвтономнаяРаботаСлужебный.ТекстИнструкцииИзМакета(Параметры.ИмяМакета);
	
	Заголовок = Параметры.Заголовок;
	
КонецПроцедуры
