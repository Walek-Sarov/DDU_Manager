////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Обработчик события ПриОткрытии формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Макет = Справочники.удуОснованияУвольненияИзОрганизации.ПолучитьМакет("СписокОснованийУвольнения");

	Макет.Параметры.Расшифровка = Истина; // чтобы работала расшифровка

	ТабличныйДокумент = Классификатор;
	
	ТабличныйДокумент.Очистить();
	ТабличныйДокумент.Вывести(Макет);

	ТабличныйДокумент.ФиксацияСверху      = 3;

	ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
	ТабличныйДокумент.ОтображатьСетку     = Ложь;
	ТабличныйДокумент.ТолькоПросмотр      = Истина;
	
КонецПроцедуры

&НаСервере
Функция НайтиЭлемент(Наименование)
	
	 Возврат Справочники.удуОснованияУвольненияИзОрганизации.НайтиПоНаименованию(Наименование);
	 
КонецФункции

&НаКлиенте
Процедура КлассификаторОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	// Получение значений полей выбранной строки.
	ТабличныйДокумент = Классификатор;
	ТекущаяОбласть    = ТабличныйДокумент.ТекущаяОбласть;

	ОбластьКод          = ТабличныйДокумент.Области.Код;
	ОбластьНаименование = ТабличныйДокумент.Области.Наименование;
	ОбластьСтатья	    = ТабличныйДокумент.Области.Статья;
	
	Если ТекущаяОбласть.Низ = ТекущаяОбласть.Верх Тогда
		
		Наименование          = ТабличныйДокумент.Область(ТекущаяОбласть.Верх, ОбластьНаименование.Лево, ТекущаяОбласть.Низ, ОбластьНаименование.Право).Текст;
		Статья = ТабличныйДокумент.Область(ТекущаяОбласть.Верх, ОбластьСтатья.Лево, ТекущаяОбласть.Низ, ОбластьСтатья.Право).Текст;
		
		// Проверка наличия выбранного элемента.
		Ссылка=НайтиЭлемент(Статья);

		Если НЕ Ссылка.Пустая() Тогда
			
			Вопрос = "В справочнике ""Основания увольнения из организации"" уже существует элемент с наименованием """ + Статья + """! Открыть существующий?";
			Ответ  = Вопрос(Вопрос, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Отмена, );
			
			Если      Ответ = КодВозвратаДиалога.Да Тогда
				
				ФормаЭлемента=ПолучитьФорму("Справочник.удуОснованияУвольненияИзОрганизации.Форма.ФормаЭлемента",Новый Структура("Ключ",Ссылка),ВладелецФормы, );
				ФормаЭлемента.Открыть();
				Возврат;

			ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
				Возврат;
			КонецЕсли;
			
		КонецЕсли;

		// Создание нового элемента справочника.
		ФормаНовогоЭлемента = ПолучитьФорму("Справочник.удуОснованияУвольненияИзОрганизации.Форма.ФормаЭлемента", ,ВладелецФормы, );
		ФормаНовогоЭлемента.Объект.Наименование = Статья;
		ФормаНовогоЭлемента.Объект.ТекстОснования = Наименование;
		ФормаНовогоЭлемента.Открыть();
	КонецЕсли;	
	
	
	
КонецПроцедуры
