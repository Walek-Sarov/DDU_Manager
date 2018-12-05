&НаСервере
Функция СформироватьотчетНаСервере()	
				   
	ТекстЗапроса = "ВЫБРАТЬ
	               |	МАКСИМУМ(удуВзаиморасчетыСРодителями.Период) КАК Период,
	               |	удуВзаиморасчетыСРодителями.Учреждение,
	               |	удуВзаиморасчетыСРодителями.Ребенок,
	               |	СУММА(удуВзаиморасчетыСРодителями.Сумма) КАК Сумма,
	               |	МЕСЯЦ(ДОБАВИТЬКДАТЕ(удуВзаиморасчетыСРодителями.Период, МЕСЯЦ, -1)) + ГОД(ДОБАВИТЬКДАТЕ(удуВзаиморасчетыСРодителями.Период, МЕСЯЦ, -1)) * 100 КАК МесяцПосещения,
	               |	ВЫРАЗИТЬ(удуВзаиморасчетыСРодителями.Регистратор КАК Документ.удуКвитанцияОбОплатеПосещенияДОУ).Группа КАК Группа
	               |ПОМЕСТИТЬ ВТ_Оплаты
	               |ИЗ
	               |	РегистрНакопления.удуВзаиморасчетыСРодителями КАК удуВзаиморасчетыСРодителями
	               |ГДЕ
	               |	ВЫБОР
	               |			КОГДА удуВзаиморасчетыСРодителями.Регистратор <> &ПустойРегистратор
	               |				ТОГДА удуВзаиморасчетыСРодителями.Период МЕЖДУ ДОБАВИТЬКДАТЕ(&ПериодНач, МЕСЯЦ, 1) И КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(&ПериодКон, МЕСЯЦ, 1), МЕСЯЦ)
	               |			ИНАЧЕ ИСТИНА
	               |		КОНЕЦ
	               |	И удуВзаиморасчетыСРодителями.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	               |	И (ВЫРАЗИТЬ(удуВзаиморасчетыСРодителями.Регистратор КАК Документ.удуКвитанцияОбОплатеПосещенияДОУ).Группа = &Группа
	               |			ИЛИ &Группа = ЗНАЧЕНИЕ(Справочник.удуГруппыУчреждения.ПустаяСсылка))
	               |	И удуВзаиморасчетыСРодителями.Учреждение = &Учреждение
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	удуВзаиморасчетыСРодителями.Учреждение,
	               |	удуВзаиморасчетыСРодителями.Ребенок,
	               |	МЕСЯЦ(ДОБАВИТЬКДАТЕ(удуВзаиморасчетыСРодителями.Период, МЕСЯЦ, -1)) + ГОД(ДОБАВИТЬКДАТЕ(удуВзаиморасчетыСРодителями.Период, МЕСЯЦ, -1)) * 100,
	               |	ВЫРАЗИТЬ(удуВзаиморасчетыСРодителями.Регистратор КАК Документ.удуКвитанцияОбОплатеПосещенияДОУ).Группа
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	удуСведенияОПосещаемостиДОУ.Учреждение,
	               |	удуСведенияОПосещаемостиДОУ.Группа,
	               |	удуСведенияОПосещаемостиДОУ.Ребенок,
	               |	МЕСЯЦ(удуСведенияОПосещаемостиДОУ.Период) + ГОД(удуСведенияОПосещаемостиДОУ.Период) * 100 КАК МесяцПосещения,
	               |	СУММА(ВЫБОР
	               |			КОГДА удуСведенияОПосещаемостиДОУ.ПризнакПрисутствия
	               |				ТОГДА 1
	               |			ИНАЧЕ 0
	               |		КОНЕЦ) КАК КоличествоДней
	               |ПОМЕСТИТЬ ВТ_Посещение
	               |ИЗ
	               |	РегистрСведений.удуСведенияОПосещаемостиДОУ КАК удуСведенияОПосещаемостиДОУ
	               |ГДЕ
	               |	(удуСведенияОПосещаемостиДОУ.Период МЕЖДУ &ПериодНач И &ПериодКон
	               |				И удуСведенияОПосещаемостиДОУ.Группа = &Группа
	               |			ИЛИ &Группа = ЗНАЧЕНИЕ(Справочник.удуГруппыУчреждения.ПустаяСсылка))
	               |	И удуСведенияОПосещаемостиДОУ.Учреждение = &Учреждение
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	удуСведенияОПосещаемостиДОУ.Учреждение,
	               |	удуСведенияОПосещаемостиДОУ.Группа,
	               |	удуСведенияОПосещаемостиДОУ.Ребенок,
	               |	МЕСЯЦ(удуСведенияОПосещаемостиДОУ.Период) + ГОД(удуСведенияОПосещаемостиДОУ.Период) * 100
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЕСТЬNULL(ВТ_Оплаты.Учреждение, ВТ_Посещение.Учреждение) КАК Учреждение,
	               |	ЕСТЬNULL(ВТ_Оплаты.Ребенок, ВТ_Посещение.Ребенок) КАК Ребенок,
	               |	ЕСТЬNULL(ВТ_Оплаты.МесяцПосещения, ВТ_Посещение.МесяцПосещения) КАК МесяцПосещения,
	               |	ЕСТЬNULL(ВТ_Посещение.Группа, ВТ_Оплаты.Группа) КАК Группа,
	               |	ЕСТЬNULL(ВТ_Оплаты.Сумма, 0) КАК СуммаОплаты,
	               |	ВТ_Оплаты.Период КАК ПериодОплаты,
	               |	ЕСТЬNULL(ВТ_Посещение.КоличествоДней, 0) КАК КоличествоДней
	               |ИЗ
	               |	ВТ_Оплаты КАК ВТ_Оплаты
	               |		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_Посещение КАК ВТ_Посещение
	               |		ПО ВТ_Оплаты.МесяцПосещения = ВТ_Посещение.МесяцПосещения
	               |			И ВТ_Оплаты.Ребенок = ВТ_Посещение.Ребенок
	               |			И ВТ_Оплаты.Учреждение = ВТ_Посещение.Учреждение
	               |ИТОГИ
	               |	СУММА(СуммаОплаты),
	               |	СУММА(КоличествоДней)
	               |ПО
	               |	Группа,
	               |	Ребенок,
	               |	МесяцПосещения
	               |АВТОУПОРЯДОЧИВАНИЕ";			   
				   
				   
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ПериодНач", НачалоДня(Отчет.ДатаНачало));
	Запрос.УстановитьПараметр("ПериодКон", КонецДня(Отчет.ДатаОкончания));
	Запрос.УстановитьПараметр("ПериодНачОплаты", ДобавитьМесяц(НачалоДня(Отчет.ДатаНачало), 1));
	Запрос.УстановитьПараметр("ПериодКонОплаты", ДобавитьМесяц(КонецДня(Отчет.ДатаОкончания), 1));
	Запрос.УстановитьПараметр("ПустойРегистратор", Документы.удуКвитанцияОбОплатеПосещенияДОУ.ПустаяСсылка());
	Запрос.УстановитьПараметр("Группа", Отчет.Группа);
	Запрос.УстановитьПараметр("Учреждение", Отчет.Учреждение);
		
	сэРезультатВыполнения = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	РезультирующаяТаблица = Новый ТабличныйДокумент;
	
	Макет = РеквизитФормыВЗначение("Отчет").ПолучитьМакет("МакетОсновной");
	
	СекцияЗаголовокОтчета = Макет.ПолучитьОбласть("Шапка|Основная");
	СекцияЗаголовокОтчета.Параметры.ПериодФормированияОтчета = ПредставлениеПериода(НачалоДня(Отчет.ДатаНачало), КонецДня(Отчет.ДатаОкончания), "ФП=Истина");
	РезультирующаяТаблица.Вывести(СекцияЗаголовокОтчета);
	
	
	СписокМесяцев = Новый СписокЗначений;	
	ПеременнаяДата = Отчет.ДатаНачало;
	Пока ПеременнаяДата < КонецДня(Отчет.ДатаОкончания) Цикл
		СписокМесяцев.Добавить(Месяц(ПеременнаяДата) + (Год(ПеременнаяДата) * 100));
		СекцияШапкаМесяц = Макет.ПолучитьОбласть("Шапка|Месяц");
		СекцияШапкаМесяц.Параметры.МесяцОтчета = ПредставлениеПериода(НачалоМесяца(ПеременнаяДата), КонецМесяца(ПеременнаяДата), "ФП=Истина");
		РезультирующаяТаблица.Присоединить(СекцияШапкаМесяц);
		ПеременнаяДата = ДобавитьМесяц(ПеременнаяДата, 1);		
	КонецЦикла;	
	
	СекцияСтрокаГруппы = Макет.ПолучитьОбласть("СтрокаГруппа|Основная");
	СекцияСтрокаРебенок = Макет.ПолучитьОбласть("СтрокаРебенок|Основная");
	
	Для Каждого СтрокаГруппы Из сэРезультатВыполнения.Строки Цикл
		// цикл по группам
		СекцияСтрокаГруппы.Параметры.ГруппаНаименование = СокрЛП(СтрокаГруппы.Группа.Наименование);
		СекцияСтрокаГруппы.Параметры.ГруппаСсылка = СтрокаГруппы.Группа;
		РезультирующаяТаблица.Вывести(СекцияСтрокаГруппы);
		НПП = 0;
		Для Каждого СтрокаРебенок Из СтрокаГруппы.Строки Цикл
			// цикл по детям
			НПП = НПП + 1;
			СекцияСтрокаРебенок.Параметры.НПП = НПП;
			СекцияСтрокаРебенок.Параметры.ФИОРебенка = СокрЛП(СтрокаРебенок.Ребенок.Наименование);
			СекцияСтрокаРебенок.Параметры.ДатаРождения = СтрокаРебенок.Ребенок.ДатаРождения;
			РезультирующаяТаблица.Вывести(СекцияСтрокаРебенок);
			
			Для Сч = 0 По СписокМесяцев.Количество() - 1 Цикл
				// цикл по датам посещения
				
				СекцияСтрокаМесяц = Макет.ПолучитьОбласть("СтрокаРебенок|Месяц");
				
				ТекущийМесяц = СписокМесяцев.Получить(Сч);				
				СтрокаПосещения = СтрокаРебенок.Строки.Найти(ТекущийМесяц.Значение, "МесяцПосещения");
				Если СтрокаПосещения = Неопределено Тогда
					СекцияСтрокаМесяц.Параметры.КоличествоДней = "- - -";
					СекцияСтрокаМесяц.Параметры.ПланДатаОплаты = "- - -";					
					СекцияСтрокаМесяц.Параметры.ФактДатаОплаты = "- - -";
					СекцияСтрокаМесяц.Параметры.СуммаОплаты = "- - -";
					Если ФлагРаскрашиватьОтчет Тогда
						СекцияСтрокаМесяц.Область().ЦветФона = ЦветФонаНетСведений;
					КонецЕсли;
					РезультирующаяТаблица.Присоединить(СекцияСтрокаМесяц);
				Иначе
					СекцияСтрокаМесяц.Параметры.КоличествоДней = СтрокаПосещения.КоличествоДней;
					ГодПосещения = Число(Лев(Формат(ТекущийМесяц.Значение,"ЧГ=6"), 4));
					МесяцПосещения = Число(Прав(Формат(ТекущийМесяц.Значение,"ЧГ=6"), 2));
					Если ЗначениеЗаполнено(Отчет.Учреждение.ДеньОплаты) Тогда 
						СекцияСтрокаМесяц.Параметры.ПланДатаОплаты = ДобавитьМесяц(Дата(ГодПосещения, МесяцПосещения, Отчет.Учреждение.ДеньОплаты), 1);
					Иначе 
						СекцияСтрокаМесяц.Параметры.ПланДатаОплаты = ДобавитьМесяц(Дата(ГодПосещения, МесяцПосещения, 1), 1);
					КонецЕсли;
					// теперь получаем сведения об оплате
					СтрокаОплаты = СтрокаПосещения.Строки[0];
					Если СтрокаОплаты.ПериодОплаты = Null Тогда
						СекцияСтрокаМесяц.Параметры.ФактДатаОплаты = "- - -";
						СекцияСтрокаМесяц.Параметры.СуммаОплаты = "- - -";
						Если ФлагРаскрашиватьОтчет Тогда							
							СекцияСтрокаМесяц.Область().ЦветФона = ЦветФонаДолжники;
						КонецЕсли;
					Иначе
						СекцияСтрокаМесяц.Параметры.ФактДатаОплаты = СтрокаОплаты.ПериодОплаты;
						СекцияСтрокаМесяц.Параметры.СуммаОплаты = СтрокаОплаты.СуммаОплаты;
						Если День(СтрокаОплаты.ПериодОплаты) > Отчет.Учреждение.ДеньОплаты Тогда
							Если ФлагРаскрашиватьОтчет Тогда
								СекцияСтрокаМесяц.Область().ЦветФона = ЦветФонаПросрочка;
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;					
					РезультирующаяТаблица.Присоединить(СекцияСтрокаМесяц);
					
				КонецЕсли;				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Возврат РезультирующаяТаблица	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Отчет.Учреждение) Тогда
		Отчет.Учреждение = Константы.удуОсновноеУчреждение.Получить();
	КонецЕсли;	
	
	Отчет.ДатаНачало = НачалоМесяца(ТекущаяДата());
	Отчет.ДатаОкончания = КонецМесяца(ТекущаяДата());
	
	Элементы.ГруппаОформление.Видимость = ФлагРаскрашиватьОтчет;
	ЦветФонаДолжники = Новый Цвет(255, 192, 203);
	ЦветФонаПросрочка = Новый Цвет(255, 250, 205);	
	ЦветФонаНетСведений = Новый Цвет(220, 220, 220);	
	
	ФлагРаскрашиватьОтчет = Истина;
	Элементы.ГруппаОформление.Видимость = ФлагРаскрашиватьОтчет;
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	// Вставить содержимое обработчика.
	ОтказОтФормирования = Ложь;
	Если Не ЗначениеЗаполнено(Отчет.Учреждение) Тогда
		Вопрос("Перед формированием отчета обязательно укажите учреждение", РежимДиалогаВопрос.ОК);
		ОтказОтФормирования = Истина;
	ИначеЕсли Не ЗначениеЗаполнено(Отчет.ДатаНачало) Тогда
		Вопрос("Перед формированием отчета обязательно укажите дату начала формирования отчета", РежимДиалогаВопрос.ОК);
		ОтказОтФормирования = Истина;
	ИначеЕсли Не ЗначениеЗаполнено(Отчет.ДатаОкончания) Тогда
		Вопрос("Перед формированием отчета обязательно укажите дату окончания формирования отчета", РежимДиалогаВопрос.ОК);
		ОтказОтФормирования = Истина;
	ИначеЕсли Отчет.ДатаОкончания < Отчет.ДатаНачало Тогда
		Вопрос("Дата окончания отчета должна быть больше или равна дате начала отчета", РежимДиалогаВопрос.ОК);
		ОтказОтФормирования = Истина;
	КонецЕсли;	
	
	Если Не ОтказОтФормирования Тогда
		ОсновнаяТаблица = СформироватьОтчетНаСервере();
		
		ОсновнаяТаблица.ОтображатьЗаголовки = Ложь;
		ОсновнаяТаблица.ОтображатьСетку = Ложь;
		ОсновнаяТаблица.АвтоМасштаб = Истина;
		ОсновнаяТаблица.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;	
		ОсновнаяТаблица.ТолькоПросмотр = Истина;
				
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ФлагРаскрашиватьОтчетПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	Элементы.ГруппаОформление.Видимость = ФлагРаскрашиватьОтчет;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодОтчета(Команда)
	// Вставить содержимое обработчика.
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	
	Диалог.Период.ДатаНачала    = Отчет.ДатаНачало;
	Диалог.Период.ДатаОкончания = Отчет.ДатаОкончания;
	
	Если Диалог.Редактировать() Тогда		
		Отчет.ДатаНачало = НачалоМесяца(Диалог.Период.ДатаНачала);
		Отчет.ДатаОкончания = КонецМесяца(Диалог.Период.ДатаОкончания);
	КонецЕсли;		
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалоПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	Если ЗначениеЗаполнено(Отчет.ДатаНачало) Тогда
		Отчет.ДатаНачало = НачалоМесяца(Отчет.ДатаНачало);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	Если ЗначениеЗаполнено(Отчет.ДатаОкончания) Тогда
		Отчет.ДатаОкончания = КонецМесяца(Отчет.ДатаОкончания);
	КонецЕсли;
КонецПроцедуры
