
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)
	
	ЭлементыОтбора = Список.Отбор.Элементы;
	
	// наименование
	Если Не ЗначениеЗаполнено(ПараметрыОтбора["Наименование"]) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьОтборУСписка(Список.Отбор,
			Новый ПолеКомпоновкиДанных("Наименование"));
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьОтборУСпискаНаСодержит(
			Список.Отбор,
			Новый ПолеКомпоновкиДанных("Наименование"),
			ПараметрыОтбора["Наименование"]);
	КонецЕсли;
		
	// автор
	Если Не ЗначениеЗаполнено(ПараметрыОтбора["Автор"]) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьОтборУСписка(Список.Отбор,
			Новый ПолеКомпоновкиДанных("АвторПредставление"));
	Иначе
		Если Тип("СправочникСсылка.удуАвторы") = ТипЗнч(ПараметрыОтбора["Автор"]) Тогда
			ОтборПоАвтору = ПараметрыОтбора["Автор"].ПолучитьОбъект().Наименование;
		Иначе 
			ОтборПоАвтору = ПараметрыОтбора["Автор"];
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьОтборУСпискаНаСодержит(
			Список.Отбор,
			Новый ПолеКомпоновкиДанных("АвторПредставление"),
			ОтборПоАвтору);
	КонецЕсли;	
	
	// направление
	Если Не ЗначениеЗаполнено(ПараметрыОтбора["Направление"]) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьОтборУСписка(Список.Отбор,
			Новый ПолеКомпоновкиДанных("НаправлениеДеятельностиДОУ"));
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьОтборУСпискаНаРавенство(
			Список.Отбор,
			Новый ПолеКомпоновкиДанных("НаправлениеДеятельностиДОУ"),
			ПараметрыОтбора["Направление"]);
		КонецЕсли;
		
	// вид материала
	Если Не ЗначениеЗаполнено(ПараметрыОтбора["ВидМатериала"]) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьОтборУСписка(Список.Отбор,
			Новый ПолеКомпоновкиДанных("ВидМатериала"));
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьОтборУСпискаНаРавенство(
			Список.Отбор,
			Новый ПолеКомпоновкиДанных("ВидМатериала"),
			ПараметрыОтбора["ВидМатериала"]);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор()
	
	ПараметрыОтбора = Новый Соответствие();
	Параметрыотбора.Вставить("Наименование",ОтборНаименование);
	ПараметрыОтбора.Вставить("Автор", 	ОтборАвтор);
	ПараметрыОтбора.Вставить("Направление",	ОтборНаправление);
	ПараметрыОтбора.Вставить("ВидМатериала", Параметры.ВидМатериала);
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНаименованиеПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ОтборАвторПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ОтборНаправлениеПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Параметры.ВидМатериала) Тогда
		УстановитьОтбор();
	КонецЕсли;
	
КонецПроцедуры

