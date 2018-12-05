&НаКлиенте
Перем мПредставлениеПустогоРасписания;

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	мПредставлениеПустогоРасписания = Строка(Новый РасписаниеРегламентногоЗадания);
	ОбновитьПредставлениеРасписания();
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеРегламентногоЗадания(Команда)
	РедактированиеРасписанияРегламентногоЗадания();
	ОбновитьПредставлениеРасписания();
КонецПроцедуры

&НаКлиенте
Процедура РедактированиеРасписанияРегламентногоЗадания()
	
	// если расписание не инициализировано в форме на сервере, то создаем новое
	Если РасписаниеРегламентногоЗадания = Неопределено Тогда
		
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
		
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	
	// открываем диалог для редактирования Расписания
	Если Диалог.ОткрытьМодально() Тогда
		
		РасписаниеРегламентногоЗадания = Диалог.Расписание;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредставлениеРасписания()
	
	ПредставлениеРасписания = Строка(РасписаниеРегламентногоЗадания);
	
	Если ПредставлениеРасписания = мПредставлениеПустогоРасписания Тогда
		
		ПредставлениеРасписания = НСтр("ru = 'Расписание не задано'");
		
	КонецЕсли;
	
	Элементы.НастроитьРасписаниеРегламентногоЗадания.Заголовок = ПредставлениеРасписания;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТипПлатформыСервера = РаботаСФайламиПовтИсп.ТипПлатформыСервера();
	Если ТипПлатформыСервера = ТипПлатформы.Windows_x86 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
		Элементы.ТаблицаНастроекКаталогWindows.АвтоОтметкаНезаполненного = Истина;
	Иначе
		Элементы.ТаблицаНастроекКаталогLinux.АвтоОтметкаНезаполненного = Истина;
	КонецЕсли;	
	
	РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
	
	// тут читаем из параметров регл задания - если оно есть
	РегламентноеЗаданиеОбъект = НайтиРегламентноеЗадание();
	
	Если РегламентноеЗаданиеОбъект <> Неопределено Тогда
		
		РасписаниеРегламентногоЗадания = РегламентноеЗаданиеОбъект.Расписание;
		МассивПараметров = РегламентноеЗаданиеОбъект.Параметры;
		
		Если ТипЗнч(МассивПараметров) = Тип("Массив") И МассивПараметров.Количество() > 0 Тогда
			
			МассивНастроек = МассивПараметров[0];
			
			Для Каждого Настройка Из МассивНастроек Цикл
				Строка = ТаблицаНастроек.Добавить();
				Строка.КаталогLinux = Настройка.КаталогLinux;
				Строка.КаталогWindows = Настройка.КаталогWindows;
				Строка.Папка = Настройка.Папка;
				Строка.Пользователь = Настройка.Пользователь;
			КонецЦикла;	
			
		КонецЕсли;	
		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	// тут проверяем что все заполнено
	ОчиститьСообщения();
	
	Если ЗаписатьПараметрыРегламентногоЗадания() Тогда
		Закрыть(КодВозвратаДиалога.ОК);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Функция ЗаписатьПараметрыРегламентногоЗадания()
	
	МассивПараметров = Новый Массив;
	МассивНастроек = Новый Массив;
	НайденыОшибки = Ложь;
	
	ВсеПутиWindows = Новый Соответствие;
	ВсеПутиLinux = Новый Соответствие;
	
	Индекс = 0;
	Для Каждого Настройка Из ТаблицаНастроек Цикл
		
		СтруктураНастройки = Новый Структура("КаталогLinux, КаталогWindows, Папка, Пользователь", 
			Настройка.КаталогLinux, Настройка.КаталогWindows, Настройка.Папка, Настройка.Пользователь);
			
		КаталогНаДиске = "";
		ТипПлатформыСервера = РаботаСФайламиПовтИсп.ТипПлатформыСервера();
		Если ТипПлатформыСервера = ТипПлатформы.Windows_x86 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
			
			КаталогНаДиске = Настройка.КаталогWindows;
			
			Если Не ПустаяСтрока(Настройка.КаталогWindows) Тогда
				
				Если ВсеПутиWindows.Получить(Настройка.КаталогWindows) <> Неопределено Тогда
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Неуникальный путь к каталогу Microsoft Windows: ""%1""'"), 
						Настройка.КаталогWindows);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ТаблицаНастроек");
					НайденыОшибки = Истина;
				Иначе	
					ВсеПутиWindows.Вставить(Настройка.КаталогWindows, 1);
				КонецЕсли;	
				
			КонецЕсли;

			Если Не ПустаяСтрока(Настройка.КаталогLinux) Тогда
				
				Если ВсеПутиLinux.Получить(Настройка.КаталогLinux) <> Неопределено Тогда
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Неуникальный путь к каталогу Linux: ""%1""'"), 
						Настройка.КаталогLinux);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ТаблицаНастроек");
				Иначе	
					ВсеПутиLinux.Вставить(Настройка.КаталогLinux, 1);
				КонецЕсли;	
				
			КонецЕсли;
			
			Если Не ПустаяСтрока(Настройка.КаталогWindows) И (Лев(Настройка.КаталогWindows, 2) <> "\\" ИЛИ Найти(Настройка.КаталогWindows, ":") <> 0) Тогда
				
				ТекстОшибки = НСтр("ru = 'Путь к тому должен быть в формате UNC (\\servername\resource) '");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ТаблицаНастроек");
				
				НайденыОшибки = Истина;
			КонецЕсли;	
			
		Иначе	
			КаталогНаДиске = Настройка.КаталогLinux;
		КонецЕсли;	
		
		Папка = Настройка.Папка;
		Пользователь = Настройка.Пользователь;
		
		Если ПустаяСтрока(КаталогНаДиске) Тогда
			
			ТекстОшибки = "";
			Если ТипПлатформыСервера = ТипПлатформы.Windows_x86 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
				ТекстОшибки = НСтр("ru = 'Не заполнен путь к каталогу Microsoft Windows на диске'");
			Иначе	
				ТекстОшибки = НСтр("ru = 'Не заполнен путь к каталогу Linux на диске'");
			КонецЕсли;	
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ТаблицаНастроек");
			
			НайденыОшибки = Истина;
		КонецЕсли;	
		
		Если Папка.Пустая() Тогда
			
			ТекстОшибки = НСтр("ru = 'Не заполнена папка'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ТаблицаНастроек");
			
			НайденыОшибки = Истина;
		КонецЕсли;	
		
		Если Пользователь.Пустая() Тогда
			ТекстОшибки = НСтр("ru = 'Не заполнен пользователь'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ТаблицаНастроек");
			
			НайденыОшибки = Истина;
		КонецЕсли;	
			
		МассивНастроек.Добавить(СтруктураНастройки);
		
		Индекс = Индекс + 1;
	КонецЦикла;	
	
	Если НайденыОшибки Тогда
		Возврат Ложь;
	КонецЕсли;	
		
	РегламентноеЗаданиеОбъект = СоздатьРегламентноеЗаданиеПриНеобходимости();
	РегламентноеЗаданиеОбъект.Расписание = РасписаниеРегламентногоЗадания;
		
	МассивПараметров.Добавить(МассивНастроек);
	РегламентноеЗаданиеОбъект.Параметры = МассивПараметров;
	
	
	РегламентноеЗаданиеОбъект.Записать();
	Возврат Истина;
КонецФункции

&НаСервере
Функция СоздатьРегламентноеЗаданиеПриНеобходимости()
	
	РегламентноеЗаданиеОбъект = НайтиРегламентноеЗадание();
	
	// при необходимости создаем регл. задание
	Если РегламентноеЗаданиеОбъект = Неопределено Тогда
		РегламентноеЗаданиеОбъект = РегламентныеЗадания.СоздатьРегламентноеЗадание("ЗагрузкаФайлов");
		РегламентноеЗаданиеОбъект.Наименование = "ЗагрузкаФайлов";
	КонецЕсли;
	
	Возврат РегламентноеЗаданиеОбъект;
	
КонецФункции

&НаСервере
Функция НайтиРегламентноеЗадание()
	
	РегламентноеЗаданиеОбъект = Неопределено;
	
	Отбор = Новый Структура("Наименование", "ЗагрузкаФайлов");
	МассивЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	Если МассивЗаданий.Количество() <> 0 Тогда
		РегламентноеЗаданиеОбъект = МассивЗаданий[0];
	КонецЕсли;
	
	Возврат РегламентноеЗаданиеОбъект;
	
КонецФункции
