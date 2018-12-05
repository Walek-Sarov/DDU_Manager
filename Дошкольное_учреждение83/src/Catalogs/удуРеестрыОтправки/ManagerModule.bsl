
// Печать списка документов РеестраОтправки.
Процедура Печать(ТабДок, Ссылка) Экспорт
	Макет = Справочники.удуРеестрыОтправки.ПолучитьМакет("Печать");
	
	// Выбрать Получателя и Адресата из выбранного РеестраОтправки
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	удуРеестрыОтправкиПакеты.Корреспондент,
	|	удуРеестрыОтправкиПакеты.Номер КАК Номер
	|ИЗ
	|	Справочник.удуРеестрыОтправки.Пакеты КАК удуРеестрыОтправкиПакеты
	|ГДЕ
	|	удуРеестрыОтправкиПакеты.Ссылка В(&Ссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номер";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	// Заголовок, шапка документа
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьДокументыШапка = Макет.ПолучитьОбласть("ДокументыШапка");
	ОбластьДокументы = Макет.ПолучитьОбласть("Документы");
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(Шапка, Выборка.Уровень());
	ТабДок.Вывести(ОбластьДокументыШапка);
	
	НомераКолонок = Макет.ПолучитьОбласть("НомераКолонок");
	ТабДок.Вывести(НомераКолонок, Выборка.Уровень());

	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		// Заполнить Корреспондента
		ОбластьДокументы.Параметры.Заполнить(Выборка);			
		// Заполнить Адресата если он в данном пакете единсвтенный
		ОбластьДокументы.Параметры.Адресат = ПолучитьАдресата(Ссылка,Выборка.Номер).Адресат;
		
		АдресПолучателя = ПолучитьАдрес(Выборка.Корреспондент);
				
		Если АдресПолучателя.Тип = 1 Тогда
			Если ЗначениеЗаполнено(АдресПолучателя.Индекс) Тогда
				ОбластьДокументы.Параметры.Адрес = Строка(АдресПолучателя.Индекс) + ", " +АдресПолучателя.Адрес;
			Иначе
				ОбластьДокументы.Параметры.Адрес = АдресПолучателя.Адрес;
			КонецЕсли;
			
		Иначе 
        	ОбластьДокументы.Параметры.Адрес = АдресПолучателя.АдресПредставление;
		КонецЕсли;
	 			
			// Если текущая строка не входит на страницу, то 
			// вывести разделитель страниц и повторить НомераКолонок
		Если НЕ ТабДок.ПроверитьВывод(ОбластьДокументы) Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			НомераКолонок = Макет.ПолучитьОбласть("НомераКолонок");
			ТабДок.Вывести(НомераКолонок, Выборка.Уровень());
		КонецЕсли;
		ТабДок.Вывести(ОбластьДокументы, Выборка.Уровень());
	КонецЦикла;
	 
	 // Формирование итоговой строки
	ОбластьИтого = Макет.ПолучитьОбласть("Итого");
	ТабДок.Вывести(ОбластьИтого);
	// Вывод области с подписями списка
	ОбластьПодписи = Макет.ПолучитьОбласть("Подписи");
	ТабДок.Вывести(ОбластьПодписи);
		
	ВставлятьРазделительСтраниц = Истина;
	
КонецПроцедуры

// Печать элемента РеестраОтправки на Конверте формата DL(Средний).
Процедура ПечатьКонверт1(ТабДок, Ссылка) Экспорт
	Макет = Справочники.удуРеестрыОтправки.ПолучитьМакет("ПечатьКонверт1");

	// Выбрать Получателя и Адресата из выбранного РеестраОтправки
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	удуРеестрыОтправкиПакеты.Корреспондент КАК Получатель,
	|	удуРеестрыОтправкиПакеты.Номер КАК Номер
	|ИЗ
	|	Справочник.удуРеестрыОтправки.Пакеты КАК удуРеестрыОтправкиПакеты
	|ГДЕ
	|	удуРеестрыОтправкиПакеты.Ссылка В(&Ссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номер";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	// Заголовок, шапка документа
	ОбластьОтправитель = Макет.ПолучитьОбласть("Отправитель");
	ОбластьПолучатель = Макет.ПолучитьОбласть("Получатель");
	ТабДок.Очистить();
    ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		// Заполнить Корреспондента
		ОбластьПолучатель.Параметры.Заполнить(Выборка);	
		
		// ДокументСтруктура = Адресат + Регистрационный номер отправляемого документа 
		ДокументСтруктура = ПолучитьАдресата(Ссылка, Выборка.Номер);
		ОбластьПолучатель.Параметры.Адресат = ДокументСтруктура.Адресат;
		ОбластьПолучатель.Параметры.НомераДокументов = ДокументСтруктура.РегистрационныйНомер;
		
		ОбластьПолучатель.Параметры.НомерПоРеестру = "№ по реестру " + Выборка.Номер;
		АдресПолучателя = ПолучитьАдрес(Выборка.Получатель);
				
		Если АдресПолучателя.Тип = 1 Тогда
			ОбластьПолучатель.Параметры.Представление = АдресПолучателя.Адрес;
			ОбластьПолучатель.Параметры.Индекс = АдресПолучателя.Индекс;
		Иначе 
			СтруктураАдреса = Новый Структура();
			СтруктураАдреса = РазбитьПредставлениеАдреса(АдресПолучателя.АдресПредставление);
 			ОбластьПолучатель.Параметры.Индекс = СтруктураАдреса.Индекс;
        	ОбластьПолучатель.Параметры.Представление = СтруктураАдреса.Адрес;
		КонецЕсли;
		// Индекс
			ОбластьПолучатель.Параметры.Заполнить(ПолучитьСтрокуШрифта(ОбластьПолучатель.Параметры.Индекс))	;
		// Вывести Получателя и Отправителя
		ТабДок.Вывести(ОбластьОтправитель);
    	ТабДок.Вывести(ОбластьПолучатель);
		ТабДок.ВывестиГоризонтальныйРазделительСтраниц();	
        
		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
КонецПроцедуры

// Печать элемента РеестраОтправки на Конверте (Малый).
Процедура ПечатьКонверт2(ТабДок, Ссылка) Экспорт
	
	Макет = Справочники.удуРеестрыОтправки.ПолучитьМакет("ПечатьКонверт2");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	удуРеестрыОтправкиПакеты.Корреспондент КАК Получатель,
	|	удуРеестрыОтправкиПакеты.Номер КАК Номер
	|ИЗ
	|	Справочник.удуРеестрыОтправки.Пакеты КАК удуРеестрыОтправкиПакеты
	|ГДЕ
	|	удуРеестрыОтправкиПакеты.Ссылка В(&Ссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номер";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);

	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьОтправитель = Макет.ПолучитьОбласть("Отправитель");
	ОбластьПолучатель = Макет.ПолучитьОбласть("Получатель");
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		// Заполнить Корреспондента
		ОбластьПолучатель.Параметры.Заполнить(Выборка);	
		ОбластьПолучатель.Параметры.Адресат = ПолучитьАдресата(Ссылка, Выборка.Номер).Адресат;
		
		АдресПолучателя = ПолучитьАдрес(Выборка.Получатель);
				
		Если АдресПолучателя.Тип = 1 Тогда
			ОбластьПолучатель.Параметры.Представление = АдресПолучателя.Адрес;
			ОбластьПолучатель.Параметры.Индекс = АдресПолучателя.Индекс;
		Иначе 
			СтруктураАдреса = Новый Структура();
			СтруктураАдреса = РазбитьПредставлениеАдреса(АдресПолучателя.АдресПредставление);
 			ОбластьПолучатель.Параметры.Индекс = СтруктураАдреса.Индекс;
        	ОбластьПолучатель.Параметры.Представление = СтруктураАдреса.Адрес;
		КонецЕсли;
		
		ТабДок.Вывести(ОбластьОтправитель);
    	ТабДок.Вывести(ОбластьПолучатель);
		ТабДок.ВывестиГоризонтальныйРазделительСтраниц();	
		        
		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	
КонецПроцедуры

// Печать элемента РеестраОтправки на Конверте формата А5(Большой)
Процедура ПечатьКонвертБольшой(ТабДок, Ссылка) Экспорт
	Макет = Справочники.удуРеестрыОтправки.ПолучитьМакет("ПечатьКонвертБольшой");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	удуРеестрыОтправкиПакеты.Корреспондент КАК Получатель,
	|	удуРеестрыОтправкиПакеты.Номер КАК Номер
	|ИЗ
	|	Справочник.удуРеестрыОтправки.Пакеты КАК удуРеестрыОтправкиПакеты
	|ГДЕ
	|	удуРеестрыОтправкиПакеты.Ссылка В(&Ссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номер";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьОтправитель = Макет.ПолучитьОбласть("Отправитель");
	ОбластьПолучатель = Макет.ПолучитьОбласть("Получатель");
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		// Заполнить Корреспондента
		ОбластьПолучатель.Параметры.Заполнить(Выборка);	
		ОбластьПолучатель.Параметры.Адресат = ПолучитьАдресата(Ссылка, Выборка.Номер).Адресат;
		
		АдресПолучателя = ПолучитьАдрес(Выборка.Получатель);
				
		Если АдресПолучателя.Тип = 1 Тогда
			Если ЗначениеЗаполнено(АдресПолучателя.Индекс) Тогда
				ОбластьПолучатель.Параметры.Представление = Строка(АдресПолучателя.Индекс) + ", " +АдресПолучателя.Адрес;
			Иначе
				ОбластьПолучатель.Параметры.Представление = АдресПолучателя.Адрес;
			КонецЕсли;
			
		Иначе 
        	ОбластьПолучатель.Параметры.Представление = АдресПолучателя.АдресПредставление;
		КонецЕсли;

		ТабДок.Вывести(ОбластьОтправитель);
    	ТабДок.Вывести(ОбластьПолучатель);
		ТабДок.ВывестиГоризонтальныйРазделительСтраниц();	
		       
		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;

	
КонецПроцедуры
// Преобразовать индекс получателя из строки в структуру по 1 цифре
Функция ПолучитьСтрокуШрифта(Индекс)
	СтрокаИндекса = Новый Структура;
	Для Инкр = 1 По СтрДлина(Индекс) Цикл
		СтрокаИндекса.Вставить("И" + Строка(Инкр), Сред(Индекс,Инкр,1));
	КонецЦикла;
	Возврат СтрокаИндекса;
КонецФункции

// Разбить представление адреса Получателя и преобразовать в структуру СтруктураАдреса(Индекс, Адрес).
// Параметры: 
//		Адрес -  Корреспонденты.КонтактнаяИнформация.(Представление), строковая переменная
//
Функция РазбитьПредставлениеАдреса(Знач Адрес)
	СтруктураАдреса = Новый Структура();
	МассивАдрес = Новый Массив();
	МассивАдрес = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Адрес);
	Индекс = "";
	Инд = 0;
	Для Каждого Элемент Из МассивАдрес Цикл
		Элемент = СтрЗаменить(Элемент, " ", "");
		Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Элемент) 
		  И  (СтрДлина(Элемент) >= 5 И СтрДлина(Элемент) < 7) Тогда	
			Индекс = Элемент;
			МассивАдрес.Удалить(Инд);
		КонецЕсли;
		Инд = Инд + 1;
	КонецЦикла;	
	СтруктураАдреса.Вставить("Индекс",Индекс);
	Результат = "";
	Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Индекс) Тогда
		Результат = СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(МассивАдрес);
	Иначе 
		Если Найти(Адрес,"@") = 0 Тогда
			Результат = Адрес;
			КонецЕсли;
	КонецЕсли;
	СтруктураАдреса.Вставить("Адрес",Результат);
	Возврат СтруктураАдреса;
КонецФункции // РазбитьПредставлениеАдреса()

Функция ПолучитьАдресата(Знач Ссылка, Знач Номер)
	ЗапросАдресат = Новый Запрос(
		"ВЫБРАТЬ
		|	удуРеестрыОтправкиДокументы.Адресат КАК Адресат,
		|	удуРеестрыОтправкиДокументы.Документ.РегистрационныйНомер КАК РегистрационныйНомер
		|ИЗ
		|	Справочник.удуРеестрыОтправки.Документы КАК удуРеестрыОтправкиДокументы
		|ГДЕ
		|	удуРеестрыОтправкиДокументы.Ссылка В(&Ссылка)
		|	И удуРеестрыОтправкиДокументы.НомерПакета = &НомерПакета"
		);
		ЗапросАдресат.УстановитьПараметр("Ссылка",Ссылка);
		ЗапросАдресат.УстановитьПараметр("НомерПакета",Номер);
		ВыборкаКолвоАдресатов = ЗапросАдресат.Выполнить().Выбрать();
		
		ДокументСтруктура = Новый Структура;
		ДокументСтруктура.Вставить("Адресат","");
		ДокументСтруктура.Вставить("РегистрационныйНомер","");
		Если ВыборкаКолвоАдресатов.Количество() > 0 Тогда 
			Пока ВыборкаКолвоАдресатов.Следующий() Цикл
				ДокументСтруктура.Адресат = ВыборкаКолвоАдресатов.Адресат;
				
				Если ЗначениеЗаполнено(ДокументСтруктура.РегистрационныйНомер) Тогда
					ДокументСтруктура.РегистрационныйНомер = ДокументСтруктура.РегистрационныйНомер + "; ";
				КонецЕсли;
				ДокументСтруктура.РегистрационныйНомер = ДокументСтруктура.РегистрационныйНомер + ВыборкаКолвоАдресатов.РегистрационныйНомер;
			КонецЦикла;
		КонецЕсли;
		ДокументСтруктура.РегистрационныйНомер = "№ " + ДокументСтруктура.РегистрационныйНомер;
		Возврат ДокументСтруктура;
	
КонецФункции // ПолучитьАдресата
	
Функция ПолучитьАдрес(Знач Получатель)
	
	ЗапросАдрес = Новый Запрос();
	Если Получатель.ВидКорреспондента = Перечисления.ВидыКорреспондентов.ЮрЛицо Тогда
		ЗапросАдрес.Текст = 
		"ВЫБРАТЬ
		|	КорреспондентыКонтактнаяИнформация.Представление,
		|	КорреспондентыКонтактнаяИнформация.Вид,
		|	КорреспондентыКонтактнаяИнформация.ЗначенияПолей
		|ИЗ
		|	Справочник.Корреспонденты.КонтактнаяИнформация КАК КорреспондентыКонтактнаяИнформация
		|ГДЕ
		|	КорреспондентыКонтактнаяИнформация.Ссылка = &Корреспондент";
		
	ИначеЕсли Получатель.ВидКорреспондента = Перечисления.ВидыКорреспондентов.ФизЛицо Тогда
		ЗапросАдрес.Текст =
		"ВЫБРАТЬ
		|	ФизическиеЛицаКонтактнаяИнформация.Представление,
		|	ФизическиеЛицаКонтактнаяИнформация.Вид,
		|	ФизическиеЛицаКонтактнаяИнформация.ЗначенияПолей
		|ИЗ
		|	Справочник.Корреспонденты КАК Корреспонденты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица.КонтактнаяИнформация КАК ФизическиеЛицаКонтактнаяИнформация
		|		ПО Корреспонденты.ФизЛицо = ФизическиеЛицаКонтактнаяИнформация.Ссылка
		|ГДЕ
		|	Корреспонденты.Ссылка = &Корреспондент";
		
	ИначеЕсли Получатель.ВидКорреспондента = Перечисления.ВидыКорреспондентов.Родитель Тогда
		ЗапросАдрес.Текст =
		"ВЫБРАТЬ
		|	удуРодителиКонтактнаяИнформация.Представление,
		|	удуРодителиКонтактнаяИнформация.Вид,
		|	удуРодителиКонтактнаяИнформация.ЗначенияПолей
		|ИЗ
		|	Справочник.Корреспонденты КАК Корреспонденты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.удуРодители.КонтактнаяИнформация КАК удуРодителиКонтактнаяИнформация
		|		ПО Корреспонденты.удуРодитель = удуРодителиКонтактнаяИнформация.Ссылка
		|ГДЕ
		|	Корреспонденты.Ссылка = &Корреспондент";
		
	КонецЕсли;
		
	ЗапросАдрес.УстановитьПараметр("Корреспондент", Получатель);

	ВыборкаАдреса = ЗапросАдрес.Выполнить();
	ВыборкаАдреса = ВыборкаАдреса.Выбрать();
	
	ПочтовыйАдрес = "";
	ФактическийАдрес = "";
	ЮридическийАдрес = "";
	ЗначенияПолейП = "";
	ЗначенияПолейФ = "";
	ЗначенияПолейЮ = "";
	
	Пока ВыборкаАдреса.Следующий() Цикл
		Если ВыборкаАдреса.Вид = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресКорреспондента Тогда 
			ПочтовыйАдрес = ВыборкаАдреса.Представление;
			ЗначенияПолейП = ВыборкаАдреса.ЗначенияПолей;
			
		ИначеЕсли 	ВыборкаАдреса.Вид = Справочники.ВидыКонтактнойИнформации.ФактическийАдресКорреспондента 
			ИЛИ		ВыборкаАдреса.Вид = Справочники.ВидыКонтактнойИнформации.АдресМестаПроживанияРодителя Тогда
			ФактическийАдрес = ВыборкаАдреса.Представление;
			ЗначенияПолейФ = ВыборкаАдреса.ЗначенияПолей;
			
		ИначеЕсли 	ВыборкаАдреса.Вид = Справочники.ВидыКонтактнойИнформации.ЮридическийАдресКорреспондента 
			ИЛИ 	ВыборкаАдреса.Вид = Справочники.ВидыКонтактнойИнформации.АдресМестаПропискиФизическогоЛица
			ИЛИ		ВыборкаАдреса.Вид = Справочники.ВидыКонтактнойИнформации.АдресМестаПропискиРодителя Тогда 
			ЮридическийАдрес = ВыборкаАдреса.Представление;
			ЗначенияПолейЮ = ВыборкаАдреса.ЗначенияПолей;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Адрес = "";
	Значения = "";
		
	Если ЗначениеЗаполнено(ПочтовыйАдрес) Тогда
		Адрес = ПочтовыйАдрес;
		Значения = ЗначенияПолейП;
	ИначеЕсли ЗначениеЗаполнено(ФактическийАдрес) Тогда
		Адрес = ФактическийАдрес;
		Значения = ЗначенияПолейФ;
	ИначеЕсли ЗначениеЗаполнено(ЮридическийАдрес) Тогда
		Адрес = ЮридическийАдрес;
		Значения = ЗначенияПолейЮ;
	КонецЕсли;
	
	Возврат СформироватьАдрес(Адрес, Значения);
		
КонецФункции // ПолучитьАдрес()

Функция СформироватьАдрес(Знач Адрес, Знач Значения)
	Результат = Новый Структура();
		Результат.Вставить("АдресПредставление",Адрес);
		Результат.Вставить("Тип", 0);
		Если ЗначениеЗаполнено(Значения) Тогда 
			АдресПоля = Новый СписокЗначений();
			АдресПоля = УправлениеКонтактнойИнформацией.ПреобразоватьСтрокуВСписокПолей(Значения);
			Для Каждого Элемент ИЗ АдресПоля Цикл
				Если Элемент.Представление = "Регион" Тогда
					Регион = Элемент.Значение;
				ИначеЕсли Элемент.Представление = "Индекс" Тогда
					Индекс = Элемент.Значение;
				ИначеЕсли Элемент.Представление = "Город" Тогда
					Город = Элемент.Значение;
				ИначеЕсли Элемент.Представление = "Район" Тогда
					Район = Элемент.Значение;
				ИначеЕсли Элемент.Представление = "НаселенныйПункт" Тогда
					НаселенныйПункт = Элемент.Значение;
				ИначеЕсли Элемент.Представление = "Улица" Тогда
					Улица = Элемент.Значение;
				ИначеЕсли Элемент.Представление = "Дом" Тогда
					Дом = СокрЛП(Элемент.Значение);
				ИначеЕсли Элемент.Представление = "Корпус" Тогда
					Корпус = Элемент.Значение;
				ИначеЕсли Элемент.Представление = "Квартира" Тогда
					Квартира = СокрЛП(Элемент.Значение);
				ИначеЕсли Элемент.Представление = "ТипДома" Тогда
					ТипДома = Элемент.Значение;
				ИначеЕсли Элемент.Представление = "ТипКорпуса" Тогда
					ТипКорпуса = Элемент.Значение;
				ИначеЕсли Элемент.Представление = "ТипКвартиры" Тогда
					ТипКвартиры = Элемент.Значение;
				КонецЕсли;
			КонецЦикла;
			Адрес = "";
			Если ЗначениеЗаполнено(Улица) Тогда
			//	Адрес = Адрес + "ул. " + Улица + ", ";
				Адрес = Адрес + Улица + ", ";
			КонецЕсли;
			Если ЗначениеЗаполнено(Дом) Тогда
				сокр = "";
				Если СокрЛП(ТипДома) = "владение" Тогда
					сокр = "владение ";
				Иначе 
					сокр = "д. ";
				КонецЕсли;
				Адрес = Адрес + сокр + Дом + ", ";
			КонецЕсли;
			Если ЗначениеЗаполнено(Корпус) Тогда
				сокр = "";
				Если ТипКорпуса = "строение" Тогда
					сокр = "стр. ";
				Иначе 
					сокр = "к. ";
				КонецЕсли;
				Адрес = Адрес + сокр + Корпус + ", ";
			КонецЕсли;
			Если ЗначениеЗаполнено(Квартира) Тогда
				сокр = "";
				Если СокрЛП(ТипКвартиры) = "квартира" Тогда
					сокр = "кв. ";
				Иначе 
					сокр = "оф. ";
				КонецЕсли;
				Адрес = Адрес + сокр + Квартира + ", ";
			КонецЕсли;
			
			Если ЗначениеЗаполнено(НаселенныйПункт) Тогда
				Адрес = Адрес + НаселенныйПункт + ", ";
			КонецЕсли;
			Если ЗначениеЗаполнено(Район) Тогда
				Адрес = Адрес + Район + ", ";
			КонецЕсли;
			Если ЗначениеЗаполнено(Город) Тогда
				Адрес = Адрес + Город + ", ";
			КонецЕсли;
			Если ЗначениеЗаполнено(Регион) Тогда
				Адрес = Адрес + Регион + ", ";
			КонецЕсли;
			Адрес = Лев(Адрес,СтрДлина(Адрес) - 2);
			Если ЗначениеЗаполнено(Адрес) Тогда
				Результат.Вставить("Адрес",Адрес);
				Результат.Тип = 1;
			КонецЕсли;
			Результат.Вставить("Индекс",Индекс);
		КонецЕсли;
		Возврат Результат;
КонецФункции // СформироватьАдрес()
