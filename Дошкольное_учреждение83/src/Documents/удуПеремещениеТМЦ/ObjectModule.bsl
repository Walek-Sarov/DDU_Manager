

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если СкладыВТабличнойЧасти Тогда
		ПроверяемыеРеквизиты.Добавить("ТМЦ.Склад");
		ПроверяемыеРеквизиты.Добавить("ТМЦ.СкладПриемник");
		ПроверяемыеРеквизиты.Добавить("УчетныеЕдиницы.Склад");
		ПроверяемыеРеквизиты.Добавить("УчетныеЕдиницы.СкладПриемник");
	Иначе
		ПроверяемыеРеквизиты.Добавить("Склад");
		ПроверяемыеРеквизиты.Добавить("СкладПриемник");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// Списание:
	Движения.удуТМЦ_НаСкладах.Записывать = Истина;
	
	Движения.удуТМЦ_НаСкладах.Записывать = Истина;
	Движения.удуТМЦ_НаСкладах.Записать();
	
    Отказ = удуУчетТМЦСервер.ПроверитьВозможностьСписанияТМЦ(ЭтотОбъект, "удуПеремещениеТМЦ");
	
	Для Каждого ТекСтрокаТМЦ Из ТМЦ Цикл
		// регистр удуТМЦ_НаСкладах Расход
		Движение = Движения.удуТМЦ_НаСкладах.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Учреждение = Организация;
		
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
		// регистр удуТМЦ_НаСкладах Расход
		// таб часть "УчетныеЕдиницы"
		Движение = Движения.удуТМЦ_НаСкладах.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
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

	
	// Приход:
	Для Каждого ТекСтрокаТМЦ Из ТМЦ Цикл
		// регистр удуТМЦ_НаСкладах Приход
		Движение = Движения.удуТМЦ_НаСкладах.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Учреждение = Организация;
		
		Если СкладыВТабличнойЧасти Тогда
			Движение.Склад = ТекСтрокаТМЦ.СкладПриемник;
		Иначе
			Движение.Склад = СкладПриемник;
		КонецЕсли;

		Движение.ИнвентарныйНомер = ТекСтрокаТМЦ.ИнвентарныйНомер;
		Движение.Номенклатура = ТекСтрокаТМЦ.Номенклатура;
		Движение.КВД              = КВД;
		Движение.Количество = ТекСтрокаТМЦ.Количество;
	КонецЦикла;

	Для Каждого ТекСтрокаУЕд Из УчетныеЕдиницы Цикл
		// регистр удуТМЦ_НаСкладах Приход
		// таб часть "УчетныеЕдиницы"
		Движение = Движения.удуТМЦ_НаСкладах.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период      = Дата;
		Движение.Учреждение  = Организация;
		
		Если СкладыВТабличнойЧасти Тогда
			Движение.Склад = ТекСтрокаУЕд.СкладПриемник;
		Иначе
			Движение.Склад = СкладПриемник;
		КонецЕсли;
		
		Движение.ИнвентарныйНомер = ТекСтрокаУЕд.ИнвентарныйНомер;
		Движение.Номенклатура     = ТекСтрокаУЕд.УчетнаяЕдиница;
		Движение.КВД              = КВД;
		Движение.Количество       = ТекСтрокаУЕд.Количество;
	КонецЦикла;

	
	Движения.Записать();

КонецПроцедуры
