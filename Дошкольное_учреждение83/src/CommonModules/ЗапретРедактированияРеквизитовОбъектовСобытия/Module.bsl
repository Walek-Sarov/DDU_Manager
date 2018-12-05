
// Обработчик события "ПередЗаписьюОбъекта".
// Проверяет установленность свойства "ИзменениеРеквизитов".
// Если свойство не установлено - объект не записывается.
//
Процедура ЗапретРедактированияРеквизитовОбъектовПередЗаписьюОбъекта(Источник, Отказ) Экспорт
	
	Если ЗначениеЗаполнено(Источник.Ссылка)
	   И НЕ Источник.ОбменДанными.Загрузка Тогда
		
		ПараметрыЗапретаРедактирования = ? (Источник.ДополнительныеСвойства.Свойство("__ПараметрыЗапретаРедактирования"),
											Источник.ДополнительныеСвойства.__ПараметрыЗапретаРедактирования,
											Неопределено);
		
		Если ПроверитьВсеРеквизитыРазрешеныДляРедактирования(Источник, ПараметрыЗапретаРедактирования) Тогда
			ТребуетсяПоискСсылокВИБ = Ложь;
		Иначе
			ТребуетсяПоискСсылокВИБ = НЕ ПроверитьИзменениеРеквизитовОбъекта(Источник, ПараметрыЗапретаРедактирования)
		КонецЕсли;
		
		Если ТребуетсяПоискСсылокВИБ И ЗапретРедактированияРеквизитовОбъектов.ПроверитьНаОбъектИмеютсяСсылкиВИБ(Источник.Ссылка) Тогда
			Отказ = Истина;
			ТекстСообщения = НСтр("ru = 'Попытка изменения реквизитов объекта, на который имеются ссылки в информационной базе'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Запрет редактирования реквизитов объекта'"),
									УровеньЖурналаРегистрации.Ошибка, , ,
									ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ПроверитьИзменениеРеквизитовОбъекта(знач Объект, знач ПараметрыЗапретаРедактирования)
	
	ИмяТипаОбъекта = Объект.Ссылка.Метаданные().Имя;
	
	Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(Объект.Ссылка)) Тогда
		БлокируемыеРеквизитыМассив = Справочники[ИмяТипаОбъекта].ПолучитьБлокируемыеРеквизитыОбъекта();
		ВыбиратьИз = "Справочник";
	ИначеЕсли Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Объект.Ссылка)) Тогда
		БлокируемыеРеквизитыМассив = Документы[ИмяТипаОбъекта].ПолучитьБлокируемыеРеквизитыОбъекта();
		ВыбиратьИз = "Документ";
	ИначеЕсли ПланыВидовХарактеристик.ТипВсеСсылки().СодержитТип(ТипЗнч(Объект.Ссылка)) Тогда
		БлокируемыеРеквизитыМассив = ПланыВидовХарактеристик[ИмяТипаОбъекта].ПолучитьБлокируемыеРеквизитыОбъекта();
		ВыбиратьИз = "ПланВидовХарактеристик";
	ИначеЕсли ПланыСчетов.ТипВсеСсылки().СодержитТип(ТипЗнч(Объект.Ссылка)) Тогда
		БлокируемыеРеквизитыМассив = ПланыСчетов[ИмяТипаОбъекта].ПолучитьБлокируемыеРеквизитыОбъекта();
		ВыбиратьИз = "ПланСчетов";
	ИначеЕсли ПланыВидовРасчета.ТипВсеСсылки().СодержитТип(ТипЗнч(Объект.Ссылка)) Тогда
		БлокируемыеРеквизитыМассив = ПланыВидовРасчета[ИмяТипаОбъекта].ПолучитьБлокируемыеРеквизитыОбъекта();
		ВыбиратьИз = "ПланВидовРасчета";
	ИначеЕсли БизнесПроцессы.ТипВсеСсылки().СодержитТип(ТипЗнч(Объект.Ссылка)) Тогда
		БлокируемыеРеквизитыМассив = БизнесПроцессы[ИмяТипаОбъекта].ПолучитьБлокируемыеРеквизитыОбъекта();
		ВыбиратьИз = "БизнесПроцесс";
	ИначеЕсли Задачи.ТипВсеСсылки().СодержитТип(ТипЗнч(Объект.Ссылка)) Тогда
		БлокируемыеРеквизитыМассив = Задачи[ИмяТипаОбъекта].ПолучитьБлокируемыеРеквизитыОбъекта();
		ВыбиратьИз = "Задача";
	ИначеЕсли ПланыОбмена.ТипВсеСсылки().СодержитТип(ТипЗнч(Объект.Ссылка)) Тогда
		БлокируемыеРеквизитыМассив = ПланыОбмена[ИмяТипаОбъекта].ПолучитьБлокируемыеРеквизитыОбъекта();
		ВыбиратьИз = "ПланОбмена";
	КонецЕсли;
	
	Если ПараметрыЗапретаРедактирования = Неопределено Тогда
		ПараметрыЗапретаРедактирования = Новый Соответствие;
	КонецЕсли;
	
	ПроверяемыеРеквизитыМассив = Новый Массив;
	
	Для Каждого ИмяРеквизита Из БлокируемыеРеквизитыМассив Цикл
		РедактированиеРазрешено = ПараметрыЗапретаРедактирования.Получить(ИмяРеквизита);
		Если РедактированиеРазрешено = Неопределено ИЛИ РедактированиеРазрешено = Ложь Тогда
			ПроверяемыеРеквизитыМассив.Добавить(ИмяРеквизита);
		КонецЕсли;
	КонецЦикла;
	
	Если ПроверяемыеРеквизитыМассив.Количество() > 0 Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Объект.Ссылка,
			СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(ПроверяемыеРеквизитыМассив));
		Для Каждого ИмяРеквизита Из ПроверяемыеРеквизитыМассив Цикл
			Если ЗначениеЗаполнено(ЗначенияРеквизитов[ИмяРеквизита])
				И Объект[ИмяРеквизита] <> ЗначенияРеквизитов[ИмяРеквизита] Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ПроверитьВсеРеквизитыРазрешеныДляРедактирования(знач Источник, знач ПараметрыЗапретаРедактирования)
	
	Если ПараметрыЗапретаРедактирования = Неопределено Тогда
		Возврат Ложь;
	КОнецЕсли;
	
	МенеджерОМД = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Источник.Ссылка);
	БлокируемыеРеквизиты = МенеджерОМД.ПолучитьБлокируемыеРеквизитыОбъекта();
	
	Для Каждого БлокируемыйРеквизит Из БлокируемыеРеквизиты Цикл
		Если ПараметрыЗапретаРедактирования.Получить(БлокируемыйРеквизит) = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции
