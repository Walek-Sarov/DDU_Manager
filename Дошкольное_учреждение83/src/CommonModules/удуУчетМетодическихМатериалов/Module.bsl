
// Функция позволяет проверить доступность учетной единицы к выдаче по ее инвентарному номеру.
//
// Параметры:
//  ИнНомер		- инвентарный номер учетной единицы
//
// Возвращаемое значение:
// Истина		- если единица доступна к выдаче
// Ложь			- в противном случае
// 
Функция УчетЕдДоступнаКВыдаче(Знач ИнНомер) Экспорт
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	удуНедоступныеМетодическиеМатериалы.УчетнаяЕдиница
	|ИЗ
	|	РегистрСведений.удуНедоступныеМетодическиеМатериалы КАК удуНедоступныеМетодическиеМатериалы
	|ГДЕ
	|	удуНедоступныеМетодическиеМатериалы.ИнвентарныйНомер = &ИнвентарныйНомер"
	);
	Запрос.УстановитьПараметр("ИнвентарныйНомер",ИнНомер);
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции // УчетЕдДоступнаКВыдаче

// Функция формирует текстовое представление методического материала
//
// Параметры:
//  УчетЕд		- учетная единица
//
// Возвращаемое значение:
// Строка		- библиографическое представление единицы
// 
Функция СформироватьПредставлениеМетодМатериала(УчетЕд) Экспорт
	
	ПредставлениеУчетЕд = "";
	ОбъектУчетЕд = УчетЕд.ПолучитьОбъект();
	Если ЗначениеЗаполнено(ОбъектУчетЕд.АвторПредставление) Тогда
		ПредставлениеУчетЕд = ПредставлениеУчетЕд + ОбъектУчетЕд.АвторПредставление + Символы.ПС;
	КонецЕсли;
	ПредставлениеУчетЕд = ПредставлениеУчетЕд +  ОбъектУчетЕд.Наименование;

	Возврат ПредставлениеУчетЕд;	
КонецФункции // СформироватьПредставлениеМетодМатериала()
 
 //////////////////////////////////////////////////////////////////////////////
 // ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ФОРМИРОВАНИЯ БИБЛИОГРАФИЧЕСКОГО ПРЕДСТАВЛЕНИЯ
 //
 
 Процедура ПоставитьТочкуВКонцеЗаписи(ПредставлениеУчетЕд)
 	ПредставлениеУчетЕд1 = СокрЛП(ПредставлениеУчетЕд);
	Если СтрЗаменить(ПредставлениеУчетЕд1,Лев(ПредставлениеУчетЕд1,СтрДлина(ПредставлениеУчетЕд1) - 1),"") <> "." Тогда 
		ПредставлениеУчетЕд = СокрЛП(ПредставлениеУчетЕд) + ".";
	КонецЕсли;
 КонецПроцедуры // ПоставитьТочкуВКонцеЗаписи()
 
 // Сформировать часть представления по списку авторов (после /) на оcнове массива СписокАвторов.
Функция СформироватьЧастьПредставленияАвторы(ПредставлениеУчетЕд, СписокАвторов)
	Если Не СписокАвторов = Неопределено Тогда
			// Список авторов полностью
			
			Для Инкр = 0 По СписокАвторов.Количество() - 1 Цикл
				// Если еще не выведен
				Если СписокАвторов[Инкр].Печатать Тогда
										
					Если ЗначениеЗаполнено(СписокАвторов[Инкр].Роль) Тогда
						Если Инкр <> 0 Тогда
							ПредставлениеУчетЕд = СокрП(ПредставлениеУчетЕд) + "; ";
						КонецЕсли;
						ПредставлениеУчетЕд = ПредставлениеУчетЕд + СписокАвторов[Инкр].Роль.Сокращение;
						// Если роль = "содерж авт", то надо поставить двоеточие
						ПредставлениеУчетЕд = ПредставлениеУчетЕд + " " + СписокАвторов[Инкр].Автор.Инициалы + " " + СписокАвторов[Инкр].Автор.Фамилия;	
					Иначе
						Если Инкр <> 0 Тогда
							ПредставлениеУчетЕд = ПредставлениеУчетЕд + ", ";
						КонецЕсли;
						ПредставлениеУчетЕд = ПредставлениеУчетЕд + СписокАвторов[Инкр].Автор.Инициалы + " " + СписокАвторов[Инкр].Автор.Фамилия;
					КонецЕсли;
					СписокАвторов[Инкр].Печатать = Ложь;
					// Вывести всех авторов с текущей ролью и исключить их из дальнейшей печати
					Для Номер = Инкр + 1 По СписокАвторов.Количество() - 1 Цикл
						Если ЗначениеЗаполнено(СписокАвторов[Номер].Роль) И  СписокАвторов[Инкр].Роль = СписокАвторов[Номер].Роль Тогда
							ПредставлениеУчетЕд = ПредставлениеУчетЕд + ", " + СписокАвторов[Номер].Автор.Инициалы + " " + СписокАвторов[Номер].Автор.Фамилия;	
							СписокАвторов[Номер].Печатать = Ложь;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;

КонецФункции // СформироватьЧастьПредставленияАвторы(СписокАвторов)

Процедура СформироватьЧастьГодОбъем(ПредставлениеУчетЕд,ОбъектУчетЕд)
	
	Если ЗначениеЗаполнено(ОбъектУчетЕд.Год) И Число(ОбъектУчетЕд.Год) > 0 Тогда
		ПредставлениеУчетЕд = ПредставлениеУчетЕд + ", " + ОбъектУчетЕд.Год;
	КонецЕсли;
	
	// Количество страниц и иллюстрации
	Если ЗначениеЗаполнено(ОбъектУчетЕд.КоличествоСтраниц) Тогда
		ПредставлениеУчетЕд = ПредставлениеУчетЕд + ". - " + ОбъектУчетЕд.КоличествоСтраниц + " c.";
		Если ОбъектУчетЕд.Иллюстрации Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + ": ил.";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры // СформироватьЧастьГодОбъем()

Процедура ЗаполнитьВыпускиСериальногоИздания(ПредставлениеУчетЕд,ОбъектУчетЕд)
	Запрос = Новый Запрос (
	"ВЫБРАТЬ
	|	удуУчетныеЕдиницы.Год,
	|	удуУчетныеЕдиницы.НомерПерИздания
	|ИЗ
	|	Справочник.удуУчетныеЕдиницы КАК удуУчетныеЕдиницы
	|ГДЕ
	|	удуУчетныеЕдиницы.ЭтоГруппа = ЛОЖЬ
	|	И удуУчетныеЕдиницы.Серия = &Серия
	|	И удуУчетныеЕдиницы.ПометкаУдаления = ЛОЖЬ
	|	И удуУчетныеЕдиницы.Серия <> &ПустаяСсылка"
	);
	Запрос.УстановитьПараметр("Серия",ОбъектУчетЕд.Ссылка);
	Запрос.УстановитьПараметр("ПустаяСсылка",Справочники.удуСерии.ПустаяСсылка());

	Рез = Запрос.Выполнить();
	Выборка = Рез.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Год) Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + Выборка.Год;
		КонецЕсли;
		Если ЗначениеЗаполнено(Выборка.НомерПерИздания) Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + ", № " + Выборка.НомерПерИздания + " ; ";
		КонецЕсли;
	КонецЦикла;
	Если Не Рез.Пустой() Тогда 
		ПредставлениеУчетЕд = Лев(ПредставлениеУчетЕд, СтрДлина(ПредставлениеУчетЕд) - 3);
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьВыпускиСериальногоИздания()

Процедура СформироватьПредставлениеТомовМноготомника(ПредставлениеУчетЕд,ОбъектУчетЕд)
	Запрос = Новый Запрос(
	 "ВЫБРАТЬ
	 |	удуУчетныеЕдиницы.Ссылка,
	 |	удуУчетныеЕдиницы.Наименование,
	 |	удуУчетныеЕдиницы.Год,
	 |	удуУчетныеЕдиницы.КоличествоСтраниц,
	 |	удуУчетныеЕдиницы.Иллюстрации,
	 |	удуУчетныеЕдиницы.НомерТома,
	 |	удуУчетныеЕдиницы.Издательства.(
	 |		Ссылка,
	 |		НомерСтроки,
	 |		Издательство,
	 |		СтандартныйНомер,
	 |		МестоИздания
	 |	)
	 |ИЗ
	 |	Справочник.удуУчетныеЕдиницы КАК удуУчетныеЕдиницы
	 |ГДЕ
	 |	удуУчетныеЕдиницы.Многотомник = &Многотомник
	 |	И удуУчетныеЕдиницы.ПометкаУдаления = ЛОЖЬ
	 |	И удуУчетныеЕдиницы.Многотомник <> &ПустаяСсылка"
	);
	Запрос.УстановитьПараметр("ПустаяСсылка",Справочники.удуМноготомники.ПустаяСсылка());
	Запрос.УстановитьПараметр("Многотомник",ОбъектУчетЕд);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ПредставлениеУчетЕд = ПредставлениеУчетЕд + Символы.ПС;
		ПредставлениеУчетЕд = ПредставлениеУчетЕд + "Т." + Выборка.НомерТома + " : " + Выборка.Наименование;
		СформироватьЧастьГодОбъем(ПредставлениеУчетЕд,Выборка.Ссылка);
	КонецЦикла;
	
	
КонецПроцедуры // СформироватьПредставлениеТомовМноготомника()

// Функция формирует текстовое представление книги
//
// Параметры:
//  ФормаЭл		- форма элемента учетной единицы
//
// Возвращаемое значение:
// Строка		- библиографическое представление единицы
// 
Функция СформироватьПредставлениеКнига(ФормаЭл) Экспорт
	
	Мас = ФормаЭл.ПолучитьРеквизиты();
	Для Инкр = 0 По Мас.Количество() -1 Цикл
		Если Мас[Инкр].Имя = "Объект" Тогда
			ОбъектФормы = ФормаЭл.РеквизитФормыВЗначение(Мас[Инкр].Имя);
			ОбъектУчетЕд = ОбъектФормы;
		КонецЕсли;
		
	КонецЦикла;
		
    ПредставлениеУчетЕд = "";
	// Сформировать представление, если методический материал книга
	УказыватьАвтораВНачале = Истина;
		Если ЗначениеЗаполнено(ОбъектУчетЕд.АвторПредставление) Тогда
			СписокАвторов = Новый Массив;
			Для Каждого Элем Из ОбъектУчетЕд.Авторы Цикл
				НовыйАвтор = Новый Структура("Автор,Роль,Печатать",Элем.Автор,Элем.Роль, Истина);
				СписокАвторов.Добавить(НовыйАвтор);
			КонецЦикла;
			
			ОтборРоль = Справочники.удуРолиАвтора.НайтиПоНаименованию("Составитель");
			Если Не СписокАвторов.Найти(Новый Структура("Роль",ОтборРоль)) = Неопределено Тогда
				// составитель найден
				УказыватьАвтораВНачале = Ложь;
			КонецЕсли;
		КонецЕсли;
		// Записать первого указанного в списке автора в начало
		Если УказыватьАвтораВНачале И Не СписокАвторов = Неопределено Тогда
			ПредставлениеУчетЕд = СписокАвторов[0].Автор.Фамилия + ", " + СписокАвторов[0].Автор.Инициалы + " ";
		КонецЕсли;
		// Название
		ПредставлениеУчетЕд = ПредставлениеУчетЕд +  ОбъектУчетЕд.Наименование + " ["+ ОбъектУчетЕд.ОбщееОбозначениеМатериала +"]";
		Если ЗначениеЗаполнено(ОбъектУчетЕд.СведенияОтносящиесяКЗаглавию) Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + ": " + ОбъектУчетЕд.СведенияОтносящиесяКЗаглавию + " / ";
		Иначе
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + " / ";
		КонецЕсли;
		
		СформироватьЧастьПредставленияАвторы(ПредставлениеУчетЕд, СписокАвторов);
		
		// Издание (2-е издание, перераб. и доп.)
		Если ЗначениеЗаполнено(ОбъектУчетЕд.Издание) Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + ". - " + ОбъектУчетЕд.Издание;
		КонецЕсли;
		
		// Издательство (использование ТЧ)
		Если ОбъектУчетЕд.Издательства.Количество() > 0 Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + ". - " + ОбъектУчетЕд.Издательства[0].МестоИздания + ": " + ОбъектУчетЕд.Издательства[0].Издательство ;
		КонецЕсли;
		
		СформироватьЧастьГодОбъем(ПредставлениеУчетЕд,ОбъектУчетЕд);
		
		// Многотомник
		Если ЗначениеЗаполнено(ОбъектУчетЕд.Многотомник) Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + " - (" + ОбъектУчетЕд.Многотомник.Наименование;
			Если ЗначениеЗаполнено(ОбъектУчетЕд.Многотомник.КоличествоТомов) И ОбъектУчетЕд.Многотомник.КоличествоТомов > 0 Тогда
				ПредставлениеУчетЕд = ПредставлениеУчетЕд + " : в " + ОбъектУчетЕд.Многотомник.КоличествоТомов + " т.";
			КонецЕсли;
			 	ПредставлениеУчетЕд = ПредставлениеУчетЕд + " / ";
			Если ОбъектУчетЕд.Многотомник.Авторы.Количество() > 0 Тогда
				Для ИнкрАвт = 0 По ОбъектУчетЕд.Многотомник.Авторы.Количество() - 1 Цикл
					Если ИнкрАвт <> 0 Тогда
						ПредставлениеУчетЕд = ПредставлениеУчетЕд + ", ";
					КонецЕсли;
					ПредставлениеУчетЕд = ПредставлениеУчетЕд + ОбъектУчетЕд.Многотомник.Авторы[ИнкрАвт].Автор.Инициалы + " " + ОбъектУчетЕд.Многотомник.Авторы[ИнкрАвт].Автор.Фамилия;
				КонецЦикла;
			КонецЕсли;
			Если ОбъектУчетЕд.Многотомник.Авторы.Количество() > 0 Тогда
				ПредставлениеУчетЕд = СокрП(ПредставлениеУчетЕд) + "; ";
			КонецЕсли;
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + "т. " + ОбъектУчетЕд.НомерТома + ").";
		КонецЕсли;
		
		// Международный номер
		Если ОбъектУчетЕд.Издательства.Количество() > 0 И ЗначениеЗаполнено(ОбъектУчетЕд.Издательства[0].СтандартныйНомер) Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + " - " + ОбъектУчетЕд.Издательства[0].ВидСтандартногоНомера + " " + ОбъектУчетЕд.Издательства[0].СтандартныйНомер;
		КонецЕсли;

//	КонецЕсли;
	ПоставитьТочкуВКонцеЗаписи(ПредставлениеУчетЕд);
	Возврат ПредставлениеУчетЕд;	
КонецФункции // СформироватьПредставлениеКнига()

// Функция формирует текстовое периодического издания
//
// Параметры:
//  ФормаЭл		- форма элемента учетной единицы
//
// Возвращаемое значение:
// Строка		- библиографическое представление единицы
//
Функция СформироватьПредставлениеПериодика(ФормаЭл) Экспорт
	
	Мас = ФормаЭл.ПолучитьРеквизиты();
	Для Инкр = 0 По Мас.Количество() -1 Цикл
		Если Мас[Инкр].Имя = "Объект" Тогда
			ОбъектФормы = ФормаЭл.РеквизитФормыВЗначение(Мас[Инкр].Имя);
			ОбъектУчетЕд = ОбъектФормы;
		КонецЕсли;
		
	КонецЦикла;
		
    ПредставлениеУчетЕд = "";
	// Сформировать представление, если методический материал периодическое издание
	Если ОбъектУчетЕд.ВидМатериала = Справочники.удуВидыМетодическихМатериалов.ПериодическоеИздание Тогда
		
		// Название
		ПредставлениеУчетЕд = ПредставлениеУчетЕд +  ОбъектУчетЕд.Наименование + " ["+ ОбъектУчетЕд.ОбщееОбозначениеМатериала +"]";
		Если ЗначениеЗаполнено(ОбъектУчетЕд.СведенияОтносящиесяКЗаглавию) Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + ": " + ОбъектУчетЕд.СведенияОтносящиесяКЗаглавию + " / ";
		Иначе
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + " / ";
		КонецЕсли;
		
		// Учредитель
		Если ЗначениеЗаполнено(ОбъектУчетЕд.Учредитель) Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + "учредитель " + ОбъектУчетЕд.Учредитель;
		КонецЕсли;
		
		// первый номер .- последний номер
		Если ЗначениеЗаполнено(ОбъектУчетЕд.Серия) Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + ". - " + ОбъектУчетЕд.Серия.ПервыйНомер;
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + ", " + ОбъектУчетЕд.Серия.НомерПервого;
			Если ЗначениеЗаполнено(ОбъектУчетЕд.Серия.ПоследнийНомер) Тогда
				ПредставлениеУчетЕд = ПредставлениеУчетЕд + " - " + ОбъектУчетЕд.Серия.ПоследнийНомер;
			Иначе
				ПредставлениеУчетЕд = ПредставлениеУчетЕд + " -    ";
			КонецЕсли;
		КонецЕсли;
		
		// Издательство (использование ТЧ)
		Если ОбъектУчетЕд.Издательства.Количество() > 0 Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + ". - " + ОбъектУчетЕд.Издательства[0].МестоИздания + ": " + ОбъектУчетЕд.Издательства[0].Издательство ;
		КонецЕсли;
		
		// Международный номер
		Если ОбъектУчетЕд.Издательства.Количество() > 0 И ЗначениеЗаполнено(ОбъектУчетЕд.Издательства[0].СтандартныйНомер) Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + ". - "+ ОбъектУчетЕд.Издательства[0].ВидСтандартногоНомера +" " + ОбъектУчетЕд.Издательства[0].СтандартныйНомер;
		КонецЕсли;
		
		// количество страниц и иллюстрации
		Если ЗначениеЗаполнено(ОбъектУчетЕд.КоличествоСтраниц) Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + ". - " + ОбъектУчетЕд.КоличествоСтраниц + " c.";
			Если ОбъектУчетЕд.Иллюстрации Тогда
				ПредставлениеУчетЕд = ПредставлениеУчетЕд + ": ил.";
			КонецЕсли;
		КонецЕсли;
        ПоставитьТочкуВКонцеЗаписи(ПредставлениеУчетЕд);
		ПредставлениеУчетЕд = ПредставлениеУчетЕд+ Символы.ПС;
		
		// год
		Если ЗначениеЗаполнено(ОбъектУчетЕд.Год) Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + ОбъектУчетЕд.Год;
		КонецЕсли;
		Если ЗначениеЗаполнено(ОбъектУчетЕд.НомерПерИздания) Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + ", № " + ОбъектУчетЕд.НомерПерИздания;
		КонецЕсли;
		
		ПоставитьТочкуВКонцеЗаписи(ПредставлениеУчетЕд);

	КонецЕсли;
	Возврат ПредставлениеУчетЕд;	
КонецФункции // СформироватьПредставлениеПериодика()

 
// Функция формирует представление периодического издания с перечислением всех имеющихся порядковые единицы.
//
// Параметры:
//  ФормаЭл		- форма элемента учетной единицы
//
// Возвращаемое значение:
// Строка		- библиографическое представление единицы
//
Функция СформироватьПредставлениеПериодикаВершина(ФормаЭл) Экспорт
	
	Мас = ФормаЭл.ПолучитьРеквизиты();
	Для Инкр = 0 По Мас.Количество() -1 Цикл
		Если Мас[Инкр].Имя = "Объект" Тогда
			ОбъектФормы = ФормаЭл.РеквизитФормыВЗначение(Мас[Инкр].Имя);
			ОбъектУчетЕд = ОбъектФормы;
		КонецЕсли;
		
	КонецЦикла;
		
    ПредставлениеУчетЕд = "";
			
	// Название
	ПредставлениеУчетЕд = ПредставлениеУчетЕд +  ОбъектУчетЕд.Наименование + " ["+ ОбъектУчетЕд.ОбщееОбозначениеМатериала +"]";
	Если ЗначениеЗаполнено(ОбъектУчетЕд.СведенияОтносящиесяКЗаглавию) Тогда
		ПредставлениеУчетЕд = ПредставлениеУчетЕд + ": " + ОбъектУчетЕд.СведенияОтносящиесяКЗаглавию + " / ";
	Иначе
		ПредставлениеУчетЕд = ПредставлениеУчетЕд + " / ";
	КонецЕсли;
	
	// Учредитель
	Если ЗначениеЗаполнено(ОбъектУчетЕд.Учредитель) Тогда
		ПредставлениеУчетЕд = ПредставлениеУчетЕд + "учредитель " + ОбъектУчетЕд.Учредитель;
	КонецЕсли;
	
	// первый номер .- последний номер
	ПредставлениеУчетЕд = ПредставлениеУчетЕд + ". - " + ОбъектУчетЕд.ПервыйНомер;
	ПредставлениеУчетЕд = ПредставлениеУчетЕд + ", " + ОбъектУчетЕд.НомерПервого;
	Если ЗначениеЗаполнено(ОбъектУчетЕд.ПоследнийНомер) Тогда
		ПредставлениеУчетЕд = ПредставлениеУчетЕд + " - " + ОбъектУчетЕд.ПоследнийНомер;
	Иначе
		ПредставлениеУчетЕд = ПредставлениеУчетЕд + " -    ";
	КонецЕсли;
	
	// Издательство (использование ТЧ)
	Если ОбъектУчетЕд.Издательства.Количество() > 0 Тогда
		ПредставлениеУчетЕд = ПредставлениеУчетЕд + ". - " + ОбъектУчетЕд.Издательства[0].МестоИздания + ": " + ОбъектУчетЕд.Издательства[0].Издательство ;
	КонецЕсли;
	
	// Международный номер
	Если ОбъектУчетЕд.Издательства.Количество() > 0 И ЗначениеЗаполнено(ОбъектУчетЕд.Издательства[0].СтандартныйНомер) Тогда
		ПредставлениеУчетЕд = ПредставлениеУчетЕд + ". - "+ ОбъектУчетЕд.Издательства[0].ВидСтандартногоНомера + " " + ОбъектУчетЕд.Издательства[0].СтандартныйНомер;
	КонецЕсли;
	
	// количество страниц и иллюстрации
	Если ЗначениеЗаполнено(ОбъектУчетЕд.КоличествоСтраниц) Тогда
		ПредставлениеУчетЕд = ПредставлениеУчетЕд + ". - " + ОбъектУчетЕд.КоличествоСтраниц + " c.";
		Если ОбъектУчетЕд.Иллюстрации Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + ": ил.";
		КонецЕсли;
	КонецЕсли;

	ПоставитьТочкуВКонцеЗаписи(ПредставлениеУчетЕд);
	ПредставлениеУчетЕд = ПредставлениеУчетЕд+ Символы.ПС;
	
	// выпуски, номера
	ЗаполнитьВыпускиСериальногоИздания(ПредставлениеУчетЕд,ОбъектУчетЕд);
	
	ПоставитьТочкуВКонцеЗаписи(ПредставлениеУчетЕд);
	Возврат ПредставлениеУчетЕд;	
