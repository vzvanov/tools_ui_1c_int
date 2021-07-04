

#Область ПрограммныйИнтерфейс

Функция ПрефиксЭлементовРедактораКода() Экспорт
	Возврат "РедакторКода1С";
КонецФункции

Функция ИмяРеквизитаРедактораКода(ИдентификаторРедактора) Экспорт
	Возврат ПрефиксЭлементовРедактораКода()+"_"+ИдентификаторРедактора;
КонецФункции

Функция ИмяРеквизитаРедактораКодаВидРедактора(ИдентификаторРедактора) Экспорт
	Возврат ПрефиксЭлементовРедактораКода()+"_ВидРедактора_"+ИдентификаторРедактора;
КонецФункции

Функция ИмяРеквизитаРедактораКодаАдресБиблиотеки(ИдентификаторРедактора) Экспорт
	Возврат ПрефиксЭлементовРедактораКода()+"_АдресБиблиотекиВоВременномХранилище_"+ИдентификаторРедактора;
КонецФункции

Функция ВариантыРедактораКода() Экспорт
	Варианты = Новый Структура;
	Варианты.Вставить("Текст", "Текст");
	Варианты.Вставить("Ace", "Ace");
	Варианты.Вставить("Monaco", "Monaco");

	Возврат Варианты;
КонецФункции

Функция ВариантРедактораПоУмолчанию() Экспорт
	Возврат ВариантыРедактораКода().Ace;
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
// предназначен для модулей, которые являются частью некоторой функциональной подсистемы. В нем должны быть размещены экспортные процедуры и функции, которые допустимо вызывать только из других функциональных подсистем этой же библиотеки.
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// содержит процедуры и функции, составляющие внутреннюю реализацию общего модуля. В тех случаях, когда общий модуль является частью некоторой функциональной подсистемы, включающей в себя несколько объектов метаданных, в этом разделе также могут быть размещены служебные экспортные процедуры и функции, предназначенные только для вызова из других объектов данной подсистемы.
#КонецОбласти