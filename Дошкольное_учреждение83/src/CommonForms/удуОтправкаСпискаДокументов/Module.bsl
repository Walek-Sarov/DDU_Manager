///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ 

&НаСервере
Процедура ВосстановитьСписокНеотправленных()
	Для Каждого Док Из ДокументыКОтправке Цикл
		Запись = РегистрыСведений.удуНеотправленныеИсхДокументы.СоздатьМенеджерЗаписи();
		Запись.Документ = Док.Документ;
		Запись.Получатель = Док.Получатель;
		Запись.Адресат = Док.Адресат;
		Запись.ВидДоставки = Док.ВидДоставки;
		Запись.ОтправкаДокумента = Док.ОтправкаДокумента;
		Запись.Записать(Ложь);
	КонецЦикла;
КонецПроцедуры // ВосстановитьСписокНеотправленных()

&НаСервере
Функция РеестрОтправкиПустаяСсылка()
	Возврат Справочники.удуРеестрыОтправки.ПустаяСсылка();
КонецФункции // РеестрОтправкиПустаяСсылка()

&НаСервере
Функция ТипыРеестровПустаяСсылка()
	Возврат Справочники.удуТипыРеестров.ПустаяСсылка();
КонецФункции // ТипыРеестровПустаяСсылка()

///////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ОБРАБОТКИ ФОРМ
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Выборка = РегистрыСведений.удуДокументыКОтправке.Выбрать();
	
	НачатьТранзакцию();
	Пока Выборка.Следующий() Цикл
		
		СтрокаТЧ = ДокументыКОтправке.Добавить();	
		СтрокаТЧ.Документ = Выборка.Документ;
		СтрокаТЧ.Получатель = Выборка.Получатель;
		СтрокаТЧ.Адресат = Выборка.Адресат;
		СтрокаТЧ.ВидДоставки = Выборка.ВидДоставки;
		СтрокаТЧ.ОтправкаДокумента = Выборка.ОтправкаДокумента;
		
		ВыборкаНеотправленные = РегистрыСведений.удуНеотправленныеИсхДокументы.Выбрать();
		Пока ВыборкаНеотправленные.Следующий() Цикл
			Если ВыборкаНеотправленные.Документ = Выборка.Документ
				И ВыборкаНеотправленные.Получатель = Выборка.Получатель
				И ВыборкаНеотправленные.Адресат = Выборка.Адресат
				И ВыборкаНеотправленные.ОтправкаДокумента = Выборка.ОтправкаДокумента Тогда
				ВыборкаНеотправленные.ПолучитьМенеджерЗаписи().Удалить();	
			КонецЕсли;	
		КонецЦикла;
		Выборка.ПолучитьМенеджерЗаписи().Удалить();
	КонецЦикла;
	ЗафиксироватьТранзакцию();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если НЕ Добавлен Тогда
		ВосстановитьСписокНеотправленных();	
	КонецЕсли;
	ОбновитьОтображениеДанных();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Добавлен = Ложь;
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ - ДОБАВЛЕНИЕ В РЕЕСТР ОТПРАВКИ

&НаКлиенте
Процедура ДобавитьВРеестр(Команда)
	Отказ = Ложь;
	Если ВидДоставкиЗаполнен() Тогда
		Попытка 
			ЗаполнитьРеестрыОтправки(Отказ);
			ДобавитьВРеестрНаСервере();
		Исключение
			Вопрос("Данные не могут быть записаны в информационную базу",РежимДиалогаВопрос.ОК);
			Возврат;
		КонецПопытки;
		Если Не Отказ Тогда
			Вопрос("Документы добавлены в реестр отправки",РежимДиалогаВопрос.ОК);
			Добавлен = Истина;
			ЭтаФорма.Закрыть();
		КонецЕсли;
		
	Иначе 
		Вопрос("Для добавления документов в рееестр почтовых отправлений необходимо указать вид доставки",РежимДиалогаВопрос.ОК);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьВРеестрНаСервере()
	
	Для Каждого ЭлементСписка Из ДокументыКОтправке Цикл
	Если ЗначениеЗаполнено(ЭлементСписка.РеестрОтправки) Тогда
	РеестрОбъект = ЭлементСписка.РеестрОтправки.ПолучитьОбъект();
	Запрос = Новый Запрос(
			 "ВЫБРАТЬ ПЕРВЫЕ 1
			 |	удуРеестрыОтправкиПакеты.Номер КАК Номер
			 |ИЗ
			 |	Справочник.удуРеестрыОтправки.Пакеты КАК удуРеестрыОтправкиПакеты
			 |ГДЕ
			 |	удуРеестрыОтправкиПакеты.Ссылка = &Ссылка
			 |	И удуРеестрыОтправкиПакеты.Корреспондент = &Корреспондент"
			);
	 Запрос.УстановитьПараметр("Ссылка",РеестрОбъект.Ссылка);
	 Запрос.УстановитьПараметр("Корреспондент",ЭлементСписка.Получатель);
	 
	 Результат = Запрос.Выполнить();
	 Выборка = Результат.Выбрать();
	 НомерПакета = 1;
	 КорреспондентВРеестре = Ложь;
	 Пока Выборка.Следующий() Цикл
		НомерПакета = Выборка.Номер;
		КорреспондентВРеестре = Истина;
	КонецЦикла;
	
	Если НомерПакета = 1 Тогда
		Запрос = Новый Запрос(
			 "ВЫБРАТЬ
			 |	МАКСИМУМ(удуРеестрыОтправкиПакеты.Номер) КАК Номер
			 |ИЗ
			 |	Справочник.удуРеестрыОтправки.Пакеты КАК удуРеестрыОтправкиПакеты
			 |ГДЕ
			 |	удуРеестрыОтправкиПакеты.Ссылка = &Ссылка"
			);
		Запрос.УстановитьПараметр("Ссылка",РеестрОбъект.Ссылка);
	 	 
	 	Результат = Запрос.Выполнить();
	 	Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Выборка.Номер <> Null Тогда
				НомерПакета = Выборка.Номер + 1;
			КонецЕсли;
		КонецЦикла;
		РеестрПакеты = РеестрОбъект.Пакеты.Добавить();
		РеестрПакеты.Корреспондент = ЭлементСписка.Получатель;
		РеестрПакеты.Номер = НомерПакета;
	КонецЕсли;
	 
	Если НомерПакета > 0 Тогда 
		
		Запрос = Новый Запрос(
			 "ВЫБРАТЬ
			 |	удуРеестрыОтправкиДокументы.Ссылка
			 |ИЗ
			 |	Справочник.удуРеестрыОтправки.Документы КАК удуРеестрыОтправкиДокументы
			 |ГДЕ
			 |	удуРеестрыОтправкиДокументы.Ссылка = &Ссылка
			 |	И удуРеестрыОтправкиДокументы.Документ = &Документ
			 |	И удуРеестрыОтправкиДокументы.Адресат = &Адресат
			 |	И удуРеестрыОтправкиДокументы.НомерПакета = &НомерПакета"
				);
		Запрос.УстановитьПараметр("Ссылка",ЭлементСписка.РеестрОтправки);
		Запрос.УстановитьПараметр("Документ",ЭлементСписка.Документ);
		Запрос.УстановитьПараметр("Адресат",ЭлементСписка.Адресат);
		Запрос.УстановитьПараметр("НомерПакета",НомерПакета);
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() ИЛИ НЕ КорреспондентВРеестре Тогда 
			РеестрДок = РеестрОбъект.Документы.Добавить();
			РеестрДок.Документ = ЭлементСписка.Документ;
			РеестрДок.Адресат = ЭлементСписка.Адресат;
			РеестрДок.НомерПакета = НомерПакета;
		Иначе 
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст="Документ " + ЭлементСписка.Документ + " уже содержится в реестре отправки.";
			СообщениеПользователю.Сообщить();
		КонецЕсли;
		
	КонецЕсли;
	РеестрОбъект.Записать();
	
	КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры  //ДобавитьВРеестрНаСервере()

&НаКлиенте
Процедура ДобавитьВЗакрытыйРеестр(Команда)
	Результат = ОткрытьФормуМодально("ОбщаяФорма.удуВыборЗакрытогоРеестра");
	Если ТипЗнч(Результат) = Тип("СправочникСсылка.удуРеестрыОтправки") тогда
		Для Каждого Элем Из ДокументыКОтправке Цикл 
			Элем.РеестрОтправки = Результат;	
		КонецЦикла;
		Попытка 
			ДобавитьВРеестрНаСервере();
			Добавлен = Истина;
		Исключение
			Вопрос("Данные не могут быть записаны в информационную базу",РежимДиалогаВопрос.ОК);
			Возврат;
		КонецПопытки;
		ЭтаФорма.Закрыть();

	КонецЕсли;
	
КонецПроцедуры


// При изменении вида доставки определить тип реестра и реестр
&НаКлиенте
Процедура ДокументыКОтправкеВидДоставкиПриИзменении(Элемент)
	Элементы.ДокументыКОтправкеТипРеестра.Видимость = Ложь;
	ТекСтрока = Элементы.ДокументыСписок.ТекущиеДанные;
	ТекСтрока.РеестрОтправки = РеестрОтправкиПустаяСсылка();
	Если ЗначениеЗаполнено(ТекСтрока.ВидДоставки) Тогда
	Результат = ПолучитьРеестр(ТекСтрока.ВидДоставки);
	Если Результат <> Истина И Результат <> Ложь Тогда
		ТекСтрока.ТипРеестра = Результат;
		Результат = ПолучитьРеестрОбъекта(ТекСтрока.ТипРеестра);
		Элементы.ДокументыСписок.ТекущиеДанные.РеестрОтправки = Результат;
		
	Иначе 
		Если Результат = Истина Тогда
			Вопрос("Тип реестра, соответствующего выбранному виду доставки, не найдено", РежимДиалогаВопрос.ОК);
		Иначе
			ТекСтрока.ТипРеестра = ТипыРеестровПустаяСсылка();
			Элементы.ДокументыКОтправкеТипРеестра.Видимость = Истина;
			Элементы.ТипРеестра.ТолькоПросмотр = Ложь;
		КонецЕсли;
	КонецЕсли;
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьРеестрыОтправки(Отказ)
	Отказ = Ложь;
	Элементы.ДокументыКОтправкеТипРеестра.Видимость = Ложь;
	Для Каждого ЭлемСписка Из ДокументыКОтправке Цикл
		Если ЗначениеЗаполнено(ЭлемСписка.ВидДоставки)
			И НЕ ЗначениеЗаполнено(ЭлемСписка.РеестрОтправки) Тогда
			Результат = ПолучитьРеестр(ЭлемСписка.ВидДоставки);
			Если Результат <> Истина И Результат <> Ложь Тогда
				ЭлемСписка.ТипРеестра = Результат;
				РезультатРеестр = ПолучитьРеестрОбъекта(ЭлемСписка.ТипРеестра);
				ЭлемСписка.РеестрОтправки = РезультатРеестр;
	
			Иначе 
			Если Результат = Истина Тогда
				Отказ = Истина;
				Вопрос("Тип реестра, соответствующего выбранному виду доставки, не найдено", РежимДиалогаВопрос.ОК);
			Иначе
				ЭлемСписка.ТипРеестра = ТипыРеестровПустаяСсылка();
				Элементы.ДокументыКОтправкеТипРеестра.Видимость = Истина;
				Элементы.ТипРеестра.ТолькоПросмотр = Ложь;
			КонецЕсли;
			
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры // ЗаполнитьРеестрыОтправки()


// Проверить, что для всех элементов списка поле вид доставки заполнено
&НаКлиенте
Функция ВидДоставкиЗаполнен()
	Для Каждого ЭлемСписка Из ДокументыКОтправке Цикл
		Если НЕ ЗначениеЗаполнено (ЭлемСписка.ВидДоставки) Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат Истина;	
КонецФункции // ВидДоставкиЗаполнен()


// Получить ссылку на РеестрОтправки в зависимости от вида отправки, 
// или возвращает истину в случае, когда количество реестров больше 1,
// или ложь в случае, когда подходящих реестров не найдено
&НаСервере
Функция ПолучитьРеестр(Знач ВидДоставки)
	
	Запрос = Новый Запрос(
	 "ВЫБРАТЬ
	 |	ТипыРеестров.Ссылка КАК Ссылка
	 |ИЗ
	 |	Справочник.удуТипыРеестров КАК ТипыРеестров
	 |ГДЕ
	 |	ТипыРеестров.СпособОтправки = &СпособОтправки"
	);
	Запрос.УстановитьПараметр("СпособОтправки",ВидДоставки);
	Выборка = Запрос.Выполнить().Выгрузить();
	Если Выборка.Количество() = 1 Тогда
		Реестр = Выборка.ВыгрузитьКолонку("Ссылка")[0];	
		Возврат Реестр;
	КонецЕсли;
	Если Выборка.Количество() = 0 Тогда
		Возврат Истина;
	КонецЕсли;
	Если Выборка.Количество() > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
