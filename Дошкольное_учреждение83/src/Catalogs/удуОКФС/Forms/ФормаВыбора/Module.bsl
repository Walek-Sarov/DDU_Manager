
&НаКлиенте
Процедура КомандаЗагрузитьКлассификатор(Команда)
	// Вставить содержимое обработчика.
	ФормаОбработки = ПолучитьФорму("Обработка.удуЗагрузкаКлассификаторов.Форма");
	ФормаОбработки.Объект.ВидКлассификатора = "ОКФС";
	ФормаОбработки.ВладелецФормы = ЭтаФорма;
	ФормаОбработки.ОткрытьМодально();		
КонецПроцедуры
