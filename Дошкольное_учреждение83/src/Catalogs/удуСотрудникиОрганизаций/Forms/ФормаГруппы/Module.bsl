
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Запрос = Новый Запрос;
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	МАКСИМУМ(СотрудникиОрганизаций.Код) КАК Код
		|ИЗ
		|	Справочник.удуСотрудникиОрганизаций КАК СотрудникиОрганизаций
		|ГДЕ
		|	СотрудникиОрганизаций.ЭтоГруппа";
		
		Запрос.Текст = ТекстЗапроса;
		РезультатаЗапроса = Запрос.Выполнить();
		Если РезультатаЗапроса.Пустой() Тогда
			Объект.Код = "0000000001";
		Иначе
			СтрокаРезультата = РезультатаЗапроса.Выгрузить()[0];
			Если НЕ ЗначениеЗаполнено(СтрокаРезультата.Код) Тогда
				Объект.Код = "0000000001";
			Иначе
				Объект.Код = удуФизическиеЛица.ПолучитьСледующийНомер(СокрП(СтрокаРезультата.Код));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры
