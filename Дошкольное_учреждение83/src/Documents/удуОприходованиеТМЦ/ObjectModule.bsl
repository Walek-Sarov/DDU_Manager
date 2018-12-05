

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если СкладыВТабличнойЧасти Тогда
		ПроверяемыеРеквизиты.Добавить("ТМЦ.Склад");
		ПроверяемыеРеквизиты.Добавить("УчетныеЕдиницы.Склад");
	Иначе
		ПроверяемыеРеквизиты.Добавить("Склад");
	КонецЕсли;
	
КонецПроцедуры

Процедура ДвиженияПоУчетуТМЦ(Отказ)
	
	Движения.удуТМЦ_НаСкладах.Записывать = Истина;
	Для Каждого ТекСтрокаТМЦ Из ТМЦ Цикл
		// регистр удуТМЦ_НаСкладах Приход
		// таб часть "ТМЦ"
		Движение = Движения.удуТМЦ_НаСкладах.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период      = Дата;
		Движение.Учреждение  = Организация;
		
		Если СкладыВТабличнойЧасти Тогда
			Движение.Склад = ТекСтрокаТМЦ.Склад;
		Иначе
			Движение.Склад = Склад;
		КонецЕсли;

		Движение.ИнвентарныйНомер = ТекСтрокаТМЦ.ИнвентарныйНомер;
		Движение.Номенклатура     = ТекСтрокаТМЦ.Номенклатура;
		Движение.КВД              = КВД;
		Движение.Количество       = ТекСтрокаТМЦ.Количество;
	КонецЦикла;

	
	Для Каждого ТекСтрокаУЕд Из УчетныеЕдиницы Цикл
		// регистр удуТМЦ_НаСкладах Приход
		// таб часть "УчетныеЕдиницы"
		Движение = Движения.удуТМЦ_НаСкладах.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период      = Дата;
		Движение.Учреждение  = Организация;
		
		Если СкладыВТабличнойЧасти Тогда
			Движение.Склад = ТекСтрокаУЕд.Склад;
		Иначе
			Движение.Склад = Склад;
		КонецЕсли;
		
		Движение.ИнвентарныйНомер = ТекСтрокаУЕд.ИнвентарныйНомер;
		Движение.Номенклатура     = ТекСтрокаУЕд.УчетнаяЕдиница;
		Движение.КВД              = КВД;
		Движение.Количество       = ТекСтрокаУЕд.Количество;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
		
    ДвиженияПоУчетуТМЦ(Отказ); 	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры
