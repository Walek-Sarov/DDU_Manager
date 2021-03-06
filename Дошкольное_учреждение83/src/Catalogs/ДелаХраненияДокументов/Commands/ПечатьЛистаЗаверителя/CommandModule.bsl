
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТабДок = Новый ТабличныйДокумент;
	ПечатьЛистаЗаверителя(ТабДок, ПараметрКоманды);

	ТабДок.ИмяПараметровПечати = "ПараметрыПечати_ЛистЗаверитель";
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Показать("Лист заверитель");
	
КонецПроцедуры

&НаСервере
Процедура ПечатьЛистаЗаверителя(ТабДок, Ссылка)
	
	Справочники.ДелаХраненияДокументов.ПечатьЛистаЗаверителя(ТабДок, Ссылка);
	
КонецПроцедуры	