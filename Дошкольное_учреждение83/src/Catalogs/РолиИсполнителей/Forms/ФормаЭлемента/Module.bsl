
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ГруппаАдресации.Доступность = НЕ Объект.Предопределенный;
	Если НЕ Объект.Предопределенный Тогда
		Элементы.ГруппаТипыОбъектовАдресации.Доступность = Объект.ИспользуетсяСОбъектамиАдресации;
	КонецЕсли;
	
	ОбновитьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.ВнешняяРоль И Не ЗначениеЗаполнено(Объект.УзелОбмена) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю( 
		    НСтр("ru = 'Укажите информационную базу, в которой определены исполнители данной роли.'"),
			,
			"УзелОбмена",
			"Объект",
			Отказ);
	КонецЕсли;		
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ИспользуетсяВКонтекстеДругихИзмеренийАдресацииПриИзменении(Элемент)
	Элементы.ГруппаТипыОбъектовАдресации.Доступность = Объект.ИспользуетсяСОбъектамиАдресации;
КонецПроцедуры

&НаКлиенте
Процедура ВнешняяРольПриИзменении(Элемент)
	
	ВнешняяРольПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УзелОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПланыОбменаДляВыбора = Новый Массив;
	ПланыОбменаДляВыбора.Добавить("ОбменВнешнимиЗаданиями");
	ПланыОбменаДляВыбора.Добавить("ОбменВнешнимиЗаданиямиС1СДокументооборот");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ТекущаяСтрока", Объект.УзелОбмена);
	ПараметрыФормы.Вставить("ВыбиратьВсеУзлы", Ложь);
	ПараметрыФормы.Вставить("ПланыОбменаДляВыбора", ПланыОбменаДляВыбора);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор", Ложь);
	
	ВыбранноеЗначение = ОткрытьФормуМодально("ОбщаяФорма.ВыборУзловПлановОбмена", ПараметрыФормы, ЭтаФорма);
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		Объект.УзелОбмена = ВыбранноеЗначение;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ОткрытьФормуРедактированияКомментария(Элемент.ТекстРедактирования, Объект.Комментарий, 
		Модифицированность);
	КонецПроцедуры
	
////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ВнешняяРольПриИзмененииНаСервере()
	
	Объект.ИспользуетсяБезОбъектовАдресации = Истина;
	Объект.ИспользуетсяСОбъектамиАдресации = Ложь;
	ОбновитьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступность()
	
	Если СтандартныеПодсистемыПереопределяемый.ИспользоватьВнешниеЗадачиИБизнесПроцессы() Тогда
		
		Если Объект.ВнешняяРоль Тогда
			Элементы.ИспользуетсяБезКонтекстаДругихИзмеренийАдресации.Доступность = Ложь;
			Элементы.ИспользуетсяВКонтекстеДругихИзмеренийАдресации.Доступность = Ложь;
			Элементы.ТипыОсновногоОбъектаАдресации.Доступность = Ложь;
			Элементы.ТипыДополнительногоОбъектаАдресации.Доступность = Ложь;
			Элементы.УзелОбмена.Доступность = Истина;
			Элементы.УзелОбмена.АвтоОтметкаНезаполненного = Истина;
		Иначе
			Элементы.ИспользуетсяБезКонтекстаДругихИзмеренийАдресации.Доступность = Истина;
			Элементы.ИспользуетсяВКонтекстеДругихИзмеренийАдресации.Доступность = Истина;
			Элементы.ТипыОсновногоОбъектаАдресации.Доступность = Истина;
			Элементы.ТипыДополнительногоОбъектаАдресации.Доступность = Истина;
			Элементы.УзелОбмена.Доступность = Ложь;
			Элементы.УзелОбмена.АвтоОтметкаНезаполненного = Ложь;
		КонецЕсли;	
		
	Иначе
		
		Элементы.ИспользуетсяБезКонтекстаДругихИзмеренийАдресации.Доступность = Истина;
		Элементы.ИспользуетсяВКонтекстеДругихИзмеренийАдресации.Доступность = Истина;
		Элементы.ТипыОсновногоОбъектаАдресации.Доступность = Истина;
		Элементы.ТипыДополнительногоОбъектаАдресации.Доступность = Истина;
		Элементы.УзелОбмена.Видимость = Ложь;
		Элементы.УзелОбмена.АвтоОтметкаНезаполненного = Ложь;
		Элементы.ВнешняяРоль.Видимость = Ложь;
		
	КонецЕсли;
		
КонецПроцедуры



