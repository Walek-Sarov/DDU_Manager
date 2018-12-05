&НаКлиенте
Перем ЗакрытьФормуБезусловно;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	СобытиеЖурналаРегистрацииУстановкаВедущейКонечнойТочки = ОбменСообщениямиВнутренний.СобытиеЖурналаРегистрацииУстановкаВедущейКонечнойТочки();
	
	КонечнаяТочка = Параметры.КонечнаяТочка;
	
	// Зачитываем значения настроек подключения
	ЗаполнитьЗначенияСвойств(ЭтаФорма, РегистрыСведений.НастройкиТранспортаОбмена.ПолучитьНастройкиТранспортаWS(КонечнаяТочка));
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Установка ведущей конечной точки для ""%1""'"),
		ОбщегоНазначения.ПолучитьЗначениеРеквизита(КонечнаяТочка, "Наименование")
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ЗапроситьПодтверждениеЗакрытияФормы(
		Отказ,
		,
		ЗакрытьФормуБезусловно,
		НСтр("ru = 'Отменить выполнение операции?'")
	); 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Установить(Команда)
	
	Состояние(НСтр("ru = 'Выполняется установка ведущей конечной точки. Пожалуйста, подождите...'"));
	
	Отказ = Ложь;
	ОшибкаЗаполнения = Ложь;
	
	УстановитьВедущуюКонечнуюТочкуНаСервере(Отказ, ОшибкаЗаполнения);
	
	Если ОшибкаЗаполнения Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		
		НСтрока = НСтр("ru = 'При установке ведущей конечной точки возникли ошибки.
		|Перейти в журнал регистрации?'");
		Ответ = Вопрос(НСтрока, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			
			Отбор = Новый Структура;
			Отбор.Вставить("СобытиеЖурналаРегистрации", СобытиеЖурналаРегистрацииУстановкаВедущейКонечнойТочки);
			ОткрытьФормуМодально("Обработка.ЖурналРегистрации.Форма", Отбор, ЭтаФорма);
			
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Оповестить(ОбменСообщениямиКлиент.ИмяСобытияУстановленаВедущаяКонечнаяТочка());
	
	Предупреждение(НСтр("ru = 'Установка ведущей конечной точки успешно завершена.'"));
	
	ЗакрытьФормуБезусловно = Истина;
	
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьВедущуюКонечнуюТочкуНаСервере(Отказ, ОшибкаЗаполнения)
	
	Если Не ПроверитьЗаполнение() Тогда
		ОшибкаЗаполнения = Истина;
		Возврат;
	КонецЕсли;
	
	НастройкиПодключенияWS = ОбменДаннымиСервер.СтруктураПараметровWS();
	
	ЗаполнитьЗначенияСвойств(НастройкиПодключенияWS, ЭтаФорма);
	
	ОбменСообщениямиВнутренний.УстановитьВедущуюКонечнуюТочкуНаСторонеОтправителя(Отказ, НастройкиПодключенияWS, КонечнаяТочка);
	
КонецПроцедуры



