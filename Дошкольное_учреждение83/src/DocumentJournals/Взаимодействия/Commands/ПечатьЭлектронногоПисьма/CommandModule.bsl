
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
		ПараметрыФормы = Новый Структура("Письмо",ПараметрКоманды);
		ОткрытьФорму("ЖурналДокументов.Взаимодействия.Форма.ПечатьЭлектронногоПисьма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры
