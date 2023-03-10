
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Код процедур и функций



#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Код процедур и функций

#КонецОбласти

//#Область ОбработчикиСобытийЭлементовТаблицыФормы//<ИмяТаблицыФормы>
//
//// Код процедур и функций
//
//#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	ТекстОшибки = СформироватьНаСервере();
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ПоказатьПредупреждение(, ТекстОшибки);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СформироватьНаСервере()
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	bz_НормыВыработки.Период КАК Дата1,
	|	bz_НормыВыработки.СрокДействия КАК Дата2,
	|	bz_НормыВыработки.Сотрудник,
	|	bz_НормыВыработки.Аналитика,
	|	bz_НормыВыработки.Норма
	|ИЗ
	|	РегистрСведений.bz_НормыВыработки КАК bz_НормыВыработки
	|ГДЕ
	|	bz_НормыВыработки.Период < &Дата2
	|	И (bz_НормыВыработки.СрокДействия >= &Дата1
	|	ИЛИ bz_НормыВыработки.СрокДействия = ДАТАВРЕМЯ(1, 1, 1))
	|	И bz_НормыВыработки.Сотрудник = &Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеПроизводственногоКалендаря.Дата,
	|	ДанныеПроизводственногоКалендаря.ВидДня
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	bz_ВыработкаОбороты.Проект КАК Проект,
	|	bz_ВыработкаОбороты.Этап КАК Этап,
	|	bz_ВыработкаОбороты.Сотрудник КАК Сотрудник,
	|	bz_ВыработкаОбороты.Период КАК Период,
	|	СУММА(bz_ВыработкаОбороты.ТрудозатратыОборот) КАК Трудозатраты,
	|	bz_ВыработкаОбороты.Проект.КонтрагентРаботодатель КАК КонтрагентРаботодатель,
	|	bz_ВыработкаОбороты.Проект.Менеджер КАК Менеджер
	|ИЗ
	|	РегистрНакопления.bz_Выработка.Обороты(&Дата1, &Дата2, День, Сотрудник = &Сотрудник) КАК bz_ВыработкаОбороты
	|СГРУППИРОВАТЬ ПО ГРУППИРУЮЩИМ НАБОРАМ
	|(
	|	(bz_ВыработкаОбороты.Период,
	|	bz_ВыработкаОбороты.Сотрудник),
	|	(bz_ВыработкаОбороты.Период,
	|	bz_ВыработкаОбороты.Сотрудник,
	|	bz_ВыработкаОбороты.Проект.КонтрагентРаботодатель),
	|	(bz_ВыработкаОбороты.Период,
	|	bz_ВыработкаОбороты.Сотрудник,
	|	bz_ВыработкаОбороты.Проект,
	|	bz_ВыработкаОбороты.Этап)
	|)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сотрудник,
	|	Период
	|ИТОГИ
	|ПО
	|	Сотрудник";
	
	Запрос.УстановитьПараметр("Дата1", НачалоДня(Объект.Дата1));
	Запрос.УстановитьПараметр("Дата2", КонецДня(Объект.Дата2));
	Запрос.УстановитьПараметр("Сотрудник", Объект.Сотрудник);
	
	
	РезультатПакета=Запрос.ВыполнитьПакет();
	
	РезультатВидыДней = РезультатПакета[1];
	РезультатВыработка = РезультатПакета[2];
	ОтчетОбъект = РеквизитФормыВЗначение("Объект");
	Макет = ОтчетОбъект.ПолучитьМакет("Макет");
	
	ВидДняПоДате = ПолучитьСоответствиеВидДняПоДате(РезультатВидыДней);
	
	ТабДок.Очистить();
	#Область Шапка 
		ОбластьШапкаГруппировка = Макет.ПолучитьОбласть("Шапка|Группировка");
		ОбластьШапкаПоказатель = Макет.ПолучитьОбласть("Шапка|Показатель");
		ОбластьШапкаИтогЧ = Макет.ПолучитьОбласть("Шапка|ИтогЧ");
		ОбластьШапкаИтогСумма = Макет.ПолучитьОбласть("Шапка|ИтогСумма");
		ОбластьШапкаДень = Макет.ПолучитьОбласть("Шапка|День");
		
		ТабДок.Вывести(ОбластьШапкаГруппировка);
		ТабДок.Присоединить(ОбластьШапкаГруппировка);
		ТабДок.Присоединить(ОбластьШапкаПоказатель);
		ТабДок.Присоединить(ОбластьШапкаИтогЧ);
		ТабДок.Присоединить(ОбластьШапкаИтогСумма);
		
		ТекДата = Объект.Дата1;
		Сутки = 60*60*24;
		НомерДняНедели = ДеньНедели(ТекДата)-1; 
		АкронимыДнейНедели = ПолучитьАкронимыДнейНедели();
		Пока ТекДата <= Объект.Дата2 Цикл
			ОбластьШапкаДень.Параметры.День = СтрШаблон("%1, %2", Формат(ТекДата, "ДФ=dd.MM;"), АкронимыДнейНедели[НомерДняНедели]);
			ТекОбласть = ТабДок.Присоединить(ОбластьШапкаДень);
			ТекВидДня = ВидДняПоДате[ТекДата];
			
			Если ТекВидДня = Неопределено Тогда
				ТекстОшибки = СтрШаблон(НСтр("ru='Не заполнен рабочий календарь на дату %1'"), ТекДата);
				Возврат ТекстОшибки;
			КонецЕсли;
			
			ПокраситьОбластьПоВидуДня(ТекВидДня, ТекОбласть);
			
			ТекДата = ТекДата + Сутки;
			НомерДняНедели = (НомерДняНедели + 1) % 7;
		КонецЦикла;
		
	#КонецОбласти
	
	ВыборкаСотрудник = РезультатВыработка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаСотрудник.Следующий() Цикл
	КонецЦикла;
	
	Возврат "";
КонецФункции

&НаСервере
Процедура ПокраситьОбластьПоВидуДня(Знач ТекВидДня, ТекОбласть)
	Если ТекВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Суббота или ТекВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Воскресенье Тогда  
		ТекОбласть.ЦветФона = WebЦвета.СеребристоСерый;
	ИначеЕсли ТекВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Нерабочий или ТекВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник Тогда
		ТекОбласть.ЦветФона = WebЦвета.СветлоКоралловый;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьАкронимыДнейНедели()
	Результат = Новый Массив();
	Результат.Добавить("пн");
	Результат.Добавить("вт");
	Результат.Добавить("ср");
	Результат.Добавить("чт");
	Результат.Добавить("пт");
	Результат.Добавить("сб");
	Результат.Добавить("вс");
	
	Возврат Результат;
КонецФункции

// Получить соответствие вид дня по дате.
// 
// Параметры:
//  РезультатВидыДней - РезультатЗапроса - Результат виды дней
// 
// Возвращаемое значение:
//  Соответствие - Получить соответствие вид дня по дате
&НаСервереБезКонтекста
Функция ПолучитьСоответствиеВидДняПоДате(знач РезультатВидыДней)
	Результат = Новый Соответствие();
	Выборка = РезультатВидыДней.Выбрать();
	Пока Выборка.Следующий() Цикл
		Результат.Вставить(Выборка.Дата, Выборка.ВидДня);
	КонецЦикла;
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Код процедур и функций

#КонецОбласти
