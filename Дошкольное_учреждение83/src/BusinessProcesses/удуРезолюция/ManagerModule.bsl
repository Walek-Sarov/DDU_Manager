
Функция ФормаВыполненияЗадачи(ЗадачаСсылка, ТочкаМаршрутаСсылка) Экспорт
	
	Если ТочкаМаршрутаСсылка = БизнесПроцессы.удуРезолюция.ТочкиМаршрута.Исполнить Тогда 
		ИмяФормы = "БизнесПроцесс.удуРезолюция.Форма.ФормаЗадачиИсполнителя";
		
	ИначеЕсли ТочкаМаршрутаСсылка = БизнесПроцессы.удуРезолюция.ТочкиМаршрута.ОтветственноеИсполнение Тогда 
		ИмяФормы = "БизнесПроцесс.удуРезолюция.Форма.ФормаЗадачиОтвИсполнителя";	
		
	ИначеЕсли ТочкаМаршрутаСсылка = БизнесПроцессы.удуРезолюция.ТочкиМаршрута.Проверить Тогда 
		ИмяФормы = "БизнесПроцесс.удуРезолюция.Форма.ФормаЗадачиПроверяющего";
		
	КонецЕсли;	
		
	Результат = Новый Структура;
	Результат.Вставить("ПараметрыФормы", Новый Структура("Ключ", ЗадачаСсылка));
	Результат.Вставить("ИмяФормы", ИмяФормы);
	Возврат Результат;	
	
КонецФункции

// Вызывается при выполнении задачи из формы списка.
//
// Параметры
//   ЗадачаСсылка  – ЗадачаСсылка.ЗадачаИсполнителя – задача 
//   ТочкаМаршрутаСсылка – точка маршрута 
//
Процедура ОбработкаВыполненияПоУмолчанию(ЗадачаСсылка, БизнесПроцессСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт
	
КонецПроцедуры	

// Вызывается при перенаправлении задачи.
//
// Параметры
//   ЗадачаСсылка  – ЗадачаСсылка.ЗадачаИсполнителя – перенаправляемая задача.
//   НоваяЗадачаСсылка  – ЗадачаСсылка.ЗадачаИсполнителя – задача для нового исполнителя.
//
Процедура ПриПеренаправленииЗадачи(ЗадачаСсылка) Экспорт
	
	// Изменяем бизнес-процесс
	УстановитьПривилегированныйРежим(Истина);
	БизнесПроцессОбъект = ЗадачаСсылка.БизнесПроцесс.ПолучитьОбъект();
	БизнесПроцессОбъект.Заблокировать();
	Строка = БизнесПроцессОбъект.ДополнительныеИсполнители.Добавить();
	Строка.Исполнитель = ЗадачаСсылка.Исполнитель;
	Строка.ОсновнойОбъектАдресации = ЗадачаСсылка.ОсновнойОбъектАдресации;
	Строка.ДополнительныйОбъектАдресации = ЗадачаСсылка.ДополнительныйОбъектАдресации;
	
	Если ТипЗнч(Строка.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
		Строка.ГруппаДоступаИсполнителей = РегистрыСведений.ИсполнителиЗадач.ГруппаДоступаИсполнителей(
			Строка.Исполнитель, Строка.ОсновнойОбъектАдресации, Строка.ДополнительныйОбъектАдресации);
	Иначе		
		Строка.ГруппаДоступаИсполнителей = Строка.Исполнитель;
	КонецЕсли;		
	
	БизнесПроцессОбъект.Записать();
	УстановитьПривилегированныйРежим(Ложь);
	
	РаботаСБизнесПроцессами.ПриПеренаправленииЗадачи(ЗадачаСсылка);
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
&НаСервере
Процедура ЗаписатьСостояниеЗадачиИсполнителя(ЗадачаИсполнителяОбъект, Состояние, КомментарийПроверяющего = "") Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
    НачатьТранзакцию();
	Попытка
		
		Если Состояние = Перечисления.удуСостоянияЗадачиПослеПроверки.Завершена И КомментарийПроверяющего = "" Тогда
			 			                                                          	
			НаборЗаписей = РегистрыСведений.удуРезультатыПроверкиРезолюций.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Задача.Установить(ЗадачаИсполнителяОбъект.Ссылка);
			НаборЗаписей.Прочитать();
			Если НаборЗаписей.Количество() > 0  Тогда
				КомментарийПроверяющего = НаборЗаписей[0].КомментарийПроверяющего;
			КонецЕсли;
		КонецЕсли;
		
		Запись = РегистрыСведений.удуРезультатыПроверкиРезолюций.СоздатьМенеджерЗаписи();
		Запись.Резолюция = ЗадачаИсполнителяОбъект.БизнесПроцесс;
		Запись.НомерИтерации = ЗадачаИсполнителяОбъект.БизнесПроцесс.НомерИтерации;
		Запись.Задача = ЗадачаИсполнителяОбъект.Ссылка;
		Запись.Дата = ТекущаяДата();
		Запись.Состояние = Состояние; 	
		Запись.Пользователь = ОбщегоНазначения.ТекущийПользователь();
		Запись.КомментарийПроверяющего = КомментарийПроверяющего;
		Запись.Записать(Истина);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
		
КонецПроцедуры