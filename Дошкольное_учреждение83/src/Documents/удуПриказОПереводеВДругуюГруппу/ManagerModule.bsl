#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//  представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура
//  - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриказОПереводеСписком");
	Если НужноПечататьМакет Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		"ПриказОПереводеСписком",
		НСтр("ru = 'Приказ о переводе воспитанников (списком)'"),
		ПечатьПриказа(МассивОбъектов, ОбъектыПечати,"ПФ_MXL_ПриказОПереводеСписком"),
		,
		"Документ.удуПриказОЗачисленииРебенкаВГруппу.ПФ_MXL_ПриказОПереводеСписком");
	КонецЕсли;
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриказОПереводе");
	Если НужноПечататьМакет Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		"ПриказОПереводе",
		НСтр("ru = 'Приказ о переводе воспитанника'"),
		ПечатьПриказа(МассивОбъектов, ОбъектыПечати,"ПФ_MXL_ПриказОПереводе"),
		,
		"Документ.удуПриказОЗачисленииРебенкаВГруппу.ПФ_MXL_ПриказОПереводе");
	КонецЕсли;
	
КонецПроцедуры

// Процедура печати документа.
//
Функция ПечатьПриказа(МассивОбъектов, ОбъектыПечати, ИмяМакета)
	
	
	ПараметрыОбъектов = ПолучитьДанныеОбъектов(МассивОбъектов);
	
	ПечатьСписком = (ИмяМакета = "ПФ_MXL_ПриказОПереводеСписком");
			
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПриказОПереводеРебенка";
	
	Макет = УправлениеПечатью.ПолучитьМакет("Документ.удуПриказОПереводеВДругуюГруппу." + ИмяМакета);
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
	ТабличнаяЧасть.Колонки.Добавить("НовоеОснованиеЗачисления");
	ТабличнаяЧасть.Колонки.Добавить("РебенокРП");
	
	Запрос = Новый Запрос;	
	Запрос.Текст = "ВЫБРАТЬ
	|	удуПриказОПереводеВДругуюГруппу.Номер КАК НомерПриказа,
	|	удуПриказОПереводеВДругуюГруппу.Дата КАК ДатаПриказа,
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(удуПриказОПереводеВДругуюГруппу.Учреждение.ПолноеНаименование КАК СТРОКА(200))) <> """"
	|			ТОГДА ВЫРАЗИТЬ(удуПриказОПереводеВДругуюГруппу.Учреждение.ПолноеНаименование КАК СТРОКА(200))
	|		ИНАЧЕ удуПриказОПереводеВДругуюГруппу.Учреждение.Наименование
	|	КОНЕЦ КАК НазваниеОрганизации,
	|	ЕСТЬNULL(ВложенныйЗапрос.КоличествоВоспитанников, 0) КАК КоличествоВоспитанников,
	|	удуПриказОПереводеВДругуюГруппу.Ссылка,
	|	удуПриказОПереводеВДругуюГруппу.Учреждение,
	|	удуПриказОПереводеВДругуюГруппу.ГруппаПервоначальная,
	|	удуПриказОПереводеВДругуюГруппу.ГруппаДляПеревода
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	Документ.удуПриказОПереводеВДругуюГруппу КАК удуПриказОПереводеВДругуюГруппу
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			удуПриказОПереводеВДругуюГруппуТабличнаяЧастьВоспитанники.Ссылка КАК Ссылка,
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ удуПриказОПереводеВДругуюГруппуТабличнаяЧастьВоспитанники.Ребенок) КАК КоличествоВоспитанников
	|		ИЗ
	|			Документ.удуПриказОПереводеВДругуюГруппу.ТабличнаяЧастьВоспитанники КАК удуПриказОПереводеВДругуюГруппуТабличнаяЧастьВоспитанники
	|		ГДЕ
	|			удуПриказОПереводеВДругуюГруппуТабличнаяЧастьВоспитанники.Ссылка В(&МассивОбъектов)
	|		
	|		СГРУППИРОВАТЬ ПО
	|			удуПриказОПереводеВДругуюГруппуТабличнаяЧастьВоспитанники.Ссылка) КАК ВложенныйЗапрос
	|		ПО удуПриказОПереводеВДругуюГруппу.Ссылка = ВложенныйЗапрос.Ссылка
	|ГДЕ
	|	удуПриказОПереводеВДругуюГруппу.Ссылка В(&МассивОбъектов)
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
	|					удуПриказОПереводеВДругуюГруппу.Учреждение
	|				ИЗ
	|					Документ.удуПриказОПереводеВДругуюГруппу КАК удуПриказОПереводеВДругуюГруппу
	|				ГДЕ
	|					удуПриказОПереводеВДругуюГруппу.Ссылка В (&МассивОбъектов))
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
	|	ВТ.ГруппаДляПеревода,
	|	ВТ.ГруппаПервоначальная
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
	|	удуПриказОПереводеВДругуюГруппуТабличнаяЧастьВоспитанники.Ребенок,
	|	удуПриказОПереводеВДругуюГруппуТабличнаяЧастьВоспитанники.Ссылка КАК Ссылка,
	|	удуПриказОПереводеВДругуюГруппуТабличнаяЧастьВоспитанники.НомерСтроки КАК Н,
	|	удуПриказОПереводеВДругуюГруппуТабличнаяЧастьВоспитанники.НовоеОснованиеЗачисления
	|ИЗ
	|	Документ.удуПриказОПереводеВДругуюГруппу.ТабличнаяЧастьВоспитанники КАК удуПриказОПереводеВДругуюГруппуТабличнаяЧастьВоспитанники
	|ГДЕ
	|	удуПриказОПереводеВДругуюГруппуТабличнаяЧастьВоспитанники.Ссылка В(&МассивОбъектов)
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
		ПараметрыОбъекта.Вставить("ГруппаПервоначальная", Шапка.ГруппаПервоначальная);
		ПараметрыОбъекта.Вставить("ГруппаДляПеревода", Шапка.ГруппаДляПеревода);
		ПараметрыОбъекта.Вставить("КоличествоВоспитанников", Шапка.КоличествоВоспитанников);		
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
                Если ЗначениеЗаполнено(СтрокаТЧ.НовоеОснованиеЗачисления) Тогда 
					ДокументОснование=СтрокаТЧ.НовоеОснованиеЗачисления.ПолучитьОбъект();
					СтрокаТЧ.НовоеОснованиеЗачисления="Договор о зачислении в группу №"+удуФормированиеПечатныхФорм.ПолучитьНомерНаПечать(ДокументОснование.Номер)+" от "+Строка(Формат(ДокументОснование.Дата,"ДФ=dd.MM.yyyy"))+" г.";
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
