﻿//начало текста модуля

///////////////////////////////////////////////////
//Служебные функции и процедуры
///////////////////////////////////////////////////

&НаКлиенте
// контекст фреймворка Vanessa-Behavior
Перем Ванесса;
 
&НаКлиенте
// Структура, в которой хранится состояние сценария между выполнением шагов. Очищается перед выполнением каждого сценария.
Перем Контекст Экспорт;
 
&НаКлиенте
// Структура, в которой можно хранить служебные данные между запусками сценариев. Существует, пока открыта форма Vanessa-Behavior.
Перем КонтекстСохраняемый Экспорт;

&НаКлиенте
// Функция экспортирует список шагов, которые реализованы в данной внешней обработке.
Функция ПолучитьСписокТестов(КонтекстФреймворкаBDD) Экспорт
	Ванесса = КонтекстФреймворкаBDD;
	
	ВсеТесты = Новый Массив;

	//описание параметров
	//Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,Снипет,ИмяПроцедуры,ПредставлениеТеста,Транзакция,Параметр);

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВТЧЯДелаюДвойнойЩелчокМышкиНаПоле(ИмяТЧ, ЗаголовокПоля)","ВТЧЯДелаюДвойнойЩелчокМышкиНаПоле","Когда В ТЧ ""Таблица"" я делаю двойной щелчок мышки на поле ""ИмяПоля""");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВТЧПолеНедоступноДляРедактирования(ИмяТЧ, ЗаголовокПоля)","ВТЧПолеНедоступноДляРедактирования","И В ТЧ ""Таблица"" поле ""ИмяПоля"" недоступно для редактирования");

	Возврат ВсеТесты;
КонецФункции
	
&НаСервере
// Служебная функция.
Функция ПолучитьМакетСервер(ИмяМакета)
	ОбъектСервер = РеквизитФормыВЗначение("Объект");
	Возврат ОбъектСервер.ПолучитьМакет(ИмяМакета);
КонецФункции
	
&НаКлиенте
// Служебная функция для подключения библиотеки создания fixtures.
Функция ПолучитьМакетОбработки(ИмяМакета) Экспорт
	Возврат ПолучитьМакетСервер(ИмяМакета);
КонецФункции



///////////////////////////////////////////////////
//Работа со сценариями
///////////////////////////////////////////////////

&НаКлиенте
// Процедура выполняется перед началом каждого сценария
Процедура ПередНачаломСценария() Экспорт
	
КонецПроцедуры

&НаКлиенте
// Процедура выполняется перед окончанием каждого сценария
Процедура ПередОкончаниемСценария() Экспорт
	
КонецПроцедуры



///////////////////////////////////////////////////
//Реализация шагов
///////////////////////////////////////////////////

&НаКлиенте
//Когда В ТЧ "Таблица" я делаю двойной щелчок мышки на поле "ИмяПоля"
//@ВТЧЯДелаюДвойнойЩелчокМышкиНаПоле(ИмяТЧ, ЗаголовокПоля)
Процедура ВТЧЯДелаюДвойнойЩелчокМышкиНаПоле(ИмяТЧ, ЗаголовокПоля) Экспорт
	
	ТЧ =  НайтиТЧПоИмени(ИмяТЧ);
	ПолеРеквизит = ТЧ.НайтиОбъект(Тип("ТестируемоеПолеФормы"), ЗаголовокПоля);
	
	Если ПолеРеквизит = Неопределено Тогда
		Стр = "Поле с заголовком <" + ЗаголовокПоля + "> не найдено!";
		Сообщить(Стр);
		ВызватьИсключение Стр;
	КонецЕсли;	 
	
	ПолеРеквизит.Активизировать();
	
	СделатьДействияПриЗаписиВидео();
	СделатьДействияПриЗаписиHTML();
	
	ТЧ.Выбрать();
	
КонецПроцедуры

&НаКлиенте
//И В ТЧ "Таблица" поле "ИмяПоля" недоступно для редактирования
//@ВТЧПолеНедоступноДляРедактирования(ИмяТЧ, ЗаголовокПоля)
Процедура ВТЧПолеНедоступноДляРедактирования(ИмяТЧ, ЗаголовокПоля) Экспорт
	
	Попытка
		
		Ванесса.Шаг("И В открытой форме в ТЧ """ + ИмяТЧ + """ в поле """ + ЗаголовокПоля + """ я ввожу текст ""0""");
		
		Стр = "В ТЧ <" + ИмяТЧ + "> поле с заголовком <" + ЗаголовокПоля + "> доступно для редактирования, а должно было быть недоступно!";
		Сообщить(Стр);
		ВызватьИсключение Стр;
		
	Исключение
		Стр = ОписаниеОшибки();
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Функция НайтиТЧПоИмени(ИмяТЧ)
	
	Получилось = Ложь;
	
	Если Не Получилось Тогда
		
		ОкноПриложения = ПолучитьАктивноеОкноИзТестовоеПриложение();
		НужнаяФорма = ОкноПриложения.НайтиОбъект(Тип("ТестируемаяФорма"));
		
		Если НужнаяФорма = Неопределено Тогда
			
			//иногда 1С некорректно отдаёт текущее окно, тогда будем искать во всех окнах
			//сначала поищем в недавно открытом окне
			
			Попытка
				ОкноПриложения = ПолучитьАктивноеОкноИзКонтекста();
				НужнаяФорма    = ОкноПриложения.НайтиОбъект(Тип("ТестируемаяФорма"));
			Исключение
				
			КонецПопытки;
			
		КонецЕсли;
			
		Если ИмяТЧ = "" Тогда
			ТЧ = НужнаяФорма.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"));
		Иначе	
			ТЧ = НужнаяФорма.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"), , ИмяТЧ);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТЧ;
	
КонецФункции

&НаКлиенте
Функция ПолучитьАктивноеОкноИзТестовоеПриложение()
	Возврат КонтекстСохраняемый.ТестовоеПриложение.ПолучитьАктивноеОкно();
КонецФункции

&НаКлиенте
Функция ПолучитьАктивноеОкноИзКонтекста()
	Возврат Контекст.АктивноеОкно;
КонецФункции	

&НаКлиенте
Процедура СделатьДействияПриЗаписиВидео(ПарамСтр = "")
	Ванесса.СделатьДействияПриЗаписиВидео(ПарамСтр);
КонецПроцедуры

&НаКлиенте
Процедура СделатьДействияПриЗаписиHTML(ПарамСтр = "")
	Ванесса.СделатьДействияПриЗаписиHTML(ПарамСтр);
КонецПроцедуры

//окончание текста модуля