#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает имена блокруемых реквизитов для подсистемы
// "Запрет редактирования реквизитов объектов".
// 
// Возвращаемое значание:
//  Массив Строк - имена блокируемых реквизитов.
// 
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("ТипЗначения");
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли