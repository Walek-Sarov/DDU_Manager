&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Макет = Справочники.удуКлассификаторЕдиницИзмерения.ПолучитьМакет("КлассификаторЕдиницИзмерения");

	Макет.Параметры.Расшифровка = Истина; // чтобы работала расшифровка

	
	ПолеТабличногоДокумента.Вывести(Макет);
	
	ПолеТабличногоДокумента.ФиксацияСверху      = ПолеТабличногоДокумента.Области.ОбластьРасшифровки.Верх - 1;
	ПолеТабличногоДокумента.ОтображатьЗаголовки = Ложь;
	ПолеТабличногоДокумента.ОтображатьСетку     = Ложь;
	ПолеТабличногоДокумента.ТолькоПросмотр      = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеТабличногоДокументаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
    СтандартнаяОбработка = Ложь;

	// Получение значений полей выбранной строки.

	ТабличныйДокумент = Элементы.ПолеТабличногоДокумента;
	ТекущаяОбласть    = ПолеТабличногоДокумента.ТекущаяОбласть;

	ОбластьКодЧисловой         = ПолеТабличногоДокумента.Области.КодЧисловой;
	ОбластьНаименованиеКраткое = ПолеТабличногоДокумента.Области.НаименованиеКраткое;
	ОбластьНаименованиеПолное  = ПолеТабличногоДокумента.Области.НаименованиеПолное;

	КодЧисловой         = ПолеТабличногоДокумента.Область(ТекущаяОбласть.Верх, ОбластьКодЧисловой.        Лево, ТекущаяОбласть.Низ, ОбластьКодЧисловой.        Право).Текст;
	НаименованиеКраткое = ПолеТабличногоДокумента.Область(ТекущаяОбласть.Верх, ОбластьНаименованиеКраткое.Лево, ТекущаяОбласть.Низ, ОбластьНаименованиеКраткое.Право).Текст;
	НаименованиеПолное  = ПолеТабличногоДокумента.Область(ТекущаяОбласть.Верх, ОбластьНаименованиеПолное. Лево, ТекущаяОбласть.Низ, ОбластьНаименованиеПолное. Право).Текст;

		
	// Проверка наличия выбранной единицы измерения.

	Ссылка = НайтиЕдиницуПоКоду(КодЧисловой);

	Если НЕ Ссылка.Пустая() Тогда
		Вопрос = "В справочнике ""Классификатор единиц измерения"" уже существует элемент с кодом """ + КодЧисловой + """! Открыть существующий?";
		Ответ  = Вопрос(Вопрос, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Отмена, );

		Если      Ответ = КодВозвратаДиалога.Да Тогда
			
			НавСсылка = ПолучитьНавигационнуюСсылку(Ссылка);	
			ПерейтиПоНавигационнойСсылке(НавСсылка);	
			Возврат;
			
		ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;

	// Создание новой единицы измерения.

	СоздатьНовыйЭлемент(КодЧисловой, НаименованиеКраткое, НаименованиеПолное);
	
КонецПроцедуры

&НаСервере
Функция НайтиЕдиницуПоКоду(КодЧисловой);
	
	Возврат(Справочники.удуКлассификаторЕдиницИзмерения.НайтиПоКоду(КодЧисловой));
	
КонецФункции

&НаКлиенте
Процедура СоздатьНовыйЭлемент(КодЧисловой, НаименованиеКраткое, НаименованиеПолное)
	
	ЗначенияЗаполнения = Новый Структура();
	ЗначенияЗаполнения.Вставить("КодЧисловой",  КодЧисловой);
	ЗначенияЗаполнения.Вставить("НаименованиеКраткое", СтрПолучитьСтроку(НаименованиеКраткое, 1));
	ЗначенияЗаполнения.Вставить("НаименованиеПолное", СтрПолучитьСтроку(НаименованиеПолное, 1));
	
	СтруктураПараметров = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Справочник.удуКлассификаторЕдиницИзмерения.ФормаОбъекта", СтруктураПараметров);
	
КонецПроцедуры

