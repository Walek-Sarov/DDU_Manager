
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УправлениеВидимостью()
	
	Элементы.Склад.Видимость    = Не Объект.СкладыВТабличнойЧасти;
	Элементы.ТМЦСклад.Видимость = Объект.СкладыВТабличнойЧасти;
	
	Элементы.УчетныеЕдиницыСклад.Видимость = Объект.СкладыВТабличнойЧасти;
	 	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеВидимостью();
	
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ФОРМЫ

&НаКлиенте
Процедура СкладыВТабличнойЧастиПриИзменении(Элемент)
	
	УправлениеВидимостью();
	
КонецПроцедуры

