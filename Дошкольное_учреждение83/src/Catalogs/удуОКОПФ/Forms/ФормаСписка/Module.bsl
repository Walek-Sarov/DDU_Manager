
&НаКлиенте
Процедура КомандаЗагрузитьКлассификатор(Команда)
	// Вставить содержимое обработчика.
	ФормаОбработки = ПолучитьФорму("Обработка.удуЗагрузкаКлассификаторов.Форма");
	ФормаОбработки.Объект.ВидКлассификатора = "ОКОПФ";
	ФормаОбработки.ВладелецФормы = ЭтаФорма;
	ФормаОбработки.ОткрытьМодально();	
КонецПроцедуры
