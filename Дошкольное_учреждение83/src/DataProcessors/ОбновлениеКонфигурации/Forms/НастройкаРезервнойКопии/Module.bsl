////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
	ОбновитьСостояниеЭлементовУправления(ЭтаФорма);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПолеКаталогРезервнойКопииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Каталог = ОбновлениеКонфигурацииКлиент.ПолучитьКаталогФайла(Объект.ИмяКаталогаРезервнойКопииИБ);
	Диалог.ПроверятьСуществованиеФайла = Истина;
	Диалог.Заголовок = НСтр("ru = 'Выбор каталога резервной копии ИБ'");
	
	Если Диалог.Выбрать() Тогда
		Объект.ИмяКаталогаРезервнойКопииИБ = Диалог.Каталог;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздаватьРезервнуюКопиюПриИзменении(Элемент)
	ОбновитьСостояниеЭлементовУправления(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ВосстанавливатьИнформационнуюБазуПриИзменении(Элемент)
	ОбновитьНадписьРучногоОтката(ЭтаФорма);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура КомандаОК(Команда)
	Отказ = Ложь;
	Если Объект.СоздаватьРезервнуюКопию = 2 Тогда
		Файл	= Новый Файл(Объект.ИмяКаталогаРезервнойКопииИБ);
		Отказ	= НЕ Файл.Существует() ИЛИ НЕ Файл.ЭтоКаталог();
		Если Отказ Тогда
			Предупреждение(НСтр("ru = 'Укажите существующий каталог для сохранения резервной копии ИБ.'"));
			ТекущийЭлемент = Элементы.ПолеКаталогРезервнойКопии;
		КонецЕсли; 
	КонецЕсли;
	Если Не Отказ Тогда
		Закрыть(Новый Структура("СоздаватьРезервнуюКопию, ИмяКаталогаРезервнойКопииИБ, ВосстанавливатьИнформационнуюБазу",
			Объект.СоздаватьРезервнуюКопию,	Объект.ИмяКаталогаРезервнойКопииИБ, Объект.ВосстанавливатьИнформационнуюБазу));
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСостояниеЭлементовУправления(Форма)
	
	Форма.Элементы.ПолеКаталогРезервнойКопии.АвтоОтметкаНезаполненного = (Форма.Объект.СоздаватьРезервнуюКопию = 2);
	Форма.Элементы.ПолеКаталогРезервнойКопии.Доступность = (Форма.Объект.СоздаватьРезервнуюКопию = 2);
	ИнфоСтраницы = Форма.Элементы.ПанельИнформация.ПодчиненныеЭлементы;
	СоздаватьРезервнуюКопию = Форма.Объект.СоздаватьРезервнуюКопию;
	ПанельИнформация = Форма.Элементы.ПанельИнформация;
	Если СоздаватьРезервнуюКопию = 0 Тогда // не создавать
		Форма.Объект.ВосстанавливатьИнформационнуюБазу = Ложь;
		ПанельИнформация.ТекущаяСтраница = ИнфоСтраницы.БезОтката;
	ИначеЕсли СоздаватьРезервнуюКопию = 1 Тогда // создавать временную
		ПанельИнформация.ТекущаяСтраница = ИнфоСтраницы.РучнойОткат;
		ОбновитьНадписьРучногоОтката(Форма);
	ИначеЕсли СоздаватьРезервнуюКопию = 2 Тогда // создавать в указанном каталоге
		Форма.Объект.ВосстанавливатьИнформационнуюБазу = Истина;
		ПанельИнформация.ТекущаяСтраница = ИнфоСтраницы.АвтоматическийОткат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьНадписьРучногоОтката(Форма)
	СтраницыНадписи = Форма.Элементы.СтраницыНадписиРучногоОтката.ПодчиненныеЭлементы;
	Форма.Элементы.СтраницыНадписиРучногоОтката.ТекущаяСтраница = ?(Форма.Объект.ВосстанавливатьИнформационнуюБазу,
		СтраницыНадписи.Восстанавливать, СтраницыНадписи.НеВосстанавливать);
КонецПроцедуры

