////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПрисоединенныеФайлы.ПриСозданииНаСервереПрисоединенныйФайл(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПерейтиКФормеФайла(Команда)
	
	ПрисоединенныеФайлыКлиент.ПерейтиКФормеПрисоединенногоФайла(ЭтаФорма);
	
КонецПроцедуры
