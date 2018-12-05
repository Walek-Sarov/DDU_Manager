Функция ПроверитьВозможностьСписанияТМЦ(ОбъектДанных, ВидДокумента = "") Экспорт;
	Отказ = Ложь;
	
	Если ВидДокумента = "" Тогда
		ВидДокумента = "удуСписаниеТМЦ"
	КонецЕсли;
	 
    Запрос = Новый Запрос;
	// <ВидДокумента>
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ДокументСписанияТЧ.Номенклатура КАК Номенклатура,
		|	СУММА(ДокументСписанияТЧ.Количество) КАК Количество,
		|	ВЫБОР
		|		КОГДА ДокументСписанияТЧ.Ссылка.СкладыВТабличнойЧасти = ИСТИНА
		|			ТОГДА ДокументСписанияТЧ.Склад
		|		ИНАЧЕ ДокументСписанияТЧ.Ссылка.Склад
		|	КОНЕЦ КАК Склад,
		|	МАКСИМУМ(ДокументСписанияТЧ.НомерСтроки) КАК НомерСтроки,
		|	ДокументСписанияТЧ.Номенклатура.ЕдиницаИзмерения,
		|	ДокументСписанияТЧ.ИнвентарныйНомер,
		|	""ТМЦ"" КАК ТабЧасть,
		|	ДокументСписанияТЧ.Ссылка.КВД
		|ПОМЕСТИТЬ ТабДок
		|ИЗ
		|	Документ.<ВидДокумента>.ТМЦ КАК ДокументСписанияТЧ
		|ГДЕ
		|	ДокументСписанияТЧ.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ДокументСписанияТЧ.Номенклатура,
		|	ВЫБОР
		|		КОГДА ДокументСписанияТЧ.Ссылка.СкладыВТабличнойЧасти = ИСТИНА
		|			ТОГДА ДокументСписанияТЧ.Склад
		|		ИНАЧЕ ДокументСписанияТЧ.Ссылка.Склад
		|	КОНЕЦ,
		|	ДокументСписанияТЧ.Номенклатура.ЕдиницаИзмерения,
		|	ДокументСписанияТЧ.ИнвентарныйНомер,
		|	ДокументСписанияТЧ.Ссылка.КВД
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДокументСписанияТЧ_УЕд.УчетнаяЕдиница,
		|	СУММА(ДокументСписанияТЧ_УЕд.Количество),
		|	ВЫБОР
		|		КОГДА ДокументСписанияТЧ_УЕд.Ссылка.СкладыВТабличнойЧасти = ИСТИНА
		|			ТОГДА ДокументСписанияТЧ_УЕд.Склад
		|		ИНАЧЕ ДокументСписанияТЧ_УЕд.Ссылка.Склад
		|	КОНЕЦ,
		|	МАКСИМУМ(ДокументСписанияТЧ_УЕд.НомерСтроки),
		|	""Ед."",
		|	ДокументСписанияТЧ_УЕд.ИнвентарныйНомер,
		|	""УчетныеЕдиницы"",
		|	ДокументСписанияТЧ_УЕд.Ссылка.КВД
		|ИЗ
		|	Документ.<ВидДокумента>.УчетныеЕдиницы КАК ДокументСписанияТЧ_УЕд
		|
		|СГРУППИРОВАТЬ ПО
		|	ДокументСписанияТЧ_УЕд.УчетнаяЕдиница,
		|	ВЫБОР
		|		КОГДА ДокументСписанияТЧ_УЕд.Ссылка.СкладыВТабличнойЧасти = ИСТИНА
		|			ТОГДА ДокументСписанияТЧ_УЕд.Склад
		|		ИНАЧЕ ДокументСписанияТЧ_УЕд.Ссылка.Склад
		|	КОНЕЦ,
		|	ДокументСписанияТЧ_УЕд.ИнвентарныйНомер,
		|	ДокументСписанияТЧ_УЕд.Ссылка.КВД
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура,
		|	Количество
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТабДок.Номенклатура,
		|	ТабДок.Количество,
		|	ТабДок.Склад,
		|	ЕСТЬNULL(удуТМЦ_НаСкладахОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
		|	ТабДок.НомерСтроки КАК НомерСтроки,
		|	ТабДок.НоменклатураЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ТабДок.ИнвентарныйНомер,
		|	ТабДок.ТабЧасть
		|ИЗ
		|	ТабДок КАК ТабДок
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.удуТМЦ_НаСкладах.Остатки(
		|				&ДатаДок,
		|				(Номенклатура, Склад, КВД) В
		|					(ВЫБРАТЬ
		|						ТабДок.Номенклатура,
		|						ТабДок.Склад,
		|						ТабДок.КВД
		|					ИЗ
		|						ТабДок КАК ТабДок)) КАК удуТМЦ_НаСкладахОстатки
		|		ПО ТабДок.Номенклатура = удуТМЦ_НаСкладахОстатки.Номенклатура
		|			И ТабДок.Склад = удуТМЦ_НаСкладахОстатки.Склад
		|			И ТабДок.ИнвентарныйНомер = удуТМЦ_НаСкладахОстатки.ИнвентарныйНомер
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "<ВидДокумента>", ВидДокумента);	
	Запрос.Текст = ТекстЗапроса;	
	Запрос.УстановитьПараметр("Ссылка",  ОбъектДанных.Ссылка);
	Запрос.УстановитьПараметр("ДатаДок", ОбъектДанных.МоментВремени());

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();
 
	Пока ВыборкаДетальныеЗаписи.Следующий()  Цикл
		
		Если  ВыборкаДетальныеЗаписи.КоличествоОстаток < ВыборкаДетальныеЗаписи.Количество Тогда		
			Отклонение =  ВыборкаДетальныеЗаписи.Количество - ВыборкаДетальныеЗаписи.КоличествоОстаток; 
			ТекстСообщения = "На складе """ + ВыборкаДетальныеЗаписи.Склад + """ не хватает позиций номенклатуры!" + Символы.ПС
							 + "По строке №" + ВыборкаДетальныеЗаписи.НомерСтроки + ": не хватает "
							 + Отклонение + " " + ВыборкаДетальныеЗаписи.ЕдиницаИзмерения + " номенклатуры """ 
							 + ВыборкаДетальныеЗаписи.Номенклатура + """"
							 + ?(ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ИнвентарныйНомер), Строка(" (инв. номер:" + ВыборкаДетальныеЗаписи.ИнвентарныйНомер.Наименование + ") ") ,"")
							 + Символы.ПС 
							 + "------------------------------------------------------------------"
							 + Символы.ПС
							 + "Всего списывается документом: " + ВыборкаДетальныеЗаписи.Количество
							 + " " + ВыборкаДетальныеЗаписи.ЕдиницаИзмерения + ", "
							 + Символы.ПС
							 + "На складе имеется: " + (ВыборкаДетальныеЗаписи.КоличествоОстаток)
							 + " " + ВыборкаДетальныеЗаписи.ЕдиницаИзмерения
			                 + Символы.ПС 
							 + "------------------------------------------------------------------"
							 + Символы.ПС
							 + "Быть может, поступление было по другому КФО?";
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = ТекстСообщения;
			Если ВыборкаДетальныеЗаписи.ТабЧасть = "ТМЦ" Тогда
				Сообщение.Поле  = "ТМЦ[" + (ВыборкаДетальныеЗаписи.НомерСтроки - 1) + "].Количество";
			Иначе
				Сообщение.Поле  = "УчетныеЕдиницы[" + (ВыборкаДетальныеЗаписи.НомерСтроки - 1) + "].Количество"
			КонецЕсли;
			Сообщение.УстановитьДанные(ОбъектДанных);
			Сообщение.Сообщить();
			
			Отказ = Истина;
		КонецЕсли;
		
	КонецЦикла;

	
Возврат(Отказ);	
	
	
КонецФункции