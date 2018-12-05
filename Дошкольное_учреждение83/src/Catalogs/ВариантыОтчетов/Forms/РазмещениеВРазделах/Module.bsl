////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПолныеПраваНаВарианты = ВариантыОтчетов.ПолныеПраваНаВарианты();
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Заполнение = Новый Структура("Подсистема, Действие, ИсключаемыеПодсистемы",
		Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка(),
		"",
		Новый Массив
	);
	ЗаполнитьЗначенияСвойств(Заполнение, Параметры);
	Если Заполнение.Действие = "Перенести" Тогда
		ПодсистемаРодитель = Заполнение.Подсистема.Родитель;
		Пока ПодсистемаРодитель <> Справочники.ИдентификаторыОбъектовМетаданных.Подсистемы Цикл
			Заполнение.ИсключаемыеПодсистемы.Добавить(ПодсистемаРодитель);
			ПодсистемаРодитель = ПодсистемаРодитель.Родитель;
		КонецЦикла;
		Заполнение.ИсключаемыеПодсистемы = Новый ФиксированныйМассив(Заполнение.ИсключаемыеПодсистемы);
	КонецЕсли;
	Заполнение = Новый ФиксированнаяСтруктура(Заполнение);
	
	// Контроль количества вариантов осуществляется до открытия формы
	ИзменяемыеВарианты.ЗагрузитьЗначения(Параметры.МассивВариантов);
	
	ПерезаполнитьДерево();
	
	ВариантыОтчетов.ДеревоПодсистемДобавитьУсловноеОформление(ЭтаФорма);
	
	ТекущийЭлемент = Элементы.ДеревоПодсистем;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если ВариантыОтчетовКлиент.СохранитьДанныеПроизвольнойФормы(Модифицированность, Отказ) Тогда
		ЗаписатьНаКлиенте();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	Если ВариантыОтчетовКлиент.СохранитьДанныеПроизвольнойФормы(Модифицированность) Тогда
		ЗаписатьНаКлиенте();
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ИзменяемыеВариантыПриИзменении(Элемент)
	ОчиститьСообщения();
	ПерезаполнитьДерево();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ДеревоПодсистем

&НаКлиенте
Процедура ДеревоПодсистемИспользованиеПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемИспользованиеПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемВажностьПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемВажностьПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Разместить(Команда)
	ЗаписатьНаКлиенте();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Перечитать(Команда)
	ПерезаполнитьДерево(Ложь);
	Элементы.ДеревоПодсистем.Развернуть(ДеревоПодсистем.ПолучитьЭлементы()[0].ПолучитьИдентификатор(), Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	ПерезаполнитьДерево(Истина);
	Элементы.ДеревоПодсистем.Развернуть(ДеревоПодсистем.ПолучитьЭлементы()[0].ПолучитьИдентификатор(), Истина);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Функция ЗаписатьНаКлиенте()
	Результат = ЗаписатьНаСервере();
	ПоказатьОповещениеПользователя(
		,
		,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Изменены настройки вариантов отчетов (%1 шт.).'"),
			Формат(ИзменяемыеВарианты.Количество(), "ЧН=0; ЧГ=0")
		)
	);
	Модифицированность = Ложь;
	
	ВариантыОтчетовКлиент.ОбновитьОткрытыеПанелиОтчетов();
	
	Возврат Результат;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПерезаполнитьДерево(ТолькоСнятьФлажки = Ложь)
	ИзменяемыеВариантыОтфильтроватьПоПравам();
	
	КоличествоВариантов = ИзменяемыеВарианты.Количество();
	Если КоличествоВариантов = 0 Тогда
		Элементы.ДеревоПодсистем.Доступность = Ложь;
		Возврат Ложь;
	Иначе
		Элементы.ДеревоПодсистем.Доступность = Истина;
	КонецЕсли;
	
	Если ТолькоСнятьФлажки Тогда
		ДеревоПриемник = РеквизитФормыВЗначение("ДеревоПодсистем", Тип("ДеревоЗначений"));
		Найденные = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Использование", 1), Истина);
		Для Каждого СтрокаДерева Из Найденные Цикл
			СтрокаДерева.Использование = 0;
			Если СтрокаДерева.Использование <> СтрокаДерева.ИспользованиеПоУмолчанию Тогда
				СтрокаДерева.ИзмененПользователем = Истина;
			КонецЕсли;
		КонецЦикла; 
		
		Найденные = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Использование", 2), Истина);
		Для Каждого СтрокаДерева Из Найденные Цикл
			СтрокаДерева.Использование = 0;
			Если СтрокаДерева.Использование <> СтрокаДерева.ИспользованиеПоУмолчанию Тогда
				СтрокаДерева.ИзмененПользователем = Истина;
			КонецЕсли;
		КонецЦикла; 
		
		ЗначениеВРеквизитФормы(ДеревоПриемник, "ДеревоПодсистем");
		Возврат Истина;
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВариантыОтчетовРазмещение.РазделИлиГруппа КАК Ссылка,
	|	СУММА(1) КАК Количество,
	|	МИНИМУМ(ВЫБОР
	|			КОГДА ВариантыОтчетовРазмещение.Важный
	|				ТОГДА &ПредставлениеВажный
	|			КОГДА ВариантыОтчетовРазмещение.СмТакже
	|				ТОГДА &ПредставлениеСмТакже
	|			ИНАЧЕ """"
	|		КОНЕЦ) КАК Важность
	|ИЗ
	|	Справочник.ВариантыОтчетов.Размещение КАК ВариантыОтчетовРазмещение
	|ГДЕ
	|	ВариантыОтчетовРазмещение.Ссылка В(&МассивВариантов)
	|	И ВариантыОтчетовРазмещение.Использование = ИСТИНА
	|
	|СГРУППИРОВАТЬ ПО
	|	ВариантыОтчетовРазмещение.РазделИлиГруппа";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивВариантов",      ИзменяемыеВарианты.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("ПредставлениеВажный",  ВариантыОтчетовКлиентСервер.ПредставлениеВажный());
	Запрос.УстановитьПараметр("ПредставлениеСмТакже", ВариантыОтчетовКлиентСервер.ПредставлениеСмТакже());
	
	Запрос.Текст = ТекстЗапроса;
	ВхожденияПодсистем = Запрос.Выполнить().Выгрузить();
	
	ДеревоИсточник = ВариантыОтчетовПовтИсп.ПодсистемыТекущегоПользователя();
	
	ДеревоПриемник = РеквизитФормыВЗначение("ДеревоПодсистем", Тип("ДеревоЗначений"));
	ДеревоПриемник.Строки.Очистить();
	
	ДобавитьПодсистемыВДерево(ДеревоПриемник, ДеревоИсточник, ВхожденияПодсистем);
	
	ЗначениеВРеквизитФормы(ДеревоПриемник, "ДеревоПодсистем");
	Возврат Истина;
КонецФункции

&НаСервере
Функция ЗаписатьНаСервере()
	Кэш = Новый Структура;
	
	НачатьТранзакцию();
	Для Каждого ЭлементСписка Из ИзменяемыеВарианты Цикл
		ВариантОбъект = ЭлементСписка.Значение.ПолучитьОбъект();
		ВариантыОтчетов.ДеревоПодсистемЗаписать(ЭтаФорма, ВариантОбъект, Кэш);
		ВариантОбъект.Записать();
	КонецЦикла;
	ЗафиксироватьТранзакцию();
	
	Возврат Истина;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура ДобавитьПодсистемыВДерево(ПриемникРодитель, ИсточникРодитель, ВхожденияПодсистем)
	Для Каждого Источник Из ИсточникРодитель.Строки Цикл
		
		Приемник = ПриемникРодитель.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(Приемник, Источник);
		
		Вхождение = ВхожденияПодсистем.Найти(Приемник.Ссылка, "Ссылка");
		Если Вхождение <> Неопределено Тогда
			ВключеныПодчиненные = Истина;
			Приемник.ВажностьПоУмолчанию = Вхождение.Важность;
			Если Вхождение.Количество = КоличествоВариантов Тогда
				Приемник.ИспользованиеПоУмолчанию = 1;
			Иначе
				Приемник.ИспользованиеПоУмолчанию = 2;
			КонецЕсли;
		КонецЕсли;
		
		Приемник.Важность      = Приемник.ВажностьПоУмолчанию;
		Приемник.Использование = Приемник.ИспользованиеПоУмолчанию;
		
		// Заполнение по данным открытия
		Если Приемник.ИспользованиеПоУмолчанию = 0 Тогда
			// Включение подсистем по данным открытия
			Если Заполнение.Действие = "Перенести" И Приемник.Ссылка = Заполнение.Подсистема Тогда
				Приемник.Использование = 1;
				Приемник.ИзмененПользователем = Истина;
			КонецЕсли;
		Иначе
			// Отключение подсистем по данным открытия
			Если Заполнение.Действие = "Очистить" ИЛИ (
					Заполнение.Действие = "Перенести"
					И Заполнение.ИсключаемыеПодсистемы.Найти(Приемник.Ссылка) <> Неопределено
				) Тогда
				Приемник.Использование = 0;
				Приемник.ИзмененПользователем = Истина;
			КонецЕсли;
		КонецЕсли;
		
		// Рекурсия
		ДобавитьПодсистемыВДерево(Приемник, Источник, ВхожденияПодсистем);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ИзменяемыеВариантыОтфильтроватьПоПравам()
	Количество = ИзменяемыеВарианты.Количество();
	Для Номер = 1 По Количество Цикл
		Индекс = Количество - Номер;
		Вариант = ИзменяемыеВарианты[Индекс].Значение;
		Если Вариант.ПометкаУдаления Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = '""%1"" помечен на удаление.'"),
					Строка(Вариант)
				),
				,
				"ИзменяемыеВарианты"
			);
			ИзменяемыеВарианты.Удалить(Индекс);
		ИначеЕсли НЕ ПолныеПраваНаВарианты И Вариант.Автор <> ТекущийПользователь Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Недостаточно прав для изменения ""%1"".'"),
					Строка(Вариант)
				),
				,
				"ИзменяемыеВарианты"
			);
			ИзменяемыеВарианты.Удалить(Индекс);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
