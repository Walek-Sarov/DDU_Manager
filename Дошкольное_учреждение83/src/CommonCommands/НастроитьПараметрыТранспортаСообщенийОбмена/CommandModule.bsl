////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Отбор              = Новый Структура("Узел", ПараметрКоманды);
	ЗначенияЗаполнения = Новый Структура("Узел", ПараметрКоманды);
	
	ОбменДаннымиКлиент.ОткрытьФормуЗаписиРегистраСведенийПоОтбору(Отбор, ЗначенияЗаполнения, "НастройкиТранспортаОбмена", ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры
