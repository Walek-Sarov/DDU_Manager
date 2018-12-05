////////////////////////////////////////////////////////////////////////////////
// Подсистема "Управление доступом".
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает массив структур, которые будут использованы для начального заполнения
// или восстановления начального заполнения профилей групп доступа.
//
//  Пустая структура может быть получена при помощи функции
// УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа().
//
//  Для автоматической подготовки содержимого процедуры следует
// воспользоваться инструментами разработчика для подсистемы
// Управление доступом.
//
// Возвращаемое значение:
//  Массив.
//
Функция ОписанияНачальногоЗаполненияПрофилейГруппДоступа() Экспорт
	
	ОписанияПрофилей = Новый Массив;
	
	Возврат ОписанияПрофилей;
	
КонецФункции

// Заполняет свойства видов доступа, заданных прикладным разработчиком,
// в виде предопределенных элементов в объекте ПланВидовХарактеристик.ВидыДоступа.
//  Структуру свойств см. в функции, вызывающей эту процедуру:
// УправлениеДоступомСлужебныйПовтИсп.СвойстваВидовДоступа().
//
// Параметры:
//  Свойства     - СтрокаТаблицыЗначений, содержащая поля,
//                 описание которых  см. в комментарии к функции
//                 УправлениеДоступомСлужебныйПовтИсп.СвойстваВидовДоступа().
// 
Процедура ЗаполнитьСвойстваВидаДоступа(Знач Свойства) Экспорт
	
	// СтандартныеПодсистемы.БизнесПроцессыИЗадачи
	Если Свойства.ВидДоступа = ПланыВидовХарактеристик.ВидыДоступа.Пользователи Тогда
		Свойства.Таблицы.Добавить("Справочник.ГруппыИсполнителейЗадач");
	// Конец СтандартныеПодсистемы.БизнесПроцессыИЗадачи
		
	// СтандартныеПодсистемы.РаботаСПочтовымиСообщениями
	ИначеЕсли Свойства.ВидДоступа = ПланыВидовХарактеристик.ВидыДоступа.УчетныеЗаписиЭлектроннойПочты Тогда
		Свойства.Таблицы.Добавить("Справочник.УчетныеЗаписиЭлектроннойПочты");
	// Конец СтандартныеПодсистемы.РаботаСПочтовымиСообщениями
	
	// СтандартныеПодсистемы.Свойства
	ИначеЕсли Свойства.ВидДоступа = ПланыВидовХарактеристик.ВидыДоступа.ДополнительныеСведения Тогда
		Свойства.Таблицы.Добавить("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения");
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.Организации
	ИначеЕсли Свойства.ВидДоступа = ПланыВидовХарактеристик.ВидыДоступа.Организации Тогда
		Свойства.Таблицы.Добавить("Справочник.Организации");
	// Конец СтандартныеПодсистемы.Организации
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ИначеЕсли Свойства.ВидДоступа = ПланыВидовХарактеристик.ВидыДоступа.ПапкиФайлов Тогда
		Свойства.Таблицы.Добавить("Справочник.ПапкиФайлов");
		Свойства.ВидДоступаЧерезПраваПоЗначениямДоступа = Истина;
	// Конец СтандартныеПодсистемы.РаботаСФайлами	
	
	КонецЕсли;
	
КонецПроцедуры

