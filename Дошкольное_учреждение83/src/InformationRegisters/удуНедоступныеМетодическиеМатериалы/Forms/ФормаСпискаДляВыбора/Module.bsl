
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Рез = Новый Структура();
	Рез.Вставить("ИнвНомер",Элементы.Список.ТекущиеДанные.ИнвентарныйНомер);
	Рез.Вставить("УчетнаяЕдиница",Элементы.Список.ТекущиеДанные.УчетнаяЕдиница);
	Закрыть(Рез);
КонецПроцедуры
