///////////////////////////////////////////////////////////////////////////////////
// СообщенияУдаленногоАдминистрирования.
//
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает новое сообщение удаленного администрирования для отправки в менеджер сервиса.
//
// Параметры:
//  ТипСообщения - ТипОбъектаXDTO - тип сообщения которое требуется создать
//
// Возвращаемое значение:
//  ОбъектXDTO - объект требуемого типа
Функция НовоеСообщение(Знач ТипСообщения) Экспорт
	
	Возврат ФабрикаXDTO.Создать(ТипСообщения);
	
КонецФункции

// Отправвляет сообщение удаленного администрирования
//
// Параметры:
//  Содержимое - ОбъектXDTO - содержимое сообщения
//  Получатель - ПланОбменаСсылка.ОбменСообщениями - получатель сообщения
//  Сейчас - Булево - отправить сообщений через механизм быстрых сообщений
//
Процедура ОтправитьСообщение(Знач Содержимое, Знач Получатель = Неопределено, Знач Сейчас = Ложь) Экспорт
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	
	ФабрикаXDTO.ЗаписатьXML(Запись, Содержимое, , , , НазначениеТипаXML.Явное);
	
	КаналСообщений = ИмяКаналаПоТипуСообщения(Содержимое.Тип());
	
	Если Сейчас Тогда
		ОбменСообщениями.ОтправитьСообщениеСейчас(КаналСообщений, Запись.Закрыть(), Получатель);
	Иначе
		ОбменСообщениями.ОтправитьСообщение(КаналСообщений, Запись.Закрыть(), Получатель);
	КонецЕсли;
	
КонецПроцедуры

// Получате содержимое сообщения удаленного администрирования из тела
// сообщения
//
// Параметры:
//  ТелоСообщения - ХранилищеЗначения - тело сообщения
//
// Возвращаемое значение:
//  ОбъектXDTO - содержимое сообщения удаленного администрирования
//  полученное из тело сообщения
//
Функция ПолучитьСодержимоеСообщения(Знач ТелоСообщения) Экспорт
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(ТелоСообщения);
	
	Содержимое = ФабрикаXDTO.ПрочитатьXML(Чтение);
	
	Чтение.Закрыть();
	
	Возврат Содержимое;
	
КонецФункции

// Возвращает имя канала сообщений удаленного администрирования соответствующего
// типу сообщения.
//
// Параметры:
//  ТипСообщения - ТипОбъектаXDTO - тип сообщения удаленного администрирования
//
// Возвращаемое значение:
//  Строка - имя канала сообщений соответствующее переданному типу сообщения
//
Функция ИмяКаналаПоТипуСообщения(Знач ТипСообщения) Экспорт
	
	Возврат СериализаторXDTO.XMLСтрока(Новый РасширенноеИмяXML(ТипСообщения.URIПространстваИмен, ТипСообщения.Имя));
	
КонецФункции

// Возвращает тип сообщений удаленного администрирования по 
// имени канала сообщений
//
// Параметры:
//  ИмяКанала - Строка - имя канала сообщений соответствующее переданному типу сообщения
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - тип сообщения удаленного администрирования
//
Функция ТипСообщенияПоИмениКанала(Знач ИмяКанала) Экспорт
	
	Возврат ФабрикаXDTO.Тип(СериализаторXDTO.XMLЗначение(Тип("РасширенноеИмяXML"), ИмяКанала));
	
КонецФункции

// Вызывает исключение при получении сообщения в неизвестный канал.
//
// Параметры:
//  КаналСообщений - Строка - имя неизвестного канала сообщений.
//
Процедура ОшибкаНеизвестноеИмяКанала(Знач КаналСообщений) Экспорт
	
	ШаблонСообщения = НСтр("ru = 'Неизвестное имя канала сообщений %1'");
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КаналСообщений);
	ВызватьИсключение(ТекстСообщения);
	
КонецПроцедуры
