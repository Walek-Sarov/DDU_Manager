
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Автор = ПараметрыСеанса.ТекущийПользователь;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)

	Если МетодическиеМатериалы.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Движения.удуМетодическиеМатериалыНаРуках.Записывать = Истина;
	Для Каждого ТекСтрокаМетодическиеМатериалы Из МетодическиеМатериалы Цикл
		
		Если ТекСтрокаМетодическиеМатериалы.Количество > 0 Тогда
			
			Движение = Движения.удуМетодическиеМатериалыНаРуках.Добавить();
			
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = Дата;
			Движение.УчетнаяЕдиница = ТекСтрокаМетодическиеМатериалы.УчетнаяЕдиница;
			Движение.ИнвентарныйНомер = ТекСтрокаМетодическиеМатериалы.ИнвентарныйНомер;
			Движение.Читатель = Читатель;
			ДатаВозврата = ТекСтрокаМетодическиеМатериалы.ДатаВозврата;
			ДатаВозврата = ?(ДатаВозврата = '00010101', ДатаВозвратаОбщая, ДатаВозврата);
			Движение.ПлановаяДатаВозврата = ДатаВозврата;			
			Движение.ПричинаВыдачи = ПричинаВыдачи;
			Движение.Количество = ТекСтрокаМетодическиеМатериалы.Количество;
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры
