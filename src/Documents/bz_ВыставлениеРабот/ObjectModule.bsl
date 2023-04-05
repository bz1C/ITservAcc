
#Если Сервер или ТолстыйКлиентОбычноеПриложение или ВнешнееСоединение Тогда
	
Процедура ОбработкаПроведения(Отказ, Режим)

	Движения.bz_Выработка.Записывать = Истина;
	Движения.bz_РаботыКВыставлению.Записывать = Истина;
	Движения.bz_СписанныеТрудозатраты.Записывать = Истина;
	
	
	Для Каждого стр Из Выработка Цикл
		Если стр.Действие = Перечисления.bz_ВариантыВыставленияОтработанногоВремени.Выставить или
			 стр.Действие = Перечисления.bz_ВариантыВыставленияОтработанногоВремени.Списать или
			 стр.Действие = Перечисления.bz_ВариантыВыставленияОтработанногоВремени.ОтложитьССуммой
			 или стр.Действие = Перечисления.bz_ВариантыВыставленияОтработанногоВремени.ОтложитьТолькоКоличество и стр.ДатаПереноса <> '00010101'  
		Тогда
				
			Движение = Движения.bz_РаботыКВыставлению.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Период = Дата;
			Движение.Организация = Организация;
			Движение.Проект = стр.Проект;
			Движение.Этап = стр.Этап;
			Движение.Работа = стр.Работа;
			Движение.Сотрудник = стр.Сотрудник;
			Движение.ПВР = стр.ПВР;
			Движение.КоличествоОтработано = стр.Количество;
			Движение.СуммаОтработано = стр.СуммаСписания;
			
		КонецЕсли;

		Если стр.Действие = Перечисления.bz_ВариантыВыставленияОтработанногоВремени.ОтложитьССуммой
			или стр.Действие = Перечисления.bz_ВариантыВыставленияОтработанногоВремени.ОтложитьТолькоКоличество и стр.ДатаПереноса <> '00010101' 
		Тогда 
			Движение = Движения.bz_РаботыКВыставлению.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = ?(стр.ДатаПереноса='00010101', КонецДня(Дата)+1, стр.ДатаПереноса);
			Движение.Организация = Организация;
			Движение.Проект = стр.Проект;
			Движение.Этап = стр.Этап;
			Движение.Работа = стр.Работа;
			Движение.Сотрудник = стр.Сотрудник;
			Движение.ПВР = стр.ПВР;			
			Движение.КоличествоОтработано = стр.Количество;
			Если стр.Действие <> Перечисления.bz_ВариантыВыставленияОтработанногоВремени.ОтложитьТолькоКоличество Тогда
				Движение.СуммаОтработано = стр.Сумма;
			КонецЕсли;
		КонецЕсли;
		
		Если стр.Действие = Перечисления.bz_ВариантыВыставленияОтработанногоВремени.Выставить
			или стр.Действие = Перечисления.bz_ВариантыВыставленияОтработанногоВремени.ВыставитьБезВыработки 
		Тогда
			Движение = Движения.bz_РаботыКВыставлению.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = Дата;
			Движение.Организация = Организация;
			Движение.Проект = стр.Проект;
			Движение.Этап = стр.Этап;
			Движение.Работа = стр.Работа;
			Движение.Сотрудник = стр.Сотрудник;
			Движение.ПВР = стр.ПВР;

			ДвижениеОб = Движения.bz_Выработка.Добавить();
			ДвижениеОб.ФактическаяДатаВыработки = стр.Дата; 
			ДвижениеОб.Период = НачалоДня(Дата);
			ДвижениеОб.Организация = Организация;
			ДвижениеОб.Проект = стр.Проект;
			ДвижениеОб.Этап = стр.Этап;
			ДвижениеОб.Работа = стр.Работа;
			ДвижениеОб.Сотрудник = стр.Сотрудник;
			
			ДвижениеОб.ПВР = стр.ПВР;
			ДвижениеОб.Содержание = стр.Содержание;
			ДвижениеОб.Примечание = стр.Примечание;
			
			Если Согласован Тогда
				Движение.КоличествоСогласовано = стр.Количество;
				Движение.СуммаСогласовано = стр.Сумма;
				ДвижениеОб.ТрудозатратыСогласовано = стр.Количество;
				ДвижениеОб.СуммаСогласовано = стр.Сумма;
			Иначе
				Движение.КоличествоНаСогласовании = стр.Количество;
				Движение.СуммаНаСогласовании = стр.Сумма;
				ДвижениеОб.ТрудозатратыНаСогласовании = стр.Количество;
				ДвижениеОб.СуммаНаСогласовании = стр.Сумма;
			КонецЕсли;
		ИначеЕсли стр.Действие = Перечисления.bz_ВариантыВыставленияОтработанногоВремени.Списать Тогда
			ДвижениеОб = Движения.bz_СписанныеТрудозатраты.Добавить();
			ДвижениеОб.Период = стр.Дата;
			ДвижениеОб.Организация = Организация;
			ДвижениеОб.Проект = стр.Проект;
			ДвижениеОб.Этап = стр.Этап;
			ДвижениеОб.Работа = стр.Работа;
			ДвижениеОб.Сотрудник = стр.Сотрудник;
			ДвижениеОб.Причина = стр.Причина;
			ДвижениеОб.ПВР = стр.ПВР;
			ДвижениеОб.Комментарий = стр.Примечание;
			ДвижениеОб.Количество = стр.Количество;
			ДвижениеОб.Сумма = стр.Сумма;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры


Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Для Каждого стр Из Выработка Цикл
		Если стр.Действие = Перечисления.bz_ВариантыВыставленияОтработанногоВремени.Выставить и стр.Сумма = 0 Тогда
			СообщитьОбОшибкеЗаполнения(НСтр("ru='Не заполнена сумма'"), "Сумма", стр, Отказ);
		КонецЕсли;		
		Если стр.Количество = 0 и не стр.Действие.Пустая() и стр.Действие <> Перечисления.bz_ВариантыВыставленияОтработанногоВремени.Списать Тогда
			СообщитьОбОшибкеЗаполнения(
				НСтр("ru='Трудозатраты могут быть пустыми только в случае выбранного действия - Списание'"),
				"Количество", 
				стр, 
				Отказ
			);
		КонецЕсли;
		Если стр.Действие = Перечисления.bz_ВариантыВыставленияОтработанногоВремени.Списать Тогда
			Если стр.Причина.Пустая() Тогда
				СообщитьОбОшибкеЗаполнения(
					НСтр("ru='Не заполнена причина списания'"),
					"Причина", 
					стр, 
					Отказ
				);
			КонецЕсли;
			Если ПустаяСтрока(стр.Примечание) Тогда
				СообщитьОбОшибкеЗаполнения(
					НСтр("ru='При списании трудозатрат нужно обязательно заполнить пояснение'"),
					"Примечание", 
					стр, 
					Отказ
				);
			КонецЕсли;
		КонецЕсли;
		
//		ИначеЕсли стр.Действие = Перечисления.bz_ВариантыВыставленияОтработанногоВремени.Списать Тогда
////			Если стр.СуммаСписания = 0 и стр.Сумма = 0 Тогда
////				ОбщегоНазначения.СообщитьПользователю(
////					НСтр("ru='Нужно оценить стоимость списываемых трудозатрат'"), 
////					ЭтотОбъект, 
////					СтрШаблон("Выработка[&1].Сумма",Формат("ЧН=; ЧГ=;", Выработка.Индекс(стр))), 
////					"Объект", 
////					Отказ);
//			ИначеЕсли стр.СуммаСписания <> 0 и стр.Сумма <> 0 и стр.Сумма <> стр.СуммаСписания Тогда
//				ОбщегоНазначения.СообщитьПользователю(
//					НСтр("ru='Списываемая сумма не соответствует сумме выработки. "), 
//					ЭтотОбъект, 
//					СтрШаблон("Выработка[&1].Количество",Формат("ЧН=; ЧГ=;", Выработка.Индекс(стр))), 
//					"Объект", 
//					Отказ);
//				
//		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура СообщитьОбОшибкеЗаполнения(ТекстСообщения, ИмяПоля, стр, Отказ)
	ОбщегоНазначения.СообщитьПользователю(
		ТекстСообщения, 
		ЭтотОбъект, 
		СтрШаблон("Выработка[%1].%2", Формат(Выработка.Индекс(стр), "ЧН=; ЧГ=;"), ИмяПоля), 
		"Объект", 
		Отказ);
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		bz_ОбщиеАлгоритмыУУ.СоздатьПВРСтрок(
			ЭтотОбъект, 
			Документы.bz_ВыставлениеРабот, 
			"Выработка", 
			Дата,  
			"Содержание, Примечание", 
			"ПВР",
			Новый Структура("Действие", Перечисления.bz_ВариантыВыставленияОтработанногоВремени.ВыставитьБезВыработки)
		);
	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	// ПВР создается уникальным для каждого документа.
	Для Каждого стр Из Выработка Цикл
		Если стр.Действие = Перечисления.bz_ВариантыВыставленияОтработанногоВремени.ВыставитьБезВыработки Тогда
			стр.ПВР = Неопределено;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
#КонецЕсли