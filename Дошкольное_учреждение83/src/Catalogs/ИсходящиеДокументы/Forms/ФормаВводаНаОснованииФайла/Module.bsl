
&НаКлиенте
Процедура ПолучательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДелопроизводствоКлиент.ВыбратьПолучателя(Элемент, Получатель);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Получатель = Справочники.Корреспонденты.ПустаяСсылка();
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВидыИсходящихДокументов") Тогда 
		ВидДокумента = Делопроизводство.ПолучитьВидДокументаПоУмолчанию(Справочники.ИсходящиеДокументы.ПустаяСсылка());
	КонецЕсли;	
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГрифыДоступаКВходящимИИсходящимДокументам") Тогда
		ГрифДоступа = Константы.ГрифДоступаПоУмолчанию.Получить();
	КонецЕсли;
	
	Организация = РаботаСОрганизациями.ПолучитьОрганизациюПоУмолчанию();
	
	// выбор вида документа
	БыстрыйВыборВидаДокумента = Делопроизводство.ПолучитьРежимВыборавидаДокумента("ИсходящийДокумент");
	Элементы.ВидДокумента.БыстрыйВыбор = БыстрыйВыборВидаДокумента;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("Получатель");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГрифыДоступаКВходящимИИсходящимДокументам") Тогда 
		ПроверяемыеРеквизиты.Добавить("ГрифДоступа");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВидыИсходящихДокументов") Тогда 
		ПроверяемыеРеквизиты.Добавить("ВидДокумента");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда 
		ПроверяемыеРеквизиты.Добавить("Организация");
	КонецЕсли;
	
КонецПроцедуры
