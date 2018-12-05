
////////////////////////////////////////////////////////////////////////////////
// РезервноеКопированиеОбластейДанныхПовтИсп.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает соответствие русских названий полей программных системных настроек
// английским из XDTO-пакета ZoneBackupControl Менеджера сервиса
// (тип: {http://www.1c.ru/SaaS/1.0/XMLSchema/ZoneBackupControl}Settings).
//
// Возвращаемое значение:
// ФиксированноеСоответствие.
//
Функция СоответствиеРусскихИменПолейНастроекАнглийским() Экспорт
	
	Результат = Новый Соответствие;
	
	Результат.Вставить("CreateDailyBackup", "ФормироватьЕжедневныеКопии");
	Результат.Вставить("CreateMonthlyBackup", "ФормироватьЕжемесячныеКопии");
	Результат.Вставить("CreateYearlyBackup", "ФормироватьЕжегодныеКопии");
	Результат.Вставить("BackupCreationTime", "ВремяФормированияКопий");
	Результат.Вставить("MonthlyBackupCreationDay", "ЧислоМесяцаФормированияЕжемесячныхКопий");
	Результат.Вставить("YearlyBackupCreationMonth", "МесяцФормированияЕжегодныхКопий");
	Результат.Вставить("YearlyBackupCreationDay", "ЧислоМесяцаФормированияЕжегодныхКопий");
	Результат.Вставить("KeepDailyBackups", "КоличествоЕжедневныхКопий");
	Результат.Вставить("KeepMonthlyBackups", "КоличествоЕжемесячныхКопий");
	Результат.Вставить("KeepYearlyBackups", "КоличествоЕжегодныхКопий");
	Результат.Вставить("CreateDailyBackupOnUserWorkDaysOnly", "ФормироватьЕжедневныеКопииТолькоВДниРаботыПользователей");
	
	Возврат Новый ФиксированноеСоответствие(Результат);

КонецФункции	

// Определяет, поддерживает ли приложение функциональность резервного копирования.
//
// Возвращаемое значение:
// Булево - Истина, если приложение поддерживает функциональность резервного копирования.
//
Функция МенеджерСервисаПоддерживаетРезервноеКопирование() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПоддерживаемыеВерсии = ОбщегоНазначения.ПолучитьВерсииИнтерфейса(
		Константы.ВнутреннийАдресМенеджераСервиса.Получить(),
		Константы.ИмяСлужебногоПользователяМенеджераСервиса.Получить(),
		Константы.ПарольСлужебногоПользователяМенеджераСервиса.Получить(),
		"РезервноеКопированиеОбластейДанных");
		
	Возврат ПоддерживаемыеВерсии.Найти("1.0.1.1") <> Неопределено;
	
КонецФункции

// Возвращает прокси web-сервиса контроля резервного копирования.
// 
// Возвращаемое значение: 
// WSПрокси.
// Прокси менеджера сервиса. 
// 
Функция ПроксиКонтроляРезервногоКопирования() Экспорт
	
	АдресМенеджераСервиса = Константы.ВнутреннийАдресМенеджераСервиса.Получить();
	Если Не ЗначениеЗаполнено(АдресМенеджераСервиса) Тогда
		ВызватьИсключение(НСтр("ru = 'Не установлены параметры связи с менеджером сервиса.'"));
	КонецЕсли;
	
	АдресСервиса = АдресМенеджераСервиса + "/ws/ZoneBackupControl?wsdl";
	ИмяПользователя = Константы.ИмяСлужебногоПользователяМенеджераСервиса.Получить();
	ПарольПользователя = Константы.ПарольСлужебногоПользователяМенеджераСервиса.Получить();
	
	Прокси = ОбщегоНазначения.WSПрокси(АдресСервиса, "http://www.1c.ru/SaaS/1.0/WS",
		"ZoneBackupControl", , ИмяПользователя, ПарольПользователя, 10);
		
	Возврат Прокси;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// Обмен сообщениями

// Возвращает URI пространство имен XDTO-пакета УправлениеРезервнымКопированиемОбластейДанных.
//
// Возвращаемое значение:
// Строка.
//
Функция ПакетУправлениеРезервнымКопированиемОбластейДанных() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/ManageZonesBackup/1.0.2.1";
	
КонецФункции

// Возвращает URI пространство имен XDTO-пакета КонтрольРезервногоКопированияОбластейДанных.
//
// Возвращаемое значение:
// Строка.
//
Функция ПакетКонтрольРезервногоКопированияОбластейДанных() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/ControlZonesBackup/1.0.2.1";
	
КонецФункции

// Возвращает тип объекта XDTO-пакета УправлениеРезервнымКопированиемОбластейДанных по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеПланироватьАрхивациюОбласти() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетУправлениеРезервнымКопированиемОбластейДанных(), "PlanZoneBackup");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета УправлениеРезервнымКопированиемОбластейДанных по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеОтменитьАрхивациюОбласти() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетУправлениеРезервнымКопированиемОбластейДанных(), "CancelZoneBackup");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета КонтрольРезервногоКопированияОбластейДанных по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеРезервнаяКопияОбластиСоздана() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетКонтрольРезервногоКопированияОбластейДанных(), "ZoneBackupSuccessfull");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета КонтрольРезервногоКопированияОбластейДанных по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеОшибкаАрхивацииОбласти() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетКонтрольРезервногоКопированияОбластейДанных(), "ZoneBackupFailed");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета КонтрольРезервногоКопированияОбластейДанных по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеАрхивацияОбластиПропущена() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетКонтрольРезервногоКопированияОбластейДанных(), "ZoneBackupSkipped");
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Фоновые задания

// Возвращает имя метода фонового задания выгрузки области в файл.
//
// Возвращаемое значение:
// Строка.
//
Функция ИмяМетодаФоновогоРезервногоКопирования() Экспорт
	
	Возврат "РезервноеКопированиеОбластейДанных.ВыгрузитьОбластьВХранилищеМС";
	
КонецФункции

// Возвращает наименование фонового задания выгрузки области в файл.
//
// Возвращаемое значение:
// Строка.
//
Функция НаименованиеФоновогоРезервногоКопирования() Экспорт
	
	Возврат НСтр("ru = 'Резервное копирование области данных'");
	
КонецФункции
