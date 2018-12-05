&НаСервере
Функция СформироватьПечатнуюФормуНаСервере()
	ПечатнаяФорма = Новый ТабличныйДокумент;
	
	ДокументОбъект = Элементы.Список.ВыделенныеСтроки[0];
	
	Макет = ДокументОбъект.ПолучитьОбъект().ПолучитьМакет("Макет");
	
	СекцияШапка = Макет.ПолучитьОбласть("Шапка");
	СекцияСтрока = Макет.ПолучитьОбласть("Строка");
	
	ПечатнаяФорма.Вывести(СекцияШапка);
	
	Для Каждого ДокументВМассиве Из Элементы.Список.ВыделенныеСтроки Цикл
		Если ДокументВМассиве.Проведен Тогда
			Для Каждого СтрокаВоспитанник Из ДокументВМассиве.ТабличнаяЧастьВоспитанники Цикл
				СекцияСтрока.Параметры.НомерИДатаПриказа = "Приказ о выбытии №" + удуФормированиеПечатныхФорм.ПолучитьНомерНаПечать(ДокументВМассиве.Номер) + " от " + Формат(ДокументВМассиве.Дата, "ДЛФ=D");
				СекцияСтрока.Параметры.СсылкаНаДокумент = ДокументВМассиве;
				
				МассивФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаВоспитанник.Ребенок.Наименование, " ");
				ПредставлениеФИО = "";
				Если МассивФИО.Количество() = 3 Тогда 
					ПредставлениеФИО = СокрЛП(МассивФИО[0]) + " " + Лев(МассивФИО[1], 1) + ". " + Лев(МассивФИО[2], 1) + ".";
				ИначеЕсли МассивФИО.Количество() = 2 Тогда
					ПредставлениеФИО = СокрЛП(МассивФИО[0]) + " " + Лев(МассивФИО[1], 1) + ".";
				Иначе
					ПредставлениеФИО = СокрЛП(МассивФИО[0])
				КонецЕсли;
				
			    СекцияСтрока.Параметры.ФИОРебенка = ПредставлениеФИО;
				СекцияСтрока.Параметры.Ребенок = СтрокаВоспитанник.Ребенок;
				СекцияСтрока.Параметры.ДатаРождения = СтрокаВоспитанник.Ребенок.ДатаРождения;
				
				СекцияСтрока.Параметры.ГруппаНаименование = СокрЛП(ДокументВМассиве.ГруппаВыбытия.Наименование);
				СекцияСтрока.Параметры.Группа = ДокументВМассиве.ГруппаВыбытия;
				СекцияСтрока.Параметры.ДатаВыбытия = ДокументВМассиве.ДатаФактическогоВыбытия;
				
				СекцияСтрока.Параметры.ПричинаВыбытия = СтрокаВоспитанник.ПричинаВыбытия;
				
				СекцияСтрока.Параметры.РодительНаименование = СокрЛП(СтрокаВоспитанник.ОснованиеЗачисленияВГруппу.Родитель.Наименование);
				
				// получим степень родства родителя
				Отбор = Новый Структура;
				Отбор.Вставить("Ребенок", СтрокаВоспитанник.ОснованиеЗачисленияВГруппу.Ребенок);
				Отбор.Вставить("ЧленСемьи", СтрокаВоспитанник.ОснованиеЗачисленияВГруппу.Родитель);
				СтепеньРодства = РегистрыСведений.удуСоставСемьиРебенка.ПолучитьПоследнее(ТекущаяДата(), Отбор).СтепеньРодства;
				Если ЗначениеЗаполнено(СтепеньРодства) Тогда
					СекцияСтрока.Параметры.РодительНаименование = СекцияСтрока.Параметры.РодительНаименование + " (" + СокрЛП(СтепеньРодства.Наименование) + ")";	
				КонецЕсли;
				// получим степень родства родителя
				
				СекцияСтрока.Параметры.Родитель = СтрокаВоспитанник.ОснованиеЗачисленияВГруппу.Родитель;
				
				ПечатнаяФорма.Вывести(СекцияСтрока);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПечатнаяФорма;
КонецФункции

&НаКлиенте
Процедура КомандаПечатьКнигиПриказов(Команда)
	// Вставить содержимое обработчика.
	Если Элементы.Список.ВыделенныеСтроки.Количество() > 0 Тогда
		ТабличныйДокумент = СформироватьПечатнуюФормуНаСервере();		
		
		ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
		ТабличныйДокумент.ОтображатьСетку = Ложь;
		ТабличныйДокумент.АвтоМасштаб = Истина;
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;	
		ТабличныйДокумент.ТолькоПросмотр = Истина;		
		ТабличныйДокумент.Показать();	
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
КонецПроцедуры
