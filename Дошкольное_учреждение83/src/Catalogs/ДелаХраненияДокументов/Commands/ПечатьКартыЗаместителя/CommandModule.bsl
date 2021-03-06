
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТабДок = Новый ТабличныйДокумент;
	ПечатьКартыЗаместителя(ТабДок, ПараметрКоманды);

	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_КартаЗаместитель";
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Показать("Карта заместитель");
	
КонецПроцедуры

&НаСервере
Процедура ПечатьКартыЗаместителя(ТабДок, Ссылка)
	
	Справочники.ДелаХраненияДокументов.ПечатьКартыЗаместителя(ТабДок, Ссылка);
	
КонецПроцедуры	