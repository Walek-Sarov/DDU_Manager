////////////////////////////////////////////////////////////////////////////////
// Подсистема "Проверка легальности получения обновления".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Запрашивает у пользователя диалог с подтверждением легальности полученного
// обновления и завершает работу системы если обновление получено не легально
// (см. параметр ЗавершатьРаботуСистемы).
//
// Параметры
//  ЗавершатьРаботуСистемы - Булево - завершать работу системы, если пользователь
//					указал что обновление получено не легально
//
// Возвращаемое значение:
//   Булево   - Истина, если проверка завершилась успешно (пользователь
//				подтвердил, что обновление получено легально)
//
Функция ПроверитьЛегальностьПолученияОбновления(знач ЗавершатьРаботуСистемы = Ложь) Экспорт
	
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЭтоБазоваяВерсияКонфигурации Тогда
		Возврат Истина;
	КонецЕсли;
	
	Результат = ОткрытьФормуМодально("Обработка.ЛегальностьПолученияОбновлений.Форма",
							Новый Структура("ПоказыватьПредупреждениеОПерезапуске,ПринудительныйЗапуск", 
											?(ЗавершатьРаботуСистемы, Истина, Ложь),
											Истина) );
	
	Если Результат <> Истина Тогда
		Если ЗавершатьРаботуСистемы Тогда
			ПропуститьПредупреждениеПередЗавершениемРаботыСистемы = Истина;
			ЗавершитьРаботуСистемы(Ложь);
		КонецЕсли;
		Возврат Ложь;
	КонецЕсли;
		
	Возврат Истина;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Проверить легальность получения обновления при запуске программы.
// Должна вызываться перед обновлением информационной базы.
//
Функция ПриНачалеРаботыСистемы() Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыКлиента.РазделениеВключено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ПараметрыКлиента.ПервыйВходВОбластьДанных
		Или Не ПараметрыКлиента.НеобходимоОбновлениеИнформационнойБазы
		Или Не ПараметрыКлиента.ЭтоГлавныйУзел Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат ПроверитьЛегальностьПолученияОбновления(Истина);
	
КонецФункции
