////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФормуМодально("Справочник.УчетныеЗаписиЭлектроннойПочты.ФормаОбъекта", Новый Структура("Ключ", УчетнаяЗапись()));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция УчетнаяЗапись()
	
	Возврат РаботаСПочтовымиСообщениями.ПолучитьСистемнуюУчетнуюЗапись();
	
КонецФункции
