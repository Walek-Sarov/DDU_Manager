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
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не АвтономнаяРаботаСлужебный.ЭтоАвтономноеРабочееМесто() Тогда
		ВызватьИсключение НСтр("ru = 'Эта информационная база не является автономным рабочим местом.'");
	КонецЕсли;
	
	ПриложениеВСервисе = АвтономнаяРаботаСлужебный.ПриложениеВСервисе();
	
	НастройкиТранспорта = РегистрыСведений.НастройкиТранспортаОбмена.ПолучитьНастройкиТранспортаWS(ПриложениеВСервисе);
	
	ЗаполнитьЗначенияСвойств(Объект, НастройкиТранспорта);
	
	// Устанавливаем текущую таблицу переходов
	СценарийЗавершенияНастройкиАвтономногоРабочегоМеста();
	
	АдресДляВосстановленияПароляУчетнойЗаписи = АвтономнаяРаботаСлужебный.АдресДляВосстановленияПароляУчетнойЗаписи();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Позиционируемся на первом шаге помощника
	УстановитьПорядковыйНомерПерехода(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ЗапроситьПодтверждениеЗакрытияФормы(Отказ,,
		ЗакрытьФормуБезусловно, НСтр("ru = 'Отменить настройку автономного рабочего места?'"))
	;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// Поставляемая часть

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	
	ЗакрытьФормуБезусловно = Истина;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

// Переопределяемая часть

&НаКлиенте
Процедура ЗабылиПароль(Команда)
	
	ПерейтиПоНавигационнойСсылке(АдресДляВосстановленияПароляУчетнойЗаписи);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Поставляемая часть

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	
	ПорядковыйНомерПерехода = Значение;
	
	Если ПорядковыйНомерПерехода < 0 Тогда
		
		ПорядковыйНомерПерехода = 0;
		
	КонецЕсли;
	
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Выполняем обработчики событий перехода
	ВыполнитьОбработчикиСобытийПерехода(ЭтоПереходДалее);
	
	// Устанавливаем отображение страниц
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяСтраницыДекорации) Тогда
		
		Элементы.ПанельДекорации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыДекорации];
		
	КонецЕсли;
	
	// Устанавливаем текущую кнопку по умолчанию
	КнопкаДалее = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаДалее");
	
	Если КнопкаДалее <> Неопределено Тогда
		
		КнопкаДалее.КнопкаПоУмолчанию = Истина;
		
	Иначе
		
		КнопкаГотово = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаГотово");
		
		Если КнопкаГотово <> Неопределено Тогда
			
			КнопкаГотово.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация Тогда
		
		ПодключитьОбработчикОжидания("ВыполнитьОбработчикДлительнойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикиСобытийПерехода(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаПерехода = СтрокиПерехода[0];
		
		// обработчик ПриПереходеДалее
		Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее)
			И Не СтрокаПерехода.ДлительнаяОперация Тогда
			
			ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
			ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
			
			Отказ = Ложь;
			
			А = Вычислить(ИмяПроцедуры);
			
			Если Отказ Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаПерехода = СтрокиПерехода[0];
		
		// обработчик ПриПереходеНазад
		Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад)
			И Не СтрокаПерехода.ДлительнаяОперация Тогда
			
			ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
			ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
			
			Отказ = Ложь;
			
			А = Вычислить(ИмяПроцедуры);
			
			Если Отказ Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Если СтрокаПереходаТекущая.ДлительнаяОперация И Не ЭтоПереходДалее Тогда
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
		Возврат;
	КонецЕсли;
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		А = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПропуститьСтраницу Тогда
			
			Если ЭтоПереходДалее Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				
				Возврат;
				
			Иначе
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикДлительнойОперации()
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// обработчик ОбработкаДлительнойОперации
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПерейтиДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации);
		
		Отказ = Ложь;
		ПерейтиДалее = Истина;
		
		А = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПерейтиДалее Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
			
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

