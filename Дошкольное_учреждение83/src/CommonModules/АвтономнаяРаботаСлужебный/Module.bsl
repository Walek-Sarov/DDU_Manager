////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными в модели сервиса".
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Переопределяет действие перед авторизацией пользователя,
// выполняемой при начале работы системы (в процессе получения
// параметров работы клиента при запуске).
//
// Можно заполнить состав пользователей и выполнить перезапуск.
// 
// Требуется, например, при настройке автономного рабочего места.
// 
// Параметры:
//  Перезапустить - Булево, начальное значение Ложь. Если указать
//                  Истина, тогда работа системы будет прекращена.
//
Процедура ПередАвторизациейТекущегоПользователяПриНачалеРаботыСистемы(Перезапустить) Экспорт
	
	Если НеобходимоВыполнитьНастройкуАвтономногоРабочегоМестаПриПервомЗапуске() Тогда
		ВыполнитьНастройкуАвтономногоРабочегоМестаПриПервомЗапуске();
		Перезапустить = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ, ИСПОЛЬЗУЕМЫЕ НА СТОРОНЕ СЕРВИСА

Процедура СоздатьНачальныйОбразАвтономногоРабочегоМеста(Параметры,
			АдресВременногоХранилищаНачальногоОбраза,
			АдресВременногоХранилищаИнформацииОПакетеУстановки
	) Экспорт
	
	ПомощникСозданияАвтономногоРабочегоМеста = Обработки.ПомощникСозданияАвтономногоРабочегоМеста.Создать();
	
	ЗаполнитьЗначенияСвойств(ПомощникСозданияАвтономногоРабочегоМеста, Параметры);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПомощникСозданияАвтономногоРабочегоМеста.СоздатьНачальныйОбразАвтономногоРабочегоМеста(
				Параметры.НастройкаОтборовНаУзле,
				АдресВременногоХранилищаНачальногоОбраза,
				АдресВременногоХранилищаИнформацииОПакетеУстановки
	);
	
КонецПроцедуры

Процедура УдалитьАвтономноеРабочееМесто(Параметры, АдресХранилища) Экспорт
	
	ОбменДаннымиСервер.ПроверитьВозможностьАдминистрированияОбменов();
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		Пользователь = РегистрыСведений.ОбщиеНастройкиУзловИнформационныхБаз.ПользовательДляСинхронизацииДанных(Параметры.АвтономноеРабочееМесто);
		
		Если Пользователь <> Неопределено Тогда
			
			ПользовательОбъект = Пользователь.ПолучитьОбъект();
			
			Если ПользовательОбъект <> Неопределено Тогда
				
				ПользовательОбъект.Удалить();
				
			КонецЕсли;
			
		КонецЕсли;
		
		АвтономноеРабочееМестоОбъект = Параметры.АвтономноеРабочееМесто.ПолучитьОбъект();
		
		Если АвтономноеРабочееМестоОбъект <> Неопределено Тогда
			
			АвтономноеРабочееМестоОбъект.Удалить();
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Функция АвтономнаяРаботаПоддерживается() Экспорт
	
	Возврат ОбменДаннымиПовтИсп.АвтономнаяРаботаПоддерживается();
	
КонецФункции

Функция КоличествоАвтономныхРабочихМест() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	ПланОбмена.[ИмяПланаОбмена] КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка <> &ПриложениеВСервисе
	|	И НЕ Таблица.ПометкаУдаления";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ИмяПланаОбмена]", ПланОбменаАвтономнойРаботы());
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПриложениеВСервисе", ПриложениеВСервисе());
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Количество;
КонецФункции

Функция ПриложениеВСервисе() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		
		Возврат ПланыОбмена.ГлавныйУзел();
		
	Иначе
		
		Возврат ПланыОбмена[ПланОбменаАвтономнойРаботы()].ЭтотУзел();
		
	КонецЕсли;
	
КонецФункции

Функция АвтономноеРабочееМесто() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Таблица.Ссылка КАК АвтономноеРабочееМесто
	|ИЗ
	|	ПланОбмена.[ИмяПланаОбмена] КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка <> &ПриложениеВСервисе
	|	И НЕ Таблица.ПометкаУдаления";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ИмяПланаОбмена]", ПланОбменаАвтономнойРаботы());
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПриложениеВСервисе", ПриложениеВСервисе());
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.АвтономноеРабочееМесто;
КонецФункции

Функция ПланОбменаАвтономнойРаботы() Экспорт
	
	Возврат ОбменДаннымиПовтИсп.ПланОбменаАвтономнойРаботы();
	
КонецФункции

Функция ЭтоУзелАвтономногоРабочегоМеста(Знач УзелИнформационнойБазы) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиПовтИсп.ЭтоУзелАвтономногоРабочегоМеста(УзелИнформационнойБазы);
	
КонецФункции

Функция ДатаПоследнейУспешнойСинхронизации(АвтономноеРабочееМесто) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	МИНИМУМ(СостоянияУспешныхОбменовДанными.ДатаОкончания) КАК ДатаСинхронизации
	|ИЗ
	|	РегистрСведений.СостоянияУспешныхОбменовДанными КАК СостоянияУспешныхОбменовДанными
	|ГДЕ
	|	СостоянияУспешныхОбменовДанными.УзелИнформационнойБазы = &АвтономноеРабочееМесто";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("АвтономноеРабочееМесто", АвтономноеРабочееМесто);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат ?(ЗначениеЗаполнено(Выборка.ДатаСинхронизации), Выборка.ДатаСинхронизации, Неопределено);
КонецФункции

Функция СформироватьНаименованиеАвтономногоРабочегоМестаПоУмолчанию() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	ПланОбмена.[ИмяПланаОбмена] КАК Таблица
	|ГДЕ
	|	Таблица.Наименование ПОДОБНО &ШаблонИмени";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ИмяПланаОбмена]", ПланОбменаАвтономнойРаботы());
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ШаблонИмени", НаименованиеАвтономногоРабочегоМестаПоУмолчанию() + "%");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Количество = Выборка.Количество;
	
	Если Количество = 0 Тогда
		
		Возврат НаименованиеАвтономногоРабочегоМестаПоУмолчанию();
		
	Иначе
		
		Результат = "[Наименование] ([Количество])";
		Результат = СтрЗаменить(Результат, "[Наименование]", НаименованиеАвтономногоРабочегоМестаПоУмолчанию());
		Результат = СтрЗаменить(Результат, "[Количество]", Формат(Количество + 1, "ЧГ=0"));
		
		Возврат Результат;
	КонецЕсли;
	
КонецФункции

Функция СформироватьПрефиксАвтономногоРабочегоМеста(Знач ПоследнийПрефикс = "") Экспорт
	
	ДопустимыеСимволы = ДопустимыеСимволыПрефиксаАвтономногоРабочегоМеста();
	
	СимволПоследнегоАвтономногоРабочегоМеста = Лев(ПоследнийПрефикс, 1);
	
	ПозицияСимвола = Найти(ДопустимыеСимволы, СимволПоследнегоАвтономногоРабочегоМеста);
	
	Если ПозицияСимвола = 0 ИЛИ ПустаяСтрока(СимволПоследнегоАвтономногоРабочегоМеста) Тогда
		
		Символ = Лев(ДопустимыеСимволы, 1); // Используем первый символ
		
	ИначеЕсли ПозицияСимвола >= СтрДлина(ДопустимыеСимволы) Тогда
		
		Символ = Прав(ДопустимыеСимволы, 1); // Используем последний символ
		
	Иначе
		
		Символ = Сред(ДопустимыеСимволы, ПозицияСимвола + 1, 1); // Используем следующий символ
		
	КонецЕсли;
	
	ПрефиксПриложения = Прав(ПолучитьФункциональнуюОпцию("ПрефиксИнформационнойБазы"), 1);
	
	Результат = "[Символ][ПрефиксПриложения]";
	Результат = СтрЗаменить(Результат, "[Символ]", Символ);
	Результат = СтрЗаменить(Результат, "[ПрефиксПриложения]", ПрефиксПриложения);
	
	Возврат Результат;
КонецФункции

Функция ИмяФайлаПакетаУстановки() Экспорт
	
	Возврат НСтр("ru = 'Автономная работа.zip'");
	
КонецФункции

Функция ОписаниеОграниченийПередачиДанных(АвтономноеРабочееМесто) Экспорт
	
	ПланОбменаАвтономнойРаботы = ПланОбменаАвтономнойРаботы();
	
	НастройкаОтборовНаУзле = ПланыОбмена[ПланОбменаАвтономнойРаботы].НастройкаОтборовНаУзле();
	
	Если НастройкаОтборовНаУзле = Неопределено
		ИЛИ НастройкаОтборовНаУзле.Количество() = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	Реквизиты = Новый Массив;
	
	Для Каждого Элемент Из НастройкаОтборовНаУзле Цикл
		
		Реквизиты.Добавить(Элемент.Ключ);
		
	КонецЦикла;
	
	Реквизиты = СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(Реквизиты);
	
	ЗначенияРеквизитов = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(АвтономноеРабочееМесто, Реквизиты);
	
	Для Каждого Элемент Из НастройкаОтборовНаУзле Цикл
		
		Если ТипЗнч(Элемент.Значение) = Тип("Структура") Тогда
			
			Таблица = ЗначенияРеквизитов[Элемент.Ключ].Выгрузить();
			
			Для Каждого ВложенныйЭлемент Из Элемент.Значение Цикл
				
				НастройкаОтборовНаУзле[Элемент.Ключ][ВложенныйЭлемент.Ключ] = Таблица.ВыгрузитьКолонку(ВложенныйЭлемент.Ключ);
				
			КонецЦикла;
			
		Иначе
			
			НастройкаОтборовНаУзле[Элемент.Ключ] = ЗначенияРеквизитов[Элемент.Ключ];
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПланыОбмена[ПланОбменаАвтономнойРаботы].ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле);
КонецФункции

Функция МониторАвтономныхРабочихМест() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	СостоянияУспешныхОбменовДанными.УзелИнформационнойБазы КАК АвтономноеРабочееМесто,
	|	МИНИМУМ(СостоянияУспешныхОбменовДанными.ДатаОкончания) КАК ДатаСинхронизации
	|ПОМЕСТИТЬ СостоянияУспешныхОбменовДанными
	|ИЗ
	|	РегистрСведений.СостоянияУспешныхОбменовДанными КАК СостоянияУспешныхОбменовДанными
	|
	|СГРУППИРОВАТЬ ПО
	|	СостоянияУспешныхОбменовДанными.УзелИнформационнойБазы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПланОбмена.Ссылка КАК АвтономноеРабочееМесто,
	|	ЕСТЬNULL(СостоянияУспешныхОбменовДанными.ДатаСинхронизации, &ПредставлениеПустойДаты) КАК ДатаСинхронизации
	|ИЗ
	|	ПланОбмена.[ИмяПланаОбмена] КАК ПланОбмена
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ СостоянияУспешныхОбменовДанными КАК СостоянияУспешныхОбменовДанными
	|	ПО ПланОбмена.Ссылка = СостоянияУспешныхОбменовДанными.АвтономноеРабочееМесто
	|
	|ГДЕ
	|	ПланОбмена.Ссылка <> &ПриложениеВСервисе
	|	И НЕ ПланОбмена.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПланОбмена.Представление";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ИмяПланаОбмена]", ПланОбменаАвтономнойРаботы());
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПриложениеВСервисе", ПриложениеВСервисе());
	Запрос.УстановитьПараметр("ПредставлениеПустойДаты", НСтр("ru = 'Синхронизация не выполнялась'"));
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

Функция СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста() Экспорт
	
	Возврат НСтр("ru = 'Автономная работа.Создание автономного рабочего места'");
	
КонецФункции

Функция СобытиеЖурналаРегистрацииУдалениеАвтономногоРабочегоМеста() Экспорт
	
	Возврат НСтр("ru = 'Автономная работа.Удаление автономного рабочего места'");
	
КонецФункции

Функция ТекстИнструкцииИзМакета(Знач ИмяМакета) Экспорт
	
	Результат = Обработки.ПомощникСозданияАвтономногоРабочегоМеста.ПолучитьМакет(ИмяМакета).ПолучитьТекст();
	Результат = СтрЗаменить(Результат, "[НазваниеПрограммы]", Метаданные.Синоним);
	Результат = СтрЗаменить(Результат, "[ВерсияПлатформы]", ОбменДаннымиВМоделиСервиса.ТребуемаяВерсияПлатформы());
	Возврат Результат;
КонецФункции

Функция ЗаменитьНедопустимыеСимволыВИмениПользователя(Знач Значение, Знач СимволЗамены = "_") Экспорт
	
	НедопустимыеСимволы = ОбменДаннымиКлиентСервер.НедопустимыеСимволыВИмениПользователяWSПрокси();
	
	Для Индекс = 1 По СтрДлина(НедопустимыеСимволы) Цикл
		
		НедопустимыйСимвол = Сред(НедопустимыеСимволы, Индекс, 1);
		
		Значение = СтрЗаменить(Значение, НедопустимыйСимвол, СимволЗамены);
		
	КонецЦикла;
	
	Возврат Значение;
КонецФункции

Функция ДобавитьКлассОшибки(Знач ПредставлениеОшибки, Знач Класс) Экспорт
	
	Возврат Класс + ПредставлениеОшибки;
	
КонецФункции

Функция УдалитьКлассОшибки(Знач ПредставлениеОшибки, Знач Класс) Экспорт
	
	Возврат СтрЗаменить(ПредставлениеОшибки, Класс, "");
	
КонецФункции

Функция КлассОшибкиСозданиеСлужебногоПользователя() Экспорт
	
	Возврат "#SA_CreateUser#";
	
КонецФункции

//

Функция НаименованиеАвтономногоРабочегоМестаПоУмолчанию()
	
	Результат = НСтр("ru = 'Автономная работа - %1'");
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Результат, ПолноеИмяПользователя());
КонецФункции

Функция ДопустимыеСимволыПрефиксаАвтономногоРабочегоМеста()
	
	Возврат НСтр("ru = 'АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЭЮЯабвгдежзиклмнопрстуфхцчшэюя'"); // 54 символа
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ, ИСПОЛЬЗУЕМЫЕ НА СТОРОНЕ АВТОНОМНОГО РАБОЧЕГО МЕСТА

Процедура СинхронизироватьДанныеСПриложениемВИнтернете() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЭтоАвтономноеРабочееМесто() Тогда
		
		ПодробноеПредставлениеОшибки =
			НСтр("ru = 'Эта информационная база не является автономным рабочим местом. Синхронизация данных отменена.'")
		;
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииСинхронизацияДанных(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки
		);
		ВызватьИсключение ПодробноеПредставлениеОшибки;
	КонецЕсли;
	
	Отказ = Ложь;
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(Отказ, ПриложениеВСервисе(), Истина, Истина,
		Перечисления.ВидыТранспортаСообщенийОбмена.WS
	);
	
	Если Отказ Тогда
		ВызватьИсключение НСтр("ru = 'В процессе синхронизации данных с приложением в Интернете возникли ошибки (см. журнал регистрации).'");
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьНастройкуАвтономногоРабочегоМестаПриПервомЗапуске() Экспорт
	
	Если Не ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ВызватьИсключение НСтр("ru = 'Первый запуск автономного рабочего места должен выполняться
								|в файловом режиме работы информационной базы.'"
		);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗагрузитьДанныеНачальногоОбраза();
	
	ЗагрузитьПараметрыИзНачальногоОбраза();
	
КонецПроцедуры

Процедура ОтключитьАвтоматическуюСинхронизациюДанныхСПриложениемВИнтернете() Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
			Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете, Ложь
		);
	
	КонецЕсли;
	
КонецПроцедуры

Функция НеобходимоВыполнитьНастройкуАвтономногоРабочегоМестаПриПервомЗапуске() Экспорт
	
	Возврат ЭтоАвтономноеРабочееМесто()
		И Не Константы.НастройкаАвтономногоРабочегоМестаЗавершена.Получить()
	;
КонецФункции

Функция СинхронизироватьДанныеСПриложениемВИнтернетеПриНачалеРаботы() Экспорт
	
	Возврат ЭтоАвтономноеРабочееМесто()
		И Константы.НастройкаПодчиненногоУзлаРИБЗавершена.Получить()
		И Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриНачалеРаботыПрограммы.Получить()
		И СинхронизацияССервисомДавноНеВыполнялась()
	;
КонецФункции

Функция СинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииРаботы() Экспорт
	
	Возврат ЭтоАвтономноеРабочееМесто()
		И Константы.НастройкаПодчиненногоУзлаРИБЗавершена.Получить()
		И Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииРаботыПрограммы.Получить()
	;
КонецФункции

Функция ОткрытьПомощникНастройкиАвтономногоРабочегоМеста() Экспорт
	
	Возврат ЭтоАвтономноеРабочееМесто()
		И Не Константы.НастройкаПодчиненногоУзлаРИБЗавершена.Получить()
	;
КонецФункции

Функция РасписаниеСинхронизацииДанныхПоУмолчанию() Экспорт // Каждый час
	
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
	Расписание.ПериодПовтораВТечениеДня = 60*60; // 60 минут
	Расписание.ПериодПовтораДней        = 1; // каждый день
	
	Возврат Расписание;
КонецФункции

Функция ЭтоАвтономноеРабочееМесто() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиПовтИсп.ЭтоАвтономноеРабочееМесто();
	
КонецФункции

Функция АдресДляВосстановленияПароляУчетнойЗаписи() Экспорт
	
	Результат = ОбменДаннымиВМоделиСервисаПереопределяемый.АдресДляВосстановленияПароляУчетнойЗаписи();
	
	Если ПустаяСтрока(Результат) Тогда
		Результат = "https://1cfresh.com/recover";
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ПараметрыФормыВыполненияОбменаДанными() Экспорт
	
	Возврат Новый Структура("УзелИнформационнойБазы, АдресДляВосстановленияПароляУчетнойЗаписи",
		ПриложениеВСервисе(), АдресДляВосстановленияПароляУчетнойЗаписи()
	);
КонецФункции

Функция СинхронизацияССервисомДавноНеВыполнялась(Интервал = 3600) Экспорт // 1 час по умолчанию
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ТекущаяДатаСеанса() - ДатаПоследнейУспешнойСинхронизации(ПриложениеВСервисе()) > Интервал;
	
КонецФункции

//

Процедура ЗагрузитьПараметрыИзНачальногоОбраза()
	
	Параметры = ПолучитьПараметрыИзНачальногоОбраза();
	
	Попытка
		ПланыОбмена.УстановитьГлавныйУзел(Неопределено);
	Исключение
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
		);
		ВызватьИсключение НСтр("ru = 'Возможно, информационная база открыта в режиме конфигуратора.
		|Завершите работу конфигуратора и повторите запуск программы.'"
		);
	КонецПопытки;
	
	// Создаем узлы плана обмена автономной работы в нулевой области данных
	УзелАвтономногоРабочегоМеста = ПланыОбмена[ПланОбменаАвтономнойРаботы()].ЭтотУзел().ПолучитьОбъект();
	УзелАвтономногоРабочегоМеста.Код          = Параметры.КодАвтономногоРабочегоМеста;
	УзелАвтономногоРабочегоМеста.Наименование = Параметры.НаименованиеАвтономногоРабочегоМеста;
	УзелАвтономногоРабочегоМеста.ДополнительныеСвойства.Вставить("ПолучениеСообщенияОбмена");
	УзелАвтономногоРабочегоМеста.Записать();
	
	УзелПриложенияВСервисе = ПланыОбмена[ПланОбменаАвтономнойРаботы()].СоздатьУзел();
	УзелПриложенияВСервисе.Код          = Параметры.КодПриложенияВСервисе;
	УзелПриложенияВСервисе.Наименование = Параметры.НаименованиеПриложенияВСервисе;
	УзелПриложенияВСервисе.ДополнительныеСвойства.Вставить("ПолучениеСообщенияОбмена");
	УзелПриложенияВСервисе.Записать();
	
	// Назначаем созданный узел главным
	ПланыОбмена.УстановитьГлавныйУзел(УзелПриложенияВСервисе.Ссылка);
	
	НачатьТранзакцию();
	Попытка
		
		Константы.НастройкаАвтономногоРабочегоМестаЗавершена.Установить(Истина);
		Константы.ИспользоватьОбменДанными.Установить(Истина);
		Константы.НастройкиПодчиненногоУзлаРИБ.Установить("");
		Константы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Установить(Параметры.Префикс);
		Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриНачалеРаботыПрограммы.Установить(Истина);
		Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииРаботыПрограммы.Установить(Истина);
		Константы.ЗаголовокСистемы.Установить(Параметры.ЗаголовокСистемы);
		
		Константы.ЭтоАвтономноеРабочееМесто.Установить(Истина);
		Константы.ИспользоватьРазделениеПоОбластямДанных.Установить(Ложь);
		
		// константа влияет на открытие помощника по настройке автономного рабочего места
		Константы.НастройкаПодчиненногоУзлаРИБЗавершена.Установить(Истина);
		
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("Узел", ПриложениеВСервисе());
		СтруктураЗаписи.Вставить("ВидТранспортаСообщенийОбменаПоУмолчанию", Перечисления.ВидыТранспортаСообщенийОбмена.WS);
		
		СтруктураЗаписи.Вставить("КоличествоЭлементовВТранзакцииВыгрузкиДанных", 200);
		СтруктураЗаписи.Вставить("КоличествоЭлементовВТранзакцииЗагрузкиДанных", 200);
		
		СтруктураЗаписи.Вставить("WSИспользоватьПередачуБольшогоОбъемаДанных", Истина);
		
		СтруктураЗаписи.Вставить("WSURLВебСервиса",   Параметры.URL);
		СтруктураЗаписи.Вставить("WSИмяПользователя", Параметры.ИмяПользователя);
		
		// добавляем запись в РС
		РегистрыСведений.НастройкиТранспортаОбмена.ДобавитьЗапись(СтруктураЗаписи);
		
		// Устанавливаем дату создания начального образа, как дату первой успешной синхронизации данных.
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("УзелИнформационнойБазы", ПриложениеВСервисе());
		СтруктураЗаписи.Вставить("ДействиеПриОбмене", Перечисления.ДействияПриОбмене.ВыгрузкаДанных);
		СтруктураЗаписи.Вставить("ДатаОкончания", Параметры.ДатаСозданияНачальногоОбраза);
		РегистрыСведений.СостоянияУспешныхОбменовДанными.ДобавитьЗапись(СтруктураЗаписи);
		
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("УзелИнформационнойБазы", ПриложениеВСервисе());
		СтруктураЗаписи.Вставить("ДействиеПриОбмене", Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
		СтруктураЗаписи.Вставить("ДатаОкончания", Параметры.ДатаСозданияНачальногоОбраза);
		РегистрыСведений.СостоянияУспешныхОбменовДанными.ДобавитьЗапись(СтруктураЗаписи);
		
		// Устанавливаем расписание синхронизации по умолчанию.
		// Расписание отключаем, т.к. пароль пользователя не задан.
		РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете);
		РегламентноеЗадание.Использование = Ложь;
		РегламентноеЗадание.Расписание = РасписаниеСинхронизацииДанныхПоУмолчанию();
		РегламентноеЗадание.Записать();
		
		// Создаем пользователя ИБ и связываем его с пользователем из справочника пользователей.
		Роли = Новый Массив;
		Роли.Добавить("АдминистраторСистемы");
		Роли.Добавить("ПолныеПрава");
		
		ОписаниеПользователяИБ = Новый Структура;
		ОписаниеПользователяИБ.Вставить("Действие", "Записать");
		ОписаниеПользователяИБ.Вставить("Имя",       Параметры.ИмяВладельца);
		ОписаниеПользователяИБ.Вставить("ПолноеИмя", Параметры.ИмяВладельца);
		ОписаниеПользователяИБ.Вставить("Роли",      Роли);
		ОписаниеПользователяИБ.Вставить("АутентификацияСтандартная", Истина);
		ОписаниеПользователяИБ.Вставить("ПоказыватьВСпискеВыбора", Истина);
		
		Пользователь = Справочники.Пользователи.ПолучитьСсылку(Новый УникальныйИдентификатор(Параметры.Владелец)).ПолучитьОбъект();
		
		Если Пользователь = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'Идентификация пользователя не выполнена.
				|Возможно, справочник пользователей не включен в состав плана обмена автономной работы.'"
			);
		КонецЕсли;
		
		УстановитьМинимальнуюДлинуПаролейПользователей(0);
		УстановитьПроверкуСложностиПаролейПользователей(Ложь);
		
		Пользователь.Наименование = Параметры.ИмяВладельца;
		Пользователь.Служебный = Ложь;
		Пользователь.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
		Пользователь.Записать();
		
		ПланыОбмена.УдалитьРегистрациюИзменений(УзелПриложенияВСервисе.Ссылка);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
		);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ЗагрузитьДанныеНачальногоОбраза()
	
	КаталогИнформационнойБазы = ОбщегоНазначенияКлиентСервер.КаталогФайловойИнформационнойБазы();
	
	ИмяФайлаДанныхНачальногоОбраза = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
		КаталогИнформационнойБазы,
		"data.xml"
	);
	
	ФайлДанныхНачальногоОбраза = Новый Файл(ИмяФайлаДанныхНачальногоОбраза);
	Если Не ФайлДанныхНачальногоОбраза.Существует() Тогда
		Возврат; // Данные начального образа были успешно загружены ранее
	КонецЕсли;
	
	ДанныеНачальногоОбраза = Новый ЧтениеXML;
	ДанныеНачальногоОбраза.ОткрытьФайл(ИмяФайлаДанныхНачальногоОбраза);
	ДанныеНачальногоОбраза.Прочитать();
	ДанныеНачальногоОбраза.Прочитать();
	
	НачатьТранзакцию();
	Попытка
		
		Пока ВозможностьЧтенияXML(ДанныеНачальногоОбраза) Цикл
			
			ЭлементДанных = ПрочитатьXML(ДанныеНачальногоОбраза);
			
			ПолучениеЭлемента = ПолучениеЭлементаДанных.Авто;
			СтандартныеПодсистемыПереопределяемый.ПриПолученииДанныхОтГлавного(, ЭлементДанных, ПолучениеЭлемента, Ложь);
			
			Если ПолучениеЭлемента = ПолучениеЭлементаДанных.Игнорировать Тогда
				Продолжить;
			КонецЕсли;
			
			ЭлементДанных.ОбменДанными.Загрузка = Истина;
			ЭлементДанных.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
			ЭлементДанных.ДополнительныеСвойства.Вставить("НеПроверятьДатыЗапретаИзмененияДанных");
			ЭлементДанных.Записать();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
		);
		
		ДанныеНачальногоОбраза = Неопределено;
		ВызватьИсключение;
	КонецПопытки;
	
	ДанныеНачальногоОбраза.Закрыть();
	
	Попытка
		УдалитьФайлы(ИмяФайлаДанныхНачальногоОбраза);
	Исключение
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста(), УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
		);
	КонецПопытки;
	
