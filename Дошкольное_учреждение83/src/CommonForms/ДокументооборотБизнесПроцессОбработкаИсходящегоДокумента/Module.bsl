
///////////////////////////////////////////////////////////
//// Обработка событий формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	//Если открывается новая карточка бизнес-процесса
	Если Параметры.Свойство("Предмет") И ЗначениеЗаполнено(Параметры.Предмет) Тогда
		
		ЗаполнитьКарточкуНовогоБизнесПроцесса("DMBusinessProcessOutgoingDocumentProcessing", ЭтаФорма, Параметры.Предмет);

	//Если открывается карточка имеющегося бизнес-процесса 		
	ИначеЕсли ЗначениеЗаполнено(Параметры.id)
		И ЗначениеЗаполнено(Параметры.type) Тогда
		ОбъектID = Параметры.id;
		ДанныеБП = РаботаС1СДокументооборот.ПолучитьОбъект(Параметры.type, Параметры.id);
		Объект = ДанныеБП.objects[0];
		ЗаполнитьФормуИзОбъектаXDTO(Объект);
 	КонецЕсли;	
	
	ЭтаФорма.Заголовок = Наименование;
	Если НЕ ЗначениеЗаполнено(ОбъектID) Тогда
		ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + НСтр("ru = ' (Создание)'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвторНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаС1СДокументооборотКлиент.ВыбратьПользователяИзДереваПодразделений("Автор", ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонСогласованияПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаС1СДокументооборотКлиент.ВыбратьЗначениеИзСписка("DMBusinessProcessApprovalTemplate", "ШаблонСогласования", ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонУтвержденияПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаС1СДокументооборотКлиент.ВыбратьЗначениеИзСписка("DMBusinessProcessConfirmationTemplate", "ШаблонУтверждения", ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонРегистрацииПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаС1СДокументооборотКлиент.ВыбратьЗначениеИзСписка("DMBusinessProcessRegistrationTemplate", "ШаблонРегистрации", ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	#Если Не ВебКлиент Тогда
	Если Модифицированность Тогда
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		Режим = РежимДиалогаВопрос.ДаНетОтмена;
		Ответ = Вопрос(ТекстВопроса, Режим);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Отказ = НЕ ЗаписатьОбъектВыполнить();
		ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	#Если ВебКлиент Тогда
	Если Модифицированность Тогда
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Вопрос(ТекстВопроса, Режим);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ЗаписатьОбъектВыполнить();
		КонецЕсли;
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ГлавнаяЗадачаПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ГлавнаяЗадача) Тогда
		ПараметрыФормы = Новый Структура("id, type", ГлавнаяЗадачаID, ГлавнаяЗадачаТип);
		ОткрытьФормуМодально("ОбщаяФорма.ДокументооборотКарточкаЗадачи", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Предмет) Тогда
		РаботаС1СДокументооборотКлиент.ОткрытьКарточкуПредметаБизнесПроцесса(ПредметТип, ПредметID, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ДокументооборотДокумент" И Источник = Элементы.ПредметПредставление Тогда 
		Предмет = Параметр.Представление;
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура АвторАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		РаботаС1СДокументооборотВызовСервера.ПолучитьДанныеДляАвтоПодбора("DMUser", Данныевыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвторОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		РаботаС1СДокументооборотВызовСервера.ПолучитьДанныеДляАвтоПодбора("DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			РаботаС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Автор", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Автор", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры


///////////////////////////////////////////////////////////
//// Обработка команд формы

&НаКлиенте
Процедура Записать(Команда)
	
	РезультатЗаписи = ЗаписатьОбъектВыполнить();
	
	Если РезультатЗаписи Тогда
		ПараметрыОповещения = Новый Структура("id", ОбъектID);
		Оповестить("Запись_ДокументооборотБизнесПроцесс", ПараметрыОповещения);
		ЭтаФорма.Заголовок = Наименование;
		Состояние(НСтр("ru = 'Бизнес-процесс """ + Наименование + """ сохранен.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтартоватьИЗакрыть(Команда)
	
	РезультатЗапуска = ПодготовитьКПередачеИСтартоватьБизнесПроцесс();
	Если РезультатЗапуска Тогда 
		ПараметрыОповещения = Новый Структура("id", ОбъектID);
		Оповестить("Запись_ДокументооборотБизнесПроцесс", ПараметрыОповещения);
		
		ТекстСостояния = НСтр("ru = 'Бизнес-процесс """ + Наименование + """ успешно запущен.'");
		Состояние(ТекстСостояния);
		
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШаблону(Команда)
	
	РезультатВыбораШаблона = РаботаС1СДокументооборотКлиент.ВыбратьШаблонБизнесПроцесса(ЭтаФорма);
	Если ТипЗнч(РезультатВыбораШаблона) = Тип("Структура") Тогда
		ЗаполнитьКарточкуПоШаблону(РезультатВыбораШаблона);	
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////
//// Служебные процедуры и функции

&НаСервере
Процедура ЗаполнитьКарточкуПоШаблону(ДанныеШаблона)
	
	РезультатЗаполнения = РаботаС1СДокументооборотВызовСервера.ЗаполнитьБизнесПроцессПоШаблону(ЭтаФорма, ДанныеШаблона);
	ЗаполнитьФормуИзОбъектаXDTO(РезультатЗаполнения.object);

КонецПроцедуры


&НаСервере
Процедура ЗаполнитьКарточкуНовогоБизнесПроцесса(ТипБизнесПроцесса, Форма, Предмет)	
	
	НовыйОбъект = РаботаС1СДокументооборот.ПолучитьНовыйОбъект(ТипБизнесПроцесса, Предмет);
	ЗаполнитьФормуИзОбъектаXDTO(НовыйОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуИзОбъектаXDTO(Объект)
	
	РаботаС1СДокументооборот.УстановитьСтандартнуюШапкуБизнесПроцесса(Объект, Этаформа);
	
	//специфика обработки исходящего документа
	ЗаполнитьРеквизитФормыИзПакета("ШаблонСогласования", Объект, "approvalTemplate");
	ЗаполнитьРеквизитФормыИзПакета("ШаблонУтверждения", Объект, "confirmationTemplate");	
	ЗаполнитьРеквизитФормыИзПакета("ШаблонРегистрации", Объект, "registrationTemplate");
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитФормыИзПакета(ИмяРеквизита, Объект, ИмяСвойстваОбъекта)
	
	Если Объект.Установлено(ИмяСвойстваОбъекта) Тогда
		ЭтаФорма[ИмяРеквизита + "id"] = Объект[ИмяСвойстваОбъекта].objectId.id;
		ЭтаФорма[ИмяРеквизита] = Объект[ИмяСвойстваОбъекта].name;
		ЭтаФорма[ИмяРеквизита + "Тип"] = Объект[ИмяСвойстваОбъекта].objectId.type;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьОбъект(Прокси, Тип)
	
	Возврат РаботаС1СДокументооборотВызовСервера.СоздатьОбъектDM(Прокси, Тип);
	
КонецФункции

&НаСервере
Функция ПодготовитьКПередачеИЗаписатьБизнесПроцесс()
	
	Прокси = РаботаС1СДокументооборотВызовСервера.ПолучитьПрокси();
	Объект = ПодготовитьБизнесПроцесс(Прокси);
	Если ЗначениеЗаполнено(ОбъектID) Тогда
		РезультатЗаписи = РаботаС1СДокументооборот.ЗаписатьОбъект(Прокси, Объект);
	Иначе
		РезультатСоздания = РаботаС1СДокументооборот.СоздатьНовыйОбъект(Прокси, Объект);
	КонецЕсли;
	
	Результат = ?(РезультатСоздания = Неопределено, РезультатЗаписи, РезультатСоздания);
	Если РаботаС1СДокументооборот.ПроверитьТип(Прокси, Результат , "DMError") Тогда
		ВызватьИсключение(РезультатСоздания.description);
	Иначе
		Если РезультатЗаписи <> Неопределено Тогда
			ОбъектID = Результат.objects[0].objectId.id;
		Иначе
			ОбъектID = Результат.object.objectId.id;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПодготовитьКПередачеИСтартоватьБизнесПроцесс()
	
	Прокси = РаботаС1СДокументооборотВызовСервера.ПолучитьПрокси();
	Объект = ПодготовитьБизнесПроцесс(Прокси);
	РезультатЗапуска = РаботаС1СДокументооборот.ЗапуститьБизнесПроцесс(Прокси, Объект); 	
	
	Если РаботаС1СДокументооборот.ПроверитьТип(Прокси, РезультатЗапуска, "DMError") Тогда
		ВызватьИсключение(РезультатЗапуска.description); 
	Иначе
		ОбъектID = РезультатЗапуска.businessProcess.objectId.id;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПодготовитьБизнесПроцесс(Прокси)
		
	Объект = СоздатьОбъект(Прокси, "DMBusinessProcessOutgoingDocumentProcessing");
	
	Объект.name = Наименование;
	Объект.objectId = СоздатьОбъект(Прокси, "DMObjectID"); 
	Объект.objectId.id = ОбъектID;
	Объект.objectId.type = "DMBusinessProcessOutgoingDocumentProcessing";
	
	//Общая шапка бизнес-процессов
	СоздатьСвойствоОбъектаXDTOИзРеквизитаФормы("Автор", Объект, "author", "DMUser", Прокси);
	СоздатьСвойствоОбъектаXDTOИзРеквизитаФормы("Предмет", Объект, "target", "DMObject", Прокси);
	Объект.beginDate = ДатаНачала;
	
	//специфика Обработки исходящего документа
	СоздатьСвойствоОбъектаXDTOИзРеквизитаФормы("ШаблонСогласования", Объект, "approvalTemplate", "DMBusinessProcessApprovalTemplate", Прокси);
	СоздатьСвойствоОбъектаXDTOИзРеквизитаФормы("ШаблонУтверждения", Объект, "confirmationTemplate", "DMBusinessProcessConfirmationTemplate", Прокси);
	СоздатьСвойствоОбъектаXDTOИзРеквизитаФормы("ШаблонРегистрации", Объект, "registrationTemplate", "DMBusinessProcessRegistrationTemplate", Прокси);
			
	Возврат Объект;
	
КонецФункции

&НаСервере
Процедура СоздатьСвойствоОбъектаXDTOИзРеквизитаФормы(ИмяРеквизитаФормы, ОбъектXDTO, ИмяСвойстаОбъекта, ТипСвойстваОбъекта, Прокси)
	
	Если ЗначениеЗаполнено(ЭтаФорма[ИмяРеквизитаФормы]) Тогда
		ОбъектXDTO[ИмяСвойстаОбъекта] = СоздатьОбъект(Прокси, ТипСвойстваОбъекта);
		ОбъектXDTO[ИмяСвойстаОбъекта].name = ЭтаФорма[ИмяРеквизитаФормы];
		ОбъектXDTO[ИмяСвойстаОбъекта].objectId = СоздатьОбъект(Прокси, "DMObjectID");
		ОбъектXDTO[ИмяСвойстаОбъекта].objectId.id = ЭтаФорма[ИмяРеквизитаФормы + "id"];
		ОбъектXDTO[ИмяСвойстаОбъекта].objectId.type = ЭтаФорма[ИмяРеквизитаФормы + "Тип"];
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЗаписатьОбъектВыполнить()
	
	ПодготовитьКПередачеИЗаписатьБизнесПроцесс();
	Модифицированность = Ложь;
	Возврат Истина;
	
КонецФункции