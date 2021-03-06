// Обработка команды Найти
//
&НаКлиенте
Процедура ИскатьВыполнить()
	ПараметрыФормы = Новый Структура("", );
	ПараметрыФормы.Вставить("ПереданнаяСтрокаПоиска", Элементы.ПолеВводаПоиска.ТекстРедактирования);
	ОткрытьФорму("Обработка.ПоискВДанных.Форма.ФормаПоиска", ПараметрыФормы);
	
	ЗагрузитьСтрокиПоиска();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗагрузитьСтрокиПоиска();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСтрокиПоиска()
	Массив = ХранилищеОбщихНастроек.Загрузить("ПолнотекстовыйПоискСтрокиПолнотекстовогоПоиска");
	
	Если Массив <> Неопределено Тогда
		Элементы.ПолеВводаПоиска.СписокВыбора.ЗагрузитьЗначения(Массив);
	КонецЕсли;
КонецПроцедуры	

&НаКлиенте
Процедура ПолеВводаПоискаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ИскатьВыполнить();
КонецПроцедуры

&НаКлиенте
Процедура ПолеВводаПоискаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ИскатьВыполнить();
КонецПроцедуры

