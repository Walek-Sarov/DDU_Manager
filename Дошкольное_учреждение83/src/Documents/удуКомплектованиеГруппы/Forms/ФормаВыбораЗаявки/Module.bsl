&НаСервере
Процедура СформироватьСписокЗавокНаСервере()
	ТекстЗапроса = "ВЫБРАТЬ
	               |	удуЗаявкаНаЗачислениеРебенкаВДОУ.Ссылка
	               |ИЗ
	               |	Документ.удуЗаявкаНаЗачислениеРебенкаВДОУ КАК удуЗаявкаНаЗачислениеРебенкаВДОУ
	               |ГДЕ
	               |	(НЕ удуЗаявкаНаЗачислениеРебенкаВДОУ.ПометкаУдаления)
	               |	И (НЕ удуЗаявкаНаЗачислениеРебенкаВДОУ.ПризнакЗачисления)
	               |	И (НЕ удуЗаявкаНаЗачислениеРебенкаВДОУ.ПризнакОтказаВЗачислении)
	               |	И удуЗаявкаНаЗачислениеРебенкаВДОУ.Группа = &Группа
	               |	И удуЗаявкаНаЗачислениеРебенкаВДОУ.ДатаПланируемогоПоступления = &ДатаПланируемогоПоступления";
				   
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Группа", ПараметрГруппа);
	Запрос.УстановитьПараметр("ДатаПланируемогоПоступления", ПараметрПериодКомплектования);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	СписокСсылокДляОтбора = Новый СписокЗначений;
	Для Каждого СтрокаРезультат Из РезультатЗапроса Цикл
		СписокСсылокДляОтбора.Добавить(СтрокаРезультат.Ссылка);		
	КонецЦикла;
	
	ЭлементОтбораНайден = Ложь;
	
	Для Каждого СтрокаЭлемент Из СписокЗаявокНаЗачисление.Отбор.Элементы Цикл
		Если Строка(СтрокаЭлемент.ЛевоеЗначение) = "Ссылка" Тогда
			ЭлементОтбораНайден = Истина;
			СтрокаЭлемент.ПравоеЗначение = СписокСсылокДляОтбора;
		КонецЕсли;
	КонецЦикла;	
	
	Если Не ЭлементОтбораНайден Тогда
		ЭлементОтбораПоСсылке = СписокЗаявокНаЗачисление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораПоСсылке.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбораПоСсылке.Использование = Истина;
		ЭлементОтбораПоСсылке.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
		ЭлементОтбораПоСсылке.ПравоеЗначение = СписокСсылокДляОтбора;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СформироватьСписокЗавокНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНовуюЗаявку(Команда)
	ФормаВводаЗаявки = ПолучитьФорму("Документ.удуЗаявкаНаЗачислениеРебенкаВДОУ.Форма.ФормаДокумента");
	ФормаВводаЗаявки.ОткрытьМодально();
	СформироватьСписокЗавокНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗаявокНаЗачислениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(ВыбраннаяСтрока);	
КонецПроцедуры
