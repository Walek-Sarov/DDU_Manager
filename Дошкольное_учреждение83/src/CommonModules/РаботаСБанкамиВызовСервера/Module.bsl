////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с банками".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Формирует, дополняет текст сообщения пользователю в случае, если загрузка данных классификатора проведена успешно
// 
// Параметры
//	ПараметрыЗагрузкиКлассификатора - Соответствие:
//	Загружено						- Число  - Количество новых записей классификатора
//	Обновлено						- Число  - Количество обновленных записей классификатора
//  ТекстСообщения					- Строка - текст сообщения об ошибке
//
Процедура ДополнитьТекстСообщения(ПараметрыЗагрузкиКлассификатора) Экспорт
	
	Если ПустаяСтрока(ПараметрыЗагрузкиКлассификатора["ТекстСообщения"]) Тогда
		ТекстСообщения = НСтр("ru ='Загрузка классификатора банков РФ выполнена успешно.'");
	Иначе
		ТекстСообщения = ПараметрыЗагрузкиКлассификатора["ТекстСообщения"];
	КонецЕсли;
	
	Если ПараметрыЗагрузкиКлассификатора["Загружено"] > 0 Тогда
		
		ТекстСообщения = ТекстСообщения + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru ='
		|Загружено новых: %1.'"), ПараметрыЗагрузкиКлассификатора["Загружено"]);
	     			
    КонецЕсли;
	
	Если ПараметрыЗагрузкиКлассификатора["Обновлено"] > 0 Тогда
		
		ТекстСообщения = ТекстСообщения + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru ='
		|Обновлено записей: %1.'"), ПараметрыЗагрузкиКлассификатора["Обновлено"]);

	КонецЕсли;
	
	ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ТекстСообщения);
	
КонецПроцедуры	
	
// Получает, сортирует, записывает данные классификатора БИК РФ с сайта РБК
// 
// Параметры
//	ПараметрыЗагрузкиКлассификатора - Соответствие:
//	Загружено						- Число	 - Количество новых записей классификатора
//	Обновлено						- Число	 - Количество обновленных записей классификатора
//  ТекстСообщения					- Строка - текст сообщения об ошибке
//
Процедура ПолучитьДанныеРБК(ПараметрыЗагрузкиКлассификатора) Экспорт
	
	ВременныйКаталог = КаталогВременныхФайлов() + "tempBik";
	СоздатьКаталог(ВременныйКаталог);
	РаботаСБанками.УдалитьФайлыВКаталоге(ВременныйКаталог, "*.*");
	
	ПараметрыПолученияФайловРБК = Новый Соответствие;
	ПараметрыПолученияФайловРБК.Вставить("ПутьКФайлуРБК", "");
	ПараметрыПолученияФайловРБК.Вставить("ТекстСообщения", ПараметрыЗагрузкиКлассификатора["ТекстСообщения"]);
	ПараметрыПолученияФайловРБК.Вставить("ВременныйКаталог", ВременныйКаталог);
	
	РаботаСБанками.ПолучитьДанныеРБКИзИнтернета(ПараметрыПолученияФайловРБК);
	
	Если Не ПустаяСтрока(ПараметрыПолученияФайловРБК["ТекстСообщения"]) Тогда
		ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ПараметрыПолученияФайловРБК["ТекстСообщения"]);
        Возврат;
	КонецЕсли;
	
	Попытка
		ZIPФайлРБК = Новый ЧтениеZipФайла(ПараметрыПолученияФайловРБК["ПутьКФайлуРБК"]);
	Исключение
		ТекстСообщения = НСтр("ru ='Возникли проблемы с файлом классификатора банков, полученным с сайта РБК.'");
        ТекстСообщения = ТекстСообщения + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	Если Не ПустаяСтрока(ТекстСообщения) Тогда
		ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ТекстСообщения);
 		Возврат;
	КонецЕсли;
    	
	Попытка
		ZIPФайлРБК.ИзвлечьВсе(ВременныйКаталог);
	Исключение
		ТекстСообщения = НСтр("ru ='Возникли проблемы с файлом классификатора банков, полученным с сайта РБК.'");
        ТекстСообщения = ТекстСообщения + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;	
	
	Если Не ПустаяСтрока(ТекстСообщения) Тогда
		ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПутьКФайлуБИКРБК = ВременныйКаталог + "\bnkseek.txt";
	ФайлБИКРБК	   = Новый Файл(ПутьКФайлуБИКРБК);
    Если Не ФайлБИКРБК.Существует() Тогда
        ТекстСообщения = НСтр("ru ='Возникли проблемы с файлом классификатора банков, полученным с сайта РБК. 
									|Архив не содержит информацию - классификатор банков.'");
		ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПутьКФайлуРегионовРБК = ВременныйКаталог + "\reg.txt";
	ФайлРегионовРБК		= Новый Файл(ПутьКФайлуРегионовРБК);
    Если Не ФайлРегионовРБК.Существует() Тогда
        ТекстСообщения = НСтр("ru ='Возникли проблемы с файлом классификатора банков, полученным с сайта РБК. 
									|Архив не содержит информацию о регионах.'");
		ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПараметрыЗагрузкиФайловРБК = Новый Соответствие;
	ПараметрыЗагрузкиФайловРБК.Вставить("ПутьКФайлуБИКРБК", ПутьКФайлуБИКРБК);
	ПараметрыЗагрузкиФайловРБК.Вставить("ПутьКФайлуРегионовРБК", ПутьКФайлуРегионовРБК);
	ПараметрыЗагрузкиФайловРБК.Вставить("ВременныйКаталог", ВременныйКаталог);
	ПараметрыЗагрузкиФайловРБК.Вставить("Загружено", ПараметрыЗагрузкиКлассификатора["Загружено"]);
	ПараметрыЗагрузкиФайловРБК.Вставить("Обновлено", ПараметрыЗагрузкиКлассификатора["Обновлено"]);
	ПараметрыЗагрузкиФайловРБК.Вставить("ТекстСообщения", ПараметрыЗагрузкиКлассификатора["ТекстСообщения"]);
		
	РаботаСБанками.ЗагрузитьДанныеРБК(ПараметрыЗагрузкиФайловРБК);
	
	Если Не ПустаяСтрока(ПараметрыЗагрузкиФайловРБК["ТекстСообщения"]) Тогда
		Возврат;
	КонецЕсли;
    	
	РаботаСБанками.УстановитьВерсиюКлассификатораБанков();
	РаботаСБанками.УдалитьФайлыВКаталоге(ВременныйКаталог,"*.*");
	
	ПараметрыЗагрузкиКлассификатора.Вставить("Загружено", ПараметрыЗагрузкиФайловРБК["Загружено"]);
	ПараметрыЗагрузкиКлассификатора.Вставить("Обновлено", ПараметрыЗагрузкиФайловРБК["Обновлено"]);
	ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ПараметрыЗагрузкиФайловРБК["ТекстСообщения"]);

КонецПроцедуры
