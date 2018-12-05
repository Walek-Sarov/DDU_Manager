
&НаКлиенте
Перем ПерваяАктивизацияГруппыПользователей;

&НаКлиенте
Перем ВыбиратьИерархическиПриОткрытии;

// Процедуры и функции формы

&НаКлиенте
Процедура ОбработкаОжиданияПриАктивизацииГруппыПользователей()
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСодержимоеФормыПриИзмененииГруппы()
	
	Если Элементы.ГруппыПользователей.ТекущаяСтрока = Справочники.ГруппыПользователей.ВсеПользователи Тогда
		Элементы.ГруппаПоказыватьПользователейДочернихГрупп.ТекущаяСтраница = 
				Элементы.ГруппаНельзяУстановитьСвойство;
		ПользователиСписок.Параметры.УстановитьЗначениеПараметра("ВыбиратьИерархически", Истина);
	Иначе
		Элементы.ГруппаПоказыватьПользователейДочернихГрупп.ТекущаяСтраница = 
				Элементы.ГруппаУстановитьСвойство;
		ПользователиСписок.Параметры.УстановитьЗначениеПараметра("ВыбиратьИерархически", ВыбиратьИерархически);
	КонецЕсли;
	
	ПользователиСписок.Параметры.УстановитьЗначениеПараметра("ГруппаПользователей", Элементы.ГруппыПользователей.ТекущаяСтрока);
	ПользователиСписок.Параметры.УстановитьЗначениеПараметра("ПустойУникальныйИдентификатор", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкиФормы(ВыбиратьИерархически)
	
	ХранилищеНастроекДанныхФорм.Сохранить("СправочникПользователиФормаСписка", "ВыбиратьИерархически", ВыбиратьИерархически);
	
КонецПроцедуры


// Обработчики событий формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Значение = ХранилищеНастроекДанныхФорм.Загрузить("СправочникПользователиФормаСписка", "ВыбиратьИерархически");
	ВыбиратьИерархически = ?(Значение = Неопределено, Истина, Значение);
	
	Если ТипЗнч(Параметры.ТекущаяСтрока) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
		Элементы.ГруппыПользователей.ТекущаяСтрока = Параметры.ТекущаяСтрока;
	Иначе
		Элементы.ГруппыПользователей.ТекущаяСтрока = Справочники.ГруппыПользователей.ВсеПользователи;
		Если ТипЗнч(Параметры.ТекущаяСтрока) = Тип("СправочникСсылка.Пользователи") Тогда
			ТекущийЭлемент = Элементы.ПользователиСписок;
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы();
	
	Параметры.Свойство("ВыборГруппПользователей", ВыборГруппПользователей);
	Элементы.ВыбратьГруппыПользователей.Видимость = ВыборГруппПользователей;
	Элементы.ГруппыПользователей.РежимВыбора      = ВыборГруппПользователей;
	Элементы.Выбрать.КнопкаПоУмолчанию            = НЕ ВыборГруппПользователей;

	
	Если Параметры.ЗакрыватьПриВыборе = Неопределено ИЛИ Параметры.ЗакрыватьПриВыборе Тогда
		
		Если ВыборГруппПользователей Тогда
			Заголовок                  = НСтр("ru = 'Выбор пользователя или группы'");
			Элементы.Выбрать.Заголовок = НСтр("ru = 'Выбрать пользователя'");
		Иначе
			Заголовок                  = НСтр("ru = 'Выбор пользователя'");
		КонецЕсли;
	Иначе
		Элементы.ПользователиСписок.МножественныйВыбор = Истина;
		Элементы.ПользователиСписок.РежимВыделения = РежимВыделенияТаблицы.Множественный;
		
		Если ВыборГруппПользователей Тогда
			Заголовок                  = НСтр("ru = 'Подбор пользователей и групп'");
			Элементы.Выбрать.Заголовок = НСтр("ru = 'Выбрать пользователей'");
			
			Элементы.ВыбратьГруппыПользователей.Заголовок = НСтр("ru = 'Выбрать группы'");
			Элементы.ГруппыПользователей.МножественныйВыбор = Истина;
			Элементы.ГруппыПользователей.РежимВыделения = РежимВыделенияТаблицы.Множественный;
		Иначе
			Заголовок                  = НСтр("ru = 'Подбор пользователей'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВыбиратьИерархическиПриОткрытии = ВыбиратьИерархически;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ВыбиратьИерархическиПриОткрытии <> ВыбиратьИерархически Тогда
		СохранитьНастройкиФормы(ВыбиратьИерархически);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененСоставГруппыПользователей" Тогда
		Если Параметр = Элементы.ГруппыПользователей.ТекущаяСтрока Тогда
			Элементы.ПользователиСписок.Обновить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбиратьИерархическиПриИзменении(Элемент)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы();
	
КонецПроцедуры


// Обработчики команд формы

&НаКлиенте
Процедура СоздатьПользователя(Команда)
	ОткрытьФорму("Справочник.Пользователи.ФормаОбъекта", Новый Структура("ГруппаПользователей", Элементы.ГруппыПользователей.ТекущаяСтрока));
КонецПроцедуры

&НаКлиенте
Процедура СоздатьГруппуПользователей(Команда)
	
	ОткрытьФорму("Справочник.ГруппыПользователей.ФормаОбъекта");
	
КонецПроцедуры


// Обработчики событий элементов формы

&НаКлиенте
Процедура ГруппыПользователейПриАктивизацииСтроки(Элемент)
	
	Если ПерваяАктивизацияГруппыПользователей = Неопределено ИЛИ ПерваяАктивизацияГруппыПользователей = Истина Тогда
		ПерваяАктивизацияГруппыПользователей = Ложь;
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбработкаОжиданияПриАктивизацииГруппыПользователей", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры


&НаКлиенте
Процедура ПользователиСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ОткрытьФорму("Справочник.Пользователи.ФормаОбъекта",
			Новый Структура("ГруппаПользователей,ЗначениеКопирования",
						Элементы.ГруппыПользователей.ТекущаяСтрока,
						Элемент.ТекущиеДанные.Ссылка));
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиСписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры




