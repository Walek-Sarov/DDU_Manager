
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТабДок = Новый ТабличныйДокумент;
	ПечатьВнутреннейОписи(ТабДок, ПараметрКоманды);

	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ВнутренняяОпись";
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Показать("Внутренняя опись");
	
КонецПроцедуры

&НаСервере
Процедура ПечатьВнутреннейОписи(ТабДок, Ссылка)
	
	Справочники.ДелаХраненияДокументов.ПечатьВнутреннейОписи(ТабДок, Ссылка);
	
КонецПроцедуры	