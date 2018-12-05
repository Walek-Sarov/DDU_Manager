////////////////////////////////////////////////////////////////////////////////
// Подсистема "Получение файлов из интернета"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Получить файл из Интернета по протоколу http(s), либо ftp и сохранить его во временный файл.
//
// Параметры:
//   URL                  - Строка - url файла в формате
//                                   [Протокол://]<Сервер>/<Путь к файлу на сервере>
//   ПараметрыПолучения   - Структура со свойствами
//     ПутьДляСохранения    - Строка - путь на сервере (включая имя файла), для сохранения скачанного файла
//     Пользователь         - Строка - пользователь от имени которого установлено соединение
//     Пароль               - Строка - пароль пользователя от которого установлено соединение
//     Порт                 - Число  - порт сервера с которым установлено соединение
//     Таймаут              - Число  - таймаут на получение файла, в секундах
//     ЗащищенноеСоединение - Булево - для случая http загрузки флаг указывает,
//                                     что соединение должно производиться через https
//     ПассивноеСоединение  - Булево - для случая ftp загрузки флаг указывает,
//                                     что соединение должно пассивным (или активным)
//
// Возвращаемое значение:
//   Структура, со свойствами
//     Статус - Булево - ключ присутствует в структуре всегда, значения
//                       Истина - вызов функции успешно завершен
//                       Ложь   - вызов функции завершен неудачно
//     Путь   - Строка - путь к файлу на сервере, ключ используется только
//                       если статус Истина
//     СообщениеОбОшибке - Строка - сообщение об ошибке, если статус Ложь
//
Функция СкачатьФайлНаСервере(знач URL, ПараметрыПолучения = Неопределено) Экспорт
	
	// Объявление переменных перед первым использованием в качестве
	// параметра метода Свойство, при анализе параметров получения файлов
	// из ПараметрыПолучения. Содержат значения переданных параметров получения файла
	Перем ПутьДляСохранения, Пользователь, Пароль, Порт, Таймаут,
	      ЗащищенноеСоединение, ПассивноеСоединение;
	
	// Инициализируем параметры скачивания файла
	Если ПараметрыПолучения = Неопределено Тогда
		ПараметрыПолучения = Новый Структура;
	КонецЕсли;
	
	Если Не ПараметрыПолучения.Свойство("ПутьДляСохранения", ПутьДляСохранения) Тогда
		ПутьДляСохранения = Неопределено;
	КонецЕсли;
	
	Если Не ПараметрыПолучения.Свойство("Пользователь", Пользователь) Тогда
		Пользователь = Неопределено;
	КонецЕсли;
	
	Если Не ПараметрыПолучения.Свойство("Пароль", Пароль) Тогда
		Пароль = Неопределено;
	КонецЕсли;
	
	Если Не ПараметрыПолучения.Свойство("Порт", Порт) Тогда
		Порт = Неопределено;
	КонецЕсли;
	
	Если Не ПараметрыПолучения.Свойство("Таймаут", Таймаут) Тогда
		Таймаут = Неопределено;
	КонецЕсли;
	
	Если Не ПараметрыПолучения.Свойство("ЗащищенноеСоединение", ЗащищенноеСоединение) Тогда
		ЗащищенноеСоединение = Неопределено;
	КонецЕсли;
	
	Если Не ПараметрыПолучения.Свойство("ПассивноеСоединение", ПассивноеСоединение) Тогда
		ПассивноеСоединение = Неопределено;
	КонецЕсли;
	
	НастройкаСохранения = Новый Соответствие;
	НастройкаСохранения.Вставить("МестоХранения", "Сервер");
	НастройкаСохранения.Вставить("Путь", ПутьДляСохранения);
	
	Результат = ПолучениеФайловИзИнтернетаКлиентСервер.ПодготовитьПолучениеФайла(
		URL,
		Пользователь,
		Пароль,
		Порт,
		Таймаут,
		ЗащищенноеСоединение,
		ПассивноеСоединение,
		НастройкаСохранения);
	
	Возврат Результат;
	
КонецФункции

// Получить файл из Интернета по протоколу http(s), либо ftp и сохранить его во временное хранилище.
//
// Параметры:
//   URL                  - Строка - url файла в формате:
//                                   [Протокол://]<Сервер>/<Путь к файлу на сервере>
//   ПараметрыПолучения   - Структура со свойствами
//     Пользователь         - Строка - пользователь от имени которого установлено соединение
//     Пароль               - Строка - пароль пользователя от которого установлено соединение
//     Порт                 - Число  - порт сервера с которым установлено соединение
//     Таймаут              - Число  - таймаут на получение файла, в секундах
//     ЗащищенноеСоединение - Булево - для случая http загрузки флаг указывает,
//                                     что соединение должно производиться через https
//     ПассивноеСоединение  - Булево - для случая ftp загрузки флаг указывает,
//                                     что соединение должно пассивным (или активным)
//
// Возвращаемое значение:
//   Структура со свойствами
//     Статус  - Булево - ключ присутствует в структуре всегда, значения
//                        Истина - вызов функции успешно завершен
//                        Ложь   - вызов функции завершен неудачно
//     Путь    - Строка - адрес временного хранилища с двоичными данными файла,
//                        ключ используется только если статус Истина
//     СообщениеОбОшибке - Строка - сообщение об ошибке, если статус Ложь
//
Функция СкачатьФайлВоВременноеХранилище(знач URL, ПараметрыПолучения = Неопределено) Экспорт
	
	// Объявление переменных перед первым использованием в качестве
	// параметра метода Свойство, при анализе параметров получения файлов
	// из ПараметрыПолучения. Содержат значения переданных параметров получения файла
	Перем ПутьДляСохранения, Пользователь, Пароль, Порт, Таймаут,
	      ЗащищенноеСоединение, ПассивноеСоединение;
		  
	// Получаем параметры получения файла
	Если ПараметрыПолучения = Неопределено Тогда
		ПараметрыПолучения = Новый Структура;
	КонецЕсли;
	
	Если Не ПараметрыПолучения.Свойство("ПутьДляСохранения", ПутьДляСохранения) Тогда
		ПутьДляСохранения = Неопределено;
	КонецЕсли;
	
	Если Не ПараметрыПолучения.Свойство("Пользователь", Пользователь) Тогда
		Пользователь = Неопределено;
	КонецЕсли;
	
	Если Не ПараметрыПолучения.Свойство("Пароль", Пароль) Тогда
		Пароль = Неопределено;
	КонецЕсли;
	
	Если Не ПараметрыПолучения.Свойство("Порт", Порт) Тогда
		Порт = Неопределено;
	КонецЕсли;
	
	Если Не ПараметрыПолучения.Свойство("Таймаут", Таймаут) Тогда
		Таймаут = Неопределено;
	КонецЕсли;
	
	Если Не ПараметрыПолучения.Свойство("ЗащищенноеСоединение", ЗащищенноеСоединение) Тогда
		ЗащищенноеСоединение = Неопределено;
	КонецЕсли;
	
	Если Не ПараметрыПолучения.Свойство("ПассивноеСоединение", ПассивноеСоединение) Тогда
		ПассивноеСоединение = Неопределено;
	КонецЕсли;
	
	НастройкаСохранения = Новый Соответствие;
	НастройкаСохранения.Вставить("МестоХранения", "ВременноеХранилище");
	
	Результат = ПолучениеФайловИзИнтернетаКлиентСервер.ПодготовитьПолучениеФайла(
		URL,
		Пользователь,
		Пароль,
		Порт,
		Таймаут,
		ЗащищенноеСоединение,
		ПассивноеСоединение,
		НастройкаСохранения);
	
	Возврат Результат;
	
КонецФункции

// Записывает двоичные данные в файл, хранящийся во временном хранилище
//
// Параметры:
//   АдресВоВременномХранилище - Строка - адрес двоичных данных файла 
//                                        во временном хранилище
//   ИмяФайла                  - Строка - путь по которому файл необходимо сохранить
//                                        на сервере
//
Функция СохранитьФайлИзВременногоХранилищаНаСервере(АдресВоВременномХранилище, ИмяФайла) Экспорт
	
	ДанныеФайла = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	ДанныеФайла.Записать(ИмяФайла);
	
	Возврат Истина;
	
КонецФункции

// Получает имя временного файла вызовом одноименной системной функции на сервере
//
Функция ПолучитьИмяВременногоФайлаНаСервере() Экспорт

	Возврат ПолучитьИмяВременногоФайла();

КонецФункции

// Возвращает параметры настройки прокси сервера на стороне сервера 1С:Предприятие
//
Функция ПолучитьНастройкиПроксиНаСервере1СПредприятие() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Константы.НастройкаПроксиСервера.Получить().Получить();
	
КонецФункции

// Возвращает параметры настройки прокси сервера на стороне сервера 1С:Предприятие
//
Процедура СохранитьНастройкиПроксиНаСервере1СПредприятие(знач Настройки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Константы.НастройкаПроксиСервера.Установить(Новый ХранилищеЗначения(Настройки));
	
КонецПроцедуры

// Возвращает настройку прокси сервера для доступа к интернет со стороны
// клиента для текущего пользователя.
//
Функция ПолучитьНастройкуПроксиСервера() Экспорт
	
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкаПроксиСервера");
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации. 
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ДобавитьПараметрыРаботыКлиента(Параметры) Экспорт
	
	Параметры.Вставить("НастройкиПроксиСервера", ПолучитьНастройкуПроксиСервера());
	
КонецПроцедуры
	
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Записывает событие-ошибку в журнал регистрации. Имя события
// "Получение файлов из Интернета".
// Параметры
//   СообщениеОбОшибке - строка сообщение об ошибке
// 
Процедура ЗаписатьОшибкуВЖурналРегистрации(знач СообщениеОбОшибке) Экспорт
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Получение файлов из Интернета'"),
		УровеньЖурналаРегистрации.Ошибка, , ,
		СообщениеОбОшибке
	);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.2.1.4";
	Обработчик.Процедура = "ПолучениеФайловИзИнтернета.ОбновитьХранимыеНастройкиПрокси";
	
КонецПроцедуры	

// Инициализирует новые настройки прокси-сервера "ИспользоватьПрокси"
// и "ИспользоватьСистемныеНастройки".
//
Процедура ОбновитьХранимыеНастройкиПрокси() Экспорт
	
	МассивПользователейИБ = ПользователиИнформационнойБазы.ПолучитьПользователей();
	
	Для Каждого ПользовательИБ Из МассивПользователейИБ Цикл
		
		НастройкаПроксиСервера = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкаПроксиСервера", ,	, ,	ПользовательИБ.Имя);
		
		Если ТипЗнч(НастройкаПроксиСервера) = Тип("Соответствие") Тогда
			
			СохранитьНастройкиПользователя = Ложь;
			Если НастройкаПроксиСервера.Получить("ИспользоватьПрокси") = Неопределено Тогда
				НастройкаПроксиСервера.Вставить("ИспользоватьПрокси", Ложь);
				СохранитьНастройкиПользователя = Истина;
			КонецЕсли;
			Если НастройкаПроксиСервера.Получить("ИспользоватьСистемныеНастройки") = Неопределено Тогда
				НастройкаПроксиСервера.Вставить("ИспользоватьСистемныеНастройки", Ложь);
				СохранитьНастройкиПользователя = Истина;
			КонецЕсли;
			Если СохранитьНастройкиПользователя Тогда
				ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
					"НастройкаПроксиСервера", , НастройкаПроксиСервера, , ПользовательИБ.Имя);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	НастройкаПроксиСервера = ПолучитьНастройкиПроксиНаСервере1СПредприятие();
	
	Если ТипЗнч(НастройкаПроксиСервера) = Тип("Соответствие") Тогда
		
		СохранитьНастройкиСервера = Ложь;
		Если НастройкаПроксиСервера.Получить("ИспользоватьПрокси") = Неопределено Тогда
			НастройкаПроксиСервера.Вставить("ИспользоватьПрокси", Ложь);
			СохранитьНастройкиСервера = Истина;
		КонецЕсли;
		Если НастройкаПроксиСервера.Получить("ИспользоватьСистемныеНастройки") = Неопределено Тогда
			НастройкаПроксиСервера.Вставить("ИспользоватьСистемныеНастройки", Ложь);
			СохранитьНастройкиСервера = Истина;
		КонецЕсли;
		Если СохранитьНастройкиСервера Тогда
			СохранитьНастройкиПроксиНаСервере1СПредприятие(НастройкаПроксиСервера);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

