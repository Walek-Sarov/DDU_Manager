&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтруктурСертификатов = Параметры.МассивСтруктурСертификатов;
	
	ОбъектСсылка = Неопределено;
	Если Параметры.Свойство("ОбъектСсылка") Тогда
		ОбъектСсылка = Параметры.ОбъектСсылка;
	КонецЕсли;	
	
	Заголовок = НСтр("ru = 'Подписать ""'") + Строка(ОбъектСсылка) + """";
	
	Для Каждого СтруктураСертификата Из МассивСтруктурСертификатов Цикл
		НоваяСтрока = ТаблицаСертификатов.Добавить();
		
		НоваяСтрока.КомуВыдан = СтруктураСертификата.КомуВыдан;
		НоваяСтрока.КемВыдан = СтруктураСертификата.КемВыдан;
		НоваяСтрока.ДействителенДо = СтруктураСертификата.ДействителенДо;
		НоваяСтрока.Отпечаток = СтруктураСертификата.Отпечаток;
		
		ЭлектроннаяЦифроваяПодпись.ЗаполнитьНазначениеСертификата(СтруктураСертификата.Назначение, НоваяСтрока.Назначение);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСертификатовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОбработкаВыбора();
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	ОбработкаВыбора();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора()
	
	ТекущиеДанные = Элементы.ТаблицаСертификатов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ВозвратПароль = Пароль;
	
	Если ПустаяСтрока(Пароль) И НЕ ПустаяСтрока(Элементы.Пароль.ТекстРедактирования) Тогда
		ВозвратПароль = Элементы.Пароль.ТекстРедактирования;
	КонецЕсли;	
	
	ВыбранныйСертификат = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьСертификатПоОтпечатку(ТекущиеДанные.Отпечаток);
	СтруктураВозврата = Новый Структура("Сертификат, Комментарий, Пароль", 
		ВыбранныйСертификат, Комментарий, ВозвратПароль);
		
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСертификат(Команда)
	
	ТекущиеДанные = Элементы.ТаблицаСертификатов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
		
	ВыбранныйСертификат = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьСертификатПоОтпечатку(ТекущиеДанные.Отпечаток);
	
	СтруктураСертификата = ЭлектроннаяЦифроваяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(ВыбранныйСертификат);
	Если СтруктураСертификата <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("СтруктураСертификата, Отпечаток", СтруктураСертификата, ТекущиеДанные.Отпечаток);
		СтруктураВозврата = ОткрытьФормуМодально("Общаяформа.СертификатЭЦП", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры
