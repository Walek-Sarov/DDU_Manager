
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
   Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда

		Значение = Неопределено;

		Если ДанныеЗаполнения.Свойство("КодЧисловой", Значение) Тогда
			Код = Значение;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("НаименованиеКраткое", Значение) Тогда
			Наименование = Значение;
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("НаименованиеПолное", Значение) Тогда
			НаименованиеПолное = Значение;
		КонецЕсли;
		
	КонецЕсли;	
	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры
