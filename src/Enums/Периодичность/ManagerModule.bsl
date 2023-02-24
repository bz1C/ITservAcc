
Функция НачалоПериода(знач Дата, знач Периодичность, знач ПериодичностьПоУмолчанию = Неопределено) Экспорт 
	Если ПериодичностьПоУмолчанию  <> Неопределено и не ЗначениеЗаполнено(Периодичность) Тогда
		Периодичность = ПериодичностьПоУмолчанию;
	КонецЕсли;
	
	Если Дата = '00010101' Тогда
		Возврат Дата;
	КонецЕсли;
	
	Если Периодичность = Перечисления.Периодичность.Месяц Тогда
 		Возврат НачалоМесяца(Дата);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция КонецПериода(знач Дата, знач Периодичность, знач ПериодичностьПоУмолчанию = Неопределено) Экспорт 
	Если ПериодичностьПоУмолчанию  <> Неопределено и не ЗначениеЗаполнено(Периодичность) Тогда
		Периодичность = ПериодичностьПоУмолчанию;
	КонецЕсли;
	
	Если Дата = '00010101' Тогда
		Возврат Дата;
	КонецЕсли;
	
	Если Периодичность = Перечисления.Периодичность.Месяц Тогда
 		Возврат КонецМесяца(Дата);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции
