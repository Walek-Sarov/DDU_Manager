////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	АдминистраторИБ = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформацияОПользователе.Имя;
	Если ТипВызова = 1 или ТипВызова = 2 Тогда  
		Если ПараметрыРезервногоКопированияИБ.Свойство("ПарольАдминистратораИБ") Тогда 
			ПарольАдминистратораИБ = ПараметрыРезервногоКопированияИБ.ПарольАдминистратораИБ;
		КонецЕсли;	
	КонецЕсли;	
		
	Если Не ПустаяСтрока(ТекстПути) Тогда
		ПриОткрытииНовойСтраницы(Элементы.СтраницыПомощника.ТекущаяСтраница, ТекстПути);
	Иначе
		ПриОткрытииНовойСтраницы(Элементы.СтраницыПомощника.ТекущаяСтраница);
	КонецЕсли;
	
	УстановитьЗаголовокКнопкиДалее(Истина);
	
	ИмяФайлаЗапускаПриложенияВРежимеПредприятия = ПолучитьИмяФайлаЗапускаПриложенияВРежимеПредприятия();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ВызватьИсключение НСтр("ru = 'В клиент-серверном варианте работы резервное копирование следует выполнять сторонними средствами (средствами СУБД).'");
	КонецЕсли;
		
	НастройкиРезервногоКопирования = РезервноеКопированиеИБСервер.ПолучитьНастройкиРезервногоКопирования();
	Объект.КодТипаРезервногоКопирования = НастройкиРезервногоКопирования.ВыборПунктаНастройки;
	Объект.КодТипаИнтерактивногоРезервногоКопирования = 1;	
	Объект.ОчисткаКаталогаСРезервнымиКопиямиПриПереполнении = Истина;
	Объект.ПериодХраненияРезервныхКопий = 1;
	Объект.ЕдиницаИзмеренияПериодаХраненияРезервныхКопий = "Месяц";
	Объект.ПериодОтложенногоОповещения = 1;
	Объект.ЕдиницаИзмеренияПериодаОповещения = "День";
	Объект.ЕдиницаИзмеренияПериодаОтложенногоОповещения = "Час";
	Объект.ТипОграниченияКаталогаСРезервнымиКопиями = "ПоПериоду";
	Объект.ПериодОповещения = 1;
	Объект.ВариантРасписанияРезервногоКопирования = "1";
	Объект.НажатиеГиперссылки = Ложь;
	Расписание = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(НастройкиРезервногоКопирования.РасписаниеКопирования);
	Объект.СтрокаРасписания = Строка(Расписание);
	
	Если Параметры.Свойство("ТекстПути") Тогда
		ТекстПути= Параметры.ТекстПути;
		ТекущаяСтраница = Параметры.ТекущаяСтраница;
	Иначе
		ТекстПути = "";
		ТекущаяСтраница = "";
	КонецЕсли;
	Элементы.СтраницыПомощника.ТекущаяСтраница = ОпределитьСтраницуПоПравамИАрхитектуре();
	
	ТипВызова = 0;
	Если Параметры.Свойство("ТипВызова") Тогда
		
		ТипВызова = Параметры.ТипВызова;
		
		Если Параметры.ТипВызова = 1 Тогда
			Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы[Параметры.ТекущаяСтраница];
			Элементы.НадписьВремяОжиданияРезервногоКопирования.Заголовок = Параметры.ЗаголовокНадписи;
		КонецЕсли;
		
		Если Параметры.ТипВызова = 2 Тогда
			Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы[Параметры.ТекущаяСтраница];		
			Объект.КодТипаРезервногоКопирования = 3;
		КонецЕсли;
		
	КонецЕсли;
	
	Объект.КаталогСРезервнымиКопиями =НастройкиРезервногоКопирования.КаталогХраненияРезервныхКопий;
	Если НастройкиРезервногоКопирования.ПервыйЗапуск Тогда
		ТекстЗаголовка = НСтр("ru = 'Резервное копирование еще ни разу не проводилось'"); 
	Иначе
		ТекстЗаголовка = НСтр("ru = 'В последний раз резервное копирование проводилось: %1'"); 
		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить(Формат(РезервноеКопированиеИБСервер.ПолучитьНастройкиРезервногоКопирования().ДатаПоследнегоРезервногоКопирования,"ДЛФ=ДДВ"));
		ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(ТекстЗаголовка,МассивПараметров);
	КонецЕсли;
	
	Элементы.НадписьДатаПроведенияПоследнегоРезервногоКопирования.Заголовок = ТекстЗаголовка;
	
	Если Не ПустаяСтрока(ТекстПути) Тогда
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы[ТекущаяСтраница];
	Иначе
		Элементы.ПараметрыИнтерактивногоРезервногоКопирования.ТекущаяСтраница = Элементы.ПараметрыИнтерактивногоРезервногоКопирования.ПодчиненныеЭлементы.СтраницаКопированиеСейчас;
		Элементы.НадписьПояснениеКИнтерактивномуКопированию.Заголовок = НСтр("ru = 'Нажмите ""Далее"" для выполнения резервного копирования прямо сейчас.'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если  НЕ ОбработкаЗакрытияФормы() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	СоединенияИБВызовСервера.РазрешитьРаботуПользователей();
	ОтключитьОбработчикОжидания("ИстечениеВремениОжидания");
	ОтключитьОбработчикОжидания("ПроверкаНаЕдинственностьПодключения");	
	ОтключитьОбработчикОжидания("ЗавершитьРаботуПользователей");
	
	ПараметрыРезервногоКопированияИБ.ПроцессВыполняется = Ложь;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура НадписьСписокДействийНажатие(Элемент)
	
	ОткрытьФормуМодально("Обработка.АктивныеПользователи.Форма.ФормаСпискаАктивныхПользователей");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПользователейНажатие(Элемент)
	
	ОткрытьФормуМодально("Обработка.АктивныеПользователи.Форма.ФормаСпискаАктивныхПользователей");
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьЖурналРегистрацииНажатие(Элемент)
	
	ОткрытьФормуМодально("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации");
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательИнтерактивногоРезервногоКопированияПриИзменении(Элемент)
	
	ПараметрПереключения = Объект.КодТипаИнтерактивногоРезервногоКопирования;
	Если ПараметрПереключения = 1 Тогда
		УстановитьЗаголовокКнопкиДалее(Истина);
		Элементы.ПараметрыИнтерактивногоРезервногоКопирования.ТекущаяСтраница = Элементы.ПараметрыИнтерактивногоРезервногоКопирования.ПодчиненныеЭлементы.СтраницаКопированиеСейчас;
		Элементы.НадписьПояснениеКИнтерактивномуКопированию.Заголовок = НСтр("ru = 'Нажмите ""Далее"" для выполнения резервного копирования прямо сейчас.'");
	ИначеЕсли ПараметрПереключения = 2 Тогда
		УстановитьЗаголовокКнопкиДалее(Ложь);
		Элементы.ПараметрыИнтерактивногоРезервногоКопирования.ТекущаяСтраница = Элементы.ПараметрыИнтерактивногоРезервногоКопирования.ПодчиненныеЭлементы.СтраницаКопированиеПозднее;
		Элементы.НадписьПояснениеКИнтерактивномуКопированию.Заголовок = НСтр("ru = 'Нажмите ""Готово"", чтобы закрыть помощник. Резервное копирование будет проведено через указанный период.'");
	ИначеЕсли ПараметрПереключения = 3  Тогда
		УстановитьЗаголовокКнопкиДалее(Ложь);
		Элементы.ПараметрыИнтерактивногоРезервногоКопирования.ТекущаяСтраница = Элементы.ПараметрыИнтерактивногоРезервногоКопирования.ПодчиненныеЭлементы.СтраницаПустая;
		Элементы.НадписьПояснениеКИнтерактивномуКопированию.Заголовок = НСтр("ru = 'Нажмите ""Готово"", чтобы закрыть помощник. Резервное копирование начнется перед закрытием программы.'");
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьККаталогуАрхивовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыбранныйПуть = ПолучитьПуть(РежимДиалогаВыбораФайла.ВыборКаталога);
	Если Не ПустаяСтрока(ВыбранныйПуть) Тогда 
		Объект.КаталогСРезервнымиКопиями = ВыбранныйПуть;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НадписьПерейтиВЖурналРегистрации1Нажатие(Элемент)
	
	ОткрытьФормуМодально("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации");
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстПутиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(ТекстПути);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Далее(Команда)
	
	ОчиститьСообщения();
	
	ИнформацияОбОшибке = "";
	Если Не ПроверитьЗаполнениеРеквизитов(ИнформацияОбОшибке) и Не ПустаяСтрока(ИнформацияОбОшибке) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ИнформацияОбОшибке);
		Возврат;
	КонецЕсли;	

    ТекущаяСтраницаПомощника = Элементы.СтраницыПомощника.ТекущаяСтраница;
	Если ТекущаяСтраницаПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаВыполненияРезервногоКопирования Тогда
		
		ОбработатьВыборРежимаИнтерактивногоКопирования();
		УстановитьПутьАрхиваСКопиями(Объект.КаталогСРезервнымиКопиями, ПараметрыРезервногоКопированияИБ);
		
	ИначеЕсли ТекущаяСтраницаПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ДополнительныеНастройки Тогда
		ОбработатьВыборРежимаИнтерактивногоКопирования();
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	ТекущаяСтраницаПомощника = Элементы.СтраницыПомощника.ТекущаяСтраница;
	Если ТекущаяСтраницаПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ДополнительныеНастройки Тогда
		ПриОткрытииНовойСтраницы(Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаВыполненияРезервногоКопирования);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Функция ПолучитьИмяФайлаЗапускаПриложенияВРежимеПредприятия()
