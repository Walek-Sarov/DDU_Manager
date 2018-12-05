
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ)
	
	// так было ранее
	мСокращенноеРабочееВремя = Ссылка.СокращенноеРабочееВремя;
	мГрафикПолногоРабочегоВремени = Ссылка.ГрафикПолногоРабочегоВремени;
	
КонецПроцедуры


Процедура ПриЗаписи(Отказ)
	
	мДлинаСуток = 86400; // в секундах
	возврат;
	Если НЕ ОбменДанными.Загрузка Тогда
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		СоответствиеИнтервалыРедактирования="";
		ТаблицаДляЗаписи="";
		мСокращенноеРабочееВремя="";
		мГрафикПолногоРабочегоВремени="";
		
		
		МассивМесяцев = Новый Массив;
		Для каждого Элемент Из СоответствиеИнтервалыРедактирования Цикл
			МассивМесяцев.Добавить(Элемент.Ключ)
		КонецЦикла; 
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("МассивМесяцев", МассивМесяцев);
		Запрос.УстановитьПараметр("парамТекущийГрафик", Ссылка);
		
		// Получим таблицу сведений о производственном календаре за нужные месяцы
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РегламентированныйПроизводственныйКалендарь.ДатаКалендаря,
		|	РегламентированныйПроизводственныйКалендарь.Пятидневка,
		|	РегламентированныйПроизводственныйКалендарь.Шестидневка,
		|	РегламентированныйПроизводственныйКалендарь.КалендарныеДни,
		|	РегламентированныйПроизводственныйКалендарь.ВидДня
		|ИЗ
		|	РегистрСведений.удуРегламентированныйПроизводственныйКалендарь КАК РегламентированныйПроизводственныйКалендарь
		|ГДЕ
		|	НАЧАЛОПЕРИОДА(РегламентированныйПроизводственныйКалендарь.ДатаКалендаря, МЕСЯЦ) В (&МассивМесяцев)";
		
		ПроизводственныйКалендарь = Запрос.Выполнить().Выгрузить();
		ПроизводственныйКалендарь.Индексы.Добавить("ДатаКалендаря");
		
		УсловнаяПродолжительностьДня = ДлительностьРабочейНедели / 5;
		// запишем отредактированные месяцы
		Для каждого Элемент из СоответствиеИнтервалыРедактирования Цикл
			
			ДатаИзСписка = Элемент.Ключ;
			
			ДатаНачалаИнтервалаИзСписка  = НачалоМесяца(ДатаИзСписка);
			ДатаОкончанияИнтервалаИзСписка = КонецМесяца(ДатаИзСписка);
			
			ДнейВИнтервале = Окр((ДатаОкончанияИнтервалаИзСписка - ДатаНачалаИнтервалаИзСписка) / мДлинаСуток);
			
			НаборЗаписейЗаДеньПоВремени = РегистрыСведений.удуГрафикиРаботыПоВидамВремени.СоздатьНаборЗаписей();
			НаборЗаписейЗаДеньПоВремени.Отбор.ГрафикРаботы.Значение       = Ссылка;
			НаборЗаписейЗаДеньПоВремени.Отбор.ГрафикРаботы.Использование  = Истина;
			НаборЗаписейЗаДеньПоВремени.Отбор.Месяц.Значение     	      = ДатаНачалаИнтервалаИзСписка;
			НаборЗаписейЗаДеньПоВремени.Отбор.Месяц.Использование         = Истина;
			НаборЗаписейЗаДеньПоВремени.Отбор.План.Значение				  = Истина;
			НаборЗаписейЗаДеньПоВремени.Отбор.План.Использование		  = Истина;
			СтруктураПоиска   = Новый Структура("Дата");
			
			Для инд = 0 по ДнейВИнтервале - 1 Цикл
				ИтогоЧасовВсего    = 0;
				ИтогоЧасовВечерних = 0;
				ИтогоЧасовНочных   = 0;
				
				индДата = ДатаНачалаИнтервалаИзСписка + инд * мДлинаСуток;
				
				СтруктураПоиска.Дата = индДата;
				НайденныеСтроки      = ТаблицаДляЗаписи.НайтиСтроки(СтруктураПоиска);
				// выбрали строки по дате, теперь будем их записывать
				Для каждого СтрокаТаблицаДляЗаписи   из НайденныеСтроки   Цикл
					
					КоличествоЧасовВсего     = СтрокаТаблицаДляЗаписи.Часы;
					КоличествоЧасовВечерних  = СтрокаТаблицаДляЗаписи.ВечерниеЧасы;
					КоличествоЧасовНочных    = СтрокаТаблицаДляЗаписи.НочныеЧасы;
					
					ИтогоЧасовВсего     = ИтогоЧасовВсего    + КоличествоЧасовВсего;
					ИтогоЧасовВечерних  = ИтогоЧасовВечерних + КоличествоЧасовВечерних;
					ИтогоЧасовНочных    = ИтогоЧасовНочных   + КоличествоЧасовНочных;
					
				КонецЦикла;
				
				ЗаписьПоВУВ = НаборЗаписейЗаДеньПоВремени.Добавить();
				ЗаписьПоВУВ.ГрафикРаботы      = Ссылка;
				ЗаписьПоВУВ.План			  = Истина;
				ЗаписьПоВУВ.Месяц			  = ДатаНачалаИнтервалаИзСписка;
				ЗаписьПоВУВ.ВидУчетаВремени   = Перечисления.удуВидыУчетаВремени.ПоДням;
				ЗаписьПоВУВ.Дата     = индДата;
				ЗаписьПоВУВ.ОсновноеЗначение  = ?(ИтогоЧасовВсего > 0, 1, 0);
				ЗаписьПоВУВ.ДополнительноеЗначение = ИтогоЧасовВсего;
				ЗаписьПоВУВ.ПроизводственныйКалендарьПятидневка     = Справочники.удуГрафикиРаботы.ОтмеченВРесурсеПроизводственногоКалендаря(индДата, "Пятидневка",   ПроизводственныйКалендарь);
				ЗаписьПоВУВ.ПроизводственныйКалендарьПятидневкаЧасы = УсловнаяПродолжительностьДня * ЗаписьПоВУВ.ПроизводственныйКалендарьПятидневка;
				ЗаписьПоВУВ.ПроизводственныйКалендарьШестиДневка    = Справочники.удуГрафикиРаботы.ОтмеченВРесурсеПроизводственногоКалендаря(индДата, "Шестидневка",  ПроизводственныйКалендарь);
				ЗаписьПоВУВ.ПроизводственныйКалендарьКалендарныеДни = Справочники.удуГрафикиРаботы.ОтмеченВРесурсеПроизводственногоКалендаря(индДата, "КалендарныеДни", ПроизводственныйКалендарь);
				
				ЗаписьПоВУВ = НаборЗаписейЗаДеньПоВремени.Добавить();
				ЗаписьПоВУВ.ГрафикРаботы          = Ссылка;
				ЗаписьПоВУВ.План				  = Истина;
				ЗаписьПоВУВ.Месяц			 	  = ДатаНачалаИнтервалаИзСписка;
				ЗаписьПоВУВ.ВидУчетаВремени       = Перечисления.удуВидыУчетаВремени.ПоЧасам;
				ЗаписьПоВУВ.Дата    			  = индДата;
				ЗаписьПоВУВ.ОсновноеЗначение      = ИтогоЧасовВсего;
				ЗаписьПоВУВ.ДополнительноеЗначение = ?(ИтогоЧасовВсего > 0, 1, 0);
				ЗаписьПоВУВ.ПроизводственныйКалендарьПятидневка     = Справочники.удуГрафикиРаботы.ОтмеченВРесурсеПроизводственногоКалендаря(индДата, "Пятидневка",   ПроизводственныйКалендарь);
				ЗаписьПоВУВ.ПроизводственныйКалендарьПятидневкаЧасы = УсловнаяПродолжительностьДня * ЗаписьПоВУВ.ПроизводственныйКалендарьПятидневка;
				ЗаписьПоВУВ.ПроизводственныйКалендарьШестиДневка    = Справочники.удуГрафикиРаботы.ОтмеченВРесурсеПроизводственногоКалендаря(индДата, "Шестидневка",  ПроизводственныйКалендарь);
				ЗаписьПоВУВ.ПроизводственныйКалендарьКалендарныеДни = Справочники.удуГрафикиРаботы.ОтмеченВРесурсеПроизводственногоКалендаря(индДата, "КалендарныеДни", ПроизводственныйКалендарь);
				
				ЗаписьПоВУВ = НаборЗаписейЗаДеньПоВремени.Добавить();
				ЗаписьПоВУВ.ГрафикРаботы      = Ссылка;
				ЗаписьПоВУВ.План			  = Истина;
				ЗаписьПоВУВ.Месяц			  = ДатаНачалаИнтервалаИзСписка;
				ЗаписьПоВУВ.ВидУчетаВремени   = Перечисления.удуВидыУчетаВремени.ПоВечернимЧасам;
				ЗаписьПоВУВ.Дата    		  = индДата;
				ЗаписьПоВУВ.ОсновноеЗначение  = ИтогоЧасовВечерних;
				// ПроизводственныйКалендарьПятидневка 
				// ПроизводственныйКалендарьШестиДневка
				// ПроизводственныйКалендарьКалендарныеДни
				// ДополнительноеЗначение
				// ОсновноеЗначениеНорма
				// ДополнительноеЗначениеНорма
				// не записываются для ПоВечернимЧасам
				
				ЗаписьПоВУВ = НаборЗаписейЗаДеньПоВремени.Добавить();
				ЗаписьПоВУВ.ГрафикРаботы      = Ссылка;
				ЗаписьПоВУВ.План			  = Истина;
				ЗаписьПоВУВ.Месяц			  = ДатаНачалаИнтервалаИзСписка;
				ЗаписьПоВУВ.ВидУчетаВремени   = Перечисления.удуВидыУчетаВремени.ПоНочнымЧасам;
				ЗаписьПоВУВ.Дата     = индДата;
				ЗаписьПоВУВ.ОсновноеЗначение  = ИтогоЧасовНочных;
				// ПроизводственныйКалендарьПятидневка 
				// ПроизводственныйКалендарьШестиДневка
				// ПроизводственныйКалендарьКалендарныеДни
				// ДополнительноеЗначение
				// ОсновноеЗначениеНорма
				// ДополнительноеЗначениеНорма
				// не записываются для ПоНочнымЧасам
				
			КонецЦикла;
			
			НаборЗаписейЗаДеньПоВремени.Записать(Истина);
			НаборЗаписейЗаДеньПоВремени.Очистить();
		КонецЦикла;
		
		ОбновлятьВесьНаборЗаписейКалендаря = (мСокращенноеРабочееВремя И Не мГрафикПолногоРабочегоВремени.Пустая()) Или (СокращенноеРабочееВремя И Не ГрафикПолногоРабочегоВремени.Пустая());
		// переписываем норму времени в остальных месяцах календаря
		Если ОбновлятьВесьНаборЗаписейКалендаря Тогда
			
			Запрос.Текст = 
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ГрафикиРаботыПоВидамВремени.Месяц
			|ИЗ
			|	РегистрСведений.удуГрафикиРаботыПоВидамВремени КАК ГрафикиРаботыПоВидамВремени
			|ГДЕ
			|	ГрафикиРаботыПоВидамВремени.ГрафикРаботы = &парамТекущийГрафик
			|	И (НЕ ГрафикиРаботыПоВидамВремени.Месяц В (&МассивМесяцев))";
			
			Выборка = Запрос.Выполнить().Выбрать();
			НаборЗаписейЗаДеньПоВремени = РегистрыСведений.удуГрафикиРаботыПоВидамВремени.СоздатьНаборЗаписей();
			НаборЗаписейЗаДеньПоВремени.Отбор.ГрафикРаботы.Использование  = Истина;
			НаборЗаписейЗаДеньПоВремени.Отбор.ГрафикРаботы.Значение		  = Ссылка;
			НаборЗаписейЗаДеньПоВремени.Отбор.Месяц.Использование         = Истина;
			
			Пока Выборка.Следующий() Цикл
				
				НаборЗаписейЗаДеньПоВремени.Отбор.Месяц.Значение = Выборка.Месяц;
				НаборЗаписейЗаДеньПоВремени.Прочитать();
				НаборЗаписейЗаДеньПоВремени.Записать(Истина);
				
			КонецЦикла;
			
		КонецЕсли;
		
		// Заполнение нормы времени для графиков сокращенного рабочего времени,
		// опирающихся на текущий график как график полного рабочего времени 
		Если Не СокращенноеРабочееВремя Тогда
			
			Запрос.Текст = 
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ГрафикиРаботы.Ссылка КАК ГрафикРаботы
			|ИЗ
			|	Справочник.удуГрафикиРаботы КАК ГрафикиРаботы
			|ГДЕ
			|	ГрафикиРаботы.ГрафикПолногоРабочегоВремени = &парамТекущийГрафик
			|	И ГрафикиРаботы.СокращенноеРабочееВремя";
			
			ВыборкаГрафик = Запрос.Выполнить().Выбрать();
			
			НаборЗаписейЗаДеньПоВремени = РегистрыСведений.удуГрафикиРаботыПоВидамВремени.СоздатьНаборЗаписей();
			НаборЗаписейЗаДеньПоВремени.Отбор.ГрафикРаботы.Использование  = Истина;
			НаборЗаписейЗаДеньПоВремени.Отбор.Месяц.Использование         = Истина;
			
			// переписываем норму времени для всех графиков сокращенного рабочего времени
			Пока ВыборкаГрафик.Следующий() Цикл
				НаборЗаписейЗаДеньПоВремени.Отбор.ГрафикРаботы.Значение = ВыборкаГрафик.ГрафикРаботы;
				Для каждого Элемент из СоответствиеИнтервалыРедактирования Цикл
					НаборЗаписейЗаДеньПоВремени.Отбор.Месяц.Значение = НачалоМесяца(Элемент.Ключ);
					НаборЗаписейЗаДеньПоВремени.Прочитать();
					НаборЗаписейЗаДеньПоВремени.Записать(Истина);
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
		
		ТаблицаДляЗаписи.Очистить();
		СоответствиеИнтервалыРедактирования.Очистить();
		
	КонецЕсли; 
КонецПроцедуры