КонецПроцедуры

Функция ПолучитьПараметрыИзНачальногоОбраза()
	
	СтрокаXML = Константы.НастройкиПодчиненногоУзлаРИБ.Получить();
	
	Если ПустаяСтрока(СтрокаXML) Тогда
		ВызватьИсключение НСтр("ru = 'В автономное рабочее место не были переданы настройки.
									|Работа с автономным рабочим место невозможна.'"
		);
	КонецЕсли;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	
	ЧтениеXML.Прочитать(); // Параметры
	ВерсияФормата = ЧтениеXML.ПолучитьАтрибут("ВерсияФормата");
	
	ЧтениеXML.Прочитать(); // ПараметрыАвтономногоРабочегоМеста
	
	Результат = СчитатьДанныеВСтуктуру(ЧтениеXML);
	
	ЧтениеXML.Закрыть();
	
	Возврат Результат;
КонецФункции

Функция СчитатьДанныеВСтуктуру(ЧтениеXML)
	
	// возвращаемое значение функции
	Результат = Новый Структура;
	
	Если ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка чтения XML'");
	КонецЕсли;
	
	ЧтениеXML.Прочитать();
	
	Пока ЧтениеXML.ТипУзла <> ТипУзлаXML.КонецЭлемента Цикл
		
		Ключ = ЧтениеXML.Имя;
		
		Результат.Вставить(Ключ, ПрочитатьXML(ЧтениеXML));
		
	КонецЦикла;
	
	ЧтениеXML.Прочитать();
	
	Возврат Результат;
КонецФункции

Функция СобытиеЖурналаРегистрацииСинхронизацияДанных()
	
	Возврат НСтр("ru = 'Автономная работа.Синхронизация данных'");
	
КонецФункции
