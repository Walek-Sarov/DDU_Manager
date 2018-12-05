////////////////////////////////////////////////////////////////////////////////
// Подсистема "Напоминания пользователя".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Заполняет структуру параметров, необходимых для работы клиентского кода
// при запуске конфигурации. 
//
// Параметры:
//   Параметры - Структура - структура параметров запуска.
//
Процедура ДобавитьПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Параметры.Вставить("НастройкиНапоминаний", 
		Новый ФиксированнаяСтруктура(НапоминанияПользователяСервер.ПолучитьНастройкиНапоминаний()));
			
КонецПроцедуры

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации. 
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ДобавитьПараметрыРаботыКлиента(Параметры) Экспорт
	
	Параметры.Вставить("НастройкиНапоминаний", 
		Новый ФиксированнаяСтруктура(НапоминанияПользователяСервер.ПолучитьНастройкиНапоминаний()));
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает структуру настроек напоминаний пользователя
Функция ПолучитьНастройкиНапоминаний() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьНапоминания", ЕстьПравоИспользованияНапоминаний() и ПолучитьФункциональнуюОпцию("ИспользоватьНапоминанияПользователя"));
	Результат.Вставить("ИнтервалПроверкиНапоминаний", ПолучитьИнтервалПроверкиНапоминаний());
	
	Возврат Результат;
	
КонецФункции

// Проверяет наличие права изменения РС НапоминанияПользователя.
//
// Возвращаемое значение:
//  Булево - Истина, если право есть.
Функция ЕстьПравоИспользованияНапоминаний()
	Возврат ПравоДоступа("Изменение", Метаданные.РегистрыСведений.НапоминанияПользователя); 
КонецФункции

// Возвращает ближайшую дату по расписанию относительно даты, переданной в параметре
//
// Параметры
//  Расписание - РасписаниеРегламентногоЗадания - любое расписание
//  ПредыдущаяДата - Дата - дата предыдущего события по расписанию
//
// Возвращаемое значение:
//   Дата - дата и время следующего события по расписанию
//
Функция ПолучитьБлижайшуюДатуСобытияПоРасписанию(Расписание, ПредыдущаяДата = '000101010000') Экспорт

	Результат = Неопределено;
	
	ДатаОтсчета = ПредыдущаяДата;
	Если Не ЗначениеЗаполнено(ДатаОтсчета) Тогда
		ДатаОтсчета = ТекущаяДатаСеанса();
	КонецЕсли;

	Календарь = ПолучитьКалендарьНаБудущее(365*4+1, ДатаОтсчета, Расписание.ДатаНачала, Расписание.ПериодПовтораДней, Расписание.ПериодНедель);
	
	ДниНедели = Расписание.ДниНедели;
	Если ДниНедели.Количество() = 0 Тогда
		ДниНедели = Новый Массив;
		Для День = 1 по 7 Цикл
			ДниНедели.Добавить(День);
		КонецЦикла;
	КонецЕсли;
	
	Месяцы = Расписание.Месяцы;
	Если Месяцы.Количество() = 0 Тогда
		Месяцы = Новый Массив;
		Для Месяц = 1 по 12 цикл
			Месяцы.Добавить(Месяц);
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = "ВЫБРАТЬ * ПОМЕСТИТЬ Календарь Из &Календарь как Календарь";
	Запрос.УстановитьПараметр("Календарь", Календарь);
	Запрос.Выполнить();
	
	Запрос.УстановитьПараметр("ДатаНачала",			Расписание.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаКонца",			Расписание.ДатаКонца);
	Запрос.УстановитьПараметр("ДниНедели",			ДниНедели);
	Запрос.УстановитьПараметр("Месяцы",				Месяцы);
	Запрос.УстановитьПараметр("ДеньВМесяце",		Расписание.ДеньВМесяце);
	Запрос.УстановитьПараметр("ДеньНеделиВМесяце",	Расписание.ДеньНеделиВМесяце);
	Запрос.УстановитьПараметр("ПериодПовтораДней",	?(Расписание.ПериодПовтораДней = 0,1,Расписание.ПериодПовтораДней));
	Запрос.УстановитьПараметр("ПериодНедель",		?(Расписание.ПериодНедель = 0,1,Расписание.ПериодНедель));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Календарь.Дата,
	|	Календарь.НомерМесяца,
	|	Календарь.НомерДняНеделиВМесяце,
	|	Календарь.НомерДняНеделиСКонцаМесяца,
	|	Календарь.НомерДняВМесяце,
	|	Календарь.НомерДняВМесяцеСКонцаМесяца,
	|	Календарь.НомерДняВНеделе,
	|	Календарь.НомерДняВПериоде,
	|	Календарь.НомерНеделиВПериоде
	|ИЗ
	|	Календарь КАК Календарь
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ДатаНачала = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ Календарь.Дата >= &ДатаНачала
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ДатаКонца = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ Календарь.Дата <= &ДатаКонца
	|		КОНЕЦ
	|	И Календарь.НомерДняВНеделе В(&ДниНедели)
	|	И Календарь.НомерМесяца В(&Месяцы)
	|	И ВЫБОР
	|			КОГДА &ДеньВМесяце = 0
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ВЫБОР
	|					КОГДА &ДеньВМесяце > 0
	|						ТОГДА Календарь.НомерДняВМесяце = &ДеньВМесяце
	|					ИНАЧЕ Календарь.НомерДняВМесяцеСКонцаМесяца = -&ДеньВМесяце
	|				КОНЕЦ
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ДеньНеделиВМесяце = 0
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ВЫБОР
	|					КОГДА &ДеньНеделиВМесяце > 0
	|						ТОГДА Календарь.НомерДняНеделиВМесяце = &ДеньНеделиВМесяце
	|					ИНАЧЕ Календарь.НомерДняНеделиСКонцаМесяца = -&ДеньНеделиВМесяце
	|				КОНЕЦ
	|		КОНЕЦ
	|	И Календарь.НомерДняВПериоде = &ПериодПовтораДней
	|	И Календарь.НомерНеделиВПериоде = &ПериодНедель";

	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		БлижайшаяДата = Выборка.Дата;
		
		ВремяОтсчета = '00010101';
		Если НачалоДня(БлижайшаяДата) = НачалоДня(ТекущаяДатаСеанса()) Тогда
			ВремяОтсчета = ВремяОтсчета + (ТекущаяДатаСеанса()-НачалоДня(ТекущаяДатаСеанса()));
		КонецЕсли;
		
		БлижайшееВремя = ПолучитьБлижайшееВремяИзРасписания(Расписание, ВремяОтсчета);
		Если БлижайшееВремя <> Неопределено Тогда
			Результат = БлижайшаяДата + (БлижайшееВремя - '00010101');
		Иначе
			Если Выборка.Следующий() Тогда
				Время = ПолучитьБлижайшееВремяИзРасписания(Расписание);
				Результат = Выборка.Дата + (Время - '00010101');
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ПолучитьСледующуюДатуСобытияПоРасписанию()

Функция ПолучитьКалендарьНаБудущее(КоличествоДнейКалендаря, ДатаОтсчета, Знач ДатаНачалаПериодичности = Неопределено, Знач ПериодДней = 1, Знач ПериодНедель = 1) 
	
	Если ПериодНедель = 0 Тогда 
		ПериодНедель = 1;
	КонецЕсли;
	
	Если ПериодДней = 0 Тогда
		ПериодДней = 1;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаНачалаПериодичности) Тогда
		ДатаНачалаПериодичности = ДатаОтсчета;
	КонецЕсли;
	
	Календарь = Новый ТаблицаЗначений;
	Календарь.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты()));
	Календарь.Колонки.Добавить("НомерМесяца", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(2,0,ДопустимыйЗнак.Неотрицательный)));
	Календарь.Колонки.Добавить("НомерДняНеделиВМесяце", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(1,0,ДопустимыйЗнак.Неотрицательный)));
	Календарь.Колонки.Добавить("НомерДняНеделиСКонцаМесяца", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(1,0,ДопустимыйЗнак.Неотрицательный)));
	Календарь.Колонки.Добавить("НомерДняВМесяце", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(2,0,ДопустимыйЗнак.Неотрицательный)));
	Календарь.Колонки.Добавить("НомерДняВМесяцеСКонцаМесяца", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(2,0,ДопустимыйЗнак.Неотрицательный)));
	Календарь.Колонки.Добавить("НомерДняВНеделе", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(2,0,ДопустимыйЗнак.Неотрицательный)));	
	Календарь.Колонки.Добавить("НомерДняВПериоде", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(3,0,ДопустимыйЗнак.Неотрицательный)));	
	Календарь.Колонки.Добавить("НомерНеделиВПериоде", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(3,0,ДопустимыйЗнак.Неотрицательный)));
	
	Дата = НачалоДня(ДатаОтсчета);
	ДатаНачалаПериодичности = НачалоДня(ДатаНачалаПериодичности);
	НомерДняВПериоде = 0;
	НомерНеделиВПериоде = 0;
	
	Если ДатаНачалаПериодичности <= Дата Тогда
		КоличествоДней = (Дата - ДатаНачалаПериодичности)/60/60/24;
		НомерДняВПериоде = КоличествоДней - Цел(КоличествоДней/ПериодДней)*ПериодДней;
		
		КоличествоНедель = Цел(КоличествоДней / 7);
		НомерНеделиВПериоде = КоличествоНедель - Цел(КоличествоНедель/ПериодНедель)*ПериодНедель;
	КонецЕсли;
	
	Если НомерДняВПериоде = 0 Тогда 
		НомерДняВПериоде = ПериодДней;
	КонецЕсли;
	
	Если НомерНеделиВПериоде = 0 Тогда 
		НомерНеделиВПериоде = ПериодНедель;
	КонецЕсли;
	
	Для Счетчик = 0 По КоличествоДнейКалендаря - 1 Цикл
		
		Дата = НачалоДня(ДатаОтсчета) + Счетчик * 60*60*24;
		НоваяСтрока = Календарь.Добавить();
		НоваяСтрока.Дата = Дата;
		НоваяСтрока.НомерМесяца = Месяц(Дата);
		НоваяСтрока.НомерДняНеделиВМесяце = Цел((Дата - НачалоМесяца(Дата))/60/60/24/7) + 1;
		НоваяСтрока.НомерДняНеделиСКонцаМесяца = Цел((КонецМесяца(НачалоДня(Дата)) - Дата)/60/60/24/7) + 1;
		НоваяСтрока.НомерДняВМесяце = День(Дата);
		НоваяСтрока.НомерДняВМесяцеСКонцаМесяца = День(КонецМесяца(НачалоДня(Дата))) - День(Дата) + 1;
		НоваяСтрока.НомерДняВНеделе = ДеньНедели(Дата);
		
		Если ДатаНачалаПериодичности <= Дата Тогда
			НоваяСтрока.НомерДняВПериоде = НомерДняВПериоде;
			НоваяСтрока.НомерНеделиВПериоде = НомерНеделиВПериоде;
			
			НомерДняВПериоде = ?(НомерДняВПериоде+1 > ПериодДней, 1, НомерДняВПериоде+1);
			
			Если НоваяСтрока.НомерДняВНеделе = 1 Тогда
				НомерНеделиВПериоде = ?(НомерНеделиВПериоде+1 > ПериодНедель, 1, НомерНеделиВПериоде+1);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Календарь;
	
КонецФункции

Функция ПолучитьБлижайшееВремяИзРасписания(Расписание, Знач ВремяОтсчета = '000101010000')
	
	Результат = Неопределено;
	
	СписокЗначений = Новый СписокЗначений;
	
	Если Расписание.ДетальныеРасписанияДня.Количество() = 0 Тогда
		СписокЗначений.Добавить(Расписание.ВремяНачала);
	Иначе
		Для Каждого РасписаниеДня Из Расписание.ДетальныеРасписанияДня Цикл
			СписокЗначений.Добавить(РасписаниеДня.ВремяНачала);
		КонецЦикла;
	КонецЕсли;
	
	СписокЗначений.СортироватьПоЗначению(НаправлениеСортировки.Возр);
	
	Для Каждого ВремяДня Из СписокЗначений Цикл
		Если ВремяОтсчета <= ВремяДня.Значение Тогда
			Результат = ВремяДня.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает интервал времени в минутах, через который необходимо повторять проверку текущих напоминаний.
Функция ПолучитьИнтервалПроверкиНапоминаний(Пользователь = Неопределено) Экспорт
	Интервал = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
									"НастройкиНапоминаний", 
									"ИнтервалПроверкиНапоминаний", 
									1,
									,
									ПолучитьИмяПользователяИБ(Пользователь)
								);
	Возврат Макс(Интервал, 1);
КонецФункции

// Конвертирует таблицу в массив структур.
//
// Параметры
//  ТаблицаЗначений - произвольная таблица значений, у которой есть имена колонок.
//
// Возвращаемое значение
//  Массив - массив структур, содержащих значения строк таблицы
Функция ПолучитьМассивСтруктурИзТаблицы(ТаблицаЗначений) Экспорт
	Результат = Новый Массив;
	Для Каждого Строка Из ТаблицаЗначений Цикл
		СтруктураСтроки = Новый Структура;
		Для Каждого Колонка из ТаблицаЗначений.Колонки Цикл
			СтруктураСтроки.Вставить(Колонка.Имя, Строка[Колонка.Имя]);
		КонецЦикла;
		Результат.Добавить(СтруктураСтроки);
	КонецЦикла;
	Возврат Результат;			
КонецФункции

Функция ПолучитьИмяПользователяИБ(Пользователь)
	Если Не ЗначениеЗаполнено(Пользователь) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ОбщегоНазначения.ПолучитьЗначениеРеквизита(Пользователь, "ИдентификаторПользователяИБ"));
	Если ПользовательИБ = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПользовательИБ.Имя;
КонецФункции

// Получает значение реквизита для любого объекта ссылочного типа
Функция ПолучитьЗначениеРеквизитаПредмета(СсылкаНаПредмет, ИмяРеквизита) Экспорт
	
	Результат = Неопределено;
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса =
	"ВЫБРАТЬ 
	|	Таблица.&Реквизит КАК Реквизит
	|ИЗ
	|	&ИмяТаблицы КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка = &Ссылка";

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяТаблицы", СсылкаНаПредмет.Метаданные().ПолноеИмя());
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Реквизит", ИмяРеквизита);
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаПредмет);

	Результат = Запрос.Выполнить();

	Выборка = Результат.Выбрать();

	Если Выборка.Следующий() Тогда
		Результат = Выборка.Реквизит;
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

// Проверяет изменения реквизитов предметов, на которые есть пользовательская подписка,
// изменяет срок оповещения в случае необходимости.
Процедура ПроверитьИзмененияДатВПредмете(Предмет) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Напоминания.Пользователь,
	|	Напоминания.ВремяСобытия,
	|	Напоминания.Источник,
	|	Напоминания.СрокНапоминания,
	|	Напоминания.Описание,
	|	Напоминания.СпособУстановкиВремениНапоминания,
	|	Напоминания.ИнтервалВремениНапоминания,
	|	Напоминания.ИмяРеквизитаИсточника,
	|	Напоминания.Расписание
	|ИЗ
	|	РегистрСведений.НапоминанияПользователя КАК Напоминания
	|ГДЕ
	|	Напоминания.СпособУстановкиВремениНапоминания = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета)
	|	И Напоминания.Источник = &Источник";
	
	Запрос.УстановитьПараметр("Источник", Предмет);
	
	ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаТаблицы Из ТаблицаРезультата Цикл
		ДатаПредмета = ПолучитьЗначениеРеквизитаПредмета(СтрокаТаблицы.Источник, СтрокаТаблицы.ИмяРеквизитаИсточника);
		Если (ДатаПредмета - СтрокаТаблицы.ИнтервалВремениНапоминания) <> СтрокаТаблицы.ВремяСобытия Тогда
			НапоминанияПользователяВызовСервера.ОтключитьНапоминание(СтрокаТаблицы);
			СтрокаТаблицы.СрокНапоминания = ДатаПредмета - СтрокаТаблицы.ИнтервалВремениНапоминания;
			СтрокаТаблицы.ВремяСобытия = ДатаПредмета;
			НапоминанияПользователяВызовСервера.ПодключитьНапоминание(СтрокаТаблицы);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ПроверитьИзмененияДатВПредметеПриЗаписи(Источник, Отказ) Экспорт
	Если Источник.ОбменДанными.Загрузка Тогда 
		Возврат; 
	КонецЕсли;	
	ПроверитьИзмененияДатВПредмете(Источник.Ссылка);
КонецПроцедуры

