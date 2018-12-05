
&НаКлиенте
Процедура ОбновитьВходящие(Команда)
	
	ОбновитьСписокСообщений();
	
КонецПроцедуры

// Функция оранизует получения пароля для учетной записи, в которой он не задан
//
&НаКлиенте
Функция ЗапросПароляДоступаКПочтовомуСерверу(УчетнаяЗапись)
	
	ПараметрУчетнаяЗапись = Новый Структура("УчетнаяЗапись", УчетнаяЗапись);
	Пароль = ОткрытьФормуМодально("ОбщаяФорма.ПодтверждениеПароляУчетнойЗаписи",
	                                 ПараметрУчетнаяЗапись);
	Если ТипЗнч(Пароль) = Тип("Строка") Тогда
		Возврат Пароль;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Функция обрабатывает загрузку почтовых сообщений с сервера.
// В том числе обработка ошибок.
//
&НаСервере
Функция ЗагрузитьВходящиеСообщения(знач ПарольПараметр = Неопределено)
	
	ПараметрыЗагрузки = Новый Структура;
	
	ПараметрыЗагрузки.Вставить("Колоноки", "ИмяОтправителя, Вложения, Тема, ДатаОтправления, ОбратныйАдрес");
	ПараметрыЗагрузки.Вставить("Пароль", ПарольПараметр);
	
	ТаблицаВходящихСообщений = ЭлектроннаяПочта.ЗагрузитьПочтовыеСообщения(УчетнаяЗаписьВходящие, ПараметрыЗагрузки);
	
	ВходящиеСообщения.Очистить();
	
	Для Каждого ЭлементВходящееСообщение Из ТаблицаВходящихСообщений Цикл
		
		НоваяСтрока = ВходящиеСообщения.Добавить();
		НоваяСтрока.Отправитель     = ЭлементВходящееСообщение.Отправитель;
		НоваяСтрока.ОбратныйАдрес   = ЭлементВходящееСообщение.ОбратныйАдрес;
		НоваяСтрока.Тема            = ЭлементВходящееСообщение.Тема;
		НоваяСтрока.ДатаОтправления = ЭлементВходящееСообщение.ДатаОтправления;
		НоваяСтрока.ДатаПолучения   = ЭлементВходящееСообщение.ДатаПолучения;
		НоваяСтрока.Идентификатор   = ЭлементВходящееСообщение.Идентификатор[0];
		НоваяСтрока.Размер          = ЭлементВходящееСообщение.Размер / 1024;
		Если НоваяСтрока.Размер = 0 Тогда
			НоваяСтрока.Размер = 1;
		КонецЕсли;	
		
		Для каждого Текст из ЭлементВходящееСообщение.Тексты Цикл
			
			ТипТекста = Текст.Получить("ТипТекста");
			Если ТипТекста = Строка( ТипТекстаПочтовогоСообщения.ПростойТекст) Тогда
				НоваяСтрока.Содержание = НоваяСтрока.Содержание + Текст.Получить("Текст");
			КонецЕсли;
			
		КонецЦикла;	
		
		Если ЭлементВходящееСообщение.Вложения.Количество() > 0 Тогда
			НоваяСтрока.Вложение = Истина;
		Иначе
			НоваяСтрока.Вложение = Ложь;
		КонецЕсли;
		
		Для каждого Вложение Из ЭлементВходящееСообщение.Вложения Цикл
			НовоеВложение = НоваяСтрока.Вложения.Добавить();
			НовоеВложение.Имя = Вложение.Ключ;
			НовоеВложение.НавигационнаяСсылка = ПоместитьВоВременноеХранилище(Вложение.Значение, ЭтаФорма.УникальныйИдентификатор);
			НовоеВложение.Размер = Вложение.Значение.Размер() / 1024;
			Если НовоеВложение.Размер = 0 Тогда
				НовоеВложение.Размер = 1;
			КонецЕсли	
		КонецЦикла;
		
	КонецЦикла;
	
	РезСтрук = Новый Структура("Статус", Истина);
	
	Возврат РезСтрук;
	
КонецФункции

// Проверяет задан пароль у учетной записи или нет
// Параметры
// УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты
// Возвращаемое значение
// Истина - пароль задан
// Ложь   - пароль не задан
//
&НаСервере
Функция ПарольЗадан(УчетнаяЗапись)
	
	Если ЗначениеЗаполнено(УчетнаяЗапись.Пароль) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли
	
КонецФункции

&НаСервере
Функция ПолучитьВерсииФайлов(ВладелецФайла)
	
	МассивДанныхФВерсийФайлов = Новый Массив();
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	Файлы.ТекущаяВерсия
	               |ИЗ
	               |	Справочник.Файлы КАК Файлы
	               |ГДЕ
	               |	Файлы.ВладелецФайла = &ВладелецФайла";
	Запрос.УстановитьПараметр( "ВладелецФайла", ВладелецФайла );
	
	Данные = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Строка из Данные Цикл
		МассивДанныхФВерсийФайлов.Добавить(Строка.ТекущаяВерсия);
	КонецЦикла;	
	
	Возврат МассивДанныхФВерсийФайлов;
	
