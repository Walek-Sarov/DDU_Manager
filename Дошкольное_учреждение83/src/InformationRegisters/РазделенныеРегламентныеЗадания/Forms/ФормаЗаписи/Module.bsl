
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Запись.РегламентноеЗадание);
	Если Задание = Неопределено Тогда
		ШаблонПредставления = НСтр("ru = 'Задание с идентификатором %1 не найдено'");
		ПредставлениеРегламентногоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПредставления,
			Запись.РегламентноеЗадание);
	Иначе
		
		ШаблонПредставления = НСтр("ru = '%1 (идентификатор: %2)'");
		Если ПустаяСтрока(Задание.Наименование) Тогда
			НаименованиеЗадания = Задание.Метаданные.Представление();
		Иначе
			НаименованиеЗадания = Задание.Наименование;
		КонецЕсли;
		
		ПредставлениеРегламентногоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПредставления,
			НаименованиеЗадания, Запись.РегламентноеЗадание);
			
	КонецЕсли;
	
	
КонецПроцедуры
