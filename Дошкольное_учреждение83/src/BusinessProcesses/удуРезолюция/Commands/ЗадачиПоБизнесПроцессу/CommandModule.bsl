
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("БизнесПроцесс.удуРезолюция.Форма.ЗадачиПоБизнесПроцессу", 
		Новый Структура("БизнесПроцесс", ПараметрКоманды), 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
