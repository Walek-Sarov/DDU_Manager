
&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)	
	УстановитьДоступностьПапокИГрифов();
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьПапокИГрифов()
	Если ЗначениеЗаполнено(Запись.ВидДокумента) Тогда
		ДоступностьПапокВнутреннихДокументов = (ТипЗнч(Запись.ВидДокумента) = Тип("СправочникСсылка.ВидыВнутреннихДокументов"));
		Если ДоступностьПапокВнутреннихДокументов Тогда
			Запись.ГрифДоступа = Справочники.ГрифыДоступа.ПустаяСсылка();			
		Иначе
			Запись.Папка = Справочники.ПапкиВнутреннихДокументов.ПустаяСсылка();
		КонецЕсли;
		Элементы.ГрифДоступа.Доступность = Не ДоступностьПапокВнутреннихДокументов;
		Элементы.Папка.Доступность = ДоступностьПапокВнутреннихДокументов;
	Иначе
		Элементы.ГрифДоступа.Доступность = Ложь;
		Элементы.Папка.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьПапокИГрифов();
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТипЗнч(Запись.ВидДокумента) = Тип("СправочникСсылка.ВидыВнутреннихДокументов") Тогда
		Если Запись.Папка = Справочники.ПапкиВнутреннихДокументов.ПустаяСсылка() Тогда
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст="Поле ""Папка"" не заполнено";		
			СообщениеПользователю.Сообщить();
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	Иначе
		Если Константы.ИспользоватьГрифыДоступаКВходящимИИсходящимДокументам И Запись.ГрифДоступа = Справочники.ГрифыДоступа.ПустаяСсылка() Тогда
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст="Поле ""Гриф доступа"" не заполнено";
			СообщениеПользователю.Сообщить();
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;

	
КонецПроцедуры
