////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем ПерваяЧастьИмени, ВтораяЧастьИмени;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	0 КАК Выбран,
	|	НаборыДополнительныхРеквизитовИСведений.Ссылка КАК Набор,
	|	НаборыДополнительныхРеквизитовИСведений.Наименование
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений КАК НаборыДополнительныхРеквизитовИСведений
	|
	|УПОРЯДОЧИТЬ ПО
	|	НаборыДополнительныхРеквизитовИСведений.Ссылка ИЕРАРХИЯ
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	МассивУдаляемыхСтрок = Новый Массив;
	
	Для каждого СтрокаДерева Из Дерево.Строки Цикл
		
		ВидыСвойствНабора = УправлениеСвойствами.ВидыСвойствНабора(СтрокаДерева.Набор);
		
		Если Параметры.ЭтоДополнительноеСведение
		   И НЕ ВидыСвойствНабора.ДополнительныеСведения Тогда
			
			МассивУдаляемыхСтрок.Добавить(СтрокаДерева);
			
		ИначеЕсли НЕ Параметры.ЭтоДополнительноеСведение
		        И НЕ ВидыСвойствНабора.ДополнительныеРеквизиты Тогда
			
			МассивУдаляемыхСтрок.Добавить(СтрокаДерева);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементУдаляемаяСтрока Из МассивУдаляемыхСтрок Цикл
		Дерево.Строки.Удалить(ЭлементУдаляемаяСтрока);
	КонецЦикла;
	
	ВыбранныеНаборы = Параметры.ВыбранныеНаборы;
	Для каждого Набор Из ВыбранныеНаборы Цикл
		
		Строка = Дерево.Строки.Найти(Набор.Значение, "Набор", Истина);
		Если Строка <> Неопределено Тогда
			Строка.Выбран = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Строка Из Дерево.Строки Цикл
		ПроверитьФлагУСтроки(Строка);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоНаборов");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ВыбранПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоНаборов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Выбран = 2 Тогда
		ТекущиеДанные.Выбран = 0;
	КонецЕсли;
	
	Строки = ТекущиеДанные.ПолучитьЭлементы();
	УстановитьФлагПодчиненнымСтрокам(Строки, ТекущиеДанные.Выбран);
	
	Родитель = ТекущиеДанные.ПолучитьРодителя();
	Пока Родитель <> Неопределено Цикл
		
		Есть0 = Ложь;
		Есть1 = Ложь;
		Есть2 = Ложь;
		
		Для Каждого Строка Из Родитель.ПолучитьЭлементы() Цикл
			Есть0 = Есть0 ИЛИ (Строка.Выбран = 0);
			Есть1 = Есть1 ИЛИ (Строка.Выбран = 1);
			Есть2 = Есть2 ИЛИ (Строка.Выбран = 2);
		КонецЦикла;
		
		Если Не Есть1 И Не Есть2 Тогда
			Родитель.Выбран = 0;
			
		ИначеЕсли Не Есть2 И Не Есть0 Тогда
			Родитель.Выбран = 1;
		Иначе
			Родитель.Выбран = 2;
		КонецЕсли;
		
		Родитель = Родитель.ПолучитьРодителя();
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбранныеНаборы = Новый СписокЗначений;
	ЗаполнитьВыбранныеНаборы(ВыбранныеНаборы, ДеревоНаборов.ПолучитьЭлементы());
	
	Закрыть(ВыбранныеНаборы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсеНаборы(Команда)
	
	УстановитьФлагПодчиненнымСтрокам(ДеревоНаборов.ПолучитьЭлементы(), 1);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметкуВсемНаборам(Команда)
	
	УстановитьФлагПодчиненнымСтрокам(ДеревоНаборов.ПолучитьЭлементы(), 0);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ЗаполнитьВыбранныеНаборы(ВыбранныеНаборы, Строки)
	
	Для каждого Строка Из Строки Цикл
		ПодчиненныеСтроки = Строка.ПолучитьЭлементы();
		
		Если ПодчиненныеСтроки.Количество() <> 0 Тогда
			ЗаполнитьВыбранныеНаборы(ВыбранныеНаборы, ПодчиненныеСтроки);
			
		ИначеЕсли Строка.Выбран Тогда
			ВыбранныеНаборы.Добавить(Строка.Набор, Строка.Наименование);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьФлагУСтроки(СтрокаДерева)
	
	Если СтрокаДерева.Строки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Есть0 = Ложь;
	Есть1 = Ложь;
	Есть2 = Ложь;
	
	Для Каждого Строка Из СтрокаДерева.Строки Цикл
		
		ПроверитьФлагУСтроки(Строка);
		
		Есть0 = Есть0 ИЛИ (Строка.Выбран = 0);
		Есть1 = Есть1 ИЛИ (Строка.Выбран = 1);
		Есть2 = Есть2 ИЛИ (Строка.Выбран = 2);
	КонецЦикла;
	
	Если Не Есть1 И Не Есть2 Тогда
		СтрокаДерева.Выбран = 0;
		
	ИначеЕсли Не Есть2 И Не Есть0 Тогда
		СтрокаДерева.Выбран = 1;
	Иначе
		СтрокаДерева.Выбран = 2;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлагПодчиненнымСтрокам(Строки, Флаг)
	
	Для Каждого Строка Из Строки Цикл
		Строка.Выбран = Флаг;
		УстановитьФлагПодчиненнымСтрокам(Строка.ПолучитьЭлементы(), Флаг)
	КонецЦикла;
	
КонецПроцедуры


