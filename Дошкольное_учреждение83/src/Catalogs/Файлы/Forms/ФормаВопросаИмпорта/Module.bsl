
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ФайлыБольшие = Параметры.ФайлыБольшие;
	
	МаксимальныйРазмерФайла = Цел(Константы.МаксимальныйРазмерФайла.Получить() / (1024 * 1024));
	
	Сообщение =
	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	    НСтр("ru = 'Внимание!
	               |Некоторые файлы превышают предельный размер (%1 Мб) и не будут добавлены в хранилище.
				   |Продолжить импорт?'"),
	    Строка(МаксимальныйРазмерФайла) );
		
	Если Параметры.Свойство("РежимЗагрузки") Тогда
		Если Параметры.РежимЗагрузки Тогда
			
			Сообщение =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			    НСтр("ru = 'Внимание!
			               |Некоторые файлы превышают предельный размер (%1 Мб) и не будут добавлены в хранилище.
						   |Продолжить загрузку файлов?'"),
			    Строка(МаксимальныйРазмерФайла) );
			
		КонецЕсли;
	КонецЕсли;	
		
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;	
		
КонецПроцедуры
