#Использовать v8runner
#Использовать v8find
#Использовать fs
#Использовать tempfiles
#Использовать osparser
#Использовать "plugins"


Перем КаталогИсходныхФайлов;
Перем КаталогИсходныхФайловРезультирующегоРасширения;
Перем ВариантСборки Экспорт;
Перем ИмяКаталогаПлатформы Экспорт;
Перем КаталогРезультатаСборки;
Перем Лог;
Перем МенеджерВременныхФайлов;
Перем Версия;

Процедура УстановитьКаталогИсходныхФайлов(Каталог) Экспорт
	КаталогИсходныхФайлов=Каталог;
КонецПроцедуры

Процедура УстановитьКаталогРезультатаСборки(Каталог) Экспорт
	КаталогРезультатаСборки = Каталог;
	МенеджерВременныхФайлов.БазовыйКаталог = ОбъединитьПути(КаталогРезультатаСборки, "tmp");
	
КонецПроцедуры

Процедура УстановитьЛог(НовыйЛог) Экспорт
	Лог=НовыйЛог;
КонецПроцедуры

Процедура УдалитьОбъектыИзОписанияПодсистем(КаталогПодсистем, УдаляемыеОбъекты)
	ПроцессорXML = Новый СериализаторXML();
	
	МассивФайловПодсистем = НайтиФайлы(КаталогПодсистем, "*.xml", Ложь);
	Для Каждого ФайлПодсистемы Из МассивФайловПодсистем Цикл
		ИмяПодсистемы = ФайлПодсистемы.ИмяБезРасширения;
		
		
		ОписаниеПодсистемы = ПроцессорXML.ПрочитатьИзФайла(ФайлПодсистемы.ПолноеИмя);
		СоставПодсистемы = ОписаниеПодсистемы["MetaDataObject"]._Элементы["Subsystem"]._Элементы["Properties"]["Content"];
		
		ЕстьИзменения=Ложь;
		Если ТипЗнч(СоставПодсистемы)=Тип("Массив") Тогда
			ИндексМассива = СоставПодсистемы.Количество() - 1;
			Пока ИндексМассива >= 0 Цикл
				ЭлементСостава = СоставПодсистемы[ИндексМассива];
				Для Каждого Эл Из ЭлементСостава Цикл
					Ключ = Эл.Ключ;
					Значение = Эл.Значение;
				КонецЦикла;
				
				Если УдаляемыеОбъекты.Найти(Значение._Значение) <> Неопределено Тогда
					СоставПодсистемы.Удалить(ИндексМассива);
					ЕстьИзменения=Истина;
				КонецЕсли;
				
				ИндексМассива = ИндексМассива - 1;
			КонецЦикла;		
		Иначе
			
			КлючиКУдалению = Новый Массив;
			Для Каждого ЭлементСостава Из СоставПодсистемы Цикл
				Ключ = ЭлементСостава.Ключ;
				Значение = ЭлементСостава.Значение;
				
				Если УдаляемыеОбъекты.Найти(Значение._Значение) <> Неопределено Тогда
					КлючиКУдалению.Добавить(Ключ);
				КонецЕсли;
			КонецЦикла;		
			
			Для Каждого Ключ Из КлючиКУдалению Цикл
				СоставПодсистемы.Удалить(Ключ);
				ЕстьИзменения=Истина;
			КонецЦикла;
		КонецЕсли;
		Если ЕстьИзменения Тогда
			ПроцессорXML.ЗаписатьВФайл(ОписаниеПодсистемы, ФайлПодсистемы.ПолноеИмя, Истина);
		КонецЕсли;
		ПодчиненныеПодсистемы = ОписаниеПодсистемы["MetaDataObject"]._Элементы["Subsystem"]._Элементы["ChildObjects"];
		Если ПодчиненныеПодсистемы<>Неопределено Тогда
			Для Каждого ЭлементПодчиненнойПодсистемы Из ПодчиненныеПодсистемы Цикл
				УдалитьОбъектыИзОписанияПодсистем(ОбъединитьПути(КаталогПодсистем, ИмяПодсистемы, "Subsystems"), УдаляемыеОбъекты);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура УдалитьСтруктурыТаблицДанных(ОписаниеОсновногоРасширения)
	УдаляемыеОбъекты = Новый Массив;
	УдаляемыеОбъекты.Добавить("Catalog.UT_Algorithms");
	
	УдалитьПодчиненныеОбъектыРасширения(ОписаниеОсновногоРасширения, УдаляемыеОбъекты);
	
	// УдалитьФайлы(ОбъединитьПути(КаталогИсходныхФайловРезультирующегоРасширения, "Catalogs"));
	
	// 3. Удалить объекты из подсистем
	УдалитьОбъектыИзОписанияПодсистем(ОбъединитьПути(КаталогИсходныхФайловРезультирующегоРасширения, "Subsystems"), УдаляемыеОбъекты);
КонецПроцедуры

Функция РазложенныеУдаляемыеОбъекты(УдаляемыеОбъекты)
	РазложенныеУдаляемыеОбъекты = Новый Массив;
	Для Каждого ИмяОбъекта Из УдаляемыеОбъекты Цикл
		СтруктураОъекта = Новый Структура;
		
		массивИмени = СтрРазделить(ИмяОбъекта, ".");
		СтруктураОъекта.Вставить("Вид", массивИмени[0]);
		СтруктураОъекта.Вставить("Имя", массивИмени[1]);
		
		РазложенныеУдаляемыеОбъекты.Добавить(СтруктураОъекта);
	КонецЦикла;
	
	Возврат РазложенныеУдаляемыеОбъекты;
КонецФункции

Процедура УдалитьПодчиненныеОбъектыРасширения(ОписаниеРасширения, УдаляемыеОбъекты)
	ПодчиненныеОбъектыОсновногоРасширения = ОписаниеРасширения["MetaDataObject"]._Элементы["Configuration"]._Элементы["ChildObjects"];
	
	РазложенныеУдаляемыеОбъекты = РазложенныеУдаляемыеОбъекты(УдаляемыеОбъекты);
	
	// 1. Нужно удалить данные об объектах из основного расширения
	ИндексМассива = ПодчиненныеОбъектыОсновногоРасширения.Количество() - 1;
	Пока ИндексМассива >= 0 Цикл
		ПодчиненныйОбъект = ПодчиненныеОбъектыОсновногоРасширения[ИндексМассива];
		Для Каждого Эл Из ПодчиненныйОбъект Цикл
			Ключ = Эл.Ключ;
			Значение = Эл.Значение;
		КонецЦикла;
		
		УдаляемОбъект = Ложь;
		Для Каждого УдОбъект ИЗ РазложенныеУдаляемыеОбъекты Цикл
			Если УдОбъект.Вид = Ключ
				И УдОбъект.Имя = Значение Тогда
				УдаляемОбъект = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если УдаляемОбъект Тогда
			ПодчиненныеОбъектыОсновногоРасширения.Удалить(ИндексМассива);
		КонецЕсли;
		
		ИндексМассива = ИндексМассива - 1;
	КонецЦикла;
	
	
	// 2. Удалить папки со структурами данных
	Для Каждого УдаляемыйМодуль Из РазложенныеУдаляемыеОбъекты Цикл
		ИмяПапкиМодуля =	"CommonModules";
		Если УдаляемыйМодуль.Вид = "Catalog" Тогда
			ИмяПапкиМодуля =	"Catalogs";
		КонецЕсли;
		УдалитьФайлы(ОбъединитьПути(КаталогИсходныхФайловРезультирующегоРасширения, ИмяПапкиМодуля, УдаляемыйМодуль.Имя));
		УдалитьФайлы(ОбъединитьПути(КаталогИсходныхФайловРезультирующегоРасширения, ИмяПапкиМодуля, УдаляемыйМодуль.Имя + ".xml"));
	КонецЦикла;
	
КонецПроцедуры

Процедура УдалитьПоддержкуБСП(ОписаниеОсновногоРасширения)
	УдаляемыеОбъекты = Новый Массив;
	УдаляемыеОбъекты.Добавить("CommonModule.AttachableCommandsOverridable");
	УдаляемыеОбъекты.Добавить("CommonModule.AdditionalReportsAndDataProcessors");
	УдаляемыеОбъекты.Добавить("Catalog.AdditionalReportsAndDataProcessors");
	
	УдалитьПодчиненныеОбъектыРасширения(ОписаниеОсновногоРасширения, УдаляемыеОбъекты);
	
	
КонецПроцедуры

Функция ТекстМодуля(ФайлМодуля)
	Текст=Новый ТекстовыйДокумент;
	Текст.Прочитать(ФайлМодуля);
	
	Возврат Текст.ПолучитьТекст();
КонецФункции

Процедура ЗаписатьМодуль(ТекстМодуля, имяФайла)
	Текст=Новый ТекстовыйДокумент;
	Текст.УстановитьТекст(ТекстМодуля);
	
	Текст.Записать(Имяфайла);
	
КонецПроцедуры

Процедура ДобавитьИнформациюОСборкеВОбщийМодуль(ВКонфигурацию=Ложь) Экспорт
	ИмяФайла=ОбъединитьПути(ОбъединитьПути(КаталогИсходныхФайловРезультирующегоРасширения,"CommonModules","UT_CommonClientServer","Ext"),"Module.bsl");

	Исходник=ТекстМодуля(ИмяФайла);

	Парсер = Новый ПарсерВстроенногоЯзыка;
		
	ПлагинУстановкаВариантаСборки = Новый УстановкаВариантаСборки();
		
	Плагины = Новый Массив();
	Плагины.Добавить(ПлагинУстановкаВариантаСборки);
		
	НастройкиПлагина=Новый Структура;
	НастройкиПлагина.Вставить("ВариантСборки",ВариантСборки);
	НастройкиПлагина.Вставить("Версия",Версия);
	НастройкиПлагина.Вставить("ВКонфигурацию",ВКонфигурацию);

	ПараметрыПлагинов = Новый Соответствие;
	ПараметрыПлагинов[ПлагинУстановкаВариантаСборки] = НастройкиПлагина;
		
	Результаты = Парсер.Пуск(Исходник, Плагины, ПараметрыПлагинов);
		
	Замены = Парсер.ТаблицаЗамен();
	Если Замены.Количество() > 0 Тогда
		НовыйИсходник = Парсер.ВыполнитьЗамены();
		ЗаписатьМодуль(НовыйИсходник, ИмяФайла);
	КонецЕсли;
КонецПроцедуры

Процедура ВыполнитьСборкуИсходников() Экспорт
	
	КаталогИсходныхФайловРезультирующегоРасширения = КаталогРезультатаСборки;
	
	ФС.КопироватьСодержимоеКаталога(ОбъединитьПути(КаталогИсходныхФайлов, "ToolsInternational"), КаталогИсходныхФайловРезультирующегоРасширения);
	
	ПроцессорXML = Новый СериализаторXML();
	
	ОписаниеОсновногоРасширения = ПроцессорXML.ПрочитатьИзФайла(ОбъединитьПути(КаталогИсходныхФайловРезультирующегоРасширения, "Configuration.xml"));
	// ОписаниеРасширенияИнтеграции = ПроцессорXML.ПрочитатьИзФайла(ОбъединитьПути(ВременныйКаталогРасширенияИнтеграции, "Configuration.xml"));
	
	СвойстваКонфигурацииОсновногоРасширения = ОписаниеОсновногоРасширения["MetaDataObject"]._Элементы["Configuration"]._Элементы["Properties"];
	Если ЗначениеЗаполнено(ВариантСборки.СуффиксИмени) Тогда
		СвойстваКонфигурацииОсновногоРасширения["Name"] = СвойстваКонфигурацииОсновногоРасширения["Name"] + "_" + ВариантСборки.СуффиксИмени;
	КонецЕсли;
	Если ЗначениеЗаполнено(ВариантСборки.СуффиксСинонима) Тогда
			СвойстваКонфигурацииОсновногоРасширения["Synonym"]["v8:item"]["v8:content"] = СвойстваКонфигурацииОсновногоРасширения["Synonym"]["v8:item"]["v8:content"] + " " + ВариантСборки.СуффиксСинонима;
	КонецЕсли;
	
	Если ВариантСборки.ИсключатьТаблицыБД Тогда
		УдалитьСтруктурыТаблицДанных(ОписаниеОсновногоРасширения);
		
		СвойстваКонфигурацииОсновногоРасширения["ConfigurationExtensionCompatibilityMode"] = "Version8_3_10";
		// < ConfigurationExtensionCompatibilityMode > Version8_3_9 < /ConfigurationExtensionCompatibilityMode > 
	КонецЕсли;
	
	Если Не ВариантСборки.ПоддержкаБСП Тогда
		УдалитьПоддержкуБСП(ОписаниеОсновногоРасширения);
	КонецЕсли;
	Версия=СвойстваКонфигурацииОсновногоРасширения["Version"];
	ПодчиненныеОбъектыОсновногоРасширения=ОписаниеОсновногоРасширения["MetaDataObject"]._Элементы["Configuration"]._Элементы["ChildObjects"];
	// ПодчиненныеОбъектыРасширенияИнтеграции = ОписаниеРасширенияИнтеграции["MetaDataObject"]._Элементы["Configuration"]._Элементы["ChildObjects"];
	
	// Для Каждого ПодчиненныйОбъект ИЗ ПодчиненныеОбъектыРасширенияИнтеграции Цикл
	// 	Если ТипЗнч(ПодчиненныйОбъект) = Тип("КлючИЗначение") Тогда
	// 		Ключ = ПодчиненныйОбъект.Ключ;
	// 		Значение=ПодчиненныйОбъект.Значение;
	// 	Иначе
	// 		Ключ = ПодчиненныйОбъект[0].Ключ;
	// 		Значение=ПодчиненныйОбъект[0].Значение;
	// 	КонецЕсли;
	// 	Если ТипЗнч(ПодчиненныеОбъектыОсновногоРасширения) = Тип("Соответствие") Тогда
	// 		ПодчиненныеОбъектыОсновногоРасширения.Вставить(Ключ, Значение);
	// 	Иначе
	
	// 		СоответствиеВставки = Новый Соответствие();
	// 		СоответствиеВставки.Вставить(Ключ, Значение);
	// 		ПодчиненныеОбъектыОсновногоРасширения.Добавить(СоответствиеВставки);
	// 	КонецЕсли;
	
	// 	//Теперь нужно скопировать нужную папку
	// 	ИмяКаталогаОбъекта="";
	// 	Если Ключ = "CommonModule" Тогда
	// 		ИмяКаталогаОбъекта = "CommonModules";
	// 	КонецЕсли;
	
	// 	Если Не ЗначениеЗаполнено(ИмяКаталогаОбъекта) Тогда
	// 		Лог.Ошибка("Не удалось определить местоположения объекта "+Ключ+" "+Значение);
	// 		Продолжить;
	// 	КонецЕсли;
	
	// 	//Основной файл
	// 	КопироватьФайл(
	// 	ОбъединитьПути(ВременныйКаталогРасширенияИнтеграции, ИмяКаталогаОбъекта, Значение + ".xml"), 
	// 	ОбъединитьПути(КаталогИсходныхФайловРезультирующегоРасширения, ИмяКаталогаОбъекта, Значение + ".xml"));
	
	// 	ФС.КопироватьСодержимоеКаталога(
	// 	ОбъединитьПути(ВременныйКаталогРасширенияИнтеграции, ИмяКаталогаОбъекта, Значение), 
	// 	ОбъединитьПути(КаталогИсходныхФайловРезультирующегоРасширения, ИмяКаталогаОбъекта, Значение));
	// КонецЦикла;
	
	ПроцессорXML.ЗаписатьВФайл(ОписаниеОсновногоРасширения, ОбъединитьПути(КаталогИсходныхФайловРезультирующегоРасширения, "Configuration.xml"), Истина);
	
	ДобавитьИнформациюОСборкеВОбщийМодуль();

	МенеджерВременныхФайлов.Удалить();
	Если ЗначениеЗаполнено(МенеджерВременныхФайлов.БазовыйКаталог) Тогда
		УдалитьФайлы(МенеджерВременныхФайлов.БазовыйКаталог);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьСозданиеБинарногоФайла(Знач ИмяФайлаРасширения) Экспорт
	
	ИмяВременнойБазы = МенеджерВременныхФайлов.СоздатьКаталог();
	ФС.ОбеспечитьКаталог(ИмяВременнойБазы);
	
	Конфигуратор = Новый УправлениеКонфигуратором();
	Если ЗначениеЗаполнено(ИмяКаталогаПлатформы) Тогда
		Конфигуратор.ПутьКПлатформе1С(ОбъединитьПути(ИмяКаталогаПлатформы,"1cv8"+?(ОбщиеМетоды.ЭтоWindows(),".exe","")));
	КонецЕсли;
	
	Лог.Информация(СтрШаблон("Создаю временную базу %1", ИмяВременнойБазы));
	Конфигуратор.СоздатьФайловуюБазу(ИмяВременнойБазы);
	
	Конфигуратор.УстановитьКонтекст("/F" + ИмяВременнойБазы, "", "");
	
	Лог.Информация(СтрШаблон("Загружаю исходные файлы в базу"));
	Конфигуратор.ЗагрузитьРасширениеИзФайлов(КаталогИсходныхФайловРезультирующегоРасширения, "UniversalTools");
	
	Конфигуратор.ВыгрузитьРасширениеВФайл(ИмяФайлаРасширения,  "UniversalTools");
	
	МенеджерВременныхФайлов.Удалить();
	УдалитьФайлы(МенеджерВременныхФайлов.БазовыйКаталог);
КонецПроцедуры

Лог = Новый Лог("app.build.tools_ui_1c");
МенеджерВременныхФайлов = Новый МенеджерВременныхФайлов();
