////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НомерСеансаИнформационнойБазы = НомерСеансаИнформационнойБазы();
	УсловноеОформление.Элементы[0].Отбор.Элементы[0].ПравоеЗначение = НомерСеансаИнформационнойБазы;
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Если Элементы.Найти("ЗавершитьСеанс") <> Неопределено Тогда
			Элементы.ЗавершитьСеанс.Видимость = Ложь;
			Элементы.ЗавершитьСеансКонтекст.Видимость = Ложь;
		КонецЕсли;
		Если Элементы.Найти("ПараметрыАдминистрированияИнформационнойБазы") <> Неопределено Тогда
			Элементы.ПараметрыАдминистрированияИнформационнойБазы.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
			Элементы.ПараметрыАдминистрированияИнформационнойБазы.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ИмяКолонкиСортировки = "НачалоРаботы";
	НаправлениеСортировки = "Возр";
	ЗаполнитьСписокПользователей();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЦЫ СписокПользователей

&НаКлиенте
Процедура СписокПользователейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьПользователяИзСписка();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗавершитьСеанс(Команда)
	
	Сообщение = "";
	
	НомерСеансаДляЗавершения = Элементы.СписокПользователей.ТекущиеДанные.Сеанс;
	
	Если НомерСеансаДляЗавершения = НомерСеансаИнформационнойБазы Тогда
		Предупреждение(НСтр("ru = 'Невозможно завершить текущий сеанс. Для выхода из программы можно закрыть главное окно программы.'"));
		Возврат;
	КонецЕсли;
	
	Отключено = СоединенияИБКлиентСервер.ОтключитьСеанс(НомерСеансаДляЗавершения, Сообщение);
	Если НЕ ПустаяСтрока(Сообщение) и Не Отключено Тогда
		Предупреждение(Сообщение);
	КонецЕсли;
	
	Если Отключено Тогда
		Предупреждение(НСтр("ru = 'Сеанс завершен.'"));
	КонецЕсли;
	
	ЗаполнитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВыполнить()
	
	ЗаполнитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурналРегистрации()
	
	Если Элементы.СписокПользователей.ВыделенныеСтроки.Количество() > 1 Тогда
		Предупреждение(НСтр("ru = 'Для просмотра журнала регистрации выберите в списке только одного пользователя.'"));
		Возврат;
	КонецЕсли;
		
	ТекущиеДанные = Элементы.СписокПользователей.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Предупреждение(НСтр("ru = 'Невозможно открыть журнал регистрации для выбранного пользователя.'"));
		Возврат;
	КонецЕсли;
	
	ИмяПользователя  = ТекущиеДанные.ИмяПользователя;
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Новый Структура("Пользователь", ИмяПользователя));
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоВозрастанию()
	
	СортировкаПоКолонке("Возр");
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоУбыванию()
	
	СортировкаПоКолонке("Убыв");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПользователя(Команда)
	ОткрытьПользователяИзСписка();
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыАдминистрированияИнформационнойБазы(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыАдминистрированияСервернойИБ");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ЗаполнитьСписок()
	
	// Для восстановления позиции запомним текущий сеанс
	ТекущийСеанс = Неопределено;
	ТекущиеДанные = Элементы.СписокПользователей.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущийСеанс = ТекущиеДанные.Сеанс;
	КонецЕсли;
	
	ЗаполнитьСписокПользователей();
	
	// Восстанавливаем текущую строку по запомненному сеансу
	Если ТекущийСеанс <> Неопределено Тогда
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Сеанс", ТекущийСеанс);
		НайденныеСеансы = СписокПользователей.НайтиСтроки(СтруктураПоиска);
		Если НайденныеСеансы.Количество() = 1 Тогда
			Элементы.СписокПользователей.ТекущаяСтрока = НайденныеСеансы[0].ПолучитьИдентификатор();
			Элементы.СписокПользователей.ВыделенныеСтроки.Очистить();
			Элементы.СписокПользователей.ВыделенныеСтроки.Добавить(Элементы.СписокПользователей.ТекущаяСтрока);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПоКолонке(Направление)
	
	Колонка = Элементы.СписокПользователей.ТекущийЭлемент;
	Если Колонка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКолонкиСортировки = Колонка.Имя;
	НаправлениеСортировки = Направление;
	
	ЗаполнитьСписок();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПользователей()
	
	СписокПользователей.Очистить();
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено()
	 ИЛИ ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Пользователи.НайтиНеоднозначныхПользователейИБ();
	КонецЕсли;
	
	СеансыИнформационнойБазы = ПолучитьСеансыИнформационнойБазы();
	
	Для Каждого СеансИБ Из СеансыИнформационнойБазы Цикл
		СтрПользователя = СписокПользователей.Добавить();
		
		СтрПользователя.Приложение   = ПредставлениеПриложения(СеансИБ.ИмяПриложения);
		СтрПользователя.НачалоРаботы = СеансИБ.НачалоСеанса;
		СтрПользователя.Компьютер    = СеансИБ.ИмяКомпьютера;
		СтрПользователя.Сеанс        = СеансИБ.НомерСеанса;
		СтрПользователя.Соединение   = СеансИБ.НомерСоединения;

		Если ТипЗнч(СеансИБ.Пользователь) = Тип("ПользовательИнформационнойБазы")
		   И ЗначениеЗаполнено(СеансИБ.Пользователь.Имя) Тогда
			
			СтрПользователя.Пользователь        = СеансИБ.Пользователь.Имя;
			СтрПользователя.ИмяПользователя     = СеансИБ.Пользователь.Имя;
			СтрПользователя.ПользовательСсылка  = НайтиСсылкуПоИдентификаторуПользователя(
				СеансИБ.Пользователь.УникальныйИдентификатор);
			
			Если ОбщегоНазначенияПовтИсп.РазделениеВключено() 
				И Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
				
				СтрПользователя.РазделениеДанных = ЗначенияРазделителейДанныхВСтроку(
					СеансИБ.Пользователь.РазделениеДанных);
			КонецЕсли;
			
		Иначе
			СвойстваНеУказанного = ПользователиСлужебный.СвойстваНеуказанногоПользователя();
			СтрПользователя.Пользователь       = СвойстваНеУказанного.ПолноеИмя;
			СтрПользователя.ИмяПользователя    = "";
			СтрПользователя.ПользовательСсылка = СвойстваНеУказанного.Ссылка;
		КонецЕсли;

		Если СеансИБ.НомерСеанса = НомерСеансаИнформационнойБазы Тогда
			СтрПользователя.НомерРисункаПользователя = 0;
		Иначе
			СтрПользователя.НомерРисункаПользователя = 1;
		КонецЕсли;
		
	КонецЦикла;
	
	КоличествоАктивныхПользователей = СеансыИнформационнойБазы.Количество();
	СписокПользователей.Сортировать(ИмяКолонкиСортировки + " " + НаправлениеСортировки);
	
КонецПроцедуры

&НаСервере
Функция ЗначенияРазделителейДанныхВСтроку(РазделениеДанных)
	
	Результат = "";
	Значение = "";
	Если РазделениеДанных.Свойство("ОбластьДанных", Значение) Тогда
		Результат = Строка(Значение);
	КонецЕсли;
	
	ЕстьДругиеРазделители = Ложь;
	Для каждого Разделитель Из РазделениеДанных Цикл
		Если Разделитель.Ключ = "ОбластьДанных" Тогда
			Продолжить;
		КонецЕсли;
		Если Не ЕстьДругиеРазделители Тогда
			Если Не ПустаяСтрока(Результат) Тогда
				Результат = Результат + " ";
			КонецЕсли;
			Результат = Результат + "(";
		КонецЕсли;
		Результат = Результат + Строка(Разделитель.Значение);
		ЕстьДругиеРазделители = Истина;
	КонецЦикла;
	Если ЕстьДругиеРазделители Тогда
		Результат = Результат + ")";
	КонецЕсли;
	Возврат Результат;
		
КонецФункции

&НаСервере
Функция НайтиСсылкуПоИдентификаторуПользователя(Идентификатор)
	
	// Нет доступа к разделенному справочнику из неразделенного сеанса.
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() 
		И Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат Неопределено;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	
	ШаблонТекстаЗапроса = "ВЫБРАТЬ
					|	Ссылка КАК Ссылка
					|ИЗ
					|	%1
					|ГДЕ
					|	ИдентификаторПользователяИБ = &Идентификатор";
					
	ТекстЗапросаПоПользователям = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонТекстаЗапроса,
					"Справочник.Пользователи");
	
	ТекстЗапросаПоВнешниемПользователям = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонТекстаЗапроса,
					"Справочник.ВнешниеПользователи");
					
	Запрос.Текст = ТекстЗапросаПоПользователям;
	Запрос.Параметры.Вставить("Идентификатор", Идентификатор);
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапросаПоВнешниемПользователям;
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.Пользователи.ПустаяСсылка();
	
КонецФункции

&НаКлиенте
Процедура ОткрытьПользователяИзСписка()
	
	ТекущиеДанные = Элементы.СписокПользователей.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Пользователь = ТекущиеДанные.ПользовательСсылка;
	Если ЗначениеЗаполнено(Пользователь) Тогда
		ПараметрыОткрытия = Новый Структура("Ключ", Пользователь);
		Если ТипЗнч(Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
			ОткрытьФорму("Справочник.Пользователи.Форма.ФормаЭлемента", ПараметрыОткрытия);
		ИначеЕсли ТипЗнч(Пользователь) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
			ОткрытьФорму("Справочник.ВнешниеПользователи.Форма.ФормаЭлемента", ПараметрыОткрытия);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
