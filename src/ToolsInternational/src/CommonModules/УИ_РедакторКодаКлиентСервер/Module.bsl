

#Область ПрограммныйИнтерфейс

Функция ПрефиксЭлементовРедактораКода() Экспорт
	Возврат "РедакторКода1С";
КонецФункции

Функция ИмяРеквизитаРедактораКода(ИдентификаторРедактора) Экспорт
	Возврат ПрефиксЭлементовРедактораКода()+"_"+ИдентификаторРедактора;
КонецФункции

Функция ИмяРеквизитаРедактораКодаВидРедактора() Экспорт
	Возврат ПрефиксЭлементовРедактораКода()+"_ВидРедактора";
КонецФункции

Функция ИмяРеквизитаРедактораКодаАдресБиблиотеки() Экспорт
	Возврат ПрефиксЭлементовРедактораКода()+"_АдресБиблиотекиВоВременномХранилище";
КонецФункции

Функция ИмяРеквизитаРедактораКодаСписокРедакторовФормы() Экспорт
	Возврат ПрефиксЭлементовРедактораКода()+"_СписокРедакторовФормы";
КонецФункции

Функция ИмяРеквизитаРедактораКодаРедакторыФормы(ИдентификаторРедактора) Экспорт
	Возврат ПрефиксЭлементовРедактораКода()+"_РедакторыФормы";
КонецФункции

Функция ВариантыРедактораКода() Экспорт
	Варианты = Новый Структура;
	Варианты.Вставить("Текст", "Текст");
	Варианты.Вставить("Ace", "Ace");
	Варианты.Вставить("Monaco", "Monaco");

	Возврат Варианты;
КонецФункции

Функция ВариантРедактораПоУмолчанию() Экспорт
	Возврат ВариантыРедактораКода().Monaco;
КонецФункции

Функция РедакторКодаИспользуетПолеHTML(ВидРедактора) Экспорт
	Варианты=ВариантыРедактораКода();
	Возврат ВидРедактора = Варианты.Ace
		Или ВидРедактора = Варианты.Monaco;
КонецФункции

Функция ИдентификаторРедактораПоЭлементуФормы(Форма, Элемент) Экспорт
	РедакторыФормы = Форма[УИ_РедакторКодаКлиентСервер.ИмяРеквизитаРедактораКодаСписокРедакторовФормы()];

	Для Каждого КлючЗначение Из РедакторыФормы Цикл
		Если КлючЗначение.Значение.ПолеРедактора = Элемент.Имя Тогда
			Возврат КлючЗначение.Ключ;
		КонецЕсли;
	КонецЦикла;

	Возврат Неопределено;
КонецФункции

Функция ВыполнитьАлгоритм(__ТекстАлготима__, __Контекст__) Экспорт
	Успешно = Истина;
	ОписаниеОшибки = "";
	
	ВыполняемыйТекстАлгоритма = ДополненныйКонтекстомКодАлгоритма(__ТекстАлготима__, __Контекст__);

	НачалоВыполнения = ТекущаяУниверсальнаяДатаВМиллисекундах();
	Попытка
		Выполнить (ВыполняемыйТекстАлгоритма);
	Исключение
		Успешно = Ложь;
		ОписаниеОшибки = ОписаниеОшибки();
		Сообщить(ОписаниеОшибки);
	КонецПопытки;
	ОкончаниеВыполнения = ТекущаяУниверсальнаяДатаВМиллисекундах();

	РезультатВыполнения = Новый Структура;
	РезультатВыполнения.Вставить("Успешно", Успешно);
	РезультатВыполнения.Вставить("ВремяВыполнения", ОкончаниеВыполнения - НачалоВыполнения);
	РезультатВыполнения.Вставить("ОписаниеОшибки", ОписаниеОшибки);

	Возврат РезультатВыполнения;
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ВариантыЯзыкаСинтаксисаРедактораMonaco() Экспорт
	ЯзыкиСинтаксиса = Новый Структура;
	ЯзыкиСинтаксиса.Вставить("Авто", "Авто");
	ЯзыкиСинтаксиса.Вставить("Русский", "Русский");
	ЯзыкиСинтаксиса.Вставить("Английский", "Английский");
	
	Возврат ЯзыкиСинтаксиса;
КонецФункции

Функция ВариантыТемыРедактораMonaco() Экспорт
	Варианты = Новый Структура;
	
	Варианты.Вставить("Светлая", "Светлая");
	Варианты.Вставить("Темная", "Темная");
	
	Возврат Варианты;
КонецФункции

Функция ТемаРедактораMonacoПоУмолчанию() Экспорт
	ТемыРедактора = ВариантыТемыРедактораMonaco();
	
	Возврат ТемыРедактора.Светлая;
КонецФункции
Функция ЯзыкСинтаксисаРедактораMonacoПоУмолчанию() Экспорт
	Варианты = ВариантыЯзыкаСинтаксисаРедактораMonaco();
	
	Возврат Варианты.Авто;
КонецФункции

Функция ПараметрыРедактораMonacoПоУмолчанию() Экспорт
	ПараметрыРедактора = Новый Структура;
	ПараметрыРедактора.Вставить("ВысотаСтрок", 0);
	ПараметрыРедактора.Вставить("Тема", ТемаРедактораMonacoПоУмолчанию());
	ПараметрыРедактора.Вставить("ЯзыкСинтаксиса", ЯзыкСинтаксисаРедактораMonacoПоУмолчанию());
	ПараметрыРедактора.Вставить("ИспользоватьКартуКода", Ложь);
	ПараметрыРедактора.Вставить("СкрытьНомераСтрок", Ложь);
	ПараметрыРедактора.Вставить("КаталогиИсходныхФайлов", Новый Массив);
	
	Возврат ПараметрыРедактора;
КонецФункции

Функция ПараметрыРедактораКодаПоУмолчанию() Экспорт
	ПараметрыРедактора = Новый Структура;
	ПараметрыРедактора.Вставить("Вариант",  ВариантРедактораПоУмолчанию());
	ПараметрыРедактора.Вставить("РазмерШрифта", 0);
	ПараметрыРедактора.Вставить("Monaco", ПараметрыРедактораMonacoПоУмолчанию());
	
	Возврат ПараметрыРедактора;
КонецФункции

Функция НовыйОписаниеКаталогаИсходныхФайловКонфигурации() Экспорт
	Описание = Новый Структура;
	Описание.Вставить("Каталог", "");
	Описание.Вставить("Источник", "");
	
	Возврат Описание;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДополненныйКонтекстомКодАлгоритма(ТекстАлготима, Контекст)
	ПодготовленныйКод="";

	Для Каждого КлючЗначение Из Контекст Цикл
		ПодготовленныйКод = ПодготовленныйКод +"
		|"+КлючЗначение.Ключ+"=__Контекст__."+КлючЗначение.Ключ+";";
	КонецЦикла;

	ПодготовленныйКод=ПодготовленныйКод + Символы.ПС + ТекстАлготима;

	Возврат ПодготовленныйКод;
КонецФункции

#КонецОбласти