КонецФункции	

&НаКлиенте
Процедура ИзвлечьТекстыИзФайлов(ВладелецФайла)
	
#Если Не ВебКлиент Тогда
	МассивДанныхВерсийФайлов = ПолучитьВерсииФайлов(ВладелецФайла);
	
	Для каждого Версия Из МассивДанныхВерсийФайлов Цикл
		
		СтруктураВозврата = РаботаСФайлами.ПолучитьДанныеФайлаИНавигационнуюСсылкуВерсии(, Версия, УникальныйИдентификатор);
		ДанныеФайла = СтруктураВозврата.ДанныеФайла;
		АдресФайла = СтруктураВозврата.НавигационнаяСсылкаВерсии;
		
		Если ДанныеФайла.СтатусИзвлеченияТекста <> "НеИзвлечен" Тогда
			
			// Для варианта с хранением файлов на диске (на сервере) удаляем Файл из временного хранилища после получения.
			Если ЭтоАдресВременногоХранилища(АдресФайла) Тогда
				УдалитьИзВременногоХранилища(АдресФайла);
			КонецЕсли;
			
		КонецЕсли;	
		
		Расширение = ДанныеФайла.Расширение;
		
		ФайловыеФункцииКлиент.ИзвлечьТекстВерсии(Версия, АдресФайла, Расширение, УникальныйИдентификатор);
		
	КонецЦикла;	
#КонецЕсли

КонецПроцедуры	

&НаКлиенте
Процедура ВходящийДокумент(Команда)
	
	Если Элементы.ВходящиеСообщения.ТекущаяСтрока <> Неопределено Тогда
		
		Форма = ПолучитьФорму("Обработка.ЗагрузкаЭлектроннойПочты.Форма.ФормаДобавленияВходящегоДокумента", );
		Если Форма.ОткрытьМодально() <> КодВозвратаДиалога.ОК Тогда 
			Возврат;
		КонецЕсли;	
		
		Состояние(НСтр("ru = 'Идет регистрация входящего документа. Пожалуйста, подождите...'"));
		ВходящийДокумент = СоздатьВходящийДокумент(
			Элементы.ВходящиеСообщения.ТекущаяСтрока,
			Форма.Отправитель,
			Форма.ГрифДоступа,
			Форма.ВидДокумента,
			Форма.Организация);
			
		Если Не ВходящийДокумент.Пустая() Тогда
			УдалитьТекущееСообщение();
			ИзвлечьТекстыИзФайлов(ВходящийДокумент);
			ОткрытьЗначение(ВходящийДокумент);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьВходящийДокумент(НомерПисьма, Корреспондент, ГрифДоступа, ВидДокумента, Организация)
	
	Письмо = ВходящиеСообщения.НайтиПоИдентификатору(НомерПисьма);

	// Создаем входящий документ
	ВходящийДокумент = Справочники.ВходящиеДокументы.СоздатьЭлемент();
	ВходящийДокумент.Заголовок = Письмо.Тема;
	ВходящийДокумент.Содержание = Письмо.Содержание;
	ВходящийДокумент.ИсходящаяДата = Письмо.ДатаОтправления;
	ВходящийДокумент.ДатаСоздания = Письмо.ДатаПолучения;
	ВходящийДокумент.Отправитель = Корреспондент;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГрифыДоступаКВходящимИИсходящимДокументам") Тогда
		ВходящийДокумент.ГрифДоступа = ГрифДоступа;
	КонецЕсли;	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВидыВходящихДокументов") Тогда
		ВходящийДокумент.ВидДокумента = ВидДокумента;
	КонецЕсли;	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда
		ВходящийДокумент.Организация = Организация;
	КонецЕсли;	
	
	НачатьТранзакцию();
	Попытка
		ВходящийДокумент.Записать();
		
		Делопроизводство.ЗаписатьСостояниеДокумента(
			ВходящийДокумент.Ссылка, 
			ТекущаяДата(), 
			Перечисления.СостоянияДокументов.НаРегистрации, 
			ОбщегоНазначения.ТекущийПользователь());
		
		// Сохраняем все файлы на диске
		Для каждого Вложение Из Письмо.Вложения Цикл
			
			ВрФайл = Новый Файл(Вложение.Имя);
			ИмяФайла = ВрФайл.ИмяБезРасширения;
			РасширениеФайла = РасширениеБезТочки(ВрФайл.Расширение);
			
			// Создадим карточку Файла в БД
			НовыйФайл = РаботаСФайлами.СоздатьФайлСВерсией(
				ВходящийДокумент.Ссылка,
				ИмяФайла,
				РасширениеФайла,
				ТекущаяДата(),
				УниверсальноеВремя(ТекущаяДата()),
				Вложение.Размер,
				Вложение.НавигационнаяСсылка,
				"",
				Ложь); // это не веб клиент				
				
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
	     ОтменитьТранзакцию();
	     ВызватьИсключение;
	КонецПопытки;
	
	Возврат ВходящийДокумент.Ссылка;
	
КонецФункции

&НаСервере
Функция РасширениеБезТочки(стрРасширение)
	
	Расширение = НРег(СокрЛП(стрРасширение));
	Если Сред(Расширение, 1, 1) = "." Тогда
		Расширение = Сред(Расширение, 2);
	КонецЕсли;
	Возврат Расширение;
	
КонецФункции // РасширениеБезТочки()

&НаКлиенте
Процедура УдалитьТекущееСообщение()
	
	Если Элементы.ВходящиеСообщения.ТекущаяСтрока <> Неопределено Тогда
		Строки = Новый Массив();
		Строки.Добавить(Элементы.ВходящиеСообщения.ТекущаяСтрока);
		УдалитьСообщенияСервер(Строки);
	КонецЕсли;

КонецПроцедуры	

&НаКлиенте
Процедура УдалитьСообщение(Команда)
	
	Строки = Новый Массив();
	Для каждого Строка из Элементы.ВходящиеСообщения.ВыделенныеСтроки Цикл
		Строки.Добавить(Строка);
	КонецЦикла;	
	
	Если Строки.Количество() > 0 Тогда
		Состояние(НСтр("ru = 'Идет удаление отмеченных сообщений. Пожалуйста, подождите...'"));
		УдалитьСообщенияСервер(Строки);
		Состояние(НСтр("ru = 'Удаление отмеченных сообщений завершено.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСообщенияСервер(ИдентификаторыСтрок)
	
	ИдентификаторыСообщений = Новый Массив();
	Для каждого ИдентификаторСтроки Из ИдентификаторыСтрок Цикл
		Ид = ВходящиеСообщения.НайтиПоИдентификатору(ИдентификаторСтроки).Идентификатор;
		ИдентификаторыСообщений.Добавить(Ид);	
	КонецЦикла;	
	
	Профиль = ЭлектроннаяПочта.СформироватьИнтернетПрофиль(УчетнаяЗаписьВходящие);
	
	Соединение = Новый ИнтернетПочта;
	
	Соединение.Подключиться(Профиль);
	Соединение.УдалитьСообщения(ИдентификаторыСообщений);
	Соединение.Отключиться();

	Для каждого ИдентификаторСтроки Из ИдентификаторыСтрок Цикл
		Ид = ВходящиеСообщения.НайтиПоИдентификатору(ИдентификаторСтроки);
		ВходящиеСообщения.Удалить(Ид);
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура УчетнаяЗаписьВходящиеПриИзменении(Элемент)
	
	ОбновитьСписокСообщений();
	
КонецПроцедуры

&НаСервере
Функция ПроверитьУчетнуюЗапись(СообщениеОбОшибке)
	
	Если УчетнаяЗаписьВходящие.ОставлятьКопииСообщенийНаСервере	<> Истина Тогда 
		СообщениеОбОшибке = НСтр("ru = 'В учетной записи не установлен флажок ""Оставлять копии сообщений на сервере"".'");
		Возврат Ложь;
	КонецЕсли;
	
	Если УчетнаяЗаписьВходящие.ИспользоватьДляПолучения	<> Истина Тогда
		СообщениеОбОшибке = НСтр("ru = 'В учетной записи не установлен флажок ""Использовать для получения"".'");
		Возврат Ложь;
	КонецЕсли;	
	
	Возврат Истина;
	
КонецФункции	

&НаКлиенте
Процедура ОбновитьСписокСообщений()
	
	ВходящиеСообщения.Очистить();
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(УчетнаяЗаписьВходящие) Тогда	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбрана учетная запись.'"),,,"УчетнаяЗаписьВходящие");
		Возврат;
	КонецЕсли;
	
	СообщениеОбОшибке = "";
	Если Не ПроверитьУчетнуюЗапись(СообщениеОбОшибке) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,,"УчетнаяЗаписьВходящие");
		Возврат;
	КонецЕсли;	
	
	Состояние(НСтр("ru = 'Идет загрузка электронной почты. Пожалуйста, подождите...'"));
	
	Если ПарольЗадан(УчетнаяЗаписьВходящие) Тогда
		ПарольПараметр = Неопределено;
	Иначе
		ПарольПараметр = ЗапросПароляДоступаКПочтовомуСерверу(УчетнаяЗаписьВходящие);
		Если ПарольПараметр = Неопределено Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		ОбновитьСписокСообщенийСервер(ПарольПараметр);
	Исключение
		Предупреждение(ОбщегоНазначенияКлиентСервер.ПолучитьПредставлениеОписанияОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Состояние(НСтр("ru = 'Загрузка электронной почты завершена.'"));
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокСообщенийСервер(ПарольПараметр)
	
	Если ЗначениеЗаполнено(УчетнаяЗаписьВходящие) Тогда
		СообщениеОбОшибке = "";
		Если Не ПроверитьУчетнуюЗапись(СообщениеОбОшибке) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,,"УчетнаяЗаписьВходящие");
			Возврат;
		КонецЕсли;
		
		Результат = ЗагрузитьВходящиеСообщения(ПарольПараметр);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Учетная запись для получения входящих не заполнена'"),,,"УчетнаяЗаписьВходящие");
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	УчетныеЗаписиЭлектроннойПочты.Ссылка
	               |ИЗ
	               |	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	               |ГДЕ
	               |	УчетныеЗаписиЭлектроннойПочты.ОтветственныйЗаОбработкуПисем = &ТекущийПользователь";
	Запрос.УстановитьПараметр("ТекущийПользователь", ПараметрыСеанса.ТекущийПользователь);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		УчетнаяЗаписьВходящие = Выборка.Ссылка;
		
		Попытка
			Если ПарольЗадан(УчетнаяЗаписьВходящие) Тогда
				ОбновитьСписокСообщенийСервер(Неопределено);
			КонецЕсли	
		Исключение
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнутреннийДокумент(Команда)
	
	Если Элементы.ВходящиеСообщения.ТекущаяСтрока <> Неопределено Тогда
		
		Форма = ПолучитьФорму("Обработка.ЗагрузкаЭлектроннойПочты.Форма.ФормаДобавленияВнутреннегоДокумента", );
		Если Форма.ОткрытьМодально() <> КодВозвратаДиалога.ОК Тогда 
			Возврат;
		КонецЕсли;	
		
		Состояние(НСтр("ru = 'Идет регистрация внутреннего документа. Пожалуйста, подождите...'"));
		ВнутреннийДокумент = СоздатьВнутреннийДокумент(
			Элементы.ВходящиеСообщения.ТекущаяСтрока,
			Форма.Папка,
			Форма.ВидДокумента,
			Форма.Организация);
			
		Если Не ВнутреннийДокумент.Пустая() Тогда
			УдалитьТекущееСообщение();
			ИзвлечьТекстыИзФайлов(ВнутреннийДокумент);
			ОткрытьЗначение(ВнутреннийДокумент);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьВнутреннийДокумент(НомерПисьма, Папка, ВидДокумента, Организация)
	
	Письмо = ВходящиеСообщения.НайтиПоИдентификатору(НомерПисьма);

	// Создаем нутренний документ
	ВнутреннийДокумент = Справочники.ВнутренниеДокументы.СоздатьЭлемент();
	ВнутреннийДокумент.Заголовок = Письмо.Тема;
	ВнутреннийДокумент.Содержание = Письмо.Содержание;
	ВнутреннийДокумент.ДатаСоздания = Письмо.ДатаПолучения;
	ВнутреннийДокумент.Папка = Папка;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВидыВнутреннихДокументов") Тогда
		ВнутреннийДокумент.ВидДокумента = ВидДокумента;
	КонецЕсли;	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда
		ВнутреннийДокумент.Организация = Организация;
	КонецЕсли;	
	
	НачатьТранзакцию();
	Попытка
		ВнутреннийДокумент.Записать();
		Делопроизводство.ЗаписатьСостояниеДокумента(
			ВнутреннийДокумент.Ссылка, 
			ТекущаяДата(), 
			Перечисления.СостоянияДокументов.Проект, 
			ОбщегоНазначения.ТекущийПользователь());
		
		// Сохраняем все файлы на диске
		Для каждого Вложение Из Письмо.Вложения Цикл
			
			ВрФайл = Новый Файл(Вложение.Имя);
			ИмяФайла = ВрФайл.ИмяБезРасширения;
			РасширениеФайла = РасширениеБезТочки(ВрФайл.Расширение);
			
			// Создадим карточку Файла в БД
			НовыйФайл = РаботаСФайлами.СоздатьФайлСВерсией(
				ВнутреннийДокумент.Ссылка,
				ИмяФайла,
				РасширениеФайла,
				ТекущаяДата(),
				УниверсальноеВремя(ТекущаяДата()),
				Вложение.Размер,
				Вложение.НавигационнаяСсылка,
				"",
				Ложь); // это не веб клиент				
				
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
	     ОтменитьТранзакцию();
	     ВызватьИсключение;
	КонецПопытки;
	
	Возврат ВнутреннийДокумент.Ссылка;
	
КонецФункции