// Заполняет описания возможных прав, назначаемых по значениям доступа.
//  Структуру описаний см. в функции, вызывающей эту процедуру:
// УправлениеДоступомСлужебныйПовтИсп.ВозможныеПраваПоЗначениямДоступа().
// 
// Параметры:
//  ВозможныеПрава - ТаблицаЗначений, содержащая поля,
//                 описание которых  см. в комментарии к функции
//                 УправлениеДоступомСлужебныйПовтИсп.ВозможныеПраваПоЗначениямДоступа().
//
Процедура ЗаполнитьВозможныеПраваПоЗначениямДоступа(Знач ВозможныеПрава) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	
	////////////////////////////////////////////////////////////
	// Справочник.ПапкиФайлов
	////////////////////////////////////////////////////////////
	Право = ВозможныеПрава.Добавить();
	Право.ВладелецПрав  = "Справочник.ПапкиФайлов";
	Право.Имя           = "ЧтениеПапокИФайлов";
	Право.Синоним       = НСтр("ru = 'Чтение папок и файлов'");
	Право.Сокращение    = НСтр("ru = 'Чтение'");
	Право.Заголовок     = НСтр("ru = 'Чт'");
	Право.НачальноеЗначение = Истина;
	// Требуемая роль (одна из указанных)
	Право.ТребуемаяРоль.Добавить("РаботаСПапкамиФайлов");
	// Права для стандартных шаблонов ограничений доступа.
	Право.ЧтениеВТаблицах.Добавить("Справочник.ПапкиФайлов");
	Право.ЧтениеВТаблицах.Добавить("Справочник.Файлы");
	Право.ЧтениеВТаблицах.Добавить("Справочник.ВерсииФайлов");
	Право.ЧтениеВТаблицах.Добавить("РегистрСведений.ХранимыеФайлыВерсий");
	
	Право = ВозможныеПрава.Добавить();
	Право.ВладелецПрав  = "Справочник.ПапкиФайлов";
	Право.Имя           = "ДобавлениеПапокИФайлов";
	Право.Синоним       = НСтр("ru = 'Добавление папок и файлов'");
	Право.Сокращение    = НСтр("ru = 'Добавление'");
	Право.Заголовок     = НСтр("ru = 'Доб'");
	// Права, требуемые для этого права.
	Право.ТребуемыеПрава.Добавить("ЧтениеПапокИФайлов");
	Право.ТребуемыеПрава.Добавить("ИзменениеПапокИФайлов");
	// Требуемая роль (одна из указанных).
	Право.ТребуемаяРоль.Добавить("РаботаСПапкамиФайлов");
	// Права для стандартных шаблонов ограничений доступа.
	Право.ДобавлениеВТаблицах.Добавить("Справочник.ПапкиФайлов");
	Право.ДобавлениеВТаблицах.Добавить("Справочник.Файлы");
	
	Право = ВозможныеПрава.Добавить();
	Право.ВладелецПрав  = "Справочник.ПапкиФайлов";
	Право.Имя           = "ИзменениеПапокИФайлов";
	Право.Синоним       = НСтр("ru = 'Изменение папок и файлов'");
	Право.Сокращение    = НСтр("ru = 'Изменение'");
	Право.Заголовок     = НСтр("ru = 'Изм'");
	// Требуемая роль (одна из указанных).
	Право.ТребуемаяРоль.Добавить("РаботаСПапкамиФайлов");
	Право.ТребуемыеПрава.Добавить("ЧтениеПапокИФайлов");
	// Права для стандартных шаблонов ограничений доступа.
	Право.ИзменениеВТаблицах.Добавить("Справочник.ПапкиФайлов");
	Право.ИзменениеВТаблицах.Добавить("Справочник.Файлы");
	
	Право = ВозможныеПрава.Добавить();
	Право.ВладелецПрав  = "Справочник.ПапкиФайлов";
	Право.Имя           = "ПометкаУдаленияПапокИФайлов";
	Право.Синоним       = НСтр("ru = 'Пометка удаления папок и файлов'");
	Право.Сокращение    = НСтр("ru = 'Пометка удаления'");
	Право.Заголовок     = НСтр("ru = 'ПомУд'");
	// Права, требуемые для этого права.
	Право.ТребуемыеПрава.Добавить("ЧтениеПапокИФайлов");
	Право.ТребуемыеПрава.Добавить("ИзменениеПапокИФайлов");
	// Требуемая роль (одна из указанных)
	Право.ТребуемаяРоль.Добавить("РаботаСПапкамиФайлов");
	
	Право = ВозможныеПрава.Добавить();
	Право.ВладелецПрав  = "Справочник.ПапкиФайлов";
	Право.Имя           = "УправлениеПравами";
	Право.Синоним       = НСтр("ru = 'Управление правами папок файлов'");
	Право.Сокращение    = НСтр("ru = 'Управление правами'");
	Право.Заголовок     = НСтр("ru = 'Адм'");
	// Права, требуемые для этого права.
	Право.ТребуемыеПрава.Добавить("ЧтениеПапокИФайлов");
	// Требуемая роль (одна из указанных)
	Право.ТребуемаяРоль.Добавить("РаботаСПапкамиФайлов");
	
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

// Возвращает менеджер временных таблиц, содержащий временную таблицу пользователей,
// подчиненных другим пользователям, для расширения доступа пользователей-руководителей
// доступом пользователей-подчиненных.
//
//  Например, если есть справочник Подразделения у которого есть пользователь-руководитель
// и состав пользователей-сотрудников, то можно сделать выборку из этого справочника
// и поместить во временную таблицу.
//  При записи групп пользователей, будет учтено, что пользователи-руководители должны
// иметь доступ, включающий доступ их пользователей-подчиненных.
//  При изменении связи Руководитель<->Подчиненный, например, при изменении руководителя
// в подразделении, нужно в модуле УправлениеДоступом вызвать процедуру
// ЗаписатьГруппыИВидыДоступа(Справочник.ГруппыПользователей.ВсеПользователи), чтобы
// произошло обновление данных, в формировании которых используется эта процедура.
//
// Параметры:
//  МенеджерВременныхТаблиц - МенеджерВременныхТаблиц в который можно поместить таблицу:
//                 ТаблицаПодчиненностиПользователей с полями:
//                   Пользователь            - СправочникСсылка.Пользователи, СправочникСсылка.ВнешниеПользователи
//                   ПодчиненныйПользователь - СправочникСсылка.Пользователи, СправочникСсылка.ВнешниеПользователи
//
// Возвращаемое значение:
//  Булево - если Истина, МенеджерВременныхТаблиц содержит временную таблицу, иначе нет.
//
Функция ТаблицаПодчиненностиПользователей(МенеджерВременныхТаблиц) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает менеджер временных таблиц, содержащий временную таблицу пользователей
// некоторых дополнительных групп пользователей, например, пользователей групп исполнителей задач,
// которые соответствуют ключам адресации (РольИсполнителя + ОсновнойОбъектАдресации + ДополнительныйОбъектАдресации).
//
//  При изменении состава дополнительных групп пользователей, необходимо сделать вызов
// "УправлениеДоступом.ЗаписатьГруппыИВидыДоступа(Справочник.ГруппыПользователей.ВсеПользователи);",
// чтобы применить изменения к внутренним данным подсистемы.
//
// Параметры:
//  МенеджерВременныхТаблиц - МенеджерВременныхТаблиц в который можно поместить таблицу
//                 ТаблицаГруппИсполнителей с полями:
//                   ГруппаИсполнителей - например, СправочникСсылка.ГруппыИсполнителейЗадач
//                   Пользователь       - СправочникСсылка.Пользователи, СправочникСсылка.ВнешниеПользователи
//
// Возвращаемое значение:
//  Булево - если Истина, МенеджерВременныхТаблиц содержит временную таблицу, иначе нет.
//
Функция ТаблицаГруппИсполнителей(МенеджерВременныхТаблиц) Экспорт
	
	// СтандартныеПодсистемы.БизнесПроцессыИЗадачи
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ИсполнителиЗадач.ГруппаИсполнителейЗадач КАК ГруппаИсполнителей,
	|	ИсполнителиЗадач.Исполнитель КАК Пользователь
	|ПОМЕСТИТЬ ТаблицаГруппИсполнителей
	|ИЗ
	|	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	Возврат Истина;
	// Конец СтандартныеПодсистемы.БизнесПроцессыИЗадачи
	
	Возврат Ложь;
	
КонецФункции

// Позволяет реализовать перезапись зависимых наборов значений доступа других объектов.
//
//  Вызывается из процедур:
// УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// УправлениеДоступомСлужебный.ЗаписатьЗависимыеНаборыЗначенийДоступа().
//
// Параметры:
//  Ссылка       - СправочникСсылка, ДокументСсылка, ... - ссылка на объект для которого
//                 записаны наборы значений доступа.
//
//  СсылкиНаЗависимыеОбъекты - Массив элементов типа СправочникСсылка, ДокументСсылка, ...
//                 Содержит ссылки на объекты с зависимыми наборами значений доступа
//                 Начальное значение - пустой массив.
//
Процедура ПриИзмененииНаборовЗначенийДоступа(Знач Ссылка, СсылкиНаЗависимыеОбъекты) Экспорт
	
	
КонецПроцедуры

// Заполняет зависимости прав доступа "подчиненного" объекта, например, задачи ЗадачаИсполнителя,
// от "ведущего" объекта, например,  бизнес-процесса Задание, которые отличаются от стандартных.
//
// Зависимости прав используются в стандартном шаблоне ограничения доступа для вида доступа "Объект":
// 1) стандартно при чтении "подчиненного" объекта
//    проверяется наличие права чтения "ведущего" объекта
//    и проверяется отсутствие ограничения чтения "ведущего" объекта;
// 2) стандартно при добавлении, изменении, удалении "подчиненного" объекта
//    проверяется наличие права изменения "ведущего" объекта
//    и проверяется отсутствие ограничения изменения "ведущего" объекта.
//
// Параметры:
//  Таблица      - РегистрСведенийНаборЗаписей.ЗависимостиПравДоступа.
//                 Допустимые значения ресурсов:
//                   "ПланыВидовХарактеристик.ВидыДоступа.ПравоЧтения",
//                   "ПланыВидовХарактеристик.ВидыДоступа.ПравоДобавления",
//                   "ПланыВидовХарактеристик.ВидыДоступа.ПравоИзменения".
//
//                 Если задано недопустимое значение, будет установлено значение по умолчанию:
//                 для права Чтение                         - ПланыВидовХарактеристик.ВидыДоступа.ПравоЧтения,
//                 для прав Добавление, Изменение, Удаление - ПланыВидовХарактеристик.ВидыДоступа.ПравоИзменения.
//                 
//                 Следует иметь в виду, что обычная "жесткость" условия ограничения доступа
//                 уменьшается в порядке "Добавление", "Изменение", "Чтение",
//                 Т.е. то, что можно добавить, можно и изменить и прочитать,
//                 соответственно, то что можно изменить можно и прочитать, но не наоборот.
//
Процедура ЗаполнитьЗависимостиПравДоступа(Знач Таблица) Экспорт
	
	// СтандартныеПодсистемы.БизнесПроцессыИЗадачи
	
	// Задача исполнителя может быть изменена, когда бизнес-процесс доступен только для чтения,
	// поэтому проверка права изменения и ограничения изменения не требуется,
	// а требуется более "мягкое" условие - проверка права и ограничения чтения.
	//
	// Для задач права добавление и удаление могут быть использованы только в привилегированном
	// режиме, поэтому для них проверять что-либо не требуется.
	Строка = Таблица.Добавить();
	Строка.ПодчиненнаяТаблица   = "Задача.ЗадачаИсполнителя";
	Строка.ТипВедущейТаблицы = БизнесПроцессы.Задание.ПустаяСсылка();
	// Для права Изменения проверка изменяется с "Изменение" на "Чтение".
	Строка.ПриПроверкеПраваИзменение  = ПланыВидовХарактеристик.ВидыДоступа.ПравоЧтения;
	
	// Конец СтандартныеПодсистемы.БизнесПроцессыИЗадачи
	
КонецПроцедуры

// Возвращает вид используемого интерфейса для настройки прав доступа.
//
//  Упрощенный интерфейс удобен для конфигураций с небольшим количеством пользователей,
// так как много функций не требуются и они могут быть скрыты (скрытие не может быть
// выполнено только лишь функциональной опцией, так как потребуется пересмотр
// содержимого групп доступа и профилей).
//
// Возвращаемое значение:
//  Булево
//
Функция УпрощенныйИнтерфейсНастройкиПравДоступа() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Заполняет состав видов доступа, используемых при ограничении прав объектов метаданных.
// Если состав видов доступа не заполнен, отчет "Права доступа" покажет некорректые сведения.
//
// Обязательно требуется заполнить только виды доступа, используемые
// в шаблонах ограничения доступа явно, а виды доступа, используемые
// в наборах значений доступа могут быть получены из текущего состояния
// регистра сведений НаборыЗначенийДоступа.
//
//  Для автоматической подготовки содержимого процедуры следует
// воспользоваться инструментами разработчика для подсистемы
// Управление доступом.
//
// Параметры:
//  Описание     - Строка, многострочная строка формата <Таблица>.<Право>.<ВидДоступа>[.Таблица объекта]
//                 Например, Документ.ПриходнаяНакладная.Чтение.Организации
//                           Документ.ПриходнаяНакладная.Чтение.Контрагенты
//                           Документ.ПриходнаяНакладная.Добавление.Организации
//                           Документ.ПриходнаяНакладная.Добавление.Контрагенты
//                           Документ.ПриходнаяНакладная.Изменение.Организации
//                           Документ.ПриходнаяНакладная.Изменение.Контрагенты
//                           Документ.ЭлектронныеПисьма.Чтение.Объект.Документ.ЭлектронныеПисьма
//                           Документ.ЭлектронныеПисьма.Добавление.Объект.Документ.ЭлектронныеПисьма
//                           Документ.ЭлектронныеПисьма.Изменение.Объект.Документ.ЭлектронныеПисьма
//                           Документ.Файлы.Чтение.Объект.Справочник.ПапкиФайлов
//                           Документ.Файлы.Чтение.Объект.Документ.ЭлектронноеПисьмо
//                           Документ.Файлы.Добавление.Объект.Справочник.ПапкиФайлов
//                           Документ.Файлы.Добавление.Объект.Документ.ЭлектронноеПисьмо
//                           Документ.Файлы.Изменение.Объект.Справочник.ПапкиФайлов
//                           Документ.Файлы.Изменение.Объект.Документ.ЭлектронноеПисьмо
//                 Вид доступа Объект предопределен, как литерал, его нет в предопределенных элементах
//                 ПланыВидовХарактеристик.ВидыДоступа. Этот вид доступа используется в шаблонах ограничений доступа,
//                 как "ссылка" на другой объект, по которому ограничивается таблица.
//                 Когда вид доступа "Объект" задан, также требуется задать типы таблиц, которые используются
//                 для этого вида доступа. Т.е. перечислить типы, которые соответствующие полю,
//                 использованному в шаблоне ограничения доступа в паре с видом доступа "Объект".
//                 При перечислении типов по виду доступа "Объект" нужно перечислить только те типы поля,
//                 которые есть у поля РегистрыСведений.НаборыЗначенийДоступа.Объект, остальные типы лишние.
// 
Процедура ЗаполнитьВидыОграниченийПравОбъектовМетаданных(Описание) Экспорт
	
	Описание = "";
	
	// СтандартныеПодсистемы.БизнесПроцессыИЗадачи
	Описание = Описание + 
	"
	|РегистрСведений.ИсполнителиЗадач.Чтение.Организации
	|РегистрСведений.ИсполнителиЗадач.Изменение.Организации
	|БизнесПроцесс.Задание.Чтение.Пользователи
	|БизнесПроцесс.Задание.Добавление.Пользователи
	|БизнесПроцесс.Задание.Изменение.Пользователи
	|Задача.ЗадачаИсполнителя.Чтение.Объект.БизнесПроцесс.Задание
	|Задача.ЗадачаИсполнителя.Чтение.Пользователи
	|Задача.ЗадачаИсполнителя.Изменение.Пользователи
	|РегистрСведений.ДанныеБизнесПроцессов.Чтение.Объект.БизнесПроцесс.Задание
	|";
	// Конец СтандартныеПодсистемы.БизнесПроцессыИЗадачи
	
	// СтандартныеПодсистемы.Взаимодействия
	Описание = Описание + 
	"
	|Справочник.ПапкиЭлектронныхПисем.Чтение.УчетныеЗаписиЭлектроннойПочты
	|Справочник.ПапкиЭлектронныхПисем.Добавление.УчетныеЗаписиЭлектроннойПочты
	|Справочник.ПапкиЭлектронныхПисем.Изменение.УчетныеЗаписиЭлектроннойПочты
	|Справочник.ПравилаОбработкиЭлектроннойПочты.Чтение.УчетныеЗаписиЭлектроннойПочты
	|Справочник.ПравилаОбработкиЭлектроннойПочты.Добавление.УчетныеЗаписиЭлектроннойПочты
	|Справочник.ПравилаОбработкиЭлектроннойПочты.Изменение.УчетныеЗаписиЭлектроннойПочты
	|Документ.Встреча.Чтение.Объект.Документ.Встреча
	|Документ.Встреча.Добавление.Объект.Документ.Встреча
	|Документ.Встреча.Изменение.Объект.Документ.Встреча
	|Документ.ЗапланированноеВзаимодействие.Чтение.Объект.Документ.ЗапланированноеВзаимодействие
	|Документ.ЗапланированноеВзаимодействие.Добавление.Объект.Документ.ЗапланированноеВзаимодействие
	|Документ.ЗапланированноеВзаимодействие.Изменение.Объект.Документ.ЗапланированноеВзаимодействие
	|Документ.ТелефонныйЗвонок.Чтение.Объект.Документ.ТелефонныйЗвонок
	|Документ.ТелефонныйЗвонок.Добавление.Объект.Документ.ТелефонныйЗвонок
	|Документ.ТелефонныйЗвонок.Изменение.Объект.Документ.ТелефонныйЗвонок
	|Документ.ЭлектронноеПисьмоВходящее.Чтение.Объект.Документ.ЭлектронноеПисьмоВходящее
	|Документ.ЭлектронноеПисьмоВходящее.Добавление.Объект.Документ.ЭлектронноеПисьмоВходящее
	|Документ.ЭлектронноеПисьмоВходящее.Изменение.Объект.Документ.ЭлектронноеПисьмоВходящее
	|Документ.ЭлектронноеПисьмоИсходящее.Чтение.Объект.Документ.ЭлектронноеПисьмоИсходящее
	|Документ.ЭлектронноеПисьмоИсходящее.Добавление.Объект.Документ.ЭлектронноеПисьмоИсходящее
	|Документ.ЭлектронноеПисьмоИсходящее.Изменение.Объект.Документ.ЭлектронноеПисьмоИсходящее
	|ЖурналДокументов.Взаимодействия.Чтение.Объект.Документ.Встреча
	|ЖурналДокументов.Взаимодействия.Чтение.Объект.Документ.ЗапланированноеВзаимодействие
	|ЖурналДокументов.Взаимодействия.Чтение.Объект.Документ.ТелефонныйЗвонок
	|ЖурналДокументов.Взаимодействия.Чтение.Объект.Документ.ЭлектронноеПисьмоВходящее
	|ЖурналДокументов.Взаимодействия.Чтение.Объект.Документ.ЭлектронноеПисьмоИсходящее
	|РегистрСведений.НастройкиУчетныхЗаписейЭлектроннойПочты.Чтение.УчетныеЗаписиЭлектроннойПочты
	|";
	// Конец СтандартныеПодсистемы.Взаимодействия
	
	
	// СтандартныеПодсистемы.Организации
	Описание = Описание + 
	"
	|Справочник.Организации.Чтение.Организации
	|";
	// Конец СтандартныеПодсистемы.Организации
	
	
	// СтандартныеПодсистемы.Пользователи
	Описание = Описание + 
	"
	|Справочник.ВнешниеПользователи.Чтение.ВнешниеПользователи
	|Справочник.ВнешниеПользователи.Изменение.ВнешниеПользователи
	|Справочник.ГруппыВнешнихПользователей.Чтение.ВнешниеПользователи
	|Справочник.ГруппыПользователей.Чтение.Пользователи
	|Справочник.Пользователи.Чтение.Пользователи
	|Справочник.Пользователи.Изменение.Пользователи
	|РегистрСведений.СоставыГруппПользователей.Чтение.ВнешниеПользователи
	|РегистрСведений.СоставыГруппПользователей.Чтение.Пользователи
	|";
	// Конец СтандартныеПодсистемы.Пользователи
	
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	Описание = Описание + 
	"
	|Справочник.ВстречаПрисоединенныеФайлы.Чтение.Объект.Документ.Встреча
	|Справочник.ВстречаПрисоединенныеФайлы.Добавление.Объект.Документ.Встреча
	|Справочник.ВстречаПрисоединенныеФайлы.Изменение.Объект.Документ.Встреча
	|Справочник.ЗапланированноеВзаимодействиеПрисоединенныеФайлы.Чтение.Объект.Документ.ЗапланированноеВзаимодействие
	|Справочник.ЗапланированноеВзаимодействиеПрисоединенныеФайлы.Добавление.Объект.Документ.ЗапланированноеВзаимодействие
	|Справочник.ЗапланированноеВзаимодействиеПрисоединенныеФайлы.Изменение.Объект.Документ.ЗапланированноеВзаимодействие
	|Справочник.ТелефонныйЗвонокПрисоединенныеФайлы.Чтение.Объект.Документ.ТелефонныйЗвонок
	|Справочник.ТелефонныйЗвонокПрисоединенныеФайлы.Добавление.Объект.Документ.ТелефонныйЗвонок
	|Справочник.ТелефонныйЗвонокПрисоединенныеФайлы.Изменение.Объект.Документ.ТелефонныйЗвонок
	|Справочник.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы.Чтение.Объект.Документ.ЭлектронноеПисьмоВходящее
	|Справочник.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы.Добавление.Объект.Документ.ЭлектронноеПисьмоВходящее
	|Справочник.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы.Изменение.Объект.Документ.ЭлектронноеПисьмоВходящее
	|Справочник.ЭлектронноеПисьмоИсходящееПрисоединенныеФайлы.Чтение.Объект.Документ.ЭлектронноеПисьмоИсходящее
	|Справочник.ЭлектронноеПисьмоИсходящееПрисоединенныеФайлы.Добавление.Объект.Документ.ЭлектронноеПисьмоИсходящее
	|Справочник.ЭлектронноеПисьмоИсходящееПрисоединенныеФайлы.Изменение.Объект.Документ.ЭлектронноеПисьмоИсходящее
	|";
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
	
	// СтандартныеПодсистемы.РаботаСПочтовымиСообщениями
	Описание = Описание + 
	"
	|Справочник.УчетныеЗаписиЭлектроннойПочты.Чтение.УчетныеЗаписиЭлектроннойПочты
	|";
	// Конец СтандартныеПодсистемы.РаботаСПочтовымиСообщениями
	
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Описание = Описание + 
	"
	|Справочник.ПапкиФайлов.Чтение.ПапкиФайлов
	|Справочник.ПапкиФайлов.Добавление.ПапкиФайлов
	|Справочник.ПапкиФайлов.Изменение.ПапкиФайлов
	|Справочник.ВерсииФайлов.Чтение.Объект.Справочник.ПапкиФайлов
	|Справочник.ВерсииФайлов.Чтение.Объект.БизнесПроцесс.Задание
	|Справочник.Файлы.Чтение.Объект.Справочник.ПапкиФайлов
	|Справочник.Файлы.Чтение.Объект.БизнесПроцесс.Задание
	|Справочник.Файлы.Добавление.Объект.Справочник.ПапкиФайлов
	|Справочник.Файлы.Добавление.Объект.БизнесПроцесс.Задание
	|Справочник.Файлы.Изменение.Объект.Справочник.ПапкиФайлов
	|Справочник.Файлы.Изменение.Объект.БизнесПроцесс.Задание
	|РегистрСведений.ХранимыеФайлыВерсий.Чтение.Объект.БизнесПроцесс.Задание
	|РегистрСведений.ХранимыеФайлыВерсий.Чтение.Объект.Справочник.ПапкиФайлов
	|";
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.Свойства
	Описание = Описание + 
	"
	|ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Чтение.ДополнительныеСведения
	|РегистрСведений.ДополнительныеСведения.Чтение.ДополнительныеСведения
	|РегистрСведений.ДополнительныеСведения.Изменение.ДополнительныеСведения
	|";
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры
