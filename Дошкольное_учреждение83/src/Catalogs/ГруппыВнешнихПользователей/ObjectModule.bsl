#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Перем СтарыйРодитель; // Значение родителя группы до изменения для использования
                      // в обработчике события ПриЗаписи.

Перем СтарыйСоставГруппыВнешнихПользователей; // Состав внешних пользователей группы внешних
                                              // пользователей до изменения для использования
                                              // в обработчике события ПриЗаписи.

Перем СтарыйСоставРолейГруппыВнешнихПользователей; // Флажок изменения состава ролей для
                                                   // использования в обработчике события ПриЗаписи.

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверенныеРеквизитыОбъекта = Новый Массив;
	Ошибки = Неопределено;
	
	// Проверка использования родителя.
	Если Родитель = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
			"Объект.Родитель",
			НСтр("ru = 'Предопределенная группа ""Все внешние пользователи"" не может быть родителем.'"));
	КонецЕсли;
	
	// Проверка незаполненных и повторяющихся внешних пользователей.
	ПроверенныеРеквизитыОбъекта.Добавить("Состав.ВнешнийПользователь");
	
	Для каждого ТекущаяСтрока Из Состав Цикл
		НомерСтроки = Состав.Индекс(ТекущаяСтрока);
		
		// Проверка заполнения значения.
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.ВнешнийПользователь) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"Объект.Состав[%1].ВнешнийПользователь",
				НСтр("ru = 'Внешний пользователь не выбран.'"),
				"Объект.Состав",
				НомерСтроки,
				НСтр("ru = 'Внешний пользователь в строке %1 не выбран.'"));
			Продолжить;
		КонецЕсли;
		
		// Проверка наличия повторяющихся значений.
		НайденныеЗначения = Состав.НайтиСтроки(Новый Структура("ВнешнийПользователь", ТекущаяСтрока.ВнешнийПользователь));
		Если НайденныеЗначения.Количество() > 1 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"Объект.Состав[%1].ВнешнийПользователь",
				НСтр("ru = 'Внешний пользователь повторяется.'"),
				"Объект.Состав",
				НомерСтроки,
				НСтр("ru = 'Внешний пользователь в строке %1 повторяется.'"));
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ПроверенныеРеквизитыОбъекта);
	
КонецПроцедуры

// Блокирует недопустимые действия с предопределенной группой "Все внешние пользователи".
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Ссылка = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
		
		ТипОбъектовАвторизации = Неопределено;
		ВсеОбъектыАвторизации  = Ложь;
		
		Если НЕ Родитель.Пустая() Тогда
			ВызватьИсключение
				НСтр("ru = 'Предопределенная группа ""Все внешние пользователи""
				           |может быть только в корне.'");
		КонецЕсли;
		Если Состав.Количество() > 0 Тогда
			ВызватьИсключение
				НСтр("ru = 'Добавление внешних пользователей в группу
				           |""Все внешние пользователи"" не поддерживается.'");
		КонецЕсли;
	Иначе
		Если Родитель = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
			ВызватьИсключение
				НСтр("ru = 'Предопределенная группа ""Все внешние пользователи""
				           |не может быть родителем.'");
		КонецЕсли;
		
		Если ТипОбъектовАвторизации = Неопределено Тогда
			ВсеОбъектыАвторизации = Ложь;
			
		ИначеЕсли ВсеОбъектыАвторизации
		        И ЗначениеЗаполнено(Родитель) Тогда
			
			ВызватьИсключение
				НСтр("ru = 'Группа внешних пользователей, содержащая все объекты
				           |информационной базы заданного типа может быть только в корне.'");
		КонецЕсли;
		
		// Проверка уникальности группы всех объектов авторизации заданного типа.
		Если ВсеОбъектыАвторизации Тогда
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			Запрос.УстановитьПараметр("ТипОбъектовАвторизации", ТипОбъектовАвторизации);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ПРЕДСТАВЛЕНИЕ(ГруппыВнешнихПользователей.Ссылка) КАК СсылкаПредставление
			|ИЗ
			|	Справочник.ГруппыВнешнихПользователей КАК ГруппыВнешнихПользователей
			|ГДЕ
			|	ГруппыВнешнихПользователей.Ссылка <> &Ссылка
			|	И ГруппыВнешнихПользователей.ТипОбъектовАвторизации = &ТипОбъектовАвторизации
			|	И ГруппыВнешнихПользователей.ВсеОбъектыАвторизации";
			
			РезультатЗапроса = Запрос.Выполнить();
			Если НЕ РезультатЗапроса.Пустой() Тогда
			
				Выборка = РезультатЗапроса.Выбрать();
				Выборка.Следующий();
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Группа внешних пользователей ""%1""
					           |для всех объектов информационной базы
					           |типа ""%2"" уже существует.'"),
					Выборка.СсылкаПредставление,
					ТипОбъектовАвторизации.Метаданные().Синоним);
			КонецЕсли;
		КонецЕсли;
		
		// Проверка совпадения типа объектов авторизации с родителем
		//(допустимо, если тип у родителя не задан).
		Если ЗначениеЗаполнено(Родитель) Тогда
			ТипОбъектовАвторизацииРодителя = ОбщегоНазначения.ПолучитьЗначениеРеквизита(
				Родитель, "ТипОбъектовАвторизации");
			
			Если ТипОбъектовАвторизацииРодителя <> Неопределено
			   И ТипОбъектовАвторизацииРодителя <> ТипОбъектовАвторизации Тогда
				
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'У нижестоящей группы внешних пользователей тип объектов
					           |информационной базы должен быть ""%1"",
					           |как у вышестоящей группы внешних пользователей ""%2"".'"),
					ТипОбъектовАвторизацииРодителя.Метаданные().Синоним,
					Родитель);
			КонецЕсли;
		КонецЕсли;
		
		// Проверка, что при изменении типа объектов авторизации
		// нет подчиненных элементов другого типа (очистка типа допустима).
		Если ТипОбъектовАвторизации <> Неопределено
		   И ЗначениеЗаполнено(Ссылка) Тогда
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			Запрос.УстановитьПараметр("ТипОбъектовАвторизации", ТипОбъектовАвторизации);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ПРЕДСТАВЛЕНИЕ(ГруппыВнешнихПользователей.Ссылка) КАК СсылкаПредставление,
			|	ГруппыВнешнихПользователей.ТипОбъектовАвторизации
			|ИЗ
			|	Справочник.ГруппыВнешнихПользователей КАК ГруппыВнешнихПользователей
			|ГДЕ
			|	ГруппыВнешнихПользователей.Родитель = &Ссылка
			|	И ГруппыВнешнихПользователей.ТипОбъектовАвторизации <> &ТипОбъектовАвторизации";
			
			РезультатЗапроса = Запрос.Выполнить();
			Если НЕ РезультатЗапроса.Пустой() Тогда
				
				Выборка = РезультатЗапроса.Выбрать();
				Выборка.Следующий();
				
				Если Выборка.ТипОбъектовАвторизации = Неопределено Тогда
					ПредставлениеДругогоТипаОбъектаАвторизации = НСтр("ru = '<Любой тип>'");
				Иначе
					ПредставлениеДругогоТипаОбъектаАвторизации =
						Выборка.ТипОбъектовАвторизации.Метаданные().Синоним;
				КонецЕсли;
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'У группы внешних пользователей ""%1""
					           |невозможно изменить тип объектов информационной базы,
					           |так как существует нижестоящая группа внешних пользователей
					           |""%2"" с другим типом
					           |объектов информационной базы ""%3"".'"),
					Наименование,
					Выборка.СсылкаПредставление,
					ПредставлениеДругогоТипаОбъектаАвторизации);
			КонецЕсли;
		КонецЕсли;
		
		СтарыйРодитель = ?(
			Ссылка.Пустая(),
			Неопределено,
			ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "Родитель") );
		
		Если ЗначениеЗаполнено(Ссылка)
		   И Ссылка <> Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
			
			СтарыйСоставГруппыВнешнихПользователей =
				ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "Состав").Выгрузить();
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПользователиПереопределяемый.ЗапретРедактированияРолей() Тогда
		СтарыйСоставРолейГруппыВнешнихПользователей =
			ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "Роли").Выгрузить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПользователиПереопределяемый.ЗапретРедактированияРолей() Тогда
		ИзменилсяСоставРолейГруппыВнешнихПользователей = Ложь;
	Иначе
		ИзменилсяСоставРолейГруппыВнешнихПользователей =
			ПользователиСлужебный.РазличияЗначенийКолонки(
				"Роль",
				Роли.Выгрузить(),
				СтарыйСоставРолейГруппыВнешнихПользователей).Количество() <> 0;
	КонецЕсли;
	
	Если Ссылка = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
		
		Если ИзменилсяСоставРолейГруппыВнешнихПользователей Тогда
			ПользователиСлужебный.ОбновитьРолиВнешнихПользователей(Ссылка);
		Иначе
			Выборка = Справочники.ГруппыВнешнихПользователей.Выбрать();
			Пока Выборка.Следующий() Цикл
				ПользователиСлужебный.ОбновитьСоставыГруппВнешнихПользователей(Выборка.Ссылка);
			КонецЦикла;
			ПользователиСлужебный.ОбновитьРолиВнешнихПользователей();
		КонецЕсли;
	Иначе
		Если ВсеОбъектыАвторизации Тогда
			ПользователиСлужебный.ОбновитьСоставыГруппВнешнихПользователей(Ссылка);
		Иначе
			ИзмененияСостава = ПользователиСлужебный.РазличияЗначенийКолонки(
				"ВнешнийПользователь",
				Состав.Выгрузить(),
				СтарыйСоставГруппыВнешнихПользователей);
			
			ПользователиСлужебный.ОбновитьСоставыГруппВнешнихПользователей(
				Ссылка, ИзмененияСостава);
			
			Если ЗначениеЗаполнено(СтарыйРодитель) И СтарыйРодитель <> Родитель Тогда
				ИзмененияСоставаПриИзмененииРодителя = Неопределено;
				ПользователиСлужебный.ОбновитьСоставыГруппВнешнихПользователей(СтарыйРодитель);
			КонецЕсли;
		КонецЕсли;
		
		Если ИзменилсяСоставРолейГруппыВнешнихПользователей Тогда
			ПользователиСлужебный.ОбновитьРолиВнешнихПользователей(Ссылка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


#КонецЕсли