КонецФункции // СформироватьПредставлениеПериодика()

// Функция формирует представление многотомника
//
// Параметры:
//  ФормаЭл		- форма элемента учетной единицы
//
// Возвращаемое значение:
// Строка		- библиографическое представление единицы
//
Функция СформироватьПредставлениеМноготомника(ФормаЭл) Экспорт
	Мас = ФормаЭл.ПолучитьРеквизиты();
	Для Инкр = 0 По Мас.Количество() -1 Цикл
		Если Мас[Инкр].Имя = "Объект" Тогда
			ОбъектФормы = ФормаЭл.РеквизитФормыВЗначение(Мас[Инкр].Имя);
			ОбъектУчетЕд = ОбъектФормы;
		КонецЕсли;
		
	КонецЦикла;
		
    ПредставлениеУчетЕд = "";
	// Сформировать представление, если методический материал книга
	
		УказыватьАвтораВНачале = Истина;
		Если ОбъектУчетЕд.Авторы.Количество() > 0 Тогда
			СписокАвторов = Новый Массив;
			Для Каждого Элем Из ОбъектУчетЕд.Авторы Цикл
				НовыйАвтор = Новый Структура("Автор,Роль,Печатать",Элем.Автор,Элем.Роль, Истина);
				СписокАвторов.Добавить(НовыйАвтор);
			КонецЦикла;
			
			ОтборРоль = Справочники.удуРолиАвтора.НайтиПоНаименованию("Составитель");
			Если Не СписокАвторов.Найти(Новый Структура("Роль",ОтборРоль)) = Неопределено Тогда
				// составитель найден
				УказыватьАвтораВНачале = Ложь;
			КонецЕсли;
		КонецЕсли;
		// Записать первого указанного в списке автора в начало
		Если УказыватьАвтораВНачале И Не СписокАвторов = Неопределено Тогда
			ПредставлениеУчетЕд = СписокАвторов[0].Автор.Фамилия + ", " + СписокАвторов[0].Автор.Инициалы + " ";
		КонецЕсли;
		// Название
		ПредставлениеУчетЕд = ПредставлениеУчетЕд +  ОбъектУчетЕд.Наименование + " ["+ ОбъектУчетЕд.ОбщееОбозначениеМатериала +"]";
		Если ЗначениеЗаполнено(ОбъектУчетЕд.КоличествоТомов) И ОбъектУчетЕд.КоличествоТомов > 0 Тогда
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + ": в " + ОбъектУчетЕд.КоличествоТомов + " т.";
		КонецЕсли;
		ПредставлениеУчетЕд = ПредставлениеУчетЕд + " / ";
		// Авторы многотомника		
		СформироватьЧастьПредставленияАвторы(ПредставлениеУчетЕд, СписокАвторов);
		ПоставитьТочкуВКонцеЗаписи(ПредставлениеУчетЕд);
		// Тома многотомника
		СформироватьПредставлениеТомовМноготомника(ПредставлениеУчетЕд,ОбъектУчетЕд.Ссылка);
					
		ПоставитьТочкуВКонцеЗаписи(ПредставлениеУчетЕд);
		
	Возврат ПредставлениеУчетЕд;		
КонецФункции // СформироватьПредставлениеМноготомника()

// Функция формирует представление составных частей методического материала
//
// Параметры:
//  ФормаЭл		- форма элемента учетной единицы
//
// Возвращаемое значение:
// Строка		- библиографическое представление единицы
//
Функция СформироватьПредставлениеСоставныеЧасти(ФормаЭл) Экспорт
	
	Мас = ФормаЭл.ПолучитьРеквизиты();
	Для Инкр = 0 По Мас.Количество() -1 Цикл
		Если Мас[Инкр].Имя = "Объект" Тогда
			ОбъектФормы = ФормаЭл.РеквизитФормыВЗначение(Мас[Инкр].Имя);
			ОбъектУчетЕд = ОбъектФормы;
		КонецЕсли;
	КонецЦикла;
		
    ПредставлениеУчетЕд = "";
	
	// Записать первого указанного в списке автора в начало
	Если ОбъектУчетЕд.Авторы.Количество() > 0 Тогда
		ПредставлениеУчетЕд = СокрП(ОбъектУчетЕд.Авторы[0].Автор.Фамилия) + ", " + ОбъектУчетЕд.Авторы[0].Автор.Инициалы + " ";
	КонецЕсли;
	// Название
	ПредставлениеУчетЕд = ПредставлениеУчетЕд +  ОбъектУчетЕд.Наименование + " ["+ ОбъектУчетЕд.ОбщееОбозначениеМатериала +"]";
	Для Инкр = 0 По ОбъектУчетЕд.Авторы.Количество() - 1 Цикл
		Если Инкр = 0 Тогда 
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + " / ";
		КонецЕсли;
		ПредставлениеУчетЕд = ПредставлениеУчетЕд + ОбъектУчетЕд.Авторы[Инкр].Автор.Инициалы + ОбъектУчетЕд.Авторы[Инкр].Автор.Фамилия + " ";	
	КонецЦикла;
	
	Если ОбъектУчетЕд.Владельцы.Количество() > 0 Тогда
		ПредставлениеУчетЕд = ПредставлениеУчетЕд + " // ";
		Для Каждого ЭлемВладелец Из ОбъектУчетЕд.Владельцы Цикл
			ПредставлениеУчетЕд = ПредставлениеУчетЕд + ЭлемВладелец.УчетнаяЕдиница.Наименование;	
			Если ЗначениеЗаполнено(ЭлемВладелец.УчетнаяЕдиница.СведенияОтносящиесяКЗаглавию) Тогда
				ПредставлениеУчетЕд = ПредставлениеУчетЕд + " : " + ЭлемВладелец.УчетнаяЕдиница.СведенияОтносящиесяКЗаглавию;	
			КонецЕсли;
			Если ЗначениеЗаполнено(ЭлемВладелец.УчетнаяЕдиница.Год) Тогда
				ПредставлениеУчетЕд = ПредставлениеУчетЕд + ". - " + ЭлемВладелец.УчетнаяЕдиница.Год;	
			КонецЕсли;
			Если ЗначениеЗаполнено(ЭлемВладелец.УчетнаяЕдиница.НомерПерИздания) Тогда
				ПредставлениеУчетЕд = ПредставлениеУчетЕд + ". - № " + ЭлемВладелец.УчетнаяЕдиница.НомерПерИздания;	
			КонецЕсли;
			Если ЗначениеЗаполнено(ЭлемВладелец.Страницы) Тогда
				ПредставлениеУчетЕд = ПредставлениеУчетЕд + ". - С." + ЭлемВладелец.Страницы;	
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ПоставитьТочкуВКонцеЗаписи(ПредставлениеУчетЕд);
	Возврат ПредставлениеУчетЕд;	
КонецФункции // СформироватьПредставлениеКнига()

///////////////////////////////////////////////////////////////////////////////
// 	ОФОРМЛЕНИЕ
//

// Устанавливает условное оформление методического материала. 
//
// Параметры:
//  ФормаЭл		- форма элемента учетной единицы
//
// Возвращаемое значение:
// Строка		- библиографическое представление единицы
//
Процедура УстановитьОформлениеМетодическихМатериалов(Знач УсловноеОформление) Экспорт

	// установка оформления для просроченных задач
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УчетнаяЕдиница");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаВозврата");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ЭлементОтбораДанных.ПравоеЗначение = КонецДня(ТекущаяДата());
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаВозврата");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение =  Метаданные.ЭлементыСтиля.ПросроченныйМетодическийМатериал.Значение; 
	ЭлементЦветаОформления.Использование = Истина;
	
КонецПроцедуры