#Если ТонкийКлиент Тогда 
	Возврат "1cv8c.exe";
#Иначе
	Возврат "1cv8.exe";
#КонецЕсли
КонецФункции

// Обработчик изменения страницы помощника. Открывает новую страницу и выполняет необходимые действия.
// Параметры :
// НоваяСтраницаПомощника  - страница , которую необходимо открыть в данный момент.
&НаКлиенте
Процедура ПриОткрытииНовойСтраницы(НоваяСтраница, ТекстПути = "") 
	
	ПодчиненныеСтраницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы;	
	Если НоваяСтраница = ПодчиненныеСтраницы.СтраницаВыполненияРезервногоКопирования Тогда
		
		Элементы.АктивныеПользователи.Видимость = ПолучитьДоступность();
		Элементы.НадписьНетАктивныхПользователей.Видимость = Не (Элементы.АктивныеПользователи.Видимость);
		УстановитьЗаголовокКнопкиДалее(Истина);
		Элементы.Назад.Видимость = Ложь;
		
	ИначеЕсли  НоваяСтраница = ПодчиненныеСтраницы.СтраницаИнформацииИВыполненияРезервногоКопирования Тогда
		
		ПараметрыРезервногоКопированияИБ.ПроцессВыполняется = Истина;
		
		Элементы.Отмена.Доступность = Истина;
		ОбновитьКоличествоАктивныхПользователей();
		УстановитьЗаголовокКнопкиДалее(Истина);
		Элементы.Назад.Видимость = Ложь;
		Элементы.Далее.Доступность = Ложь;

		ИнформацияОбОшибке = "";
		Если Не ПроверитьЗаполнениеРеквизитов(ИнформацияОбОшибке) и Не ПустаяСтрока(ИнформацияОбОшибке) Тогда 
			Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаОшибокПриКопировании;
			ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(РезервноеКопированиеИБКлиент.СобытиеЖурналаРегистрации(),
				"Ошибка", ИнформацияОбОшибке, , Истина);
			Возврат;
		КонецЕсли;
		
		Если Не ПроверитьДоступКИБ() Тогда 
			Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаОшибокПриКопировании;
			Возврат;
		КонецЕсли;
		
		УстановитьБлокировкуСоединений = Истина;
		Если РезервноеКопированиеИБВызовСервера.ПолучитьКоличествоАктивныхПользователей() = 1 Тогда
			
			ОбщегоНазначенияКлиент.ПроверитьВключениеЖурналаРегистрации();
			СоединенияИБВызовСервера.УстановитьБлокировкуСоединений("Резервное копирование", "РезервноеКопирование");
			СоединенияИБКлиент.УстановитьПризнакРаботаПользователейЗавершается(УстановитьБлокировкуСоединений);
			ЗавершитьРаботуЭтогоСеанса(Ложь);
			
			НачатьРезервноеКопирование();
		Иначе
			ОчиститьСообщения();
			ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
			Если ДатаОтложенногоРезервногоКопирования <= ТекущаяДата Тогда
				
				НазванияСоединенийИБ = "";
				Если НЕ АктивныТолькоКлиентскиеПриложения(НазванияСоединенийИБ) Тогда
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Имеются активные сеансы, которые не могут быть завершены принудительно.
							|%1'"), 
						НазванияСоединенийИБ);
					Сообщить(ТекстСообщения);
				КонецЕсли;	
				
				СоединенияИБВызовСервера.УстановитьБлокировкуСоединений("Резервное копирование", "РезервноеКопирование");
				СоединенияИБКлиент.УстановитьОбработчикиОжиданияЗавершенияРаботыПользователей(УстановитьБлокировкуСоединений);
				УстановитьОбработчикОжиданияНачалаРезервногоКопирования();
				УстановитьОбработчикОжиданияИстеченияТаймаутаРезервногоКопирования();
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли НоваяСтраница = ПодчиненныеСтраницы.СтраницаОшибокПриКопировании 
		ИЛИ НоваяСтраница = ПодчиненныеСтраницы.СтраницаУспешногоВыполненияКопирования Тогда
		Элементы.Далее.Видимость= Ложь;
		Элементы.Отмена.Заголовок = НСтр("ru = 'Закрыть'");
		УстановитьРезультатРезервногоКопирования(ПараметрыРезервногоКопированияИБ);
		
	ИначеЕсли НоваяСтраница = ПодчиненныеСтраницы.ДополнительныеНастройки Тогда
		Элементы.Назад.Видимость = Истина;
		АдминистраторИБ = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформацияОПользователе.Имя;
		Если Объект.КодТипаИнтерактивногоРезервногоКопирования = 1 Тогда 
			Элементы.ПояснениеКДалее.Заголовок = НСтр("ru = 'Нажмите ""Далее"" для выполнения резервного копирования'");
			УстановитьЗаголовокКнопкиДалее(Истина);
		Иначе
			Элементы.ПояснениеКДалее.Заголовок = НСтр("ru = 'Нажмите ""Готово"", чтобы завершить настройку резервного копирования'");
			УстановитьЗаголовокКнопкиДалее(Ложь);
		КонецЕсли;	
	КонецЕсли;	
		
	Если НоваяСтраница = Неопределено Тогда
		Закрыть();
	Иначе
		Элементы.СтраницыПомощника.ТекущаяСтраница = НоваяСтраница;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьРезультатРезервногоКопирования(ПараметрыРезервногоКопирования)
	
	РезервноеКопированиеИБСервер.УстановитьРезультатРезервногоКопирования(ПараметрыРезервногоКопирования);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция АктивныТолькоКлиентскиеПриложения(ИменаАктивныхСеансов)
	
	Результат = Истина;
	НазванияСоединенийИБ = "";
	НомерТекущегоСеанса = НомерСеансаИнформационнойБазы();
	Для каждого Сеанс Из ПолучитьСеансыИнформационнойБазы() Цикл
		Если Сеанс.НомерСеанса = НомерТекущегоСеанса Тогда
			Продолжить;
		КонецЕсли;
		Если Сеанс.ИмяПриложения <> "1CV8" И Сеанс.ИмяПриложения <> "1CV8C" И
			Сеанс.ИмяПриложения <> "WebClient" Тогда
			ИменаАктивныхСеансов = ИменаАктивныхСеансов + Символы.ПС + "• " + Сеанс;
			Результат = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОповещениеПользователю(ТекстОповещения)
	
	ПоказатьОповещениеПользователя("Резервное копирование", , ТекстОповещения);
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьДоступКИБ()
	
	Результат = Истина;
	// В базовых версиях проверку подключения не осуществляем;
	// при некорректном вводе имени и пароля обновление завершится неуспешно.
	
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЭтоБазоваяВерсияКонфигурации Тогда
		Возврат Результат;
	КонецЕсли; 
	
	ПараметрыПодключения	= ПолучитьПараметрыАутентификацииАдминистратораОбновления();
	
	Попытка
		
		ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель(Ложь);
		ComConnector = Новый COMОбъект(СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИмяCOMСоединителя);
		СтрокаСоединенияИнформационнойБазы = ПараметрыПодключения.СтрокаСоединенияИнформационнойБазы + ПараметрыПодключения.СтрокаПодключения;
		Соединение = ComConnector.Connect(СтрокаСоединенияИнформационнойБазы);
		
	Исключение
		
		Результат = Ложь;
		Инфо = ИнформацияОбОшибке();
		ОбнаруженнаяОшибкаПодключения = КраткоеПредставлениеОшибки(Инфо);
		
		ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(РезервноеКопированиеИБКлиент.СобытиеЖурналаРегистрации(),
			"Ошибка",  ОбнаруженнаяОшибкаПодключения, , Истина);
		
	КонецПопытки;
	
	Если Результат Тогда
		Если ПараметрыРезервногоКопированияИБ.Свойство("АдминистраторИБ") Тогда 
			ПараметрыРезервногоКопированияИБ.АдминистраторИБ 		= АдминистраторИБ;
			ПараметрыРезервногоКопированияИБ.ПарольАдминистратораИБ = ПарольАдминистратораИБ;
		Иначе
			ПараметрыРезервногоКопированияИБ.Вставить("АдминистраторИБ", 		АдминистраторИБ);
			ПараметрыРезервногоКопированияИБ.Вставить("ПарольАдминистратораИБ", ПарольАдминистратораИБ);
		КонецЕсли;	
		РезервноеКопированиеИБВызовСервера.УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопированияИБ);
	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ПроверитьЗаполнениеРеквизитов(ИнформацияОбОшибке)
	
	Если ПустаяСтрока(Объект.КаталогСРезервнымиКопиями) Тогда
		ИнформацияОбОшибке = Нстр("ru = 'Не выбран каталог для резервной копии.'");
		Возврат Ложь;
	КонецЕсли;
	
	Если НайтиФайлы(Объект.КаталогСРезервнымиКопиями).Количество() = 0 Тогда
		ИнформацияОбОшибке = Нстр("ru = 'Указан несуществующий каталог.'");
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		ТестовыйФайл = Новый ЗаписьXML;
		ТестовыйФайл.ОткрытьФайл(Объект.КаталогСРезервнымиКопиями + "/test.test1С");
		ТестовыйФайл.ЗаписатьОбъявлениеXML();
		ТестовыйФайл.Закрыть();
	Исключение
		ИнформацияОбОшибке = Нстр("ru = 'Нет доступа к каталогу с резервными копиями.'");
		Возврат Ложь;
	КонецПопытки;
	
	Попытка
		УдалитьФайлы(Объект.КаталогСРезервнымиКопиями, "*.test1С");
	Исключение
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции	

// Обработчик значения переключателя "Код типа резервного копирования" при нажатии на кнопку "Далее".
&НаКлиенте
Процедура ОбработатьВыборРежимаИнтерактивногоКопирования()
	
	НоваяСтраницаПомощника = Неопределено;
	
	Если НЕ ПроверитьДоступКИБ()  Тогда
		НоваяСтраницаПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.ДополнительныеНастройки;
		ПриОткрытииНовойСтраницы(НоваяСтраницаПомощника);
		Возврат;
	КонецЕсли;

	КодПереключателя = Объект.КодТипаИнтерактивногоРезервногоКопирования;
	
	Если КодПереключателя = 1 Тогда
		
		НоваяСтраницаПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаИнформацииИВыполненияРезервногоКопирования;
		
	ИначеЕсли КодПереключателя = 2 Тогда
		
		ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
		ПериодОтложенногоКопирования = ТекущаяДата + (Объект.ПериодОтложенногоОповещения*ПолучитьПериодОтложенногоКопирования());
		ДатаОтложенногоРезервногоКопирования = ПериодОтложенногоКопирования;
		РезервноеКопированиеИБКлиент.ПодключитьОжиданиеРезервногоКопирования();
		ОповещениеПользователю(НСтр("ru ='Резервное копирование будет проведено через указанный срок.'"));
		
	ИначеЕсли КодПереключателя = 3 Тогда
		
		ОповещатьОРезервномКопированииПриЗавершенииСеанса = Истина;
		ОповещениеПользователю(НСтр("ru ='Резервное копирование будет проведено при завершении работы программы.'"));
		
	КонецЕсли;
	ПриОткрытииНовойСтраницы(НоваяСтраницаПомощника);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПериодОтложенногоКопирования()
	
	ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	ПериодОповещения = ?(Объект.ЕдиницаИзмеренияПериодаОтложенногоОповещения = "Месяц", 
		(ДобавитьМесяц(ТекущаяДата, Объект.ПериодОтложенногоОповещения) - ТекущаяДата), 
		ПолучитьВременнойПараметрПоСтроке(Объект.ЕдиницаИзмеренияПериодаОтложенногоОповещения));
	Возврат ПериодОповещения;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьВременнойПараметрПоСтроке(СтрокаПараметра)
	
	Возврат РезервноеКопированиеИБСервер.ПолучитьВременнойПараметрПоСтроке(СтрокаПараметра);
	
