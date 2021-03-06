////////////////////////////////////////////////////////////////////////////////
// Подсистема "Оценка производительности".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Активизирует замер времени выполнения ключевой операции.
//
// Параметры:
//  КлючеваяОперация - СправочникСсылка.КлючевыеОперации - ключевая операция.
//
// Возвращаемое значение:
//  Число - время начала замера.
//
Функция НачатьЗамерВремени(КлючеваяОперация = Неопределено) Экспорт
	
	ВремяНачала = 0;
	Если ОценкаПроизводительностиПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		ВремяНачала = ОценкаПроизводительностиВызовСервераПолныеПрава.ЗафиксироватьВремяНачала();
		#Если Клиент Тогда
			Если КлючеваяОперация = Неопределено Тогда
				ВызватьИсключение НСтр("ru = 'Не указана ключевая операция.'");
			КонецЕсли;
			ОценкаПроизводительностиЗамерВремени = Новый Соответствие;
			ОценкаПроизводительностиЗамерВремени.Вставить("КлючеваяОперация", КлючеваяОперация);
			ОценкаПроизводительностиЗамерВремени.Вставить("ВремяНачала", ВремяНачала);
			
			ВремяСервер = ОценкаПроизводительностиВызовСервераПолныеПрава.ВремяСервер();
			ОценкаПроизводительностиЗамерВремени.Вставить("ВремяНачалаПроверка", ВремяСервер);
			
			ПодключитьОбработчикОжидания("ЗакончитьЗамерВремениАвто", 0.1, Истина);
		#КонецЕсли
	КонецЕсли;

	Возврат ВремяНачала;
	
КонецФункции

#Если Сервер Тогда
// Закончить замер времени выполнения ключевой операции.
//
// Параметры:
//  КлючеваяОперация - СправочникСсылка.КлючевыеОперации - операция, для которой надо зафиксировать время завершения;
//  ВремяНачалаКлючевойОперации - Число - время начала ключевой операции, полученное функцией НачатьЗамерВремени().
//
// Возвращаемое значение:
//  Число - время окончания замера.
//
Функция ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачалаКлючевойОперации) Экспорт
	
	ВремяОкончания = 0;
	Если ОценкаПроизводительностиПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		ВремяОкончания = ОценкаПроизводительностиВызовСервераПолныеПрава.ЗафиксироватьВремяОкончания(КлючеваяОперация, ВремяНачалаКлючевойОперации);
	КонецЕсли;
	
	Возврат ВремяОкончания;
	
КонецФункции

// Процедура записывает данные в журнал регистрации
//
// Параметры:
//  ИмяСобытия - Строка
//  Уровень - УровеньЖурналаРегистрации
//  ТекстСообщения - Строка
//
Процедура ЗаписатьВЖурналРегистрации(ИмяСобытия, Уровень, ТекстСообщения) Экспорт
	
	ЗаписьЖурналаРегистрации(ИмяСобытия,
		Уровень,
		,
		"Оценка производительности",
		ТекстСообщения);
	
КонецПроцедуры
#КонецЕсли

