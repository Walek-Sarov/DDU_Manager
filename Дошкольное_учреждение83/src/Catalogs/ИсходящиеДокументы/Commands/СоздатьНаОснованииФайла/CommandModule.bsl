
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Форма = ПолучитьФорму("Справочник.ИсходящиеДокументы.Форма.ФормаВводаНаОснованииФайла",, ПараметрыВыполненияКоманды.Источник);
	Если Форма.ОткрытьМодально() <> КодВозвратаДиалога.ОК Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	ПараметрыВводаНаОсновании = Новый Структура;
	ПараметрыВводаНаОсновании.Вставить("Основание",		ПараметрКоманды);
	ПараметрыВводаНаОсновании.Вставить("ГрифДоступа",	Форма.ГрифДоступа);
	ПараметрыВводаНаОсновании.Вставить("ВидДокумента",	Форма.ВидДокумента);
	ПараметрыВводаНаОсновании.Вставить("Организация",	Форма.Организация);
	ПараметрыВводаНаОсновании.Вставить("Получатель",	Форма.Получатель);
	
	ПараметрыФормы = Новый Структура("Основание", ПараметрыВводаНаОсновании);
	ОткрытьФорму("Справочник.ИсходящиеДокументы.ФормаОбъекта", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры
