
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Если Не ЗначениеЗаполнено(ПараметрКоманды) Тогда
		 Возврат;
	КонецЕсли;

	ОткрытьФорму("КритерийОтбора.БизнесПроцессыПоПредмету.Форма.ФормаСписка",
		Новый Структура("ЗначениеОтбора", ПараметрКоманды),
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Источник.КлючУникальности,
			ПараметрыВыполненияКоманды.Окно);	
КонецПроцедуры
