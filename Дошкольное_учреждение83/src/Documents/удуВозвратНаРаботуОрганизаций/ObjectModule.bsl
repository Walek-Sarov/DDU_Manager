
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по шапке документа
//
// Параметры:
//
// Возвращаемое значение:
//	Результат запроса
//
Функция СформироватьЗапросПоШапке()

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",		Ссылка);
	Запрос.УстановитьПараметр("ПустаяОрганизация",	Справочники.удуУчреждения.ПустаяСсылка());

	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.Дата,
	|	Док.Организация,
	|	Док.Организация КАК ГоловнаяОрганизация,
	|	Док.Ссылка
	|ИЗ
	|	Документ.удуВозвратНаРаботуОрганизаций КАК Док
	|ГДЕ
	|	Док.Ссылка = &ДокументСсылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "РаботникиОрганизации" документа
//
// Параметры:
//	Режим	- режим проведения
//
// Возвращаемое значение:
//	Результат запроса. В запросе данные документа дополняются значениями
//	проверяемых параметров из связанного с
//
Функция СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента)

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ВыборкаПоШапкеДокумента.ГоловнаяОрганизация);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТЧРаботникиОрганизации.Ссылка,
	|	ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|	ТЧРаботникиОрганизации.Сотрудник КАК Сотрудник,
	|	ТЧРаботникиОрганизации.Сотрудник.Наименование,
	|	ТЧРаботникиОрганизации.Сотрудник.Организация,
	|	ТЧРаботникиОрганизации.Сотрудник.Физлицо КАК Физлицо,
	|	ТЧРаботникиОрганизации.ДатаВозврата КАК ДатаВозврата,
	|	ТЧРаботникиОрганизации.ЗаниматьСтавку
	|ПОМЕСТИТЬ ВТДанныеДокумента
	|ИЗ
	|	Документ.удуВозвратНаРаботуОрганизаций.РаботникиОрганизации КАК ТЧРаботникиОрганизации
	|ГДЕ
	|	ТЧРаботникиОрганизации.Ссылка = &ДокументСсылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник,
	|	ДатаВозврата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|	ТЧРаботникиОрганизации.Сотрудник,
	|	ТЧРаботникиОрганизации.СотрудникНаименование,
	|	ТЧРаботникиОрганизации.Физлицо КАК Физлицо,
	|	ТЧРаботникиОрганизации.ДатаВозврата,
	|	ТЧРаботникиОрганизации.ЗаниматьСтавку,
	|	ДанныеПоРаботникуДоНазначения.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	|	ДанныеПоРаботникуДоНазначения.Должность КАК Должность,
	|	ДанныеПоРаботникуДоНазначения.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
	|	ДанныеПоРаботникуДоНазначения.Период КАК ДатаПоследнегоДвиженияПоРаботнику,
	|	ПересекающиесяСтроки.КонфликтнаяСтрокаНомер,
	|	ИмеющиесяСостояния.Состояние КАК КонфликтноеСостояние,
	|	ИмеющиесяСостояния.Регистратор КАК КонфликтныйДокумент,
	|	ВЫБОР
	|		КОГДА ТЧРаботникиОрганизации.СотрудникОрганизация = &ГоловнаяОрганизация
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОшибкаНеСоответствиеСотрудникаИОрганизации
	|ИЗ
	|	ВТДанныеДокумента КАК ТЧРаботникиОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|			МАКСИМУМ(Работники.Период) КАК ДатаДвижения
	|		ИЗ
	|			ВТДанныеДокумента КАК ТЧРаботникиОрганизации
	|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.удуРаботникиОрганизаций КАК Работники
	|				ПО (Работники.Период <= ТЧРаботникиОрганизации.ДатаВозврата)
	|					И ТЧРаботникиОрганизации.Сотрудник = Работники.Сотрудник
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ТЧРаботникиОрганизации.НомерСтроки) КАК ДатыПоследнегоДвиженияРаботника
	|		ПО ТЧРаботникиОрганизации.НомерСтроки = ДатыПоследнегоДвиженияРаботника.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.удуРаботникиОрганизаций КАК ДанныеПоРаботникуДоНазначения
	|		ПО (ДатыПоследнегоДвиженияРаботника.ДатаДвижения = ДанныеПоРаботникуДоНазначения.Период)
	|			И ТЧРаботникиОрганизации.Сотрудник = ДанныеПоРаботникуДоНазначения.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|			МИНИМУМ(ТЧРаботникиОрганизации2.НомерСтроки) КАК КонфликтнаяСтрокаНомер
	|		ИЗ
	|			ВТДанныеДокумента КАК ТЧРаботникиОрганизации
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДанныеДокумента КАК ТЧРаботникиОрганизации2
	|				ПО ТЧРаботникиОрганизации.НомерСтроки > ТЧРаботникиОрганизации2.НомерСтроки
	|					И ТЧРаботникиОрганизации.ДатаВозврата = ТЧРаботникиОрганизации2.ДатаВозврата
	|					И ТЧРаботникиОрганизации.Сотрудник = ТЧРаботникиОрганизации2.Сотрудник
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ТЧРаботникиОрганизации.НомерСтроки) КАК ПересекающиесяСтроки
	|		ПО ТЧРаботникиОрганизации.НомерСтроки = ПересекающиесяСтроки.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.удуСостояниеРаботниковОрганизаций КАК ИмеющиесяСостояния
	|		ПО ТЧРаботникиОрганизации.ДатаВозврата = ИмеющиесяСостояния.Период
	|			И ТЧРаботникиОрганизации.Ссылка <> ИмеющиесяСостояния.Регистратор
	|			И ТЧРаботникиОрганизации.Сотрудник = ИмеющиесяСостояния.Сотрудник
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоРаботникиОрганизации()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//	ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//	Отказ 					- флаг отказа в проведении,
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	// Организация
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		Отказ=Истина;	
		ТекстСообщения ="Не указана организация, сотрудники которой возвращаются на работу!"; 	
		ТекстСообщения = Заголовок + Символы.ПС + ТекстСообщения;	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "РаботникиОрганизации" документа.
// Если какой-то из реквизитов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры:
//	ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//	ВыборкаПоСтрокамДокумента	- спозиционированная на определеной строке выборка 
//								  из результата запроса по товарам документа, 
//	Отказ						- флаг отказа в проведении,
//	Заголовок					- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)
	
	СтрокаНачалаСообщенияОбОшибке =Заголовок+Символы.ВК+
		"В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) + """ табл. части ""Сотрудники"": ";
		
	// Сотрудник
	НетСотрудника = НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Сотрудник);
	Если НетСотрудника Тогда
		Отказ=Истина;
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = СтрокаНачалаСообщенияОбОшибке + "не выбран сотрудник!";
		СообщениеПользователю.Сообщить();
	КонецЕсли;
	
	// ДатаВозврата
	НетДатыВозврата = НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаВозврата);
	Если НетДатыВозврата Тогда
		Отказ=Истина;
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = СтрокаНачалаСообщенияОбОшибке + "не указана дата возврата на работу!";
		СообщениеПользователю.Сообщить();
	КонецЕсли;

	// Организация сотрудника должна совпадать с организацией документа
	Если ВыборкаПоСтрокамДокумента.ОшибкаНеСоответствиеСотрудникаИОрганизации Тогда
		Отказ=Истина;
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст=СтрокаНачалаСообщенияОбОшибке + "указанный сотрудник оформлен на другую организацию!";
		СообщениеПользователю.Сообщить();
	КонецЕсли;
	
	Если НетСотрудника ИЛИ НетДатыВозврата Тогда
		Возврат; // Дальше не проверяем
	КонецЕсли;
	
	// Проверка: ранее работник должен быть принят на работу
	Если ВыборкаПоСтрокамДокумента.ЗанимаемыхСтавок = NULL Тогда
		Отказ=Истина;
		СтрокаПродолжениеСообщенияОбОшибке = "на " + Формат(ВыборкаПоСтрокамДокумента.ДатаВозврата, "ДЛФ=DD") + " сотрудник " + ВыборкаПоСтрокамДокумента.СотрудникНаименование + " еще не принят на работу!";
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст=СтрокаНачалаСообщенияОбОшибке + СтрокаПродолжениеСообщенияОбОшибке;	
		СообщениеПользователю.Сообщить();
	ИначеЕсли ВыборкаПоСтрокамДокумента.ЗанимаемыхСтавок = 0 Тогда
		Отказ=Истина;
		СтрокаПродолжениеСообщенияОбОшибке = "на " + Формат(ВыборкаПоСтрокамДокумента.ДатаВозврата, "ДЛФ=DD") + " сотрудник " + ВыборкаПоСтрокамДокумента.СотрудникНаименование + " уже уволен (с " + Формат(ВыборкаПоСтрокамДокумента.ДатаПоследнегоДвиженияПоРаботнику, "ДЛФ=DD") + ")!";
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст=СтрокаНачалаСообщенияОбОшибке + СтрокаПродолжениеСообщенияОбОшибке;
		СообщениеПользователю.Сообщить();
	КонецЕсли;

	// Проверка: противоречие другой строке документа
	Если ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер <> NULL Тогда
		Отказ=Истина;
		СтрокаСообщениеОбОшибке = "сотрудник не может быть указан в документе дважды (см. строку " + ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер + ")!"; 
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст=СтрокаНачалаСообщенияОбОшибке + СтрокаСообщениеОбОшибке;
		СообщениеПользователю.Сообщить();
	КонецЕсли;
	
	// Проверка: в регистре уже есть такое движение
	Если ВыборкаПоСтрокамДокумента.КонфликтноеСостояние <> NULL Тогда
		Отказ=Истина;
		СтрокаСообщениеОбОшибке = "сотрудник уже переведен в состояние """ + ВыборкаПоСтрокамДокумента.КонфликтноеСостояние + """ документом "+ВыборкаПоСтрокамДокумента.КонфликтныйДокумент;
		СообщениеПользователю=Новый СообщениеПользователю;
		СообщениеПользователю.Текст=СтрокаНачалаСообщенияОбОшибке + СтрокаСообщениеОбОшибке;
		СообщениеПользователю.Сообщить();
	КонецЕсли;

	
КонецПроцедуры // ПроверитьЗаполнениеСтрокиРаботникаОрганизации()

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры: 
//	ВыборкаПоШапкеДокумента					- выборка из результата запроса по шапке документа,
//	СтруктураПроведенияПоРегистрамСведений	- структура, содержащая имена регистров 
//											  сведений по которым надо проводить документ,
//  СтруктураПараметров						- структура параметров проведения,
//
// Возвращаемое значение:
//	Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации)

	Движение = Движения.удуСостояниеРаботниковОрганизаций.Добавить();
	
	// Свойства
	Движение.Период				= ВыборкаПоРаботникиОрганизации.ДатаВозврата;
	
	// Измерения
	Движение.Сотрудник			= ВыборкаПоРаботникиОрганизации.Сотрудник;
	Движение.Организация		= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;
	
	// Ресурсы
	Движение.Состояние			= Перечисления.удуСостоянияРаботникаОрганизации.Работает;
	
	// Реквизиты
	Движение.ПервичныйДокумент	= ВыборкаПоШапкеДокумента.Ссылка;
	
	Если ВыборкаПоРаботникиОрганизации.ЗаниматьСтавку Тогда
		// займем ставки
		Движение = Движения.удуСотрудникиОсвободившиеСтавкиВОрганизациях.Добавить();
	
		// Свойства
		Движение.Период				= ВыборкаПоРаботникиОрганизации.ДатаВозврата;
	
		// Измерения
		Движение.Сотрудник			= ВыборкаПоРаботникиОрганизации.Сотрудник;
		Движение.Организация		= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;
		
		// Ресурсы
		Движение.ОсвобождатьСтавку	= ложь; 
	КонецЕсли;



КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	МассивТЧ = Новый Массив();
	МассивТЧ.Добавить(РаботникиОрганизации);
	КраткийСоставДокумента = удуДокументыКадровогоУчета.ЗаполнитьКраткийСоставДокумента(МассивТЧ);
	
	Если ПланыОбмена.ГлавныйУзел() = Неопределено Тогда
		ЗаписьРегистрации = ПринадлежностьПоследовательностям.удуКадровыеПриказыОрганизации.Добавить();
		ЗаписьРегистрации.Период		= Дата;
		ЗаписьРегистрации.Регистратор	= Ссылка;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = удуОбщегоНазначенияСервер.ПредставлениеДокументаПриПроведении(Ссылка);
	
	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке();
	
	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();
	
	Если ВыборкаПоШапкеДокумента.Следующий() Тогда
		
		Движения.удуСостояниеРаботниковОрганизаций.мВыполнятьСписаниеФактическогоОтпуска	= Истина;
		
		// Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		// Движения стоит добавлять, если в проведении еще не отказано (отказ = ложь)
		Если НЕ Отказ Тогда


			ВыборкаПоРаботникиОрганизации = СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента).Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

			Пока ВыборкаПоРаботникиОрганизации.Следующий() Цикл 

				// проверим очередную строку табличной части
				ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации, Отказ, Заголовок);

				Если НЕ Отказ Тогда

					// Заполним записи в наборах записей регистров
					ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации);

				КонецЕсли;

			КонецЦикла;
			
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	удуОбщегоНазначенияСервер.ДобавитьПрефиксОрганизации(ЭтотОбъект, Префикс);
КонецПроцедуры
