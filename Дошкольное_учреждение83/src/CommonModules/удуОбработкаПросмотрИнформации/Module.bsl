// Процедура предназначена для получения состава группы, на указанную дату
//
// Параметры:
//  Группа - состав которой необходимо получить
//  Дата - дата, на которую полчаем состав группы
//
// Возвращаемое значение;
//  ТаблицаЗначений - состав группы
//
Функция ПолучитьсоставГруппы(Знач Группа, Знач ПараметрДата) Экспорт

	ТекстЗапроса = "ВЫБРАТЬ
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Ребенок.Ссылка КАК Ребенок,
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Ребенок.Пол КАК Пол,
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.Ребенок.ДатаРождения КАК ДатаРождения
	               |ИЗ
	               |	РегистрСведений.удуСведенияОЗачисленииРебенкаВГруппу.СрезПоследних(&ДатаВыборки, Группа = &Группа) КАК удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних
	               |ГДЕ
	               |	удуСведенияОЗачисленииРебенкаВГруппуСрезПоследних.СостояниеУчетаВГруппе = &СостояниеУчетаВГруппе";
				   
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДатаВыборки", ПараметрДата);
	Запрос.УстановитьПараметр("Группа", Группа);
	Запрос.УстановитьПараметр("СостояниеУчетаВГруппе", Перечисления.удуСостояниеРебенкаНаУчетеВГруппе.ПринятВГруппу);
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции // ПолучитьНомерНаПечать()
