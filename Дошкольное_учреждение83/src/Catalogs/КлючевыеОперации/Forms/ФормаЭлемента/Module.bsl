
///////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка = ОценкаПроизводительностиВызовСервераПолныеПрава.ПолучитьПредопределенный() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры


