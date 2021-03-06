///////////////////////////////////////////////////////////////////////////////////////////////
// МОДУЛЬ СОДЕРЖИТ ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ВНУТРЕННИМИ, ВХОДЯЩИМИ И ИСХОДЯЩИМИ ДОКУМЕНТАМИ
// 

// Формирует наименование документа из заголовка 
Функция НаименованиеДокумента(Документ) Экспорт 
	
	Заголовок = СокрЛП(Документ.Заголовок);
	ДлинаНаименования = Документ.Метаданные().ДлинаНаименования;
	
	Если ЗначениеЗаполнено(Документ.РегистрационныйНомер) Тогда 
		Постфикс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСТР("ru = ' (№ %1 от %2)'"),
						СокрЛП(Документ.РегистрационныйНомер),
						Формат(Документ.ДатаРегистрации, "ДЛФ=D"));
	Иначе
		Постфикс = "";
	КонецЕсли;	
	
	Если СтрДлина(Заголовок + Постфикс) > ДлинаНаименования Тогда 
		
		Заголовок = Лев(Заголовок, ДлинаНаименования - СтрДлина(Постфикс));
		ДлинаЗаголовка = СтрДлина(Заголовок);
		
		ПозицияПробела = ДлинаЗаголовка;
		Пока ПозицияПробела > 0 Цикл
			Если Сред(Заголовок, ПозицияПробела, 1) = " " Тогда 
				Прервать;
			КонецЕсли;	
			ПозицияПробела = ПозицияПробела - 1;
		КонецЦикла;	
		
		Если ПозицияПробела > 1 Тогда 
			Заголовок = Лев(Заголовок, ПозицияПробела - 1);
		КонецЕсли;	
		
	КонецЕсли;	
	
	Возврат Заголовок + Постфикс;
	
КонецФункции	

// Формирует наименование номенклатуры дел
Функция НаименованиеНоменклатурыДел(НоменклатураДел) Экспорт
	
	Заголовок = НоменклатураДел.ПолноеНаименование;
	Заголовок = СтрЗаменить(Заголовок, Символы.ПС, " "); 
	Заголовок = СокрЛП(Заголовок);
	ДлинаНаименования = НоменклатураДел.Метаданные().ДлинаНаименования;
	
	Если СтрДлина(Заголовок) > ДлинаНаименования Тогда 
		
		Заголовок = Лев(Заголовок, ДлинаНаименования);
		ДлинаЗаголовка = СтрДлина(Заголовок);
		
		ПозицияПробела = ДлинаЗаголовка;
		Пока ПозицияПробела > 0 Цикл
			Если Сред(Заголовок, ПозицияПробела, 1) = " " Тогда 
				Прервать;
			КонецЕсли;	
			ПозицияПробела = ПозицияПробела - 1;
		КонецЦикла;	
		
		Если ПозицияПробела > 1 Тогда 
			Заголовок = Лев(Заголовок, ПозицияПробела - 1);
		КонецЕсли;	
		
	КонецЕсли;	
	
	Возврат Заголовок;
	
КонецФункции	

// Возвращает количество файлов по документу
Функция КоличествоФайлов(Документ) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	Справочник.Файлы КАК Файлы
	|ГДЕ
	|	Файлы.ВладелецФайла = &Документ";
	Запрос.УстановитьПараметр("Документ", Документ);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Количество;
	
КонецФункции

// Возвращает количество задач по документу
Функция КоличествоЗадач(Документ, ТолькоНевыполненные = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	|ГДЕ
	|	ЗадачаИсполнителя.Предмет = &Документ
	|	И (НЕ ЗадачаИсполнителя.ПометкаУдаления)";
	
	Если ТолькоНевыполненные Тогда 
		Запрос.Текст = Запрос.Текст + " И (НЕ ЗадачаИсполнителя.Выполнена)";
	КонецЕсли;	
	
	Запрос.УстановитьПараметр("Документ", Документ);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Количество;
	
КонецФункции	

// Возвращает вид документа по умолчанию
Функция ПолучитьВидДокументаПоУмолчанию(Ссылка) Экспорт
	
	ВидДокумента = Неопределено;
	
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда 
		ВидДокумента = ХранилищеОбщихНастроек.Загрузить("НастройкиРаботыСДокументами", "ВидВходящегоДокумента");
		ТипМетаданных = "ВидыВходящихДокументов";
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда 
		ВидДокумента = ХранилищеОбщихНастроек.Загрузить("НастройкиРаботыСДокументами", "ВидИсходящегоДокумента");
		ТипМетаданных = "ВидыИсходящихДокументов";
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда 
		ВидДокумента = ХранилищеОбщихНастроек.Загрузить("НастройкиРаботыСДокументами", "ВидВнутреннегоДокумента");
		ТипМетаданных = "ВидыВнутреннихДокументов";
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(ВидДокумента) Тогда 
		Запрос = Новый Запрос;
		Запрос.Текст = СтрЗаменить(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ТаблицаВидаДокументов.Ссылка КАК Ссылка
		|ИЗ
		|	&ВидДокумента КАК ТаблицаВидаДокументов
		|ГДЕ
		|	(НЕ ТаблицаВидаДокументов.ПометкаУдаления)
		|	И (НЕ ТаблицаВидаДокументов.ЭтоГруппа)
		|	И ЛОЖЬ В
		|			(ВЫБРАТЬ
		|				ЛОЖЬ КАК ЗначениеЛожь
		|			ИЗ
		|				(ВЫБРАТЬ ПЕРВЫЕ 2
		|					ИСТИНА КАК ЗначениеИстина
		|				ИЗ
		|					&ВидДокумента КАК ТаблицаВидаДокументов
		|				ГДЕ
		|					(НЕ ТаблицаВидаДокументов.ПометкаУдаления)
		|					И (НЕ ТаблицаВидаДокументов.ЭтоГруппа)
		|				) КАК ВыбранныеОбъекты
		|			ИМЕЮЩИЕ
		|				КОЛИЧЕСТВО(ВыбранныеОбъекты.ЗначениеИстина) = 1)", "&ВидДокумента", "Справочник." + ТипМетаданных);
	
		Результат = Запрос.Выполнить();
		Если Не Результат.Пустой() Тогда 
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			ВидДокумента = Выборка.Ссылка;
		КонецЕсли;	
	КонецЕсли;	
		
	Возврат ВидДокумента;
	
КонецФункции	

// Возвращает способ доставки по умолчанию
Функция ПолучитьСпособДоставкиПоУмолчанию(Тип) Экспорт 
	
	СпособДоставки = Справочники.СпособыДоставки.ПустаяСсылка();
	
	Если Тип = "СпособПолучения" Тогда 
		СпособДоставки = ХранилищеОбщихНастроек.Загрузить("НастройкиРаботыСДокументами", "СпособПолучения");
	ИначеЕсли Тип = "СпособОтправки" Тогда 
		СпособДоставки = ХранилищеОбщихНастроек.Загрузить("НастройкиРаботыСДокументами", "СпособОтправки");
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(СпособДоставки) Тогда 
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	СпособыДоставки.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.СпособыДоставки КАК СпособыДоставки
		|ГДЕ
		|	(НЕ СпособыДоставки.ПометкаУдаления)
		|	И ЛОЖЬ В
		|			(ВЫБРАТЬ
		|				ЛОЖЬ КАК ЗначениеЛожь
		|			ИЗ
		|				(ВЫБРАТЬ ПЕРВЫЕ 2
		|					ИСТИНА КАК ЗначениеИстина
		|				ИЗ
		|					Справочник.СпособыДоставки КАК СпособыДоставки
		|				ГДЕ
		|					(НЕ СпособыДоставки.ПометкаУдаления)
		|				) КАК ВыбранныеОбъекты
		|			ИМЕЮЩИЕ
		|				КОЛИЧЕСТВО(ВыбранныеОбъекты.ЗначениеИстина) = 1)";
		
		Результат = Запрос.Выполнить();
		Если Не Результат.Пустой() Тогда 
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			СпособДоставки = Выборка.Ссылка;
		КонецЕсли;	
	КонецЕсли;
	
	Возврат СпособДоставки;
	
КонецФункции	

// Получает актуальное состояние документа
Функция ПолучитьСостояниеДокумента(Документ) Экспорт
	
	Если Не ЗначениеЗаполнено(Документ) Тогда
		Возврат Перечисления.СостоянияДокументов.ПустаяСсылка();
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияДокументовСрезПоследних.Состояние КАК Состояние
	|ИЗ
	|	РегистрСведений.СостоянияДокументов.СрезПоследних(, Документ = &Документ) КАК СостоянияДокументовСрезПоследних";
	Запрос.УстановитьПараметр("Документ", Документ);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Перечисления.СостоянияДокументов.ПустаяСсылка();
	КонецЕсли;	
		
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Состояние; 
	
КонецФункции

// Устанавливает состояние документа
Процедура ЗаписатьСостояниеДокумента(Документ, Период, Состояние, Установил) Экспорт
	
	ТекущееСостояние = ПолучитьСостояниеДокумента(Документ);
	Если ТекущееСостояние = Состояние Тогда 
		Возврат;
	КонецЕсли;	
	
	МенеджерЗаписи = РегистрыСведений.СостоянияДокументов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = Период;
	МенеджерЗаписи.Документ = Документ;
	МенеджерЗаписи.Состояние = Состояние;
	МенеджерЗаписи.Установил = Установил;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры	

// Возвращает ключ актуального состояния документа
Функция ПолучитьКлючСостоянияДокумента(Документ) Экспорт
	
	Если Не ЗначениеЗаполнено(Документ) Тогда
		Возврат Неопределено;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияДокументовСрезПоследних.Период КАК Период
	|ИЗ
	|	РегистрСведений.СостоянияДокументов.СрезПоследних(, Документ = &Документ) КАК СостоянияДокументовСрезПоследних";
	Запрос.УстановитьПараметр("Документ", Документ);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Неопределено;
	КонецЕсли;	
		
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат РегистрыСведений.СостоянияДокументов.СоздатьКлючЗаписи( Новый Структура("Период, Документ", Выборка.Период, Документ) );
	
КонецФункции

// Возвращает признак использования видов входящих документов
Функция ИспользоватьВидыВходящихДокументов() Экспорт 
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьВидыВходящихДокументов");
	
КонецФункции

// Возвращает признак использования видов исходящих документов
Функция ИспользоватьВидыИсходящихДокументов() Экспорт 
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьВидыИсходящихДокументов");
	
КонецФункции

// Возвращает признак использования видов внутренних документов
Функция ИспользоватьВидыВнутреннихДокументов() Экспорт 
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьВидыВнутреннихДокументов");
	
КонецФункции

// Возвращает признак использования видов документов по объекту
Функция ИспользоватьВидыДокументов(Объект) Экспорт
	
	ИспользоватьВидыДокументов = Ложь;
	
	Если ТипЗнч(Объект.Ссылка) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда 
		ИспользоватьВидыДокументов = Делопроизводство.ИспользоватьВидыВходящихДокументов();
		
	ИначеЕсли ТипЗнч(Объект.Ссылка) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда 
		ИспользоватьВидыДокументов = Делопроизводство.ИспользоватьВидыИсходящихДокументов();
		
	ИначеЕсли ТипЗнч(Объект.Ссылка) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда 
		ИспользоватьВидыДокументов = Делопроизводство.ИспользоватьВидыВнутреннихДокументов();
		
	КонецЕсли;	
	
	Возврат ИспользоватьВидыДокументов;
	
КонецФункции	

// Возвращает признак использования номенклатуры дел
Функция ИспользоватьНоменклатуруДел() Экспорт 
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьНоменклатуруДел");
	
КонецФункции

Функция РегистрационныйНомерУникален(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Нумератор = Нумерация.ПолучитьНумераторДокумента(Объект);
	Если ЗначениеЗаполнено(Нумератор) Тогда // автонумерация
		Периодичность = Нумератор.Периодичность;
	Иначе 										   // ручная нумерация
		Периодичность = Перечисления.ПериодичностьНумераторов.Год;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Ссылка
	|ИЗ
	|	Справочник." + Объект.Метаданные().Имя + "
	|ГДЕ
	|	РегистрационныйНомер = &РегистрационныйНомер
	|	И Ссылка <> &Ссылка";
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") И Нумератор.НезависимаяНумерацияПоОрганизациям Тогда
		Запрос.Текст = Запрос.Текст + " И (Организация = &Организация) ";
		Запрос.УстановитьПараметр("Организация", Объект.Организация);
	КонецЕсли;	
	
	Если ИспользоватьВидыДокументов(Объект) Тогда 
		Запрос.Текст = Запрос.Текст + " И (ВидДокумента = &ВидДокумента) ";
		Запрос.УстановитьПараметр("ВидДокумента", Объект.ВидДокумента);
	КонецЕсли;	
	
	ЕСли ТипЗнч(Объект.Ссылка) <> Тип("СправочникСсылка.удуРеестрыОтправки") Тогда
		Запрос.Текст = Запрос.Текст + " И ДатаРегистрации МЕЖДУ &НачалоПериодаНумерации И &КонецПериодаНумерации ";
		Если ИспользоватьВидыДокументов(Объект) Тогда 
			Запрос.Текст = Запрос.Текст + " И (ВидДокумента = &ВидДокумента) ";
			Запрос.УстановитьПараметр("ВидДокумента", Объект.ВидДокумента);
		КонецЕсли;	
	
		Запрос.УстановитьПараметр("НачалоПериодаНумерации", Нумерация.НачалоПериодаНумерации(Периодичность, Объект.ДатаРегистрации));
		Запрос.УстановитьПараметр("КонецПериодаНумерации", Нумерация.КонецПериодаНумерации(Периодичность, Объект.ДатаРегистрации));
	Иначе
		Запрос.Текст = Запрос.Текст + " И ДатаОтправки МЕЖДУ &НачалоПериодаНумерации И &КонецПериодаНумерации ";
		Запрос.Текст = Запрос.Текст + " И (ТипРеестра = &ТипРеестра) ";
		Запрос.УстановитьПараметр("ТипРеестра", Объект.ТипРеестра);
		Запрос.УстановитьПараметр("НачалоПериодаНумерации", Нумерация.НачалоПериодаНумерации(Периодичность, Объект.ДатаОтправки));
		Запрос.УстановитьПараметр("КонецПериодаНумерации", Нумерация.КонецПериодаНумерации(Периодичность, Объект.ДатаОтправки));
	КонецЕсли;

		Запрос.УстановитьПараметр("РегистрационныйНомер", Объект.РегистрационныйНомер);
		Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
		Результат = Запрос.Выполнить();
	Возврат Результат.Пустой();
	
КонецФункции	

Процедура УстановитьДоступностьПоСостоянию(Форма, Состояние, ДоступныеПоля = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДоступныеПоля = "";
	НедоступныеПоля = "";
	
	Если РольДоступна("ПолныеПрава") Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Форма.Объект.Ссылка) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда 
		РольДелопроизводитель = РольДоступна("ДобавлениеИзменениеВходящихДокументов");
		
	ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда 
		РольДелопроизводитель = РольДоступна("РегистрацияИсходящихДокументов");
		
	ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда 	
		РольДелопроизводитель = РольДоступна("РегистрацияВнутреннихДокументов");
		
	КонецЕсли;	
	
	
	Если Состояние = Перечисления.СостоянияДокументов.НаРегистрации Тогда 	
		
		Если РольДелопроизводитель Тогда 
			ДоступныеПоля = "";
			НедоступныеПоля = "";
		Иначе
			ДоступныеПоля = Новый Структура("
			|Состояние, 
			|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
			|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		КонецЕсли;
		
	ИначеЕсли (Состояние = Перечисления.СостоянияДокументов.Зарегистрирован) 
	    	И (ТипЗнч(Форма.Объект.Ссылка) = Тип("СправочникСсылка.ВходящиеДокументы")) Тогда
		
		Если РольДелопроизводитель Тогда
			ДоступныеПоля = Новый Структура("
			|Зарегистрировать, РегистрационныйНомер, ДатаРегистрации,
			|Состояние, 
			|СрокИсполнения, Дело,
			|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
			|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		Иначе
			ДоступныеПоля = Новый Структура("
			|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
			|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		КонецЕсли;
		
	ИначеЕсли (Состояние = Перечисления.СостоянияДокументов.Зарегистрирован) 
			И (ТипЗнч(Форма.Объект.Ссылка) = Тип("СправочникСсылка.ИсходящиеДокументы")) Тогда
		
		Если РольДелопроизводитель Тогда 
			Если Форма.Объект.Отправлен Тогда
				ДоступныеПоля = Новый Структура("
				|Зарегистрировать, РегистрационныйНомер, ДатаРегистрации,
				|Состояние, 
				|СрокИсполнения, Дело,
				|Отправлен, ДатаОтправки, СпособОтправки,
				|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
				|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
			Иначе
				ДоступныеПоля = Новый Структура("
				|Зарегистрировать, РегистрационныйНомер, ДатаРегистрации,
				|Состояние, 
				|СрокИсполнения, Дело,
				|ЗакончитьРедактирование, Занять, Освободить, Редактировать, СохранитьИзменения, ОбновитьИзФайлаНаДиске,
				|КонтекстноеМенюФайлыЗакончитьРедактирование, КонтекстноеМенюФайлыЗанять, КонтекстноеМенюФайлыОсвободить, КонтекстноеМенюФайлыРедактировать, КонтекстноеМенюФайлыСохранитьИзменения, КонтекстноеМенюФайлыОбновитьИзФайлаНаДиске,
				|Отправлен, ДатаОтправки, СпособОтправки,
				|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
				|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
			КонецЕсли;
		Иначе
			ДоступныеПоля = Новый Структура("
			|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
			|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		КонецЕсли;
		
	ИначеЕсли (Состояние = Перечисления.СостоянияДокументов.Зарегистрирован) 
			И (ТипЗнч(Форма.Объект.Ссылка) = Тип("СправочникСсылка.ВнутренниеДокументы")) Тогда
		
		Если РольДелопроизводитель Тогда 
			ДоступныеПоля = Новый Структура("
			|Зарегистрировать, РегистрационныйНомер, ДатаРегистрации,
			|Состояние, 
			|СрокИсполнения, Дело,
			|ЗакончитьРедактирование, Занять, Освободить, Редактировать, СохранитьИзменения, ОбновитьИзФайлаНаДиске,
			|КонтекстноеМенюФайлыЗакончитьРедактирование, КонтекстноеМенюФайлыЗанять, КонтекстноеМенюФайлыОсвободить, КонтекстноеМенюФайлыРедактировать, КонтекстноеМенюФайлыСохранитьИзменения, КонтекстноеМенюФайлыОбновитьИзФайлаНаДиске,
			|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
			|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		Иначе
			ДоступныеПоля = Новый Структура("
			|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
			|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		КонецЕсли;
		
	ИначеЕсли Состояние = Перечисления.СостоянияДокументов.НаРассмотрении Тогда	
		
		Если РольДелопроизводитель Тогда 
			ДоступныеПоля = Новый Структура("
			|Зарегистрировать, РегистрационныйНомер, ДатаРегистрации,
			|Состояние, 
			|СрокИсполнения, 
			|Резолюция, ДатаРезолюции, АвторРезолюции,
			|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
			|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		Иначе
			ДоступныеПоля = Новый Структура("
			|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
			|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		КонецЕсли;
		
	ИначеЕсли Состояние = Перечисления.СостоянияДокументов.Рассмотрен Тогда	
		
		Если РольДелопроизводитель Тогда 
			ДоступныеПоля = Новый Структура("
			|Зарегистрировать, РегистрационныйНомер, ДатаРегистрации,
			|Состояние, 
			|СрокИсполнения, 
			|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
			|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		Иначе
			ДоступныеПоля = Новый Структура("
			|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
			|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		КонецЕсли;
		
	ИначеЕсли Состояние = Перечисления.СостоянияДокументов.НаИсполнении Тогда	
		
		Если РольДелопроизводитель Тогда 
			ДоступныеПоля = Новый Структура("
			|Зарегистрировать, РегистрационныйНомер, ДатаРегистрации,
			|Состояние, 
			|СрокИсполнения, 
			|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
			|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		Иначе
			ДоступныеПоля = Новый Структура("
			|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
			|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		КонецЕсли;
		
	ИначеЕсли Состояние = Перечисления.СостоянияДокументов.Исполнен Тогда
		
		Если РольДелопроизводитель Тогда 
			ДоступныеПоля = Новый Структура("
			|Зарегистрировать, РегистрационныйНомер, ДатаРегистрации,
			|Состояние, 
			|Дело, 
			|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
			|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		Иначе
			ДоступныеПоля = Новый Структура("
			|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
			|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		КонецЕсли;
		
	ИначеЕсли Состояние = Перечисления.СостоянияДокументов.Проект
		Или Состояние = Перечисления.СостоянияДокументов.НеСогласован
		Или Состояние = Перечисления.СостоянияДокументов.НеУтвержден Тогда
		
		ДоступныеПоля = "";
		НедоступныеПоля = Новый Структура("СрокИсполнения, Подписал, Утвердил, Дело");
		
	ИначеЕсли Состояние = Перечисления.СостоянияДокументов.НаСогласовании Тогда
		
		ДоступныеПоля = Новый Структура("
		|Состояние, 
		|ЗакончитьРедактирование, Занять, Освободить, Редактировать, СохранитьИзменения, ОбновитьИзФайлаНаДиске,
		|КонтекстноеМенюФайлыЗакончитьРедактирование, КонтекстноеМенюФайлыЗанять, КонтекстноеМенюФайлыОсвободить, КонтекстноеМенюФайлыРедактировать, КонтекстноеМенюФайлыСохранитьИзменения, КонтекстноеМенюФайлыОбновитьИзФайлаНаДиске,
		|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
		|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		
	ИначеЕсли Состояние = Перечисления.СостоянияДокументов.НаУтверждении Тогда
		
		ДоступныеПоля = Новый Структура("
		|Состояние, 
		|Подписал, Утвердил,
		|ЗакончитьРедактирование, Занять, Освободить, Редактировать, СохранитьИзменения, ОбновитьИзФайлаНаДиске,
		|КонтекстноеМенюФайлыЗакончитьРедактирование, КонтекстноеМенюФайлыЗанять, КонтекстноеМенюФайлыОсвободить, КонтекстноеМенюФайлыРедактировать, КонтекстноеМенюФайлыСохранитьИзменения, КонтекстноеМенюФайлыОбновитьИзФайлаНаДиске,
		|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
		|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		
	ИначеЕсли Состояние = Перечисления.СостоянияДокументов.Согласован
		Или Состояние = Перечисления.СостоянияДокументов.Утвержден Тогда	
		
		Если РольДелопроизводитель Тогда 
			ДоступныеПоля = Новый Структура("
			|Состояние, 
			|Зарегистрировать,
			|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
			|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		Иначе
			ДоступныеПоля = Новый Структура("
			|Состояние, 
			|ОткрытьФайл, СохранитьКак, НастроитьСписок, ВывестиСписок,
			|КонтекстноеМенюФайлыОткрытьФайл, КонтекстноеМенюФайлыСохранитьКак");
		КонецЕсли;	  
		
	КонецЕсли;	
	
	Для Каждого Элемент Из Форма.Элементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда 
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(Элемент) = Тип("КнопкаФормы") И Элемент.Родитель.Имя = "ФормаКоманднаяПанель" Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(Элемент) = Тип("КнопкаФормы") И Элемент.Родитель.Имя = "КоманднаяПанельФормыСоздатьНаОсновании" Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(Элемент) = Тип("КнопкаФормы") И Элемент.Родитель.Имя = "КоманднаяПанельФормыПечать" Тогда
			Продолжить;
		КонецЕсли;
		
		Если ДоступныеПоля = "" Тогда
			Если (НедоступныеПоля <> "") И НедоступныеПоля.Свойство(Элемент.Имя) Тогда  
				Доступность = Ложь;
			Иначе	
				Доступность = Истина;
			КонецЕсли;
		ИначеЕсли ДоступныеПоля.Свойство(Элемент.Имя) Тогда 
			Доступность = Истина;
		Иначе	
			Доступность = Ложь;
		КонецЕсли;	
		
		Если ТипЗнч(Элемент) = Тип("КнопкаФормы") Тогда 
			Элемент.Доступность = Доступность;
		Иначе
			Элемент.ТолькоПросмотр = Не Доступность;
		КонецЕсли;
		
	КонецЦикла;	
	
	// доступность поля состояние зависит от настройки
	Если Не Константы.РазрешитьРучноеИзменениеСостоянияДокументов.Получить() 
		И Константы.ИспользоватьБизнесПроцессыИЗадачи.Получить() Тогда 
		Форма.Элементы.Состояние.ТолькоПросмотр = Истина;
	КонецЕсли;	
	
КонецПроцедуры	

Функция КонтактноеЛицоКорреспондента(Корреспондент) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КонтактныеЛица.Ссылка КАК КонтактноеЛицо
	|ИЗ
	|	Справочник.КонтактныеЛица КАК КонтактныеЛица
	|ГДЕ
	|	КонтактныеЛица.Владелец = &Владелец
	|	И (НЕ КонтактныеЛица.ПометкаУдаления)";
	Запрос.УстановитьПараметр("Владелец", Корреспондент);
	
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат.Количество() = 1 Тогда 
		Возврат Результат[0].КонтактноеЛицо;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции	

Функция КоличествоДокументовПоВидуДокумента(ВидДокумента) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(ВидДокумента) = Тип("СправочникСсылка.ВидыВнутреннихДокументов") Тогда 
		Тип = "ВнутренниеДокументы";
	ИначеЕсли ТипЗнч(ВидДокумента) = Тип("СправочникСсылка.ВидыВходящихДокументов") Тогда 
		Тип = "ВходящиеДокументы";
	ИначеЕсли ТипЗнч(ВидДокумента) = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда 	
		Тип = "ИсходящиеДокументы";
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	Справочник." + Тип + "
	|ГДЕ
	|	ВидДокумента = &ВидДокумента
	|	И РегистрационныйНомер <> """"";
	Запрос.УстановитьПараметр("ВидДокумента", ВидДокумента);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат 0;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Количество;
	
КонецФункции	

Функция КоличествоДокументовПоНумератору(Нумератор) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	Справочник.ВходящиеДокументы КАК ВходящиеДокументы
	|ГДЕ
	|	ВходящиеДокументы.ВидДокумента.Нумератор = &Нумератор
	|	И ВходящиеДокументы.РегистрационныйНомер <> """"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*)
	|ИЗ
	|	Справочник.ИсходящиеДокументы КАК ИсходящиеДокументы
	|ГДЕ
	|	ИсходящиеДокументы.ВидДокумента.Нумератор = &Нумератор
	|	И ИсходящиеДокументы.РегистрационныйНомер <> """"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*)
	|ИЗ
	|	Справочник.ВнутренниеДокументы КАК ВнутренниеДокументы
	|ГДЕ
	|	ВнутренниеДокументы.ВидДокумента.Нумератор = &Нумератор
	|	И ВнутренниеДокументы.РегистрационныйНомер <> """"";
	Запрос.УстановитьПараметр("Нумератор", Нумератор);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат 0;
	КонецЕсли;	
	
	Возврат Результат.Выгрузить().Итог("Количество");
	
КонецФункции	

Функция КоличествоДокументовСПустымВидом(ТипДокумента) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипДокумента = "ВходящийДокумент" Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ИЗ
		|	Справочник.ВходящиеДокументы КАК ВходящиеДокументы
		|ГДЕ
		|	ВходящиеДокументы.ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыВходящихДокументов.ПустаяСсылка)";
		
	ИначеЕсли ТипДокумента = "ИсходящийДокумент" Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ИЗ
		|	Справочник.ИсходящиеДокументы КАК ИсходящиеДокументы
		|ГДЕ
		|	ИсходящиеДокументы.ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыИсходящихДокументов.ПустаяСсылка)";
		
	ИначеЕсли ТипДокумента = "ВнутреннийДокумент" Тогда	
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ИЗ
		|	Справочник.ВнутренниеДокументы КАК ВнутренниеДокументы
		|ГДЕ
		|	ВнутренниеДокументы.ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыВнутреннихДокументов.ПустаяСсылка)";
		
	КонецЕсли;	
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Количество;
	
КонецФункции	

// Инициализирует персональные настройки работы с документами - для использования на клиенте.
Функция ПолучитьПерсональныеНастройкиРаботыСДокументамиСервер() Экспорт
	Настройки = Новый Структура;

	ПоказыватьПредупреждениеПриРегистрации = ХранилищеОбщихНастроек.Загрузить("НастройкиРаботыСДокументами", "ПоказыватьПредупреждениеПриРегистрации");
	Если ПоказыватьПредупреждениеПриРегистрации = Неопределено Тогда
		ПоказыватьПредупреждениеПриРегистрации = Истина;
		ХранилищеОбщихНастроек.Сохранить("НастройкиРаботыСДокументами", "ПоказыватьПредупреждениеПриРегистрации", ПоказыватьПредупреждениеПриРегистрации);
	КонецЕсли;
	
	Настройки.Вставить("ПоказыватьПредупреждениеПриРегистрации", ПоказыватьПредупреждениеПриРегистрации);
	
	УстановитьПривилегированныйРежим(Истина);
	Настройки.Вставить("ИспользоватьФайлыУВходящихДокументов", Константы.ИспользоватьФайлыУВходящихДокументов.Получить());
	Настройки.Вставить("ИспользоватьФайлыУИсходящихДокументов", Константы.ИспользоватьФайлыУИсходящихДокументов.Получить());
	
	
	Возврат Настройки; // параметры доступны только для чтения
КонецФункции

// Получает актуальное состояние дела
Функция ПолучитьСостояниеДела(Дело) Экспорт
	
	Если Не ЗначениеЗаполнено(Дело) Тогда
		Возврат Перечисления.СостоянияДелХраненияДокументов.ПустаяСсылка();
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияДелХраненияДокументов.Состояние КАК Состояние
	|ИЗ
	|	РегистрСведений.СостоянияДелХраненияДокументов.СрезПоследних(, ДелоХраненияДокументов = &Дело) КАК СостоянияДелХраненияДокументов";
	Запрос.УстановитьПараметр("Дело", Дело);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Перечисления.СостоянияДелХраненияДокументов.ПустаяСсылка();
	КонецЕсли;	
		
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Состояние; 
	
КонецФункции

Функция ПолучитьРежимВыбораВидаДокумента(ТипДокумента) Экспорт
	
	Если ТипДокумента = "ВходящийДокумент" Тогда 
		ВидДокумента = "ВидыВходящихДокументов";
	ИначеЕсли ТипДокумента = "ИсходящийДокумент" Тогда 
		ВидДокумента = "ВидыИсходящихДокументов";
	ИначеЕсли ТипДокумента = "ВнутреннийДокумент" Тогда 
		ВидДокумента = "ВидыВнутреннихДокументов";
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = СтрЗаменить(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЛОЖЬ КАК ЗначениеЛожь
	|ГДЕ
	|	ВЫБОР
	|			КОГДА ЛОЖЬ В
	|					(ВЫБРАТЬ ПЕРВЫЕ 1
	|						ЛОЖЬ
	|					ИЗ
	|						&ВидДокумента КАК ТаблицаВидаДокументов
	|					ГДЕ
	|						ТаблицаВидаДокументов.ЭтоГруппа)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ В
	|					(ВЫБРАТЬ
	|						ЛОЖЬ КАК ЗначениеЛожь
	|					ИЗ
	|						(ВЫБРАТЬ ПЕРВЫЕ 16
	|							ИСТИНА КАК ЗначениеИстина
	|						ИЗ
	|							&ВидДокумента КАК ТаблицаВидаДокументов
	|						) КАК ВыбранныеОбъекты
	|					ИМЕЮЩИЕ
	|						КОЛИЧЕСТВО(ВыбранныеОбъекты.ЗначениеИстина) > 15)
	|		КОНЕЦ", "&ВидДокумента", "Справочник." + ВидДокумента);
	
	Результат = Запрос.Выполнить();
	БыстрыйВыборВидаДокумента = Результат.Пустой();
	
	Возврат БыстрыйВыборВидаДокумента;
	
КонецФункции	

// Позволяет проверить изменение признака "удуУчетПоДетям" при записи элемента справочников.
// "Виды...ихДокументов"
Функция удуИзмененПризнакУчетаПоДетям(Объект) Экспорт
	ПризнакИзменен = Ложь;
	
	Если Не Объект.Ссылка.Пустая() Тогда
		ОбъектВБазе =  Объект.Ссылка.ПолучитьОбъект();		
		Если Объект.удуУчетПоДетям <> ОбъектВБазе.удуУчетПоДетям Тогда
			ПризнакИзменен = Истина;
		КонецЕсли;		
	КонецЕсли;
	
	Возврат ПризнакИзменен;
КонецФункции