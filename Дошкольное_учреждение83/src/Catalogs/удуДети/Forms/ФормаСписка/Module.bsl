
&НаКлиенте
Процедура КомандаПечатьСпискаДетейПоГруппам(Команда)
	// Вставить содержимое обработчика.
	ФормаПечати = ПолучитьФорму("Справочник.удуДети.Форма.ФормаНастройкиПечати");	
	ФормаПечати.ВладелецФормы = ЭтаФорма;	
	ФормаПечати.ОткрытьМодально();	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
КонецПроцедуры

