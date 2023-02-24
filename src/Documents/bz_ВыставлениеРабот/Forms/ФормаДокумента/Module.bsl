#Область ОбработчикиСобытийФормы


#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьСервер();
КонецПроцедуры     

&НаСервере
Процедура ЗаполнитьСервер()
	Объект.Выработка.Очистить();
	ЗаполнитьТЧВыработка();
КонецПроцедуры

#КонецОбласти


&НаСервере
Процедура ЗаполнитьТЧВыработка()
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	bz_РаботыКВыставлениюОстатки.Проект КАК Проект,
	|	bz_РаботыКВыставлениюОстатки.Этап КАК Этап,
	|	bz_РаботыКВыставлениюОстатки.Работа КАК Работа,
	|	bz_РаботыКВыставлениюОстатки.Сотрудник КАК Сотрудник,
	|	bz_РаботыКВыставлениюОстатки.ПВР КАК ПВР,
	|	ЕСТЬNULL(bz_РаботыКВыставлениюОстатки.Работа.НеВыставляется, ЛОЖЬ) КАК НеВыставляется,
	|	bz_РаботыКВыставлениюОстатки.КоличествоОтработаноОстаток КАК Количество,
	|	bz_РаботыКВыставлениюОстатки.СуммаОтработаноОстаток КАК СуммаСписания,
	|	ЕСТЬNULL(bz_РаботыКВыставлениюОстатки.ПВР.Содержание, """") КАК Содержание,
	|	ЕСТЬNULL(bz_РаботыКВыставлениюОстатки.ПВР.Примечание, """") КАК Примечание,
	|	ЕСТЬNULL(bz_РаботыКВыставлениюОстатки.ПВР.Дата, &ДатаДокумента) КАК Дата,
	|	bz_РаботыКВыставлениюОстатки.Проект.КонтрагентРаботодатель КАК КонтрагентРаботодатель
	|ИЗ
	|	РегистрНакопления.bz_РаботыКВыставлению.Остатки(&Дата, Организация = &Организация
	|	И Проект = &Проект) КАК bz_РаботыКВыставлениюОстатки
	|ГДЕ
	|	bz_РаботыКВыставлениюОстатки.Организация = &Организация
	|	И bz_РаботыКВыставлениюОстатки.Проект = &Проект";
	
	Запрос.УстановитьПараметр("Дата", КонецДня(Объект.Дата)+1);
	Запрос.УстановитьПараметр("ДатаДокумента", НачалоДня(Объект.Дата));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	Если Объект.Проект.Пустая() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Проект = &Проект", "");
	Иначе
		Запрос.УстановитьПараметр("Проект", Объект.Проект);
	КонецЕсли;
	
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	Пока Выборка.Следующий() Цикл
		НовСтр = Объект.Выработка.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, Выборка);
		НовСтр.ЦенаСписания = ?(Выборка.Количество=0, Выборка.СуммаСписания, Выборка.СуммаСписания/Выборка.Количество);
		
		НовСтр.Действие = ?(Выборка.НеВыставляется, Перечисления.bz_ВариантыВыставленияОтработанногоВремени.Списать, Перечисления.bz_ВариантыВыставленияОтработанногоВремени.Выставить);
		
		Если Выборка.СуммаСписания = 0 Тогда
			Ставка = РегистрыСведений.bz_ПочасовыеСтавкиРабот.ПолучитьСтавку(Выборка.Дата, Выборка.Проект, Выборка.Работа, Выборка.КонтрагентРаботодатель);
			НовСтр.Цена = Ставка;
		Иначе
			НовСтр.Цена = НовСтр.ЦенаСписания;
		КонецЕсли;
		
		НовСтр.Сумма = НовСтр.Цена * НовСтр.Количество;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяВыработкаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ТекСтр = Элементы.Выработка.ТекущиеДанные;
	Если НоваяСтрока или Копирование Тогда
		ТекСтр.ИзмененаВручную = Истина;
	КонецЕсли;  
	
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяВыработкаПриИзмененииРеквизитовИзВыполненияРабот(Элемент)
	ТекСтр = Элементы.Выработка.ТекущиеДанные;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыработкаСодержаниеПриИзменении(Элемент)
	УстановитьФлагТекСтроки("СодержаниеИзменено");
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяВыработкаКоличествоПриИзменении(Элемент)
	ТекСтр = Элементы.Выработка.ТекущиеДанные;
	ТекСтр.ИзмененаВручную = Истина;
	ТекСтр.Сумма = ТекСтр.Цена*ТекСтр.Количество;
	ТекСтр.СуммаСписано = ТекСтр.ЦенаСписано*ТекСтр.Количество; 
