&НаКлиенте
Перем ЗакрытьФормуБезусловно;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СобытиеЖурналаРегистрацииПодключениеКонечнойТочки = ОбменСообщениямиВнутренний.СобытиеЖурналаРегистрацииПодключениеКонечнойТочки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗакрытьФормуБезусловно = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ЗапроситьПодтверждениеЗакрытияФормы(
		Отказ,
		,
		ЗакрытьФормуБезусловно,
		НСтр("ru = 'Отменить подключение конечной точки?'")
	); 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПодключитьКонечнуюТочку(Команда)
	
	Состояние(НСтр("ru = 'Выполняется подключение конечной точки. Пожалуйста, подождите...'"));
	
	Отказ = Ложь;
	ОшибкаЗаполнения = Ложь;
	
	ПодключитьКонечнуюТочкуНаСервере(Отказ, ОшибкаЗаполнения);
	
	Если ОшибкаЗаполнения Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		
		НСтрока = НСтр("ru = 'При подключении конечной точки возникли ошибки.
		|Перейти в журнал регистрации?'");
		Ответ = Вопрос(НСтрока, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			
			Отбор = Новый Структура;
			Отбор.Вставить("СобытиеЖурналаРегистрации", СобытиеЖурналаРегистрацииПодключениеКонечнойТочки);
			ОткрытьФормуМодально("Обработка.ЖурналРегистрации.Форма", Отбор, ЭтаФорма);
			
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Оповестить(ОбменСообщениямиКлиент.ИмяСобытияДобавленаКонечнаяТочка());
	
	Предупреждение(НСтр("ru = 'Подключение конечной точки успешно завершено.'"));
	
	ЗакрытьФормуБезусловно = Истина;
	
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодключитьКонечнуюТочкуНаСервере(Отказ, ОшибкаЗаполнения)
	
	Если Не ПроверитьЗаполнение() Тогда
		ОшибкаЗаполнения = Истина;
		Возврат;
	КонецЕсли;
	
	ОбменСообщениями.ПодключитьКонечнуюТочку(
		Отказ,
		НастройкиОтправителяWSURLВебСервиса,
		НастройкиОтправителяWSИмяПользователя,
		НастройкиОтправителяWSПароль,
		НастройкиПолучателяWSURLВебСервиса,
		НастройкиПолучателяWSИмяПользователя,
		НастройкиПолучателяWSПароль
	);
	
КонецПроцедуры


