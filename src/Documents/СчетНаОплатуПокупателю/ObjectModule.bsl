
#Если Сервер или ТолстыйКлиентОбычноеПриложение или ВнешнееСоединение Тогда
		
#Область ОбработчикиСобытий
&После("ОбработкаПроведения")
Процедура bz_ОбработкаПроведения(Отказ, РежимПроведения)
	Перем bz_Движение;
	Движения.bz_РаботыКВыставлению.Записывать = Истина;
	Для Каждого стр Из bz_ВыставляемыеРаботы Цикл
		bz_Движение = Движения.bz_РаботыКВыставлению.Добавить();
		bz_Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		ЗаполнитьЗначенияСвойств(bz_Движение, стр);
		bz_Движение.Период = Дата;
		bz_Движение.Организация = Организация;
		bz_Движение.КоличествоСогласовано = стр.Количество;
		bz_Движение.СуммаСогласовано = стр.Сумма;
	КонецЦикла;
КонецПроцедуры


&После("ПередЗаписью")
Процедура bz_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = СуммаДокумента - УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "bz_ВыставляемыеРаботы");
КонецПроцедуры
#КонецОбласти


&После("ОбработкаУдаленияПроведения")
Процедура bz_ОбработкаУдаленияПроведения(Отказ)
	НЗ = Движения.bz_РаботыКВыставлению;
	НЗ.Прочитать();
	Если НЗ.Количество() Тогда
		НЗ.Очистить();
		НЗ.Записать(Истина);
	КонецЕсли;	
КонецПроцедуры


#КонецЕсли
