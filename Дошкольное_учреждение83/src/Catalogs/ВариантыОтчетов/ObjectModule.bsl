#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если Отказ ИЛИ ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИсключаемыеРеквизиты = Новый Массив;
	
	Если НЕ Пользовательский Тогда
		ИсключаемыеРеквизиты.Добавить("Автор");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
	
	Если Наименование <> "" И ВариантыОтчетов.НаименованиеЗанято(Отчет, Ссылка, Наименование) Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '""%1"" занято, необходимо указать другое наименование.'"),
				Наименование
			),
			,
			"Наименование"
		);
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Если Отказ ИЛИ ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПользователемИзмененаПометкаУдаления = (
		НЕ ЭтоНовый()
		И ПометкаУдаления <> Ссылка.ПометкаУдаления
		И НЕ ДополнительныеСвойства.Свойство("ЗаполнениеПредопределенных")
	);
	
	Если НЕ Пользовательский И ПользователемИзмененаПометкаУдаления Тогда
		Если ПометкаУдаления Тогда
			ТекстОшибки = НСтр("ru = 'Пометка на удаление предопределенного варианта отчета запрещена.'");
		Иначе
			ТекстОшибки = НСтр("ru = 'Снятие пометки удаления предопределенного варианта отчета запрещена.'");
		КонецЕсли;
		ВариантыОтчетов.ОшибкаПоВарианту(Ссылка, ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если НЕ ПометкаУдаления И ПользователемИзмененаПометкаУдаления Тогда
		НаименованиеЗанято = ВариантыОтчетов.НаименованиеЗанято(Отчет, Ссылка, Наименование);
		КлючВариантаЗанят  = ВариантыОтчетов.КлючВариантаЗанят(Отчет, Ссылка, КлючВарианта);
		Если НаименованиеЗанято ИЛИ КлючВариантаЗанят Тогда
			ТекстОшибки = НСтр("ru = 'Ошибка снятия пометки удаления варианта отчета:'");
			Если НаименованиеЗанято Тогда
				ТекстОшибки = ТекстОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Наименование ""%1"" уже занято другим вариантом этого отчета.'"),
					Наименование
				);
			Иначе
				ТекстОшибки = ТекстОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ключ варианта ""%1"" уже занят другим вариантом этого отчета.'"),
					КлючВарианта
				);
			КонецЕсли;
			ТекстОшибки = ТекстОшибки + НСтр("ru = 'Перед снятием пометки удаления варианта отчета
			|необходимо установить пометку удаления конфликтующего варианта отчета.'");
			ВариантыОтчетов.ОшибкаПоВарианту(Ссылка, ТекстОшибки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если Отказ ИЛИ ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Удаление из табличной части подсистем, помеченных на удаление.
	МассивУдаляемыхСтрок = Новый Массив;
	Для Каждого СтрокаРазмещения Из Размещение Цикл
		Если СтрокаРазмещения.РазделИлиГруппа.ПометкаУдаления = Истина Тогда
			МассивУдаляемыхСтрок.Добавить(СтрокаРазмещения);
		КонецЕсли;
	КонецЦикла;
	Для Каждого СтрокаРазмещения Из МассивУдаляемыхСтрок Цикл
		Размещение.Удалить(СтрокаРазмещения);
	КонецЦикла;
КонецПроцедуры


#КонецЕсли