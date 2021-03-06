&НаСервере
Функция СформироватьПечатнуюФормуСпискаДетей()
	ТекстЗапроса = "ВЫБРАТЬ
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Ребенок.Ссылка,
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Ребенок.Наименование КАК Наименование,
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Ребенок.Пол КАК Пол,
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Ребенок.Национальность КАК Национальность,
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Ребенок.РоднойЯзык КАК РоднойЯзык,
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Ребенок.ДатаРождения КАК ДатаРождения,
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Ребенок.СерияСвидетельства КАК СерияСвидетельства,
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Ребенок.НомерСвидетельства КАК НомерСвидетельства,
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Ребенок.ДатаВыдачиСвидетельства КАК ДатаВыдачиСвидетельства,
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Ребенок.СоциальноеПоложение КАК СоциальноеПоложение,
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Ребенок.ЖилищныеУсловия КАК ЖилищныеУсловия,
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Ребенок.МатериальноеПоложение КАК МатериальноеПоложение,
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Регистратор.Ссылка,
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Регистратор.Номер,
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Регистратор.Дата,
	               |	ВЫБОР
	               |		КОГДА удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Регистратор.Ссылка ССЫЛКА Документ.удуПриказОЗачисленииРебенкаВГруппу
	               |			ТОГДА ""Приказ о зачислении №""
	               |		ИНАЧЕ ""Приказ о переводе № ""
	               |	КОНЕЦ КАК РегистраторВид
	               |ИЗ
	               |	РегистрСведений.удуСведенияОЗачисленииРебенкаВГруппу.СрезПоследних(&ДатаОтчета, Группа = &Группа) КАК удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних
	               |ГДЕ
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.СостояниеУчетаВГруппе = &СостояниеУчетаВГруппе
	               |АВТОУПОРЯДОЧИВАНИЕ";				   
				   
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДатаОтчета", КонецДня(ДатаПечатиСписка));
	Запрос.УстановитьПараметр("Группа", ПараметрГруппа);
	Запрос.УстановитьПараметр("СостояниеУчетаВГруппе", Перечисления.удуСостояниеРебенкаНаУчетеВГруппе.ПринятВГруппу);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();	
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Макет = ПараметрГруппа.ПолучитьОбъект().ПолучитьМакет("Макет");
	
	СекцияШапка = Макет.ПолучитьОбласть("Шапка|Наименование");
	СекцияШапка.Параметры.НаименованиеГруппы = СокрЛП(ПараметрГруппа.Наименование);
	СекцияШапка.Параметры.ДатаФормирования = Формат(ДатаПечатиСписка, "ДЛФ=D");
	ТабличныйДокумент.Вывести(СекцияШапка);
	
	// динамически формируем шапку отчета
	Для Каждого СтрокаНастройкиОтчета Из СписокПечатаемыхРеквизитов Цикл
		Если СтрокаНастройкиОтчета.Использование Тогда
			Если СтрокаНастройкиОтчета.НаименованиеРеквизита <> "Наименование" Тогда
				СекцияШапкаРеквизит = Макет.ПолучитьОбласть("Шапка|" + СокрЛП(СтрокаНастройкиОтчета.НаименованиеРеквизита));
				ТабличныйДокумент.Присоединить(СекцияШапкаРеквизит);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;	
	
	НПП = 0;
	Для Каждого СтрокаРезультатЗапроса Из РезультатЗапроса Цикл
		НПП = НПП + 1;
		СекцияСтрока = Макет.ПолучитьОбласть("Строка|Наименование");
		СекцияСтрока.Параметры.НПП = НПП;
		СекцияСтрока.Параметры.Заполнить(СтрокаРезультатЗапроса);
		ТабличныйДокумент.Вывести(СекцияСтрока);
		
		// динамически формируем строки отчета
		Для Каждого СтрокаНастройкиОтчета Из СписокПечатаемыхРеквизитов Цикл
			Если СтрокаНастройкиОтчета.Использование Тогда
				Если СтрокаНастройкиОтчета.НаименованиеРеквизита = "АдресМестаРождения" Тогда
					СекцияСтрокаРеквизит = Макет.ПолучитьОбласть("Строка|АдресМестаРождения");
					НайденнаяСтрокаМестаРождения = СтрокаРезультатЗапроса.РебенокСсылка.КонтактнаяИнформация.Найти(Справочники.ВидыКонтактнойИнформации.АдресМестаРожденияРебенка);
					Если НайденнаяСтрокаМестаРождения <> Неопределено Тогда
						СекцияСтрокаРеквизит.Параметры.ПараметрАдресРождения = СокрЛП(НайденнаяСтрокаМестаРождения.Представление);
					Иначе
						СекцияСтрокаРеквизит.Параметры.ПараметрАдресРождения = "";
					КонецЕсли;
					ТабличныйДокумент.Присоединить(СекцияСтрокаРеквизит);
				ИначеЕсли СтрокаНастройкиОтчета.НаименованиеРеквизита = "АдресМестаПроживания" Тогда
					СекцияСтрокаРеквизит = Макет.ПолучитьОбласть("Строка|АдресМестаПроживания");
					НайденнаяСтрокаМестаПроживания = СтрокаРезультатЗапроса.РебенокСсылка.КонтактнаяИнформация.Найти(Справочники.ВидыКонтактнойИнформации.АдресМестаПроживанияРебенка);
					Если НайденнаяСтрокаМестаПроживания <> Неопределено Тогда
						СекцияСтрокаРеквизит.Параметры.ПараметрАдресПроживания = СокрЛП(НайденнаяСтрокаМестаПроживания.Представление);
					Иначе
						СекцияСтрокаРеквизит.Параметры.ПараметрАдресПроживания = "";
					КонецЕсли;
					ТабличныйДокумент.Присоединить(СекцияСтрокаРеквизит);
				ИначеЕсли СтрокаНастройкиОтчета.НаименованиеРеквизита = "Регистратор" Тогда
					СекцияСтрокаРеквизит = Макет.ПолучитьОбласть("Строка|Регистратор");
					СекцияСтрокаРеквизит.Параметры.РегистраторВид = СтрокаРезультатЗапроса.РегистраторВид + удуФормированиеПечатныхФорм.ПолучитьНомерНаПечать(СтрокаРезультатЗапроса.РегистраторНомер);
					СекцияСтрокаРеквизит.Параметры.РегистраторДата = СтрокаРезультатЗапроса.Регистратордата;
					СекцияСтрокаРеквизит.Параметры.РегистраторСсылка = СтрокаРезультатЗапроса.РегистраторСсылка;
					ТабличныйДокумент.Присоединить(СекцияСтрокаРеквизит);						
				Иначе
					СекцияСтрокаРеквизит = Макет.ПолучитьОбласть("Строка|" + СокрЛП(СтрокаНастройкиОтчета.НаименованиеРеквизита));
					СекцияСтрокаРеквизит.Параметры.Заполнить(СтрокаРезультатЗапроса);
					ТабличныйДокумент.Присоединить(СекцияСтрокаРеквизит);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;		
	КонецЦикла;	
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	// Заполним список печатаемых реквизитов	
	Для Каждого РеквизитСправочникаДети Из Справочники.удуДети.ПустаяСсылка().Метаданные().Реквизиты Цикл
		Если СокрЛП(РеквизитСправочникаДети.Имя) = "СтатусРебенка" Тогда
			Продолжить;
		КонецЕсли;
		Если СокрЛП(РеквизитСправочникаДети.Имя) = "Фамилия" Тогда
			Продолжить;
		КонецЕсли;
		Если СокрЛП(РеквизитСправочникаДети.Имя) = "Имя" Тогда
			Продолжить;
		КонецЕсли;
		Если СокрЛП(РеквизитСправочникаДети.Имя) = "Отчество" Тогда
			Продолжить;
		КонецЕсли;
		Если СокрЛП(РеквизитСправочникаДети.Имя) = "ФотографияРебенка" Тогда
			Продолжить;
		КонецЕсли;		
		Если СокрЛП(РеквизитСправочникаДети.Имя) = "СерияСвидетельства" Тогда
			Продолжить;
		КонецЕсли;
		Если СокрЛП(РеквизитСправочникаДети.Имя) = "НомерСвидетельства" Тогда
			Продолжить;
		КонецЕсли;
		Если СокрЛП(РеквизитСправочникаДети.Имя) = "ДатаВыдачиСвидетельства" Тогда
			Продолжить;
		КонецЕсли;				
		Если СокрЛП(РеквизитСправочникаДети.Имя) = "ОрганВыдачиСвидетельства" Тогда
			Продолжить;
		КонецЕсли;
		Если СокрЛП(РеквизитСправочникаДети.Имя) = "ДополнительныеСоциальныеСведения" Тогда
			Продолжить;
		КонецЕсли;				
		Если (СокрЛП(РеквизитСправочникаДети.Имя) = "Национальность") И (НЕ Константы.удуИспользоватьПерсональныеДанные.Получить()) Тогда
			Продолжить;
		КонецЕсли;				
		Если (СокрЛП(РеквизитСправочникаДети.Имя) = "СоциальноеПоложение") И (НЕ Константы.удуИспользоватьПерсональныеДанные.Получить()) Тогда
			Продолжить;
		КонецЕсли;				
		Если (СокрЛП(РеквизитСправочникаДети.Имя) = "МатериальноеПоложение") И (НЕ Константы.удуИспользоватьПерсональныеДанные.Получить()) Тогда
			Продолжить;
		КонецЕсли;				
		
		НоваяСтрокаСписка = СписокПечатаемыхРеквизитов.Добавить();
		НоваяСтрокаСписка.Использование = Истина;
		НоваяСтрокаСписка.НаименованиеРеквизита = СокрЛП(РеквизитСправочникаДети.Имя);
		НоваяСтрокаСписка.СинонимРеквизита = СокрЛП(РеквизитСправочникаДети.Синоним);		
	КонецЦикла;	
	
	НоваяСтрокаСписка = СписокПечатаемыхРеквизитов.Добавить();
	НоваяСтрокаСписка.Использование = Истина;
	НоваяСтрокаСписка.НаименованиеРеквизита = "СвидетельствоОРождении";	
	НоваяСтрокаСписка.СинонимРеквизита = "Сведения свидетельства о рождении";	
	
	НоваяСтрокаСписка = СписокПечатаемыхРеквизитов.Добавить();
	НоваяСтрокаСписка.Использование = Истина;
	НоваяСтрокаСписка.НаименованиеРеквизита = "Регистратор";	
	НоваяСтрокаСписка.СинонимРеквизита = "Сведения о зачислении/переводе в группу";	
	
	ДатаПечатиСписка = ТекущаяДата();
КонецПроцедуры

&НаКлиенте
Процедура КомандаПечатьСписка(Команда)
	// Вставить содержимое обработчика.
	ТабличныйДокумент = СформироватьПечатнуюФормуСпискаДетей();
	
	ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
	ТабличныйДокумент.ОтображатьСетку = Ложь;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;	
	ТабличныйДокумент.ТолькоПросмотр = Истина;
	ТабличныйДокумент.ФиксацияСлева = 2;	
	ТабличныйДокумент.Показать();	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтметитьВсе(Команда)
	// Вставить содержимое обработчика.
	Для Каждого СтрокаРеквизита Из СписокПечатаемыхРеквизитов Цикл
		СтрокаРеквизита.Использование = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура КомандаСнятьВсе(Команда)
	// Вставить содержимое обработчика.
	Для Каждого СтрокаРеквизита Из СписокПечатаемыхРеквизитов Цикл
		СтрокаРеквизита.Использование = Ложь;
	КонецЦикла;	
КонецПроцедуры
