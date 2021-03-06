
////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Процедура СгруппироватьСписок(Список, ГруппироватьПо)
	
	РежимГруппировки = ГруппироватьПо;
	
	Список.Группировка.Элементы.Очистить();
	Если Не ПустаяСтрока(ГруппироватьПо) Тогда
		ПолеГруппировки = Список.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных(ГруппироватьПо);
		ПолеГруппировки.Использование = Истина;
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)
	
	ЭлементыОтбора = Список.Отбор.Элементы;
	
	// отправитель 
	Если Не ЗначениеЗаполнено(ПараметрыОтбора["Отправитель"]) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьОтборУСписка(Список.Отбор,
			Новый ПолеКомпоновкиДанных("Отправитель"));
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьОтборУСпискаНаРавенство(
			Список.Отбор,
			Новый ПолеКомпоновкиДанных("Отправитель"),
			ПараметрыОтбора["Отправитель"]);
	КонецЕсли;
	
	// вид документа 
	Если Не ЗначениеЗаполнено(ПараметрыОтбора["ВидДокумента"]) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьОтборУСписка(Список.Отбор,
			Новый ПолеКомпоновкиДанных("ВидДокумента"));
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьОтборУСпискаНаРавенство(
			Список.Отбор,
			Новый ПолеКомпоновкиДанных("ВидДокумента"),
			ПараметрыОтбора["ВидДокумента"]);
	КонецЕсли;
	
	// организация 
	Если Не ЗначениеЗаполнено(ПараметрыОтбора["Организация"]) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьОтборУСписка(Список.Отбор,
			Новый ПолеКомпоновкиДанных("Организация"));
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьОтборУСпискаНаРавенство(
			Список.Отбор,
			Новый ПолеКомпоновкиДанных("Организация"),
			ПараметрыОтбора["Организация"]);
	КонецЕсли;
	
	// период 
	ПериодВыборки = ПараметрыОтбора["ПериодВыборки"];
	Если ПериодВыборки <> Неопределено Тогда 
		
		ЭлементОтбораДанных = Неопределено;
		Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
			Если ЭлементОтбора.Представление = "ОтборПериод" Тогда
				ЭлементОтбораДанных = ЭлементОтбора;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ЭлементОтбораДанных = Неопределено Тогда
			ГруппаОтборПериод = ЭлементыОтбора.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ГруппаОтборПериод.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли; 
			ГруппаОтборПериод.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный; 
			ГруппаОтборПериод.Использование = Истина;
			ГруппаОтборПериод.Представление = "ОтборПериод";
		Иначе
			ГруппаОтборПериод = ЭлементОтбораДанных;
			ГруппаОтборПериод.Элементы.Очистить();
			ГруппаОтборПериод.Использование = Истина;
		КонецЕсли;	
		
		
		ГруппаДатаРегистрации = ГруппаОтборПериод.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаДатаРегистрации.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ; 
		ГруппаДатаРегистрации.Использование = Истина;
			
		Если ЗначениеЗаполнено(ПериодВыборки.ДатаНачала) Тогда 
			ЭлементОтбораДанных = ГруппаДатаРегистрации.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаРегистрации");
			ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
			ЭлементОтбораДанных.ПравоеЗначение = ПериодВыборки.ДатаНачала;
			ЭлементОтбораДанных.Использование = Истина;
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(ПериодВыборки.ДатаОкончания) Тогда 
			ЭлементОтбораДанных = ГруппаДатаРегистрации.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаРегистрации");
			ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
			ЭлементОтбораДанных.ПравоеЗначение = ПериодВыборки.ДатаОкончания;
			ЭлементОтбораДанных.Использование = Истина;
		КонецЕсли;
		
		
		ГруппаДатаСоздания = ГруппаОтборПериод.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаДатаСоздания.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ; 
		ГруппаДатаСоздания.Использование = Истина;
			
		Если ЗначениеЗаполнено(ПериодВыборки.ДатаНачала) Тогда 
			ЭлементОтбораДанных = ГруппаДатаСоздания.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаСоздания");
			ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
			ЭлементОтбораДанных.ПравоеЗначение = ПериодВыборки.ДатаНачала;
			ЭлементОтбораДанных.Использование = Истина;
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(ПериодВыборки.ДатаОкончания) Тогда 
			ЭлементОтбораДанных = ГруппаДатаСоздания.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаСоздания");
			ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
			ЭлементОтбораДанных.ПравоеЗначение = ПериодВыборки.ДатаОкончания;
			ЭлементОтбораДанных.Использование = Истина;
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор()
	
	ПараметрыОтбора = Новый Соответствие();
	Параметрыотбора.Вставить("ПериодВыборки", 	ПериодВыборки);
	ПараметрыОтбора.Вставить("Отправитель", 	Отправитель);
	ПараметрыОтбора.Вставить("ВидДокумента", 	ВидДокумента);
	ПараметрыОтбора.Вставить("Организация", 	Организация);
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БыстрыйВыборВидаДокумента = Делопроизводство.ПолучитьРежимВыборавидаДокумента("ВходящийДокумент");
	Элементы.ОтборВидДокумента.БыстрыйВыбор = БыстрыйВыборВидаДокумента;
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьОтборСписка(Список, Настройки);
	СгруппироватьСписок(Список, Настройки["РежимГруппировки"]);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура СгруппироватьПоБезГруппировки(Команда)
	
	СгруппироватьСписок(Список, "");
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоВидуДокумента(Команда)
	
	СгруппироватьСписок(Список, "ВидДокумента");
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоДелу(Команда)
	
	СгруппироватьСписок(Список, "Дело");
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоЗарегистрировал(Команда)
	
	СгруппироватьСписок(Список, "Зарегистрировал");
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоОтправителю(Команда)
	
	СгруппироватьСписок(Список, "Отправитель");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	ИспользоватьФайлыУВходящихДокументов = ДелопроизводствоКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСДокументами().ИспользоватьФайлыУВходящихДокументов;	
	Если Не ИспользоватьФайлыУВходящихДокументов Тогда
		Возврат;
	КонецЕсли;	
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") И ПараметрыПеретаскивания.Значение.ЭтоФайл() = Истина Тогда
		МассивФайлов = Новый Массив;
		МассивФайлов.Добавить(ПараметрыПеретаскивания.Значение.ПолноеИмя);
		ПараметрыОткрытияФормы = Новый Структура("МассивФайлов", МассивФайлов);
		ОткрытьФорму("Справочник.ВходящиеДокументы.ФормаОбъекта", ПараметрыОткрытияФормы);
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		
		Если ПараметрыПеретаскивания.Значение.Количество() >= 1 И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("Файл") Тогда
			
			МассивФайлов = Новый Массив;
			Для Каждого ФайлПринятый Из ПараметрыПеретаскивания.Значение Цикл
				МассивФайлов.Добавить(ФайлПринятый.ПолноеИмя);
			КонецЦикла;
			
			ПараметрыОткрытияФормы = Новый Структура("МассивФайлов", МассивФайлов);
			ОткрытьФорму("Справочник.ВходящиеДокументы.ФормаОбъекта", ПараметрыОткрытияФормы);
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтправительПриИзменении(Элемент)
	
	УстановитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидДокументаПриИзменении(Элемент)
	
	УстановитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодВыборкиПриИзменении(Элемент)
	
	УстановитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	УстановитьОтбор();
	
КонецПроцедуры
