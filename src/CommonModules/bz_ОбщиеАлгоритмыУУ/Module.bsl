Процедура СоздатьПВРСтрок(ДокументОбъект, МенеджерДокумента, ИмяТЧ,  знач Дата,  знач КолонкиПоискаСоответствияПВР, знач ИмяРеквизитаПВР, Отбор = Неопределено) Экспорт
	структКолонкиПоискаСоответствияПВР = Новый	Структура(КолонкиПоискаСоответствияПВР);
	
	Если ДокументОбъект.ЭтоНовый() Тогда
		СсылкаДляЗаписи = ДокументОбъект.ПолучитьСсылкуНового();
		Если СсылкаДляЗаписи.Пустая() Тогда 
			СсылкаДляЗаписи = МенеджерДокумента.ПолучитьСсылку(Новый УникальныйИдентификатор());
			ДокументОбъект.УстановитьСсылкуНового(СсылкаДляЗаписи);
		КонецЕсли;
	Иначе
		СсылкаДляЗаписи = ДокументОбъект.Ссылка;	
	КонецЕсли;
	
	// Готовим таблицу строк для обхода
	РаботыДляЗаполненияПВР = ДокументОбъект[ИмяТЧ].Выгрузить(Отбор,КолонкиПоискаСоответствияПВР+", НомерСтроки, "+ИмяРеквизитаПВР);
	отБулево = Новый ОписаниеТипов("Булево");
	РаботыДляЗаполненияПВР.Колонки.Добавить("ПВРПустая", отБулево);
	РаботыДляЗаполненияПВР.Колонки.Добавить("ПВРСоответствуетСтроке", отБулево);
	
	МасПВРДляПолученияДанных = Новый Массив();
	// НеиспользованныеПВР используем сначала для исключения дублей в МасПВРДляПолученияДанных и хранения всех значений ПВРСтроки,
	// а потом, после ремеппинга в ней останутся только неиспользованные значения. 
	НеиспользованныеПВР = Новый Соответствие();
	Для Каждого стр Из РаботыДляЗаполненияПВР Цикл
		ПВРСтроки = стр[ИмяРеквизитаПВР];
		Если ПВРСтроки.Пустая() Тогда
			Продолжить;
		КонецЕсли;
		Если НеиспользованныеПВР[ПВРСтроки] <> Истина Тогда		
			МасПВРДляПолученияДанных.Добавить(ПВРСтроки);
			НеиспользованныеПВР.Вставить(ПВРСтроки, Истина);
		КонецЕсли;
	КонецЦикла;
	//МасПВРДляПолученияДанных = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МасПВРДляПолученияДанных);
	Если МасПВРДляПолученияДанных.Количество() Тогда
		ДанныеПВР = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МасПВРДляПолученияДанных, КолонкиПоискаСоответствияПВР + ", ВыполнениеРабот");
	Иначе
		ДанныеПВР = Новый Соответствие();
	КонецЕсли;
	Для Каждого стр Из РаботыДляЗаполненияПВР Цикл
		стр.ПВРПустая = стр[ИмяРеквизитаПВР].Пустая();		
		Если стр.ПВРПустая Тогда
			стр.ПВРСоответствуетСтроке = Ложь;		 			
		Иначе
			ДанныеПВРСтроки = ДанныеПВР[стр[ИмяРеквизитаПВР]];
			КлючевыеКолонкиСовпадают = Истина;
			Для Каждого Рекв Из ДанныеПВРСтроки Цикл
				Если Рекв.Ключ = "ВыполнениеРабот" Тогда
					Если Рекв.Значение <> СсылкаДляЗаписи Тогда
						КлючевыеКолонкиСовпадают = Ложь;
					КонецЕсли;
				ИначеЕсли Рекв.Значение <> стр[Рекв.Ключ] Тогда
					 КлючевыеКолонкиСовпадают = Ложь;
					 Прервать;
				КонецЕсли;
			КонецЦикла;
			стр.ПВРСоответствуетСтроке = КлючевыеКолонкиСовпадают;		 
		КонецЕсли;
	КонецЦикла;
			
	РаботыДляЗаполненияПВР.Сортировать(КолонкиПоискаСоответствияПВР+", ПВРПустая, ПВРСоответствуетСтроке Убыв");
	
	// Произведем ремеппинг.
	// Обходим подготовленную таблицу и генерим/подставляем ПВР для всех строк
	// Менять значения в существующих (кроме даты) нельзя, поскольку это может повлиять на результат в регистрах
	ИспользованныеПВР = Новый Соответствие();
	ПредСтр = Неопределено;
	Для Каждого стр Из РаботыДляЗаполненияПВР Цикл
		
		Если ПредСтр <> Неопределено Тогда			
			КлючевыеКолонкиСовпадают = Истина;
			Для Каждого Рекв Из структКолонкиПоискаСоответствияПВР Цикл
				Если ПредСтр[Рекв.Ключ] <> стр[Рекв.Ключ] Тогда
					 КлючевыеКолонкиСовпадают = Ложь;
					 Прервать;
				КонецЕсли;
			КонецЦикла;

			Если КлючевыеКолонкиСовпадают Тогда
				стр[ИмяРеквизитаПВР] = ПредСтр[ИмяРеквизитаПВР];
				ПредСтр = стр;
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если стр.ПВРПустая Тогда
			стр[ИмяРеквизитаПВР] = СоздатьПВРСтроки(СсылкаДляЗаписи, Дата, стр, КолонкиПоискаСоответствияПВР);
		ИначеЕсли не стр.ПВРСоответствуетСтроке Тогда 
			стр[ИмяРеквизитаПВР] = СоздатьПВРСтроки(СсылкаДляЗаписи, Дата, стр, КолонкиПоискаСоответствияПВР);
		Иначе
			ПВРСтроки = стр[ИмяРеквизитаПВР];
			НеиспользованныеПВР.Удалить(ПВРСтроки);
			ИспользованныеПВР.Вставить(ПВРСтроки);			
		КонецЕсли;
		ПредСтр = стр;
	КонецЦикла;
	
	
	// теперь в НеиспользованныеПВР остались только те ПВР, которые более не используются в документе. Пометим их на удаление.
	Для Каждого ПВРУдаление Из НеиспользованныеПВР Цикл
		ПВРУдалениеОб = ПВРУдаление.Ключ.ПолучитьОбъект();
		ПВРУдалениеОб.УстановитьПометкуУдаления(Истина);						
	КонецЦикла;
	
	// Если поменялась дата, то в старых элементах её нужно обновить
	Если не ДокументОбъект.ЭтоНовый() и НачалоДня(Дата) <> НачалоДня(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОбъект.Ссылка, "Дата")) Тогда
		Для Каждого ПВР Из ИспользованныеПВР Цикл			
			ПВРОб = ПВР.Ключ.ПолучитьОбъект();
			Если НачалоДня(Дата) <> ПВРОб.Дата Тогда
				ПВРОб.Дата = НачалоДня(Дата);
				ПВРОб.Записать();				
			КонецЕсли; 									
		КонецЦикла;	
	КонецЕсли;
	 
	// Обновляем ПВРСтроки ТЧ документа.
	Для Каждого стр Из РаботыДляЗаполненияПВР Цикл
		стрР = ДокументОбъект[ИмяТЧ][стр.НомерСтроки-1];
		стрР[ИмяРеквизитаПВР] = стр[ИмяРеквизитаПВР];
	КонецЦикла;
	
КонецПроцедуры

Функция СоздатьПВРСтроки(знач СсылкаДляЗаписи, знач Дата, знач стр, знач КолонкиПоискаСоответствияПВР)
	СпрОб = Справочники.bz_ПозицияВыполненияРабот.СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(СпрОб, стр, КолонкиПоискаСоответствияПВР);
	СпрОб.ВыполнениеРабот = СсылкаДляЗаписи;
	СпрОб.Дата = НачалоДня(Дата);
	СпрОб.Записать();
	Возврат СпрОб.Ссылка; 
КонецФункции
