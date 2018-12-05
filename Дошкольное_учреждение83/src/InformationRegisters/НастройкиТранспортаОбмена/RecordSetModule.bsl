#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, Замещение)
	
	// Сбрасываем значение пароля, если не установлен признак хранения пароля в ИБ
	Для Каждого СтрокаНабора Из ЭтотОбъект Цикл
		
		Если Не СтрокаНабора.WSЗапомнитьПароль Тогда
			
			СтрокаНабора.WSПароль = "";
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	// обновляем кэш платформы для зачитывания актуальных настроек транспорта
	// сообщений обмена процедурой ОбменДаннымиПовтИсп.ПолучитьСтруктуруНастроекОбмена
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецЕсли