
&НаКлиенте
Процедура КомандаЗагрузитьКлассификатор(Команда)
	// Вставить содержимое обработчика.
	ФормаОбработки = ПолучитьФорму("Обработка.удуЗагрузкаКлассификаторов.Форма");
	ФормаОбработки.Объект.ВидКлассификатора = "ОКВЭД";
	ФормаОбработки.ВладелецФормы = ЭтаФорма;
	ФормаОбработки.ОткрытьМодально();		
КонецПроцедуры
