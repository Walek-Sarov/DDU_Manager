///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ
//
&НаСервере
Процедура УстановитьДоступностьРеквизитов()
	
	Если Объект.Проведен Тогда
		Элементы.НомерДата.ТолькоПросмотр = Истина;
		Элементы.Читатель.ТолькоПросмотр = Истина;
		Элементы.Читатель.ТолькоПросмотр = Истина;
		Элементы.ПричинаВыдачи.ТолькоПросмотр = Истина;
		Элементы.МетодическиеМатериалыКоличество.ТолькоПросмотр = Истина;
		Элементы.МетодическиеМатериалыДатаВозврата.ТолькоПросмотр = Истина;
		Элементы.МетодическиеМатериалыУчетнаяЕдиница.КнопкаВыбора = Ложь;
		Элементы.МетодическиеМатериалыКоманднаяПанель.Доступность = Ложь;

	КонецЕсли;
		
КонецПроцедуры // УстановитьДоступностьРеквизитов()

&НаСервере
&НаСервере
Процедура ЗаполнитьПредставлениеПоУчетнойЕдинице(Знач УчетЕд)
	УчетЕдОбъект = УчетЕд.ПолучитьОбъект();
	ПредставлениеУЕ = УчетЕдОбъект.Представление;
КонецПроцедуры

&НаСервере
Функция ПравильностьДатыВозврата(ДатаВозврата)
	Если ДатаВозврата < ТекущаяДата() Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции // ПравильностьДатыВозврата()

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьДоступностьРеквизитов();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Объект.Автор = ПараметрыСеанса.ТекущийПользователь;
	Объект.Дата = ТекущаяДата();
	Если НЕ ЗначениеЗаполнено(Объект.Читатель) 
		И НЕ ЗначениеЗаполнено(Объект.ПричинаВыдачи) Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Хотя бы одно из полей получатель или причина выдачи, должно быть заполнено");
	КонецЕсли;
		
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
//

&НаКлиенте
Процедура НаРуках(Команда)
	
	Если ЗначениеЗаполнено(Объект.Читатель) Тогда
		
		ПараметрыФормы = Новый Структура("Читатель", Объект.Читатель);
		ОткрытьФорму("РегистрНакопления.удуМетодическиеМатериалыНаРуках.Форма.ФормаСпискаУчетЕдНаРуках", ПараметрыФормы);
	Иначе
		Вопрос("Значение поля Читатель не заполнено",РежимДиалогаВопрос.ОК);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МетодическиеМатериалыУчетнаяЕдиницаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	                                                                          
	Результат = ОткрытьФормуМодально("РегистрНакопления.удуТМЦ_НаСкладах.Форма.ФормаДляВыдачиМетодическихМатериалов");
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
				
		Стр = Элементы.МетодическиеМатериалы.ТекущиеДанные;
        Стр.УчетнаяЕдиница = Результат.Номенклатура;
		Стр.ИнвентарныйНомер = Результат.ИнвентарныйНомер;
		Стр.ДоступноеКоличество = Результат.ДоступноеКоличество;
		Стр.Количество = 1;
		
	КонецЕсли;

	ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура МетодическиеМатериалыПриАктивизацииСтроки(Элемент)
	Если Объект.МетодическиеМатериалы.Количество() >  0 Тогда 
		Если ЗначениеЗаполнено(Элементы.МетодическиеМатериалы.ТекущиеДанные.УчетнаяЕдиница) Тогда
			ЗаполнитьПредставлениеПоУчетнойЕдинице(Элементы.МетодическиеМатериалы.ТекущиеДанные.УчетнаяЕдиница);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МетодическиеМатериалыКоличествоПриИзменении(Элемент)
	Если Элементы.МетодическиеМатериалы.ТекущиеДанные.Количество > Элементы.МетодическиеМатериалы.ТекущиеДанные.ДоступноеКоличество Тогда
		Вопрос("Для выдачи доступно только " + Элементы.МетодическиеМатериалы.ТекущиеДанные.ДоступноеКоличество + " экз." ,РежимДиалогаВопрос.ОК);
		Элементы.МетодическиеМатериалы.ТекущиеДанные.Количество = Элементы.МетодическиеМатериалы.ТекущиеДанные.ДоступноеКоличество;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаВозвратаОбщаяПриИзменении(Элемент)
	Если Не ПравильностьДатыВозврата(Объект.ДатаВозвратаОбщая) Тогда
		Вопрос("Общая дата возврата введена некорректно",РежимДиалогаВопрос.ОК);
		Объект.ДатаВозвратаОбщая = ТекущаяДата();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МетодическиеМатериалыУчетнаяЕдиницаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	Экземпляры = ПолучитьКоличествоДоступныхЭкземпляров(ВыбранноеЗначение);
	
	Если Экземпляры.ЧислитсяНаСкладе < 1 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Выбранной единицы нет на складе!");		
	Иначе
		
		ДоступноеКоличество = Экземпляры.ЧислитсяНаСкладе - Экземпляры.НаРуках;
		
		Если ДоступноеКоличество  < 1 Тогда
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Все экземпляры выданы на руки!");
		Иначе
			Стр = Элементы.МетодическиеМатериалы.ТекущиеДанные;
	        Стр.УчетнаяЕдиница = ВыбранноеЗначение;
			Стр.ДоступноеКоличество = ДоступноеКоличество;
			Стр.Количество = 1; 
		КонецЕсли;			
		
	КонецЕсли;    
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКоличествоДоступныхЭкземпляров(УчетнаяЕдиница)
	
	Результат = Новый Структура("ЧислитсяНаСкладе, НаРуках", 0, 0);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СУММА(удуТМЦ_НаСкладахОстатки.КоличествоОстаток) КАК КоличествоОстаток,
		|	удуТМЦ_НаСкладахОстатки.Номенклатура
		|ИЗ
		|	РегистрНакопления.удуТМЦ_НаСкладах.Остатки КАК удуТМЦ_НаСкладахОстатки
		|ГДЕ
		|	удуТМЦ_НаСкладахОстатки.Номенклатура = &УчетнаяЕдиница
		|
		|СГРУППИРОВАТЬ ПО
		|	удуТМЦ_НаСкладахОстатки.Номенклатура");
	
	Запрос.Параметры.Вставить("УчетнаяЕдиница", УчетнаяЕдиница);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Результат.ЧислитсяНаСкладе = Выборка.КоличествоОстаток;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	удуМетодическиеМатериалыНаРукахОстатки.УчетнаяЕдиница,
		|	СУММА(удуМетодическиеМатериалыНаРукахОстатки.КоличествоОстаток) КАК КоличествоОстаток
		|ИЗ
		|	РегистрНакопления.удуМетодическиеМатериалыНаРуках.Остатки КАК удуМетодическиеМатериалыНаРукахОстатки
		|ГДЕ
		|	удуМетодическиеМатериалыНаРукахОстатки.УчетнаяЕдиница = &УчетнаяЕдиница
		|
		|СГРУППИРОВАТЬ ПО
		|	удуМетодическиеМатериалыНаРукахОстатки.УчетнаяЕдиница");
	
	Запрос.Параметры.Вставить("УчетнаяЕдиница", УчетнаяЕдиница);	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Результат.НаРуках = Выборка.КоличествоОстаток;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