// Добавляет новую строку в конец текущей таблицы переходов
//
// Параметры:
//
//  ПорядковыйНомерПерехода (обязательный) – Число. Порядковый номер перехода, который соответствует текущему шагу перехода
//  ИмяОсновнойСтраницы (обязательный) – Строка. Имя страницы панели "ПанельОсновная", которая соответствует текущему номеру перехода
//  ИмяСтраницыНавигации (обязательный) – Строка. Имя страницы панели "ПанельНавигации", которая соответствует текущему номеру перехода
//  ИмяСтраницыДекорации (необязательный) – Строка. Имя страницы панели "ПанельДекорации", которая соответствует текущему номеру перехода
//  ИмяОбработчикаПриОткрытии (необязательный) – Строка. Имя функции-обработчика события открытия текущей страницы помощника
//  ИмяОбработчикаПриПереходеДалее (необязательный) – Строка. Имя функции-обработчика события перехода на следующую страницу помощника
//  ИмяОбработчикаПриПереходеНазад (необязательный) – Строка. Имя функции-обработчика события перехода на предыдущую страницу помощника
//  ДлительнаяОперация (необязательный) - Булево. Признак отображения страницы длительной операции.
//  Истина - отображается страница длительной операции; Ложь - отображается обычная страница. Значение по умолчанию - Ложь.
// 
&НаСервере
Процедура ТаблицаПереходовНоваяСтрока(ПорядковыйНомерПерехода,
									ИмяОсновнойСтраницы,
									ИмяСтраницыНавигации,
									ИмяСтраницыДекорации = "",
									ИмяОбработчикаПриОткрытии = "",
									ИмяОбработчикаПриПереходеДалее = "",
									ИмяОбработчикаПриПереходеНазад = "",
									ДлительнаяОперация = Ложь,
									ИмяОбработчикаДлительнойОперации = ""
	)
	НоваяСтрока = ТаблицаПереходов.Добавить();
	
	НоваяСтрока.ПорядковыйНомерПерехода = ПорядковыйНомерПерехода;
	НоваяСтрока.ИмяОсновнойСтраницы     = ИмяОсновнойСтраницы;
	НоваяСтрока.ИмяСтраницыДекорации    = ИмяСтраницыДекорации;
	НоваяСтрока.ИмяСтраницыНавигации    = ИмяСтраницыНавигации;
	
	НоваяСтрока.ИмяОбработчикаПриПереходеДалее = ИмяОбработчикаПриПереходеДалее;
	НоваяСтрока.ИмяОбработчикаПриПереходеНазад = ИмяОбработчикаПриПереходеНазад;
	НоваяСтрока.ИмяОбработчикаПриОткрытии      = ИмяОбработчикаПриОткрытии;
	
	НоваяСтрока.ДлительнаяОперация = ДлительнаяОперация;
	НоваяСтрока.ИмяОбработчикаДлительнойОперации = ИмяОбработчикаДлительнойОперации;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьКнопкуФормыПоИмениКоманды(ЭлементФормы, ИмяКоманды)
	
	Для Каждого Элемент Из ЭлементФормы.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
			
			ЭлементФормыПоИмениКоманды = ПолучитьКнопкуФормыПоИмениКоманды(Элемент, ИмяКоманды);
			
			Если ЭлементФормыПоИмениКоманды <> Неопределено Тогда
				
				Возврат ЭлементФормыПоИмениКоманды;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("КнопкаФормы")
			И Найти(Элемент.ИмяКоманды, ИмяКоманды) > 0 Тогда
			
			Возврат Элемент;
			
		Иначе
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть – Служебные процедуры и функции

&НаСервере
Процедура ПроверитьПодключениеКСервисуИСохранитьНастройки(Отказ)
	
	ПараметрыПодключения = ОбменДаннымиСервер.СтруктураПараметровWS();
	ЗаполнитьЗначенияСвойств(ПараметрыПодключения, Объект);
	ПараметрыПодключения.WSПароль = Пароль;
	
	СообщениеПользователю = "";
	WSПрокси = ОбменДаннымиСервер.ПолучитьWSПрокси(ПараметрыПодключения,, СообщениеПользователю);
	Если WSПрокси = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю,,"Пароль",, Отказ);
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		УстановитьПривилегированныйРежим(Истина);
		
		Константы.НастройкаПодчиненногоУзлаРИБЗавершена.Установить(Истина);
		
		Если ЗапомнитьПароль Тогда
			
			// обновляем запись в РС
			СтруктураЗаписи = Новый Структура;
			СтруктураЗаписи.Вставить("Узел", ПриложениеВСервисе);
			СтруктураЗаписи.Вставить("WSЗапомнитьПароль", Истина);
			СтруктураЗаписи.Вставить("WSПароль", Пароль);
			РегистрыСведений.НастройкиТранспортаОбмена.ОбновитьЗапись(СтруктураЗаписи);
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(АвтономнаяРаботаСлужебный.СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
		);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),,,, Отказ);
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть - Обработчики событий переходов

&НаКлиенте
Функция Подключаемый_Начало_ПриПереходеДалее(Отказ)
	
	Если ПустаяСтрока(Пароль) Тогда
		
		НСтрока = НСтр("ru = 'Не указан пароль.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтрока,,"Пароль",, Отказ);
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_ОжиданиеПроверкиПодключения_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ПроверитьПодключениеКСервисуИСохранитьНастройки(Отказ);
	
	Если Отказ Тогда
		
		Предупреждение(НСтр("ru = 'Не удалось выполнить операцию.'"));
		
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть - Инициализация переходов помощника

&НаСервере
Процедура СценарийЗавершенияНастройкиАвтономногоРабочегоМеста()
	
	ТаблицаПереходов.Очистить();
	
	ТаблицаПереходовНоваяСтрока(1, "Начало",                      "СтраницаНавигацииНачало",,, "Начало_ПриПереходеДалее");
	ТаблицаПереходовНоваяСтрока(2, "ОжиданиеПроверкиПодключения", "СтраницаНавигацииОжидание",,,,, Истина, "ОжиданиеПроверкиПодключения_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(3, "Окончание",                   "СтраницаНавигацииОкончание");
	
КонецПроцедуры
