#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//  Представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура
//  - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриказОВыбытииСписком");
	Если НужноПечататьМакет Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		"ПриказОВыбытииСписком",
		НСтр("ru = 'Приказ о выбытии воспитанников (списком)'"),
		ПечатьПриказа(МассивОбъектов, ОбъектыПечати,"ПФ_MXL_ПриказОВыбытииСписком"),
		,
		"Документ.удуПриказОВыбытииИзГруппы.ПФ_MXL_ПриказОВыбытииСписком");
	КонецЕсли;
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриказОВыбытии");
	Если НужноПечататьМакет Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		"ПриказОВыбытии",
		НСтр("ru = 'Приказ о выбытии воспитанника'"),
		ПечатьПриказа(МассивОбъектов, ОбъектыПечати,"ПФ_MXL_ПриказОВыбытии"),
		,
		"Документ.удуПриказОВыбытииИзГруппы.ПФ_MXL_ПриказОВыбытии");
	КонецЕсли;
	
КонецПроцедуры

// Процедура печати документа.
//
Функция ПечатьПриказа(МассивОбъектов, ОбъектыПечати, ИмяМакета)
	
	
	ПараметрыОбъектов = ПолучитьДанныеОбъектов(МассивОбъектов);
	
	ПечатьСписком = (ИмяМакета = "ПФ_MXL_ПриказОВыбытииСписком");
			
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПриказОВыбытииРебенкаИзГруппы";
	
	Макет = УправлениеПечатью.ПолучитьМакет("Документ.удуПриказОВыбытииИзГруппы." + ИмяМакета);
	МассивОбластей = Новый Массив;
	МассивОбластей.Добавить("Шапка");
	Если ПечатьСписком Тогда
		МассивОбластей.Добавить("ШапкаПриложения");	
		МассивОбластей.Добавить("СтрокаПриложения");
	КонецЕсли;
	
	Для Каждого КлючИЗначение ИЗ ПараметрыОбъектов Цикл
		ПараметрыОбъекта = КлючИЗначение.Значение;
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Для Каждого ИмяОбласти ИЗ МассивОбластей Цикл
			Область = Макет.ПолучитьОбласть(ИмяОбласти);
			Если ИмяОбласти = "ШапкаПриложения" Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			Если ИмяОбласти <> "СтрокаПриложения" Тогда			
				ЗаполнитьЗначенияСвойств(Область.Параметры,ПараметрыОбъекта);
				Если НЕ ПечатьСписком Тогда
					ЗаполнитьЗначенияСвойств(Область.Параметры,ПараметрыОбъекта.ТабличнаяЧасть[0]);
				КонецЕсли;
				
				ТабличныйДокумент.Вывести(Область);
			Иначе
				Для Каждого СтрокаТаблицы ИЗ ПараметрыОбъекта.ТабличнаяЧасть Цикл
					ЗаполнитьЗначенияСвойств(Область.Параметры,СтрокаТаблицы);
					ТабличныйДокумент.Вывести(Область);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, КлючИЗначение.Ключ);		
	КонецЦикла;
	
	
	Возврат ТабличныйДокумент;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// Работа с макетами офисных документов.

Функция ПолучитьДанныеОбъектов(МассивОбъектов)
	
	ПараметрыОбъектов = Новый Соответствие;
	ТабличнаяЧасть = Новый ТаблицаЗначений;
	ТабличнаяЧасть.Колонки.Добавить("Н");
	ТабличнаяЧасть.Колонки.Добавить("Ребенок");
	ТабличнаяЧасть.Колонки.Добавить("ПричинаВыбытия");
	ТабличнаяЧасть.Колонки.Добавить("РебенокРП");
	
	Запрос = Новый Запрос;	
	Запрос.Текст = "ВЫБРАТЬ
	|	удуПриказОВыбытииИзГруппы.Номер КАК НомерПриказа,
	|	удуПриказОВыбытииИзГруппы.Дата КАК ДатаПриказа,
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(удуПриказОВыбытииИзГруппы.Учреждение.ПолноеНаименование КАК СТРОКА(200))) <> """"
	|			ТОГДА ВЫРАЗИТЬ(удуПриказОВыбытииИзГруппы.Учреждение.ПолноеНаименование КАК СТРОКА(200))
	|		ИНАЧЕ удуПриказОВыбытииИзГруппы.Учреждение.Наименование
	|	КОНЕЦ КАК НазваниеОрганизации,
	|	ЕСТЬNULL(ВложенныйЗапрос.КоличествоВоспитанников, 0) КАК КоличествоВоспитанников,
	|	удуПриказОВыбытииИзГруппы.Ссылка,
	|	удуПриказОВыбытииИзГруппы.Учреждение,
	|	удуПриказОВыбытииИзГруппы.ГруппаВыбытия,
	|	удуПриказОВыбытииИзГруппы.ДатаФактическогоВыбытия
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	Документ.удуПриказОВыбытииИзГруппы КАК удуПриказОВыбытииИзГруппы
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			удуПриказОВыбытииИзГруппыТабличнаяЧастьВоспитанники.Ссылка КАК Ссылка,
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ удуПриказОВыбытииИзГруппыТабличнаяЧастьВоспитанники.Ребенок) КАК КоличествоВоспитанников
	|		ИЗ
	|			Документ.удуПриказОВыбытииИзГруппы.ТабличнаяЧастьВоспитанники КАК удуПриказОВыбытииИзГруппыТабличнаяЧастьВоспитанники
	|		ГДЕ
	|			удуПриказОВыбытииИзГруппыТабличнаяЧастьВоспитанники.Ссылка В(&МассивОбъектов)
	|		
	|		СГРУППИРОВАТЬ ПО
	|			удуПриказОВыбытииИзГруппыТабличнаяЧастьВоспитанники.Ссылка) КАК ВложенныйЗапрос
	|		ПО удуПриказОВыбытииИзГруппы.Ссылка = ВложенныйЗапрос.Ссылка
	|ГДЕ
	|	удуПриказОВыбытииИзГруппы.Ссылка В(&МассивОбъектов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Период,
	|	ВложенныйЗапрос.Учреждение,
	|	ПРЕДСТАВЛЕНИЕ(удуОтветственныеЛицаУчреждения.Должность) КАК Должность,
	|	удуОтветственныеЛицаУчреждения.ФизЛицо,
	|	ВложенныйЗапрос.ДатаПриказа
	|ПОМЕСТИТЬ ВТ_ОтветственныеЛица
	|ИЗ
	|	(ВЫБРАТЬ
	|		МАКСИМУМ(удуОтветственныеЛицаУчреждения.Период) КАК Период,
	|		ВТ.Учреждение КАК Учреждение,
	|		удуОтветственныеЛицаУчреждения.ОтветственноеЛицо КАК ОтветственноеЛицо,
	|		ВТ.ДатаПриказа КАК ДатаПриказа
	|	ИЗ
	|		РегистрСведений.удуОтветственныеЛицаУчреждения КАК удуОтветственныеЛицаУчреждения
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ КАК ВТ
	|			ПО удуОтветственныеЛицаУчреждения.Учреждение = ВТ.Учреждение
	|				И удуОтветственныеЛицаУчреждения.Период <= ВТ.ДатаПриказа
	|	ГДЕ
	|		удуОтветственныеЛицаУчреждения.Учреждение В
	|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					удуПриказОВыбытииИзГруппы.Учреждение
	|				ИЗ
	|					Документ.удуПриказОВыбытииИзГруппы КАК удуПриказОВыбытииИзГруппы
	|				ГДЕ
	|					удуПриказОВыбытииИзГруппы.Ссылка В (&МассивОбъектов))
	|		И удуОтветственныеЛицаУчреждения.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.РуководительОрганизации)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ВТ.Учреждение,
	|		удуОтветственныеЛицаУчреждения.ОтветственноеЛицо,
	|		ВТ.ДатаПриказа) КАК ВложенныйЗапрос
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.удуОтветственныеЛицаУчреждения КАК удуОтветственныеЛицаУчреждения
	|		ПО ВложенныйЗапрос.Период = удуОтветственныеЛицаУчреждения.Период
	|			И ВложенныйЗапрос.Учреждение = удуОтветственныеЛицаУчреждения.Учреждение
	|			И ВложенныйЗапрос.ОтветственноеЛицо = удуОтветственныеЛицаУчреждения.ОтветственноеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	удуФИОФизЛиц.Фамилия + "" "" + ПОДСТРОКА(удуФИОФизЛиц.Имя, 1, 1) + "". "" + ПОДСТРОКА(удуФИОФизЛиц.Отчество, 1, 1) + ""."" КАК ФИОРуководителя,
	|	ВТ.НомерПриказа,
	|	ВТ.ДатаПриказа,
	|	ВТ.НазваниеОрганизации,
	|	ВТ.КоличествоВоспитанников,
	|	ВТ.Ссылка,
	|	ВТ_ОтветственныеЛица.Должность КАК ДолжностьРуководителя,
	|	ВТ.ГруппаВыбытия,
	|	ВТ.ДатаФактическогоВыбытия
	|ИЗ
	|	ВТ КАК ВТ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ОтветственныеЛица КАК ВТ_ОтветственныеЛица
	|			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				ВТ_ОтветственныеЛица.ФизЛицо КАК ФизЛицо,
	|				МАКСИМУМ(удуФИОФизЛиц.Период) КАК Период
	|			ИЗ
	|				ВТ_ОтветственныеЛица КАК ВТ_ОтветственныеЛица
	|					ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.удуФИОФизЛиц КАК удуФИОФизЛиц
	|					ПО (удуФИОФизЛиц.ФизЛицо = ВТ_ОтветственныеЛица.ФизЛицо)
	|						И (удуФИОФизЛиц.Период <= ВТ_ОтветственныеЛица.ДатаПриказа)
	|			
	|			СГРУППИРОВАТЬ ПО
	|				ВТ_ОтветственныеЛица.ФизЛицо) КАК ВложенныйЗапрос
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.удуФИОФизЛиц КАК удуФИОФизЛиц
	|				ПО ВложенныйЗапрос.ФизЛицо = удуФИОФизЛиц.ФизЛицо
	|					И ВложенныйЗапрос.Период = удуФИОФизЛиц.Период
	|			ПО (ВложенныйЗапрос.ФизЛицо = ВТ_ОтветственныеЛица.ФизЛицо)
	|		ПО ВТ.Учреждение = ВТ_ОтветственныеЛица.Учреждение";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);		
	Шапка = Запрос.Выполнить().Выбрать();
	
	Запрос.Текст = "ВЫБРАТЬ
	|	удуПриказОВыбытииИзГруппыТабличнаяЧастьВоспитанники.Ребенок,
	|	удуПриказОВыбытииИзГруппыТабличнаяЧастьВоспитанники.Ссылка КАК Ссылка,
	|	удуПриказОВыбытииИзГруппыТабличнаяЧастьВоспитанники.НомерСтроки КАК Н,
	|	удуПриказОВыбытииИзГруппыТабличнаяЧастьВоспитанники.ПричинаВыбытия
	|ИЗ
	|	Документ.удуПриказОВыбытииИзГруппы.ТабличнаяЧастьВоспитанники КАК удуПриказОВыбытииИзГруппыТабличнаяЧастьВоспитанники
	|ГДЕ
	|	удуПриказОВыбытииИзГруппыТабличнаяЧастьВоспитанники.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	Н
	|ИТОГИ ПО
	|	Ссылка";
	ВыборкаТЧ = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока Шапка.Следующий() Цикл
		ПараметрыОбъекта = Новый Структура;
		ПараметрыОбъекта.Вставить("ДатаПриказа", Строка(Формат(Шапка.ДатаПриказа,"ДЛФ=D"))+" г.");
		ПараметрыОбъекта.Вставить("НомерПриказа", удуФормированиеПечатныхФорм.ПолучитьНомерНаПечать(Шапка.НомерПриказа));
		ПараметрыОбъекта.Вставить("НазваниеОрганизации", Шапка.НазваниеОрганизации);
		ПараметрыОбъекта.Вставить("ГруппаВыбытия", Шапка.ГруппаВыбытия);
		ПараметрыОбъекта.Вставить("КоличествоВоспитанников", Шапка.КоличествоВоспитанников);		
		ПараметрыОбъекта.Вставить("ДатаФактическогоВыбытия", Строка(Формат(Шапка.ДатаФактическогоВыбытия,"ДЛФ=D"))+" г.");
		ПараметрыОбъекта.Вставить("ДолжностьРуководителя",Шапка.ДолжностьРуководителя);
		ПараметрыОбъекта.Вставить("ФИОРуководителя",Шапка.ФИОРуководителя);		
		
		СтруктураПоиска = Новый Структура("Ссылка",Шапка.Ссылка);
		Если ВыборкаТЧ.НайтиСледующий(СтруктураПоиска) Тогда
			Выборка = ВыборкаТЧ.Выбрать();
			Пока Выборка.Следующий() Цикл
				СтрокаТЧ = ТабличнаяЧасть.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТЧ,Выборка);
				Результат = "";
				Если удуОбщегоНазначенияСервер.Просклонять(Выборка.Ребенок.Наименование, 4, Результат, Выборка.Ребенок.Пол) Тогда 
					СтрокаТЧ.РебенокРП = Результат;
				Иначе 
					СтрокаТЧ.РебенокРП = СтрокаТЧ.Ребенок;
				КонецЕсли;

			КонецЦикла;
			ПараметрыОбъекта.Вставить("ТабличнаяЧасть",ТабличнаяЧасть.Скопировать());
		КонецЕсли;
		ВыборкаТЧ.Сбросить();
		ТабличнаяЧасть.Очистить();
		ПараметрыОбъектов.Вставить(Шапка.Ссылка, ПараметрыОбъекта);
	КонецЦикла;
	
	Возврат ПараметрыОбъектов;
	
КонецФункции // ПолучитьДанныеОбъектов()

#КонецЕсли
