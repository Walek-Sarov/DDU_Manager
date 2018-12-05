
Процедура УдалитьСостоянияБизнесПроцесса(БизнесПроцесс) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияДокументов.Период КАК Период,
	|	СостоянияДокументов.Документ КАК Документ
	|ИЗ
	|	РегистрСведений.СостоянияДокументов КАК СостоянияДокументов
	|ГДЕ
	|	СостоянияДокументов.Установил = &Установил";
	Запрос.УстановитьПараметр("Установил", БизнесПроцесс);
	Выборка = Запрос.Выполнить().Выбрать();
	
	МенеджерЗаписи = РегистрыСведений.СостоянияДокументов.СоздатьМенеджерЗаписи();
	Пока Выборка.Следующий() Цикл
		МенеджерЗаписи.Документ = Выборка.Документ;
		МенеджерЗаписи.Период = Выборка.Период;
		МенеджерЗаписи.Удалить();
	КонецЦикла;	
	
КонецПроцедуры	

Процедура УстановитьФорматДаты(ПолеДаты) Экспорт
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	ПолеДаты.Формат					= ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	Если ПолеДаты.Вид = ВидПоляФормы.ПолеВвода Тогда
		ПолеДаты.ФорматРедактирования 	= ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	КонецЕсли;	
	
КонецПроцедуры		
	
Процедура ФормаЗадачиПриСозданииНаСервере(Форма, Объект, ЭлементСрокИсполнения, ЭлементДатаИсполнения, ЭлементПредмет) Экспорт
	
	Форма.НачальныйПризнакВыполнения = Объект.Выполнена;
	Форма.ТолькоПросмотр = Объект.Выполнена;
	
	Если Не Объект.Выполнена Тогда
		Объект.ДатаИсполнения = ТекущаяДата();
	КонецЕсли;	
	
	ЭлементПредмет.Гиперссылка = ЗначениеЗаполнено(Объект.Предмет);
	Форма.ПредметСтрокой = БизнесПроцессыИЗадачиСервер.ПредметСтрокой(Объект.Предмет);
	
	УстановитьФорматДаты(ЭлементСрокИсполнения);
	УстановитьФорматДаты(ЭлементДатаИсполнения);
	УстановитьФорматДаты(Форма.Элементы.Дата);
	
	ИзменятьЗаданияЗаднимЧислом = ПолучитьФункциональнуюОпцию("ИзменятьЗаданияЗаднимЧислом");
	ЭлементДатаИсполнения.ТолькоПросмотр = Не ИзменятьЗаданияЗаднимЧислом;
	
	// Заполняем поле "Исполнитель"
	Если НЕ Объект.Исполнитель.Пустая() Тогда
		Форма.ИсполнительСтрокой = Объект.Исполнитель;
		Форма.Элементы.ИсполнительСтрокой.КнопкаОткрытия = Истина;
	Иначе
		Форма.ИсполнительСтрокой = Строка(Объект.РольИсполнителя);
		
		Если Объект.ОсновнойОбъектАдресации <> Неопределено И НЕ Объект.ОсновнойОбъектАдресации.Пустая() Тогда
			Форма.ИсполнительСтрокой = Форма.ИсполнительСтрокой + ", " + Объект.ОсновнойОбъектАдресации;
		КонецЕсли;	
		
		Если Объект.ДополнительныйОбъектАдресации <> Неопределено И НЕ Объект.ДополнительныйОбъектАдресации.Пустая() Тогда
			Форма.ИсполнительСтрокой = Форма.ИсполнительСтрокой + ", " + Объект.ДополнительныйОбъектАдресации;
		КонецЕсли;	
		Форма.Элементы.ИсполнительСтрокой.КнопкаОткрытия = Ложь;
	КонецЕсли;
	
	Если Объект.Выполнена Тогда
		Форма.Элементы.ГруппаКомандыВыполнения.Видимость = Ложь;
		Форма.Элементы.ТекстРезультатаВыполнения.Видимость = Истина;
	Иначе	
		Форма.Элементы.ГруппаКомандыВыполнения.Видимость = Истина;
		Форма.Элементы.ТекстРезультатаВыполнения.Видимость = Ложь;
	КонецЕсли;	
	
КонецПроцедуры             

// Вызывается при перенаправлении задачи.
//
// Параметры
//   ЗадачаСсылка  – ЗадачаСсылка.ЗадачаИсполнителя – перенаправляемая задача.
//   НоваяЗадачаСсылка  – ЗадачаСсылка.ЗадачаИсполнителя – задача для нового исполнителя.
//
Процедура ПриПеренаправленииЗадачи(ЗадачаСсылка) Экспорт
КонецПроцедуры
