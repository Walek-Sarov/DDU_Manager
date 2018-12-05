////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ОтКого") Тогда 
		ОтКого = Параметры.ОтКого;
	КонецЕсли;
	
	Если Параметры.Свойство("Тема") Тогда 
		Тема = Параметры.Тема;
	КонецЕсли;
	
	Если Параметры.Свойство("Текст") Тогда 
		Текст = Параметры.Текст;
	КонецЕсли;
	
	Если Параметры.Свойство("Вложения") Тогда 
		Вложения = Параметры.Вложения;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьКурсорВШаблонеТекста();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ



////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Отправить(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат;
	КонецЕсли;
	
	РезультатОтправки = ОтправитьСообщениеСервер();
	Если РезультатОтправки Тогда 
		Предупреждение(НСтр("ru = 'Сообщение отправлено.'"));
		Закрыть();
	Иначе
		Предупреждение(НСтр("ru = 'К сожалению сообщение не было отправлено.
		|Повторите попытку позже.'"));
	КонецЕсли;	
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ОтправитьСообщениеСервер()
	
	ПараметрыСообщения = Новый Структура();
	ПараметрыСообщения.Вставить("ОтКого",	ОтКого);
	ПараметрыСообщения.Вставить("Тема",		Тема);
	ПараметрыСообщения.Вставить("Текст",	Текст);
	ПараметрыСообщения.Вставить("Вложения",	Вложения);
	
	
	Результат = Истина;
	СтандартныеПодсистемыПереопределяемый.ОтправитьСообщениеПользователяВТехподдержку(ПараметрыСообщения, Результат);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура УстановитьКурсорВШаблонеТекста()
	
	СтрокаПозицияКурсора = НСтр("ru = 'ПозицияКурсора'");
	СтрокаКурсора = ОпределитьНомерСтрокиДляКурсора(Текст, СтрокаПозицияКурсора);
	
	Текст = СтрЗаменить(Текст, СтрокаПозицияКурсора, "");
	ТекущийЭлемент = Элементы.Текст;
	Элементы.Текст.УстановитьГраницыВыделения(СтрокаКурсора, 1, СтрокаКурсора, 1);
	
КонецПроцедуры

&НаКлиенте
Функция ОпределитьНомерСтрокиДляКурсора(знач ТекстПараметр, СтрокаПозицияКурсора)
	
	МассивСтрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТекстПараметр, Символы.ПС);
	
	Если МассивСтрок.Количество() = 0 Тогда 
		Возврат 1;
	КонецЕсли;
	
	Для Итерация = 0 по МассивСтрок.Количество() - 1 Цикл 
		Если Найти(МассивСтрок.Получить(Итерация), СтрокаПозицияКурсора) <> 0 Тогда 
			Возврат Итерация + 1;
		КонецЕсли;
	КонецЦикла;
		
	Возврат 1;
	
КонецФункции
