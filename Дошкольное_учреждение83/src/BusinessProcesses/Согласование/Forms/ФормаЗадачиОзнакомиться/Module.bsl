
////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОзнакомилсяСервер()
	
	УстановитьПривилегированныйРежим(Истина);
	СогласованиеОбъект = Объект.БизнесПроцесс.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(СогласованиеОбъект.Ссылка);
	НайденнаяСтрока = СогласованиеОбъект.РезультатыОзнакомлений.Найти(Объект.Ссылка, "ЗадачаИсполнителя");
	НайденнаяСтрока.ОтправленоНаПовторноеСогласование = Ложь;
	СогласованиеОбъект.Записать();
	УстановитьПривилегированныйРежим(Ложь);
	
	БизнесПроцессыИЗадачиСервер.ВыполнитьЗадачу(Объект.Ссылка);
		
КонецПроцедуры	

&НаСервере
Процедура ПовторитьСервер()
	
	УстановитьПривилегированныйРежим(Истина);
	СогласованиеОбъект = Объект.БизнесПроцесс.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(СогласованиеОбъект.Ссылка);
	СогласованиеОбъект.ПовторитьСогласование = Истина;
	НайденнаяСтрока = СогласованиеОбъект.РезультатыОзнакомлений.Найти(Объект.Ссылка, "ЗадачаИсполнителя");
	НайденнаяСтрока.ОтправленоНаПовторноеСогласование = Истина;
	СогласованиеОбъект.Записать();
	УстановитьПривилегированныйРежим(Ложь);
	
	БизнесПроцессыИЗадачиСервер.ВыполнитьЗадачу(Объект.Ссылка);
	
КонецПроцедуры	


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессами.ФормаЗадачиПриСозданииНаСервере(ЭтаФорма, Объект, 
		Элементы.СрокИсполнения, Элементы.ДатаИсполнения, Элементы.Предмет);
		
	РаботаСБизнесПроцессами.УстановитьФорматДаты(Элементы.ХодИсполненияДатаИсполнения);
	
	// номер итерации
	НайденнаяСтрока = Объект.БизнесПроцесс.РезультатыОзнакомлений.Найти(Объект.Ссылка, "ЗадачаИсполнителя");
	Если НайденнаяСтрока <> Неопределено Тогда 
		НомерИтерации = НайденнаяСтрока.НомерИтерации;
	КонецЕсли;	
	
	// результат согласования
	РезультатСогласования = Перечисления.РезультатыСогласования.Согласовано;
	СтрокиИтерации = Объект.БизнесПроцесс.РезультатыСогласования.НайтиСтроки(Новый Структура("НомерИтерации", НомерИтерации));
	Для Каждого Строка Из СтрокиИтерации Цикл
		Если Строка.РезультатСогласования = Перечисления.РезультатыСогласования.НеСогласовано Тогда 
			РезультатСогласования = Перечисления.РезультатыСогласования.НеСогласовано;
			Прервать;
		КонецЕсли;	
		
		Если Строка.РезультатСогласования = Перечисления.РезультатыСогласования.СогласованоСЗамечаниями Тогда 
			РезультатСогласования = Перечисления.РезультатыСогласования.СогласованоСЗамечаниями;
		КонецЕсли;	
	КонецЦикла;	
	
	// цвет результата
	Если (РезультатСогласования = Перечисления.РезультатыСогласования.Согласовано) 
	 Или (РезультатСогласования = Перечисления.РезультатыСогласования.СогласованоСЗамечаниями) Тогда 
		Элементы.РезультатСогласования.ЦветТекста = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
		
	ИначеЕсли РезультатСогласования = Перечисления.РезультатыСогласования.НеСогласовано Тогда 
		Элементы.РезультатСогласования.ЦветТекста = ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи;
		
	КонецЕсли;
	
	// динамический список
	ТочкиМаршрута = Новый Массив;
	ТочкиМаршрута.Добавить(БизнесПроцессы.Согласование.ТочкиМаршрута.СогласоватьПоследовательно);
	ТочкиМаршрута.Добавить(БизнесПроцессы.Согласование.ТочкиМаршрута.СогласоватьПараллельно);
	
	ХодИсполнения.Параметры.УстановитьЗначениеПараметра("ТочкиМаршрута", ТочкиМаршрута);
	ХодИсполнения.Параметры.УстановитьЗначениеПараметра("БизнесПроцесс", Объект.БизнесПроцесс);
	ХодИсполнения.Параметры.УстановитьЗначениеПараметра("НомерИтерации", НомерИтерации);
	
	// заголовки кнопок
	Если РезультатСогласования = Перечисления.РезультатыСогласования.НеСогласовано Тогда 
		Элементы.Ознакомился.Заголовок = "Завершить согласование";
	Иначе	
		Элементы.Повторить.Видимость = Ложь;
	КонецЕсли;
	
	// Заполнение текста результата выполнения для выполненной задачи
	НайденнаяСтрока = Объект.БизнесПроцесс.РезультатыОзнакомлений.Найти(Объект.Ссылка, "ЗадачаИсполнителя");
	Если НайденнаяСтрока <> Неопределено Тогда 
		Если НайденнаяСтрока.ОтправленоНаПовторноеСогласование Тогда
			Элементы.ТекстРезультатаВыполнения.Заголовок = НСТР("ru = 'Отправлено на повторное согласование.'");
			Элементы.ТекстРезультатаВыполнения.ЦветТекста = ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи;
		Иначе	
			Элементы.ТекстРезультатаВыполнения.Заголовок = НСТР("ru = 'Ознакомился.'");
			Элементы.ТекстРезультатаВыполнения.ЦветТекста = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
		КонецЕсли;
	КонецЕсли;	
	
	Если НомерИтерации <= 1 Тогда 
		Элементы.НомерИтерации.Видимость = Ложь;
		Элементы.История.Видимость = Ложь;
	КонецЕсли;	
		
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПеренаправлениеЗадач") Тогда
		Элементы.Перенаправить.Видимость = Ложь;	
	КонецЕсли;		
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ОчиститьСообщения();
	Если Записать() Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		Закрыть();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВыполнить(Команда)
	
	Если Записать() Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(Объект.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(Объект.Предмет);
	Иначе	
		ОткрытьЗначение(Объект.Предмет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Ознакомился(Команда)
	
	Если Не РаботаСБизнесПроцессамиКлиент.ПроверитьНаличиеЗанятыхФайлов(Объект) Тогда 
		Возврат;
	КонецЕсли;
	
	Если Записать() Тогда 
		
		ОзнакомилсяСервер();
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Выполнение:'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		
		ОповеститьОбИзменении(Объект.Ссылка);
		Оповестить("ЗадачаВыполнена", Объект.Ссылка);
		Оповестить("ЗадачаИзменена", Объект.Ссылка);
		
		Закрыть();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ХодИсполненияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	БизнесПроцессыИЗадачиКлиент.СписокЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Повторить(Команда)
	
	Если Записать() Тогда 
		
		ПараметрыФормы = Новый Структура("Ключ", Объект.БизнесПроцесс);
		Результат = ОткрытьФормуМодально("БизнесПроцесс.Согласование.Форма.ФормаИзменениеПараметров", ПараметрыФормы, ЭтаФорма);
		Если Результат <> КодВозвратаДиалога.ОК Тогда 
			Возврат;
		КонецЕсли;
		
		ПовторитьСервер();
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Выполнение:'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		
		ОповеститьОбИзменении(Объект.Ссылка);
		Закрыть();
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура История(Команда)
	
	ПараметрыФормы = Новый Структура("ЗадачаСсылка", Объект.Ссылка);
	ОткрытьФорму("БизнесПроцесс.Согласование.Форма.ФормаИсторияСогласования", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительСтрокойОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСБизнесПроцессамиКлиент.ОткрытьИсполнителя(Объект.Исполнитель);
	
КонецПроцедуры

&НаКлиенте
Процедура Дополнительно(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОткрытьДопИнформациюОЗадаче(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Перенаправить(Команда)
	
	Если Объект.Выполнена Тогда
		Предупреждение(НСтр("ru = 'Уже выполненную задачу нельзя перенаправить.'"));
		Возврат;
	КонецЕсли;	
			
	Записать();
	Если БизнесПроцессыИЗадачиКлиент.ПеренаправитьЗадачу(Объект.Ссылка, ЭтаФорма) Тогда
		Закрыть();
	КонецЕсли;	
	
КонецПроцедуры
