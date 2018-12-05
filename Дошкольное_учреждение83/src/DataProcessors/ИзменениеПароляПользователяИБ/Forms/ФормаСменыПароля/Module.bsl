
// Обработчик события "ПриСозданииНаСервере" формы.
// Считываются настройки пользователя ИБ
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИзменениеПароляДоступно = ПроверитьДоступностьСменыПароляПользователю();
	
	Если ПользователиИнформационнойБазы.ТекущийПользователь().ПарольУстановлен Тогда
		Пароль				= "**********";
		ПарольПодтверждение	= "**********";
	КонецЕсли;
	
	Элементы.СменитьПароль.Доступность = Ложь;
	
КонецПроцедуры

// Обработчик события формы "ПриОткрытии".
// Если при формировании данных возникли ошибки, то необходимо
// сообщить о них пользователю.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ИзменениеПароляДоступно = Ложь Тогда
		Предупреждение(НСтр("ru = 'Изменение пароля не возможно. Обратитесь к администратору системы.'"),,
						НСтр("ru = 'Смена пароля'"));
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Функция проверяет флаг ЗапрещеноИзменятьПароль у текущего
// пользователя ИБ.
//
// Возвращаемое значение
// Истина        - смена пароля доступна
// Ложь          - смена пароля недоступна (либо потому что пользователю запрещено
//                 изменять пароль, либо потому что не установлена стандартая
//                 аутентификация)
//
&НаСервереБезКонтекста
Функция ПроверитьДоступностьСменыПароляПользователю()
	
	ИзменениеПароляДоступно = Истина;
	
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
	
	Если НЕ ЗначениеЗаполнено(ПользовательИБ.Имя) Тогда
		ИзменениеПароляДоступно = Ложь;
	ИначеЕсли ПользовательИБ.ЗапрещеноИзменятьПароль Тогда
		ИзменениеПароляДоступно = Ложь;
	ИначеЕсли НЕ ПользовательИБ.АутентификацияСтандартная Тогда
		ИзменениеПароляДоступно = Ложь;
	КонецЕсли;
	
	Возврат ИзменениеПароляДоступно;
	
КонецФункции

// Обработчик события нажатия на кнопку "Сменить пароль".
//
&НаКлиенте
Процедура СменитьПарольВыполнить()
	
	ОчиститьСообщения();
	
	Если Пароль = ПарольПодтверждение Тогда
		СменитьПарольПользователяИБ(Пароль);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Изменен пароль'"),,
			НСтр("ru = 'Пароль пользователя изменен.'"));
		Закрыть();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Пароль и подтверждение пароля не совпадают. Повторите ввод пароля и подтверждения пароля.'"), ,
			"ПарольПодтверждение");
		Пароль = "";
		ПарольПодтверждение = "";
	КонецЕсли;
	
КонецПроцедуры

// Функция меняет пароль пользователя ИБ.
// При невозможности записать пользоателя вызывается исключение
// с описанием ошибки.
//
// Возвращаемое значение
// Истина - пароль был изменен
// Ложь   - пароль не был изменен (произошла ошибка записи)
//
&НаСервереБезКонтекста
Процедура СменитьПарольПользователяИБ(Пароль)
	
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
	ПользовательИБ.Пароль = Пароль;
	ПользовательИБ.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура НовыйПарольПриИзменении(Элемент)
	Элементы.СменитьПароль.Доступность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура НовыйПарольПодтверждениеПриИзменении(Элемент)
	Элементы.СменитьПароль.Доступность = Истина;
КонецПроцедуры
