#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ВерсияОбменаДанными() Экспорт
	
	Возврат Неопределено;
	
КонецФункции

Функция ПланОбменаИспользуетсяВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Определяет использование механизма регистрации объектов
//
// Возвращаемое значение:
// Тип: Булево. Истина – механизм регистрации объектов необходимо использовать для текущего плана обмена;
// Ложь – механизм регистрации объектов использовать не требуется.
//
Функция ИспользоватьМеханизмРегистрацииОбъектов() Экспорт
	
	Возврат Истина;
	
КонецФункции


#КонецЕсли