
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуМодально(
		"ОбщаяФорма.ПраваПоЗначениямДоступа",
		Новый Структура("СсылкаНаОбъект", ПараметрКоманды));
	
КонецПроцедуры

