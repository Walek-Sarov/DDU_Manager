////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не АвтономнаяРаботаСлужебный.ЭтоАвтономноеРабочееМесто() Тогда
		ВызватьИсключение НСтр("ru = 'Эта информационная база не является автономным рабочим местом.'");
	КонецЕсли;
	
	ПриложениеВСервисе = АвтономнаяРаботаСлужебный.ПриложениеВСервисе();
	
	РегламентноеЗадание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(
		Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете);
	
	СинхронизироватьДанныеПоРасписанию = РегламентноеЗадание.Использование;
	РасписаниеСинхронизацииДанных      = РегламентноеЗадание.Расписание;
	
	ПриИзмененииРасписанияСинхронизацииДанных();
	
	СинхронизироватьДанныеПриНачалеРаботыПрограммы = Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриНачалеРаботыПрограммы.Получить();
	СинхронизироватьДанныеПриЗавершенииРаботыПрограммы = Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииРаботыПрограммы.Получить();
	
	АдресДляВосстановленияПароляУчетнойЗаписи = АвтономнаяРаботаСлужебный.АдресДляВосстановленияПароляУчетнойЗаписи();
	
	ОбновитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ОбновитьВидимость", 60);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВыполненОбменДанными" Тогда
		
		ОбновитьВидимость();
		
	ИначеЕсли ИмяСобытия = "Запись_НастройкиТранспортаОбмена" Тогда
		
		Если Параметр.НастройкаАвтоматическойСинхронизации
			И Параметр.WSЗапомнитьПароль Тогда
			
			СинхронизироватьДанныеПоРасписанию = Истина;
			
			СинхронизироватьДанныеПоРасписаниюПриИзмененииЗначения();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыполнитьСинхронизациюДанных(Команда)
	
	ОбменДаннымиКлиент.ВыполнитьОбменДаннымиОбработкаКоманды(ПриложениеВСервисе, ЭтаФорма,
		ПарольПользователяСохраняется, АдресДляВосстановленияПароляУчетнойЗаписи
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписаниеСинхронизацииДанных(Команда)
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеСинхронизацииДанных);
	
	Если Диалог.ОткрытьМодально() Тогда
		
		РасписаниеСинхронизацииДанных = Диалог.Расписание;
		
		ИзменитьРасписаниеСинхронизацииДанныхНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОбновление(Команда)
	
	ОткрытьФорму("Обработка.ОбновлениеКонфигурации.Форма.Форма");
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьДанныеПоРасписаниюПриИзменении(Элемент)
	
	Если СинхронизироватьДанныеПоРасписанию И Не ПарольПользователяСохраняется Тогда
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Настроить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
		
		Ответ = Вопрос(НСтр("ru = 'Для возможности автоматической синхронизации данных необходимо
						|в настройках подключения установить флаг ""Запомнить пароль"".'"),
						Кнопки,, КодВозвратаДиалога.Да
		);
		
		Если Ответ = КодВозвратаДиалога.Да Тогда
			
			НастроитьПодключениеКСервису(Истина);
			
		Иначе
			
			СинхронизироватьДанныеПоРасписанию = Ложь;
			
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	СинхронизироватьДанныеПоРасписаниюПриИзмененииЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРасписанияСинхронизацииДанныхПриИзменении(Элемент)
	
	ВариантРасписанияСинхронизацииДанныхПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьДанныеПриНачалеРаботыПрограммыПриИзменении(Элемент)
	
	УстановитьЗначениеКонстанты("СинхронизироватьДанныеСПриложениемВИнтернетеПриНачалеРаботыПрограммы",
		СинхронизироватьДанныеПриНачалеРаботыПрограммы
	);
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьДанныеПриЗавершенииРаботыПрограммыПриИзменении(Элемент)
	
	УстановитьЗначениеКонстанты("СинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииРаботыПрограммы",
		СинхронизироватьДанныеПриЗавершенииРаботыПрограммы
	);
	
	ПредлагатьСинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииСеанса = СинхронизироватьДанныеПриЗавершенииРаботыПрограммы;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПодключение(Команда)
	
	НастроитьПодключениеКСервису();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбновитьВидимость()
	
	ОбновитьВидимостьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДатаПоследнейУспешнойСинхронизации = АвтономнаяРаботаСлужебный.ДатаПоследнейУспешнойСинхронизации(ПриложениеВСервисе);
	
	Если ДатаПоследнейУспешнойСинхронизации <> Неопределено Тогда
		ЗаголовокЭлемента = НСтр("ru = 'Последняя синхронизация: [ДатаПоследнейУспешнойСинхронизации]'");
		ЗаголовокЭлемента = СтрЗаменить(ЗаголовокЭлемента, "[ДатаПоследнейУспешнойСинхронизации]", Формат(ДатаПоследнейУспешнойСинхронизации, "ДЛФ=DDT"));
	Иначе
		ЗаголовокЭлемента = НСтр("ru = 'Синхронизация данных не выполнялась.'");
	КонецЕсли;
	
	Элементы.ИнформацияОПоследнейСинхронизации.Заголовок = ЗаголовокЭлемента;
	Элементы.ИнформацияОПоследнейСинхронизации1.Заголовок = ЗаголовокЭлемента;
	
	ТребуетсяУстановкаОбновления = ОбменДаннымиСервер.ТребуетсяУстановкаОбновления();
	
	Элементы.АвтономнаяРабота.ТекущаяСтраница = ?(ТребуетсяУстановкаОбновления,
			Элементы.ПолученоОбновлениеКонфигурации,
			Элементы.СинхронизацияДанных
	);
	
	Элементы.ВыполнитьСинхронизациюДанных.КнопкаПоУмолчанию         = Не ТребуетсяУстановкаОбновления;
	Элементы.ВыполнитьСинхронизациюДанных.АктивизироватьПоУмолчанию = Не ТребуетсяУстановкаОбновления;
	
	Элементы.УстановитьОбновление.КнопкаПоУмолчанию         = ТребуетсяУстановкаОбновления;
	Элементы.УстановитьОбновление.АктивизироватьПоУмолчанию = ТребуетсяУстановкаОбновления;
	
	//
	НастройкиТранспортаWS = РегистрыСведений.НастройкиТранспортаОбмена.ПолучитьНастройкиТранспортаWS(ПриложениеВСервисе);
	ПарольПользователяСохраняется = НастройкиТранспортаWS.WSЗапомнитьПароль;
	
	РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете);
	СинхронизироватьДанныеПоРасписанию = РегламентноеЗадание.Использование;
	
КонецПроцедуры

&НаСервере
Процедура ВариантРасписанияСинхронизацииДанныхПриИзмененииНаСервере()
	
	НовоеРасписаниеСинхронизацииДанных = "";
	
	Если ВариантРасписанияСинхронизацииДанных = 1 Тогда
		
		НовоеРасписаниеСинхронизацииДанных = ПредопределенноеРасписаниеВариант1();
		
	ИначеЕсли ВариантРасписанияСинхронизацииДанных = 2 Тогда
		
		НовоеРасписаниеСинхронизацииДанных = ПредопределенноеРасписаниеВариант2();
		
	ИначеЕсли ВариантРасписанияСинхронизацииДанных = 3 Тогда
		
		НовоеРасписаниеСинхронизацииДанных = ПредопределенноеРасписаниеВариант3();
		
	Иначе // 4
		
		НовоеРасписаниеСинхронизацииДанных = ПользовательскоеРасписаниеСинхронизацииДанных;
		
	КонецЕсли;
	
	Если Строка(РасписаниеСинхронизацииДанных) <> Строка(НовоеРасписаниеСинхронизацииДанных) Тогда
		
		РасписаниеСинхронизацииДанных = НовоеРасписаниеСинхронизацииДанных;
		
		РегламентныеЗаданияСервер.УстановитьРасписаниеРегламентногоЗадания(
			Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете,
			РасписаниеСинхронизацииДанных);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРасписанияСинхронизацииДанных()
	
	Элементы.ВариантРасписанияСинхронизацииДанных.СписокВыбора.Очистить();
	Элементы.ВариантРасписанияСинхронизацииДанных.СписокВыбора.Добавить(1, НСтр("ru = 'Каждые 15 минут'"));
	Элементы.ВариантРасписанияСинхронизацииДанных.СписокВыбора.Добавить(2, НСтр("ru = 'Каждый час'"));
	Элементы.ВариантРасписанияСинхронизацииДанных.СписокВыбора.Добавить(3, НСтр("ru = 'Каждый день в 10:00, кроме сб. и вс.'"));
	
	// Определяем текущий вариант расписания синхронизации данных
	ВариантыРасписанияСинхронизацииДанных = Новый Соответствие;
	ВариантыРасписанияСинхронизацииДанных.Вставить(Строка(ПредопределенноеРасписаниеВариант1()), 1);
	ВариантыРасписанияСинхронизацииДанных.Вставить(Строка(ПредопределенноеРасписаниеВариант2()), 2);
	ВариантыРасписанияСинхронизацииДанных.Вставить(Строка(ПредопределенноеРасписаниеВариант3()), 3);
	
	ВариантРасписанияСинхронизацииДанных = ВариантыРасписанияСинхронизацииДанных[Строка(РасписаниеСинхронизацииДанных)];
	
	Если ВариантРасписанияСинхронизацииДанных = 0 Тогда
		
		ВариантРасписанияСинхронизацииДанных = 4;
		Элементы.ВариантРасписанияСинхронизацииДанных.СписокВыбора.Добавить(4, Строка(РасписаниеСинхронизацииДанных));
		ПользовательскоеРасписаниеСинхронизацииДанных = РасписаниеСинхронизацииДанных;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРасписаниеСинхронизацииДанныхНаСервере()
	
	РегламентныеЗаданияСервер.УстановитьРасписаниеРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете,
		РасписаниеСинхронизацииДанных);
	
	ПриИзмененииРасписанияСинхронизацииДанных();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьЗначениеКонстанты(Знач ИмяКонстанты, Знач Значение)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Константы[ИмяКонстанты].Установить(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПодключениеКСервису(НастройкаАвтоматическойСинхронизации = Ложь)
	
	Отбор              = Новый Структура("Узел", ПриложениеВСервисе);
	ЗначенияЗаполнения = Новый Структура("Узел", ПриложениеВСервисе);
	ПараметрыФормы     = Новый Структура;
	ПараметрыФормы.Вставить("АдресДляВосстановленияПароляУчетнойЗаписи", АдресДляВосстановленияПароляУчетнойЗаписи);
	ПараметрыФормы.Вставить("НастройкаАвтоматическойСинхронизации", НастройкаАвтоматическойСинхронизации);
	
	ОбменДаннымиКлиент.ОткрытьФормуЗаписиРегистраСведенийПоОтбору(Отбор, ЗначенияЗаполнения, "НастройкиТранспортаОбмена",
		ЭтаФорма, "НастройкаПодключенияКСервису", ПараметрыФормы
	);
	
	ОбновитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьДанныеПоРасписаниюПриИзмененииЗначения()
	
	УстановитьИспользованиеРегламентногоЗадания(СинхронизироватьДанныеПоРасписанию);
	
	Если СинхронизироватьДанныеПоРасписанию Тогда
		
		Состояние(НСтр("ru = 'Запуск отдельного сеанса для автоматического выполнения синхронизации данных.'"),,
			НСтр("ru = 'Пожалуйста, подождите...'")
		);
		ПодключитьОбработчикОжидания("ЗапуститьОтдельныйСеансДляВыполненияРегламентныхЗаданийЧерезОбработчикОжидания", 1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьИспользованиеРегламентногоЗадания(Знач СинхронизироватьДанныеПоРасписанию)
	
	РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете,
		СинхронизироватьДанныеПоРасписанию);
	
КонецПроцедуры

// Предопределенные расписания синхронизации данных

&НаСервереБезКонтекста
Функция ПредопределенноеРасписаниеВариант1() // Каждые 15 минут
	
	Месяцы = Новый Массив;
	Месяцы.Добавить(1);
	Месяцы.Добавить(2);
	Месяцы.Добавить(3);
	Месяцы.Добавить(4);
	Месяцы.Добавить(5);
	Месяцы.Добавить(6);
	Месяцы.Добавить(7);
	Месяцы.Добавить(8);
	Месяцы.Добавить(9);
	Месяцы.Добавить(10);
	Месяцы.Добавить(11);
	Месяцы.Добавить(12);
	
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	ДниНедели.Добавить(7);
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.Месяцы                   = Месяцы;
	Расписание.ДниНедели                = ДниНедели;
	Расписание.ПериодПовтораВТечениеДня = 60*15; // 15 минут
	Расписание.ПериодПовтораДней        = 1; // каждый день
	
	Возврат Расписание;
КонецФункции

&НаСервереБезКонтекста
Функция ПредопределенноеРасписаниеВариант2() // Каждый час
	
	Возврат АвтономнаяРаботаСлужебный.РасписаниеСинхронизацииДанныхПоУмолчанию();
	
КонецФункции

&НаСервереБезКонтекста
Функция ПредопределенноеРасписаниеВариант3() // Каждый день в 10:00, кроме сб. и вс.
	
	Месяцы = Новый Массив;
	Месяцы.Добавить(1);
	Месяцы.Добавить(2);
	Месяцы.Добавить(3);
	Месяцы.Добавить(4);
	Месяцы.Добавить(5);
	Месяцы.Добавить(6);
	Месяцы.Добавить(7);
	Месяцы.Добавить(8);
	Месяцы.Добавить(9);
	Месяцы.Добавить(10);
	Месяцы.Добавить(11);
	Месяцы.Добавить(12);
	
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.Месяцы            = Месяцы;
	Расписание.ДниНедели         = ДниНедели;
	Расписание.ВремяНачала       = Дата('00010101100000'); // 10:00
	Расписание.ПериодПовтораДней = 1; // каждый день
	
	Возврат Расписание;
КонецФункции