КонецФункции // ПолучитьРеестр()

// Получить РеестрОбъекта в зависимости от выбранного ТипаРеестра или создать, 
// если соответствующего не найдено. Возвращает РеестрОтправки.Ссылка.
//
Функция ПолучитьРеестрОбъекта(Знач ТипРеестра)
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	РеестрыОтправки.Ссылка КАК Реестр
	                      |ИЗ
	                      |	Справочник.удуРеестрыОтправки КАК РеестрыОтправки
	                      |ГДЕ
	                      |	РеестрыОтправки.ТипРеестра = &ТипРеестра
	                      |	И РеестрыОтправки.Статус = &Статус");
	Запрос.УстановитьПараметр("ТипРеестра",ТипРеестра);
	Запрос.УстановитьПараметр("Статус",Перечисления.удуСтатусОтправки.Текущий);
	Выборка = Запрос.Выполнить().Выгрузить();
	Если Выборка.Количество() > 0 Тогда
		Возврат Выборка.ВыгрузитьКолонку("Реестр")[0];
	Иначе
		РеестрОбъект = Справочники.удуРеестрыОтправки.СоздатьЭлемент();
		РеестрОбъект.Статус = Перечисления.удуСтатусОтправки.Текущий;
		РеестрОбъект.ТипРеестра = ТипРеестра;
		РеестрОбъект.Наименование = ТипРеестра;
		РеестрОбъект.Записать();
		Возврат	РеестрОбъект.Ссылка;
	КонецЕсли;
КонецФункции // ПолучитьРеестрОбъекта()

///////////////////////////////////////////////////////////////////////////////
// Обработка удаления
&НаСервере
Процедура ОбновитьДанныеПередУдалением()
	НачатьТранзакцию();
	    Для Инд = 0 По Элементы.ДокументыСписок.ВыделенныеСтроки.Количество() - 1 Цикл
	    ТекСтрока = ДокументыКОтправке.Получить(Элементы.ДокументыСписок.ВыделенныеСтроки[Инд]);
	
		ЗаписьДокументКОтправке = РегистрыСведений.удуДокументыКОтправке.СоздатьМенеджерЗаписи();
		ЗаписьДокументКОтправке.Документ = ТекСтрока.Документ;
		ЗаписьДокументКОтправке.Получатель = ТекСтрока.Получатель;
		ЗаписьДокументКОтправке.Адресат = ТекСтрока.Адресат;
		ЗаписьДокументКОтправке.ВидДоставки = ТекСтрока.ВидДоставки;
		ЗаписьДокументКОтправке.ОтправкаДокумента = ТекСтрока.ОтправкаДокумента;
		ЗаписьДокументКОтправке.Удалить();
		
		ЗаписьДокументВНеотправленные = РегистрыСведений.удуНеотправленныеИсхДокументы.СоздатьМенеджерЗаписи();
		ЗаписьДокументВНеотправленные.Документ = ТекСтрока.Документ;
		ЗаписьДокументВНеотправленные.Получатель = ТекСтрока.Получатель;
		ЗаписьДокументВНеотправленные.Адресат = ТекСтрока.Адресат;
		ЗаписьДокументВНеотправленные.ВидДоставки = ТекСтрока.ВидДоставки;
		ЗаписьДокументВНеотправленные.ОтправкаДокумента = ТекСтрока.ОтправкаДокумента;
		ЗаписьДокументВНеотправленные.Записать();
		
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	
КонецПроцедуры // ОбновитьДанныеПередУдалением()

&НаКлиенте
Процедура ДокументыСписокПередУдалением(Элемент, Отказ)
	
	ОбновитьДанныеПередУдалением();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДоставкиПоУмолчанию1ПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ВидДоставкиПоУмолчанию) Тогда
		Результат = Вопрос("Заменить вид доставки для всех документов на выбранное значение?",РежимДиалогаВопрос.ОКОтмена);
		Если Результат = КодВозвратаДиалога.ОК Тогда
			Для Каждого Элем Из ДокументыКОтправке Цикл
				Элем.ВидДоставки = ВидДоставкиПоУмолчанию;
			КонецЦикла;
		КонецЕсли;	
	Иначе
		Вопрос("Значение вида доставки по умолчанию не задано",РежимДиалогаВопрос.ОК);
	КонецЕсли;

КонецПроцедуры

 


///////////////////////////////////////////////////////////////////////////////



