
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если РольДоступна("удуРаботаСЭлектроннойБиблиотекой")
		ИЛИ РольДоступна("ПолныеПрава") Тогда
		Элементы.Пользователь.ТолькоПросмотр = Ложь;
	Иначе
		Элементы.Пользователь.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательПриИзменении(Элемент) 	
	УстановитьОтборПоСотруднику();          	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательОчистка(Элемент, СтандартнаяОбработка)
	УстановитьОтборПоСотруднику();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоСотруднику()
	
	МетодическиеМатериалы.Отбор.Элементы.Очистить();
	
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		
		ЭлементОтбораДанных = МетодическиеМатериалы.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Читатель");
		ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.ПравоеЗначение = Сотрудник;
		ЭлементОтбораДанных.Использование = Истина;
		
	КонецЕсли;
	
КонецПроцедуры
