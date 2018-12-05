
////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ

&НаСервере
Процедура ИсполненоСервер()
	
	БизнесПроцессыИЗадачиСервер.ВыполнитьЗадачу(Объект.Ссылка);
		
КонецПроцедуры	

&НаСервере
Функция ЕстьНевыполненныеЗадачиИсполнителей()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗадачаИсполнителя.Ссылка
	|ИЗ
	|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	|ГДЕ
	|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс
	|	И ЗадачаИсполнителя.ТочкаМаршрута = &ТочкаМаршрута
	|	И (НЕ ЗадачаИсполнителя.Выполнена)";
	
	Запрос.УстановитьПараметр("БизнесПроцесс", Объект.БизнесПроцесс);
	Запрос.УстановитьПараметр("ТочкаМаршрута", БизнесПроцессы.удуРезолюция.ТочкиМаршрута.Исполнить);
	
	Результат = Запрос.Выполнить();
	Возврат Не Результат.Пустой();
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессами.ФормаЗадачиПриСозданииНаСервере(ЭтаФорма, Объект, 
		Элементы.СрокИсполнения, Элементы.ДатаИсполнения, Элементы.Предмет);
		
	Исполнители.Параметры.УстановитьЗначениеПараметра("БизнесПроцесс", Объект.БизнесПроцесс);
	Исполнители.Параметры.УстановитьЗначениеПараметра("ТочкаМаршрута", БизнесПроцессы.удуРезолюция.ТочкиМаршрута.Исполнить);
	
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Исполнители.УсловноеОформление);
	
	РаботаСБизнесПроцессами.УстановитьФорматДаты(Элементы.ИсполнителиСрокИсполнения);
	РаботаСБизнесПроцессами.УстановитьФорматДаты(Элементы.ИсполнителиДатаИсполнения);
	
	Если Объект.Выполнена Тогда
		Элементы.ТекстРезультатаВыполнения.Заголовок = НСТР("ru = 'Исполнено и проверено.'");
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
		Оповестить("ЗадачаИзменена", Объект.Ссылка);
		
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
Процедура ИсполнителиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	БизнесПроцессыИЗадачиКлиент.СписокЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Исполнено(Команда)
	
	Если ЕстьНевыполненныеЗадачиИсполнителей() Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Задача не может быть завершена, пока не выполнены все задачи исполнителей'"),,,
			"Исполнители");
		Возврат;
	КонецЕсли;	
	
	Если Не РаботаСБизнесПроцессамиКлиент.ПроверитьНаличиеЗанятыхФайлов(Объект) Тогда 
		Возврат;
	КонецЕсли;
	
	Если Записать() Тогда 
		
		ИсполненоСервер();
		
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
