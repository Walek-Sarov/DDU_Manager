
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("БизнесПроцесс.Регистрация.Форма.ЗадачиПоБизнесПроцессу", 
		Новый Структура("БизнесПроцесс", ПараметрКоманды), 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
