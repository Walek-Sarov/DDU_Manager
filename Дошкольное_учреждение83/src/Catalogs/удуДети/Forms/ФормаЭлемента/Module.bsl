&НаСервере
Функция ПолучитьФормуЭлементаСправочника(ТипПередаваемогоЭлемента)
	Если ТипПередаваемогоЭлемента = ТипЗнч(Справочники.удуДети.ПустаяСсылка()) Тогда
		Возврат "Справочник.удуДети.ФормаОбъекта";
	ИначеЕсли ТипПередаваемогоЭлемента = ТипЗнч(Справочники.удуРодители.ПустаяСсылка()) Тогда
		Возврат "Справочник.удуРодители.ФормаОбъекта";
	Иначе
		Возврат "";
	КонецЕсли;		
КонецФункции

Функция ПолучитьФильтрИзображений()
	Возврат "Все картинки (*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf)|*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf|" 
	      + "Формат bmp (*.bmp;*.dib;*.rle)|*.bmp;*.dib;*.rle|"
	      + "Формат jpeg (*.jpg;*.jpeg)|*.jpg;*.jpeg|"
	      + "Формат tiff (*.tif)|*.tif|"
	      + "Формат gif (*.gif)|*.gif|"
	      + "Формат png (*.png)|*.png|"
	      + "Формат icon (*.ico)|*.ico|"
	      + "Формат метафайл (*.wmf;*.emf)|*.wmf;*.emf|";	
КонецФункции
	  
	  
&НаСервере
// Процедура извлекает данные объекта из временного хранилища, 
// производит модификацию элемента справочника и записывает его.
// 
// Параметры: 
//  АдресВременногоХранилища – Строка – адрес временного хранилища. 
// 
// Возвращаемое значение: 
//  Нет.
Процедура ПоместитьФайлОбъектаНаСервере(АдресВременногоХранилища)
	ЭлементСправочника = РеквизитФормыВЗначение("Объект");
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	ЭлементСправочника.ФотографияРебенка = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных());
	ЭлементСправочника.Записать();
	Модифицированность = Ложь;
	УдалитьИзВременногоХранилища(АдресВременногоХранилища);
	ЗначениеВРеквизитФормы(ЭлементСправочника, "Объект");	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Объект.СтатусРебенка) Тогда
		Объект.СтатусРебенка = Перечисления.удуСтатусРебенкаВДОУ.Кандидат;
	КонецЕсли;
	
	РеквизитФотографияРебенка = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "ФотографияРебенка");
	
	// Сведения о составе семьи
	ЭлементОтбораПоРебенку = РеквизитСведенияОСемье.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораПоРебенку.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораПоРебенку.Использование = Истина;
	ЭлементОтбораПоРебенку.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ребенок");
	ЭлементОтбораПоРебенку.ПравоеЗначение = Объект.Ссылка;
	ЭлементОтбораПоРебенку.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	// Сведения о посещении МДОУ
	ЭлементОтбораПоРебенку = РеквизитСведенияОПосещенииМДОУ.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораПоРебенку.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораПоРебенку.Использование = Истина;
	ЭлементОтбораПоРебенку.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ребенок");
	ЭлементОтбораПоРебенку.ПравоеЗначение = Объект.Ссылка;
	ЭлементОтбораПоРебенку.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	// Сведения о физическом состоянии
	ЭлементОтбораПоРебенку = РеквизитСведенияОФизическомСостоянии.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораПоРебенку.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораПоРебенку.Использование = Истина;
	ЭлементОтбораПоРебенку.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ребенок");
	ЭлементОтбораПоРебенку.ПравоеЗначение = Объект.Ссылка;
	ЭлементОтбораПоРебенку.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	// Сведения о посещении предыдущих МДОУ
	ЭлементОтбораПоРебенку = РеквизитСведенияОПредыдущихДОУ.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораПоРебенку.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораПоРебенку.Использование = Истина;
	ЭлементОтбораПоРебенку.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ребенок");
	ЭлементОтбораПоРебенку.ПравоеЗначение = Объект.Ссылка;
	ЭлементОтбораПоРебенку.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;	
	
	// Сведения о документах пропуска занятий
	ЭлементОтбораПоРебенку = РеквизитДокументыСправки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораПоРебенку.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораПоРебенку.Использование = Истина;
	ЭлементОтбораПоРебенку.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
	ЭлементОтбораПоРебенку.ПравоеЗначение = Объект.Ссылка;
	ЭлементОтбораПоРебенку.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;	
	
	// Сведения о квитанциях об оплате посещения ДОУ
	ЭлементОтбораПоРебенку = РеквизитКвитанцииОбОплате.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораПоРебенку.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораПоРебенку.Использование = Истина;
	ЭлементОтбораПоРебенку.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ребенок");
	ЭлементОтбораПоРебенку.ПравоеЗначение = Объект.Ссылка;
	ЭлементОтбораПоРебенку.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;		
	
	ЭтаФорма.Элементы.ГруппаПосещениеМДОУ.Доступность = ЗначениеЗаполнено(Объект.Ссылка);
	ЭтаФорма.Элементы.ГруппаРодственники.Доступность = ЗначениеЗаполнено(Объект.Ссылка);
	ЭтаФорма.Элементы.ГруппаДокументыСправки.Доступность = ЗначениеЗаполнено(Объект.Ссылка);
	
	// Обработчик подсистемы "Контактная информация"
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтаФорма, Объект, "ГруппаКонтактнаяИнформация");	
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)	
	// Обработчик подсистемы "Контактная информация"
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);	
КонецПроцедуры

&НаКлиенте
Процедура ФамилияПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	Объект.Наименование = Объект.Фамилия + " " + Объект.Имя + " " + Объект.Отчество;
КонецПроцедуры

&НаКлиенте
Процедура ИмяПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	Объект.Наименование = Объект.Фамилия + " " + Объект.Имя + " " + Объект.Отчество;
КонецПроцедуры

&НаКлиенте
Процедура ОтчествоПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	Объект.Наименование = Объект.Фамилия + " " + Объект.Имя + " " + Объект.Отчество;
КонецПроцедуры

&НаКлиенте
Процедура ПолеФотографияРебенкаНажатие(Элемент, СтандартнаяОбработка)
	// Вставить содержимое обработчика.	
	Перем ИмяФайлаКартинки;
	Перем АдресВременногоХранилища;
	
	СтандартнаяОбработка = Ложь;
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Заголовок = "Выберите файл-фотографию ребенка";		
	ДиалогВыбораФайла.Фильтр = ПолучитьФильтрИзображений();
	Если ДиалогВыбораФайла.Выбрать() Тогда
		ИмяФайлаКартинки = ДиалогВыбораФайла.ПолноеИмяФайла;		
	КонецЕсли;	
	
	Если ПоместитьФайл(АдресВременногоХранилища, ИмяФайлаКартинки, ИмяФайлаКартинки, Ложь) Тогда		
		ПоместитьФайлОбъектаНаСервере(АдресВременногоХранилища);		
		РеквизитФотографияРебенка = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "ФотографияРебенка");		
	КонецЕсли;		
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// Сведения о составе семьи
	Для Каждого СтрокаЭлемент Из РеквизитСведенияОСемье.Отбор.Элементы Цикл
		Если Строка(СтрокаЭлемент.ЛевоеЗначение) = "Ребенок" Тогда
			СтрокаЭлемент.ПравоеЗначение = Объект.Ссылка;
		КонецЕсли;
	КонецЦикла;
	
	// Сведения о посещении МДОУ
	Для Каждого СтрокаЭлемент Из РеквизитСведенияОПосещенииМДОУ.Отбор.Элементы Цикл
		Если Строка(СтрокаЭлемент.ЛевоеЗначение) = "Ребенок" Тогда
			СтрокаЭлемент.ПравоеЗначение = Объект.Ссылка;
		КонецЕсли;
	КонецЦикла;
	
	// Сведения о физическом состоянии
	Для Каждого СтрокаЭлемент Из РеквизитСведенияОФизическомСостоянии.Отбор.Элементы Цикл
		Если Строка(СтрокаЭлемент.ЛевоеЗначение) = "Ребенок" Тогда
			СтрокаЭлемент.ПравоеЗначение = Объект.Ссылка;
		КонецЕсли;
	КонецЦикла;	
	
	// Сведения о предыдущем ДОУ
	Для Каждого СтрокаЭлемент Из РеквизитСведенияОПредыдущихДОУ.Отбор.Элементы Цикл
		Если Строка(СтрокаЭлемент.ЛевоеЗначение) = "Ребенок" Тогда
			СтрокаЭлемент.ПравоеЗначение = Объект.Ссылка;
		КонецЕсли;
	КонецЦикла;	
	
	
	ЭтаФорма.Элементы.ГруппаПосещениеМДОУ.Доступность = ЗначениеЗаполнено(Объект.Ссылка);
	ЭтаФорма.Элементы.ГруппаРодственники.Доступность = ЗначениеЗаполнено(Объект.Ссылка);	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитСведенияОСемьеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	Если Поле.Имя = "ЧленСемьи" Тогда
		СтандартнаяОбработка = Ложь;
		ПередаваемыеПараметры = Новый Структура("Ключ", Элемент.ТекущиеДанные.ЧленСемьи);
		ИмяОткрываемойФормы = ПолучитьФормуЭлементаСправочника(ТипЗнч(Элемент.ТекущиеДанные.ЧленСемьи));
		Если ИмяОткрываемойФормы <> "" Тогда 
			ОткрытьФормуМодально(ИмяОткрываемойФормы, ПередаваемыеПараметры, ЭтаФорма);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СведенияОПосещенииМДОУВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	Если Поле.Имя = "Группа" Тогда
		СтандартнаяОбработка = Ложь;
		ПередаваемыеПараметры = Новый Структура("Ключ", Элемент.ТекущиеДанные.Группа);
		ОткрытьФормуМодально("Справочник.удуГруппыУчреждения.Форма.ФормаЭлемента", ПередаваемыеПараметры, ЭтаФорма);
	ИначеЕсли Поле.Имя = "ОснованиеЗачисления" Тогда
		СтандартнаяОбработка = Ложь;
		ПередаваемыеПараметры = Новый Структура("Ключ", Элемент.ТекущиеДанные.ОснованиеЗачисления);
		ОткрытьФормуМодально("Документ.удуДоговорОЗачисленииРебенка.Форма.ФормаДокумента", ПередаваемыеПараметры, ЭтаФорма);
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура РеквизитКвитанцииОбОплатеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	// Вставить содержимое обработчика.
	Отказ = Истина;
	
	ФормаНовойКвитанции = ПолучитьФорму("Документ.удуКвитанцияОбОплатеПосещенияДОУ.Форма.ФормаДокумента",,ЭтаФорма);	
	ФормаНовойКвитанции.Объект.Ребенок = Объект.Ссылка;		
	ФормаНовойКвитанции.Объект.Группа = ФормаНовойКвитанции.ПолучитьТекущуюГруппуРебенка(Объект.Ссылка, ФормаНовойКвитанции.Объект.Дата);
	ФормаНовойКвитанции.ОбновитьСведенияОбОплатеДоговора();
	ФормаНовойКвитанции.ОбновитьСведенияОСоставеГруппы();
	ФормаНовойКвитанции.Открыть();		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "КОНТАКТНАЯ ИНФОРМАЦИЯ"

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)	
	
	УправлениеКонтактнойИнформациейКлиент.ПредставлениеПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.ПредставлениеНачалоВыбора(ЭтаФорма, Элемент, Модифицированность, СтандартнаяОбработка);
	
КонецПроцедуры