КонецПроцедуры


&НаКлиенте
Процедура ВыработкаПримечаниеПриИзменении(Элемент)
	УстановитьФлагТекСтроки("СодержаниеИзменено");
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяВыработкаДействиеПриИзменении(Элемент)
	УстановитьВидимостьКолонокТЧ();
	
	ТекСтр = Элементы.ТекущаяВыработка.ТекущиеДанные;
	Если ТекСтр = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если не ТекСтр.Причина.Пустая() и ТекСтр.Действие <> ПредопределенноеЗначение("Перечисление.bz_ВариантыВыставленияОтработанногоВремени.Списать") Тогда
		ТекСтр.Причина = Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьКолонокТЧ()
	ДействиеСписание = ПредопределенноеЗначение("Перечисление.bz_ВариантыВыставленияОтработанногоВремени.Списать");
	ЕстьСписание = Ложь;
	Для Каждого стр Из Объект.Выработка Цикл
		Если стр.Действие = ДействиеСписание Тогда
			ЕстьСписание = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.ТекущаяВыработкаПричина.Видимость = ЕстьСписание;
		
КонецПроцедуры



&НаКлиенте
Процедура УстановитьФлагТекСтроки(ИмяФлага)
	Перем ТекСтр;
	ТекСтр = Элементы.ТекущаяВыработка.ТекущиеДанные;
	Если ТекСтр <> Неопределено Тогда
		ТекСтр[ИмяФлага] = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяВыработкаПричинаПриИзменении(Элемент)
	ТекСтр = Элементы.ТекущаяВыработка.ТекущиеДанные;
	Если ТекСтр <> Неопределено и ТекСтр.СодержаниеИзменено = Ложь 
		и ТекСтр.Действие = ПредопределенноеЗначение("Перечисление.bz_ВариантыВыставленияОтработанногоВремени.Списать") 
	Тогда
		ТекСтр.Примечание = "";
		ТекСтр.Содержание = "";
		ТекСтр.СодержаниеИзменено = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяВыработкаЦенаПриИзменении(Элемент)
	ТекСтр = Элементы.Выработка.ТекущиеДанные;
	ТекСтр.ИзмененаВручную = Истина;
	ТекСтр.Сумма = ТекСтр.Цена*ТекСтр.Количество;
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяВыработкаЦенаСписанияПриИзменении(Элемент)
	ТекСтр = Элементы.Выработка.ТекущиеДанные;
	ТекСтр.ИзмененаВручную = Истина;
	ТекСтр.СуммаСписания = ТекСтр.ЦенаСписания*ТекСтр.Количество;
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяВыработкаСуммаСписанияПриИзменении(Элемент)
	ТекСтр = Элементы.Выработка.ТекущиеДанные;
	ТекСтр.ИзмененаВручную = Истина;
	Если ТекСтр.Количество = 0 Тогда
		ТекСтр.ЦенаСписания = ТекСтр.СуммаСписания;
	Иначе
		ТекСтр.ЦенаСписания = ТекСтр.СуммаСписания / ТекСтр.Количество;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяВыработкаСуммаПриИзменении(Элемент)
	ТекСтр = Элементы.Выработка.ТекущиеДанные;
	ТекСтр.ИзмененаВручную = Истина;
	Если ТекСтр.Количество = 0 Тогда
		ТекСтр.Цена = ТекСтр.Сумма;
	Иначе
		ТекСтр.Цена = ТекСтр.Сумма / ТекСтр.Количество;
	КонецЕсли;
КонецПроцедуры