КонецФункции

&НаКлиенте
Процедура УстановитьОбработчикОжиданияИстеченияТаймаутаРезервногоКопирования()
	
	ПодключитьОбработчикОжидания("ИстечениеВремениОжидания", 300, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИстечениеВремениОжидания()
	
	ОтключитьОбработчикОжидания("ПроверкаНаЕдинственностьПодключения");
	ТекстВопроса = НСтр("ru = 'Не удалось отключить всех пользователей от базы. Провести резервное копирование? (возможны ошибки при архивации)'");
	ТекстПояснения = НСтр("ru = 'Не удалось отключить пользователя.'");
	Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Нет, ТекстПояснения, КодВозвратаДиалога.Нет);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		НачатьРезервноеКопирование();
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьОбработчикОжиданияНачалаРезервногоКопирования()
	
	ПодключитьОбработчикОжидания("ПроверкаНаЕдинственностьПодключения", 30);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаНаЕдинственностьПодключения()
	
	КоличествоПользователей = РезервноеКопированиеИБВызовСервера.ПолучитьКоличествоАктивныхПользователей();
	Элементы.КоличествоАктивныхПользователей.Заголовок = Строка(КоличествоПользователей);
	Если КоличествоПользователей = 1 Тогда
		НачатьРезервноеКопирование();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовокКнопкиДалее(ПараметрЗаголовка)
	
	Если ПараметрЗаголовка Тогда
		Элементы.Далее.Заголовок = НСтр("ru = 'Далее >>'");
	Иначе
		Элементы.Далее.Заголовок = НСтр("ru = 'Готово'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПуть(РежимДиалога)
	
	Режим = РежимДиалога;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	Если Режим = РежимДиалогаВыбораФайла.ВыборКаталога Тогда
		ДиалогОткрытияФайла.Заголовок= НСтр("ru = 'Выберите каталог'");
	Иначе
		ДиалогОткрытияФайла.Заголовок= НСтр("ru = 'Выберите файл'");
	КонецЕсли;	
		
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		Если РежимДиалога = РежимДиалогаВыбораФайла.ВыборКаталога тогда
			Возврат ДиалогОткрытияФайла.Каталог;
		Иначе
			Возврат ДиалогОткрытияФайла.ПолноеИмяФайла;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьКоличествоАктивныхПользователей()
	
	Элементы.КоличествоАктивныхПользователей.Заголовок = РезервноеКопированиеИБВызовСервера.ПолучитьКоличествоАктивныхПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьРезервноеКопирование() 
	
	ПриИзмененииВремениОповещения(0, 0, ПараметрыРезервногоКопированияИБ);
	ИмяГлавногоФайлаСкрипта = СформироватьФайлыСкриптаОбновления();
	
	ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(РезервноеКопированиеИБКлиент.СобытиеЖурналаРегистрации(),
		"Информация",  НСтр("ru = 'Выполняется резервное копирование информационной базы: '") + ИмяГлавногоФайлаСкрипта);
		
	Закрыть();
	ПропуститьПредупреждениеПередЗавершениемРаботыСистемы = Истина;
	
	ЗавершитьРаботуСистемы(Ложь);
	ЗапуститьПриложение("""" + ИмяГлавногоФайлаСкрипта + """",	РезервноеКопированиеИБКлиент.ПолучитьКаталогФайла(ИмяГлавногоФайлаСкрипта));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВерсиюКомпоненты(Команда)
	
	ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель();
	
КонецПроцедуры

&НаКлиенте
Функция ОбработкаЗакрытияФормы()
	
	ТекущаяСтраница = Элементы.СтраницыПомощника.ТекущаяСтраница;
	Если ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаИнформацииИВыполненияРезервногоКопирования Тогда
		
		ТекстВопроса = НСтр("ru = 'Прервать подготовку к резервному копированию данных?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет, НСтр("ru = 'Отмена резервного копирования.'"));
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	Возврат Истина;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Обработчики событий формы на сервере и изменения настроек резервного копирования.

// Возвращает страницу, которая должна быть показана пользователю при открытии окна помощника.
// Если ПолныеПрава - тогда попадаем на функциональную страницу. 
// Если нет - тогда на информационную страницу с просьбой обратиться к сис. администратору.
// Состав элементов функциональной страницы зависит от архитектуры информационной базы.
&НаСервере
Функция ОпределитьСтраницуПоПравамИАрхитектуре()
	
	СтраницыПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы;
	СтартоваяСтраница = Неопределено;
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
			СтартоваяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаВыполненияРезервногоКопирования;
		КонецЕсли;
	Иначе
		СтартоваяСтраница = СтраницыПомощника.СтраницаДляПользователяБезПрав;
	КонецЕсли;
	Возврат СтартоваяСтраница;	
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПриИзмененииВремениОповещения(ПараметрКоличества, ПараметрТипа, ПараметрыРезервногоКопированияИБНаКлиенте)	
	
	ПараметрыОповещенияОРезервномКопировании = РезервноеКопированиеИБСервер.ПолучитьНастройкиРезервногоКопирования();
	ТекущаяДата = ТекущаяДатаСеанса();
	Если ПараметрКоличества = -1 Тогда // если пользователь отказался от оповещений
		ОстановитьСервисОповещенияОРезервномКопировании();
	ИначеЕсли ПараметрКоличества = 0 Тогда // если пользователь отказался от копирования, но хочет получать оповещения
		ПараметрыОповещенияОРезервномКопировании.ДатаПоследнегоОповещения = ТекущаяДата;		
	Иначе	
		ПараметрыОповещенияОРезервномКопировании.ДатаПоследнегоОповещения = ТекущаяДата;
		ПараметрыОповещенияОРезервномКопировании.ПериодОповещения = ПараметрКоличества * 
			?(ПараметрТипа = "Месяц", 
				(ДобавитьМесяц(ТекущаяДата, ПараметрКоличества) - ТекущаяДата), 
				РезервноеКопированиеИБСервер.ПолучитьВременнойПараметрПоСтроке(ПараметрТипа));
	КонецЕсли;
	ПараметрыОповещенияОРезервномКопировании.НастроеноПользователем = Истина;
	ПараметрыРезервногоКопированияИБНаКлиенте = ПараметрыОповещенияОРезервномКопировании;
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(ПараметрыОповещенияОРезервномКопировании);	
	
Конецпроцедуры

&НаСервереБезКонтекста
Процедура ОстановитьСервисОповещенияОРезервномКопировании()
	
	ПараметрыОповещенияОРезервномКопировании= РезервноеКопированиеИБСервер.ПолучитьНастройкиРезервногоКопирования();
	ПараметрыОповещенияОРезервномКопировании.ДатаПоследнегоОповещения = Дата('00010101');
	ПараметрыОповещенияОРезервномКопировании.ПериодОповещения = 0;
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(ПараметрыОповещенияОРезервномКопировании);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьПутьАрхиваСКопиями(Путь, ПараметрыРезервногоКопированияИБНаКлиенте)
	
	НастройкиПути = РезервноеКопированиеИБСервер.ПолучитьНастройкиРезервногоКопирования();
	НастройкиПути.КаталогХраненияРезервныхКопий = Путь;
	ПараметрыРезервногоКопированияИБНаКлиенте = НастройкиПути;
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(НастройкиПути);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДоступность()
	
	Возврат ПолучитьСеансыИнформационнойБазы().Количество() > 1;
	
КонецФункции

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции подготовки резервного копирования

&НаКлиенте
Функция СформироватьФайлыСкриптаОбновления() 
	
	ПараметрыРезервногоКопирования = РезервноеКопированиеИБКлиент.КлиентскиеПараметрыРезервногоКопирования();
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	СоздатьКаталог(ПараметрыРезервногоКопирования.КаталогВременныхФайловОбновления);
	
	// Структура параметров необходима для их определения на клиенте и передачи на сервер
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИмяФайлаПрограммы"			, ПараметрыРезервногоКопирования.ИмяФайлаПрограммы);
	СтруктураПараметров.Вставить("СобытиеЖурналаРегистрации"	, ПараметрыРезервногоКопирования.СобытиеЖурналаРегистрации);
	СтруктураПараметров.Вставить("ИмяCOMСоединителя"			, ПараметрыРаботыКлиента.ИмяCOMСоединителя);
	СтруктураПараметров.Вставить("ЭтоБазоваяВерсияКонфигурации"	, ПараметрыРаботыКлиента.ЭтоБазоваяВерсияКонфигурации);
	СтруктураПараметров.Вставить("ИнформационнаяБазаФайловая"	, ПараметрыРаботыКлиента.ИнформационнаяБазаФайловая);
	СтруктураПараметров.Вставить("ПараметрыСкрипта"				, ПолучитьПараметрыАутентификацииАдминистратораОбновления());
	
	ИменаМакетов = "ДопФайлРезервногоКопирования";	
	ИменаМакетов = ИменаМакетов + ",ЗаставкаРезервногоКопирования";
	ТекстыМакетов = ПолучитьТекстыМакетов(ИменаМакетов, СтруктураПараметров, СообщенияДляЖурналаРегистрации);
	
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов[0]);
	
	ИмяФайлаСкрипта = ПараметрыРезервногоКопирования.КаталогВременныхФайловОбновления + "main.js";
	ФайлСкрипта.Записать(ИмяФайлаСкрипта, КодировкаТекста.UTF16);
	
	// Вспомогательный файл: helpers.js
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов[1]);
	ФайлСкрипта.Записать(ПараметрыРезервногоКопирования.КаталогВременныхФайловОбновления + "helpers.js", КодировкаТекста.UTF16);
	
	ИмяГлавногоФайлаСкрипта = Неопределено;
	// Вспомогательный файл: splash.png
	БиблиотекаКартинок.ЗаставкаВнешнейОперации.Записать(ПараметрыРезервногоКопирования.КаталогВременныхФайловОбновления + "splash.png");
	// Вспомогательный файл: splash.ico
	БиблиотекаКартинок.ЗначокЗаставкиВнешнейОперации.Записать(ПараметрыРезервногоКопирования.КаталогВременныхФайловОбновления + "splash.ico");
	// Вспомогательный файл: progress.gif
	БиблиотекаКартинок.ДлительнаяОперация48.Записать(ПараметрыРезервногоКопирования.КаталогВременныхФайловОбновления + "progress.gif");
	// Главный файл заставки: splash.hta
	ИмяГлавногоФайлаСкрипта = ПараметрыРезервногоКопирования.КаталогВременныхФайловОбновления + "splash.hta";
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов[2]);
	ФайлСкрипта.Записать(ИмяГлавногоФайлаСкрипта, КодировкаТекста.UTF16);
	
	Возврат ИмяГлавногоФайлаСкрипта;	
	
КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыАутентификацииАдминистратораОбновления() 
	
	Результат = Новый Структура("ИмяПользователя,
	|ПарольПользователя,
	|СтрокаПодключения,
	|ПараметрыАутентификации,
	|СтрокаСоединенияИнформационнойБазы",
	Неопределено, "", "", "", "", "");
	
	ТекущиеСоединения = ПолучитьСтрокуСоединенияИИнформациюОСоединениях(СообщенияДляЖурналаРегистрации);
	Результат.СтрокаСоединенияИнформационнойБазы = ТекущиеСоединения.СтрокаСоединенияИнформационнойБазы;
	// Диагностика случая, когда ролевой безопасности в системе не предусмотрено.
	// Т.е. ситуация, когда любой пользователь «может» в системе все.
	//Если НЕ ТекущиеСоединения.ЕстьАктивныеПользователи Тогда
	//	Возврат Результат;
	//КонецЕсли;
	
	Пользователь = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформацияОПользователе.Имя;
	
	Результат.ИмяПользователя			= Пользователь;
	Результат.ПарольПользователя		= ПарольАдминистратораИБ;
	Результат.СтрокаПодключения			= "Usr=""" + Пользователь + """;Pwd=""" + ПарольАдминистратораИБ + """;";
	Результат.ПараметрыАутентификации	= "/N""" + Пользователь + """ /P""" + ПарольАдминистратораИБ + """ /WA-";
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьТекстыМакетов(ИменаМакетов, СтруктураПараметров, СообщенияДляЖурналаРегистрации)
	
	// запись накопленных событий ЖР
	ОбщегоНазначения.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
		
	Результат = Новый Массив();
	Результат.Добавить(ПолучитьТекстСкрипта(СтруктураПараметров));
	
	ИменаМакетовМассив = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаМакетов);
	
	Для каждого ИмяМакета ИЗ ИменаМакетовМассив Цикл
		Результат.Добавить(Обработки.РезервноеКопированиеИБ.ПолучитьМакет(ИмяМакета).ПолучитьТекст());
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьТекстСкрипта(СтруктураПараметров)
	
	// Файл обновления конфигурации: main.js
	ШаблонСкрипта = Обработки.РезервноеКопированиеИБ.ПолучитьМакет("МакетФайлаРезервногоКопирования");
	
	Скрипт = ШаблонСкрипта.ПолучитьОбласть("ОбластьПараметров");
	Скрипт.УдалитьСтроку(1);
	Скрипт.УдалитьСтроку(Скрипт.КоличествоСтрок());
	
	Текст = ШаблонСкрипта.ПолучитьОбласть("ОбластьРезервногоКопирования");
	Текст.УдалитьСтроку(1);
	Текст.УдалитьСтроку(Текст.КоличествоСтрок());
	
	Возврат ВставитьПараметрыСкрипта(Скрипт.ПолучитьТекст(), СтруктураПараметров) + Текст.ПолучитьТекст();
	
КонецФункции

&НаСервере
Функция ВставитьПараметрыСкрипта(Знач Текст, Знач СтруктураПараметров)
	
	Результат = Текст;
	ИменаФайловОбновления = "";
	ИменаФайловОбновления = "[" + "" + "]";
	
	СтрокаСоединенияИнформационнойБазы = СтруктураПараметров.ПараметрыСкрипта.СтрокаСоединенияИнформационнойБазы +
	СтруктураПараметров.ПараметрыСкрипта.СтрокаПодключения; 
	
	ИмяИсполняемогоФайлаПрограммы = КаталогПрограммы() + СтруктураПараметров.ИмяФайлаПрограммы;
	
	// Определение пути к информационной базе.
	ПризнакФайловогоРежима = Неопределено;
	ПутьКИнформационнойБазе = СоединенияИБКлиентСервер.ПутьКИнформационнойБазе(ПризнакФайловогоРежима, 0);
	ИмяФайлаЗапускаПриложенияВРежимеПредприятия = КаталогПрограммы() + ИмяФайлаЗапускаПриложенияВРежимеПредприятия;
	
	ПараметрПутиКИнформационнойБазе = ?(ПризнакФайловогоРежима, "/F", "/S") + ПутьКИнформационнойБазе; 
	СтрокаПутиКИнформационнойБазе	= ?(ПризнакФайловогоРежима, ПутьКИнформационнойБазе, "");
	
	Результат = СтрЗаменить(Результат, "[ИменаФайловОбновления]"				, ИменаФайловОбновления);
	Результат = СтрЗаменить(Результат, "[ИмяИсполняемогоФайлаПрограммы]"		, ПодготовитьТекст(ИмяИсполняемогоФайлаПрограммы));
	Результат = СтрЗаменить(Результат, "[ИмяФайлаЗапускаПриложенияВРежимеПредприятия]", ПодготовитьТекст(ИмяФайлаЗапускаПриложенияВРежимеПредприятия));
	Результат = СтрЗаменить(Результат, "[ПараметрПутиКИнформационнойБазе]"		, ПодготовитьТекст(ПараметрПутиКИнформационнойБазе));
	Результат = СтрЗаменить(Результат, "[СтрокаПутиКФайлуИнформационнойБазы]"	, ПодготовитьТекст(ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(СтрЗаменить(СтрокаПутиКИнформационнойБазе, """", "")) +
	"1Cv8.1CD"));
	Результат = СтрЗаменить(Результат, "[СтрокаСоединенияИнформационнойБазы]"	, ПодготовитьТекст(СтрокаСоединенияИнформационнойБазы));
	Результат = СтрЗаменить(Результат, "[ПараметрыАутентификацииПользователя]"	, ПодготовитьТекст(СтруктураПараметров.ПараметрыСкрипта.ПараметрыАутентификации));
	Результат = СтрЗаменить(Результат, "[СобытиеЖурналаРегистрации]"			, ПодготовитьТекст(СтруктураПараметров.СобытиеЖурналаРегистрации));
	Результат = СтрЗаменить(Результат, "[АдресЭлектроннойПочты]", 
	"");
	Результат = СтрЗаменить(Результат, "[ИмяАдминистратораОбновления]"			, ПодготовитьТекст(ИмяПользователя()));
	Результат = СтрЗаменить(Результат, "[СоздаватьРезервнуюКопию]"				,"true");
	СтрокаКаталога = ПроверитьКаталогНаУказаниеКорневогоЭлемента(Объект.КаталогСРезервнымиКопиями);
	
	Результат = СтрЗаменить(Результат, "[КаталогРезервнойКопии]"				,ПодготовитьТекст(СтрокаКаталога+"\backup"+СтрокаКаталогаИзДаты()));				 
	Результат = СтрЗаменить(Результат, "[ВосстанавливатьИнформационнуюБазу]"	, "false");
	Результат = СтрЗаменить(Результат, "[БлокироватьСоединенияИБ]"				, ?(СтруктураПараметров.ИнформационнаяБазаФайловая, "false", "true"));
	Результат = СтрЗаменить(Результат, "[ИмяCOMСоединителя]"					, ПодготовитьТекст(СтруктураПараметров.ИмяCOMСоединителя));
	Результат = СтрЗаменить(Результат, "[ИспользоватьCOMСоединитель]"			, ?(СтруктураПараметров.ЭтоБазоваяВерсияКонфигурации, "false", "true"));
	Результат = СтрЗаменить(Результат, "[ТипРезервногоКопирования]"				, Строка(Объект.КодТипаИнтерактивногоРезервногоКопирования));
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПроверитьКаталогНаУказаниеКорневогоЭлемента(СтрокаКаталога)
	
	Если Прав(СтрокаКаталога, 2) = ":\" Тогда
		Возврат Лев(СтрокаКаталога, СтрДлина(СтрокаКаталога) - 1) ;
	Иначе
		Возврат СтрокаКаталога;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция СтрокаКаталогаИзДаты()
	
	СтрокаВозврата = "";
	ДатаСейчас = ТекущаяДатаСеанса();
	СтрокаВозврата = Формат(ДатаСейчас, "ДФ = гггг_ММ_дд_ЧЧ_мм_сс");
	Возврат СтрокаВозврата;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПодготовитьТекст(Знач Текст)
	
	Возврат "'" + СтрЗаменить(Текст, "\", "\\") + "'";
	
КонецФункции

&НаСервере
Функция ПолучитьСтрокуСоединенияИИнформациюОСоединениях(СообщенияДляЖурналаРегистрации)
	
	// запись накопленных событий ЖР
	ОбщегоНазначения.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	Результат = ПолучитьИнформациюОНаличииСоединений();
	Результат.Вставить("СтрокаСоединенияИнформационнойБазы", 
		СоединенияИБКлиентСервер.ПолучитьСтрокуСоединенияИнформационнойБазы(0));
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьИнформациюОНаличииСоединений(СообщенияДляЖурналаРегистрации = Неопределено)
	
	ОбщегоНазначения.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Структура("НаличиеАктивныхСоединений, НаличиеCOMСоединений, НаличиеСоединенияКонфигуратором, ЕстьАктивныеПользователи",
								Ложь,
								Ложь,
								Ложь,
								Ложь);
	
	Если ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() > 0 Тогда 
		Результат.ЕстьАктивныеПользователи = Истина;
	КонецЕсли;
	
	МассивСеансов = ПолучитьСеансыИнформационнойБазы();
	Если МассивСеансов.Количество() = 1 Тогда 
		Возврат Результат;
	КонецЕсли;
	
	Результат.НаличиеАктивныхСоединений = Истина;
	
	Для Каждого Сеанс Из МассивСеансов Цикл
		Если ЭтоCOMСоединение(Сеанс) Тогда 
			 Результат.НаличиеCOMСоединений = Истина;
		ИначеЕсли ЭтоСеансКонфигуратором(Сеанс) Тогда 
			Результат.НаличиеСоединенияКонфигуратором = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЭтоСеансКонфигуратором(СеансИнформационнойБазы)
	
	Возврат ВРег(СеансИнформационнойБазы.ИмяПриложения) = ВРег("Designer");
	
КонецФункции 

&НаСервереБезКонтекста
Функция ЭтоCOMСоединение(СеансИнформационнойБазы)
	
	Возврат ВРег(СеансИнформационнойБазы.ИмяПриложения) = ВРег("COMConnection");
	
КонецФункции 
