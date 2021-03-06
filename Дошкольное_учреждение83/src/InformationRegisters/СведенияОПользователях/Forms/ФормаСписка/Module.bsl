
&НаСервере
Процедура УстановитьОтбор()
	
	Если ЗначениеЗаполнено(ПоПодразделению) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьОтборУСпискаНаРавенство(Список.Отбор, Новый ПолеКомпоновкиДанных("Подразделение"), ПоПодразделению);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьОтборУСписка(Список.Отбор, Новый ПолеКомпоновкиДанных("Подразделение"));
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоПодразделениюПриИзменении(Элемент)
	
	УстановитьОтбор();
	Элементы.Список.Обновить();
	
КонецПроцедуры
