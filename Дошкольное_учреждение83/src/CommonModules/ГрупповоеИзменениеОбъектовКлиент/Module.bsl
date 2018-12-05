////////////////////////////////////////////////////////////////////////////////
// Подсистема "Групповое изменение объектов".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Используется для открытия формы группового изменения объектов.
//
// Параметры:
//  Список - ТаблицаФормы - элемент формы списка, содержащий ссылки на изменяемые объекты.
//
Процедура ИзменитьВыделенные(Список) Экспорт
	
	ВыделенныеСтроки = Список.ВыделенныеСтроки;
	
	ПараметрыФормы = Новый Структура("МассивОбъектов", Новый Массив);
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		ТекущаяСтрока = Список.ДанныеСтроки(ВыделеннаяСтрока);
		
		Если ТекущаяСтрока <> Неопределено Тогда
			
			ПараметрыФормы.МассивОбъектов.Добавить(ТекущаяСтрока.Ссылка);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПараметрыФормы.МассивОбъектов.Количество() = 0 Тогда
		Предупреждение(НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
		Возврат;
	КонецЕсли;
		
	ОткрытьФорму("Обработка.ГрупповоеИзменениеОбъектов.Форма", ПараметрыФормы);
	
КонецПроцедуры
