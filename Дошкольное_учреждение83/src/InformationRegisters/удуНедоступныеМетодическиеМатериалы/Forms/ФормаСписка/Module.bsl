
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.ТекстЗапроса = "
		|ВЫБРАТЬ
		|	РегистрСведенийудуНедоступныеМетодическиеМатериалы.ИнвентарныйНомер,
		|	РегистрСведенийудуНедоступныеМетодическиеМатериалы.УчетнаяЕдиница,
		|	РегистрСведенийудуНедоступныеМетодическиеМатериалы.Дата,
		|	РегистрСведенийудуНедоступныеМетодическиеМатериалы.Примечание
		|ИЗ
		|	РегистрСведений.удуНедоступныеМетодическиеМатериалы КАК РегистрСведенийудуНедоступныеМетодическиеМатериалы
		|";	
	
КонецПроцедуры
