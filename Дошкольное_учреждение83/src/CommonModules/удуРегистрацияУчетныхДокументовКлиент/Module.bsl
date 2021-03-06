// Функция создает делопроизводственный документ для указанного учетного документа, если соответсвующая настройка
// сделана в регистре сведений удуНастройкиРегистрацииДокументов. Затем открывает карточку данного документа.
//
// Параметры:
// - Форма				- форма учетного документ из которого осуществляется вызов
//
// - Корреспондент		- корреспондент в отношении которого возник документ
//
// - СведенияОДетях		- массив детей, в отношении которых возник документ
Процедура РегистрироватьДокумент(Форма, Корреспондент = Неопределено, СведенияОДетях = Неопределено) Экспорт
	
	УчетныйДокументСсылка = Форма.Параметры.Ключ;
	
	Результат = удуРегистрацияУчетныхДокументовСервер.РегистрироватьДокумент(УчетныйДокументСсылка, Корреспондент, СведенияОДетях);
	
	Если Результат.Успешно И Результат.Документ <> Неопределено Тогда		
	
		Параметры = Новый Структура("Ключ", Результат.Документ);
		ФормаДокумента = ПолучитьФорму("Справочник.ВнутренниеДокументы.ФормаОбъекта", Параметры, Форма);
	
		ФормаДокумента.Открыть();
		
	КонецЕсли;	
	
КонецПроцедуры
