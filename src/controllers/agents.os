Функция Index() Экспорт
	
	ТаблицаАгентов = ЦентральныеСерверы.ПолучитьСписок();
	Возврат Представление(ТаблицаАгентов);

КонецФункции

Функция Add() Экспорт

    // Проверяем, что Add вызван с помощью отправки формы методом HTTP POST
    Если ЗапросHttp.Метод = "POST" Тогда
        
        // Получаем контекст формы из HTTP-запроса
        НовыйID  = ЗапросHttp.ДанныеФормы["Идентификатор"];
        // Получаем сохраненный на сервере список известных центральных серверов
        ТЗ = ЦентральныеСерверы.ПолучитьСписок();
        // Создадим будущую запись таблицы центральных серверов.
        Элемент = ТЗ.Добавить();
        
        // Проверяем, что в форму добавления не ввели повторный идентификатор, 
        // который уже есть в базе.
        Элементы = ТЗ.НайтиСтроки(Новый Структура("Идентификатор", НовыйID));
        Если Элементы.Количество() > 0 Тогда
            // Регистрируем ошибку в специальном объекте СостояниеМодели
            СостояниеМодели.ДобавитьОшибку("Идентификатор","Такой ID уже есть в списке агентов");
            // Метод СохранитьДанные (см. ниже в коде)
            // наполняет Элемент значениями из ДанныхФормы
            СохранитьДанные(Элемент);
            // Отправляем эти данные обратно на клиента.
            // Поскольку это ошибка, то клиент должен увидеть ту же самую форму
            // Которую он заполнил, но с сообщениями из СостояниеМодели.
            // Для создания объекта РезультатДействияСтраница пользуемся вспомогательным методом контроллера Представление()
            Возврат Представление("Item", Элемент);
        КонецЕсли;
        
        // Если ошибки не было
        // наполняем Элемент из ДанныхФормы (метод СохранитьДанные см. ниже в коде)
        СохранитьДанные(Элемент);
        // Записываем на диск измененную таблицу центральных серверов.
        ЦентральныеСерверы.Записать(ТЗ);
        // Формируем объект РезультатДействияПеренаправление с помощью вспомогательного метода контроллера Перенаправление()
        Возврат Перенаправление("/agents/index");
    КонецЕсли;
    
    // А если это не метод POST, значит нам ничего не отправлено, а пользователь только-только запросил страницу /agents/add и собирается ввести данные нового агента.
    // Возвращаем клиенту форму с полями для заполнения.
    Возврат Представление("Item");

КонецФункции

Процедура СохранитьДанные(Знач Элемент)
    
    ДанныеФормы = ЗапросHttp.ДанныеФормы;
    Элемент.Идентификатор = ДанныеФормы["Идентификатор"];
    Элемент.СетевоеИмя = ДанныеФормы["СетевоеИмя"];
    Элемент.Порт = ДанныеФормы["Порт"];
    Элемент.Описание = ДанныеФормы["Описание"];
    Элемент.Режим = "RAS";

КонецПроцедуры
Процедура ЗаполнитьДанные(Знач Элемент)
	
	ДанныеФормы = ЗапросHttp.ДанныеФормы;
	Элемент.Идентификатор = ДанныеФормы["Идентификатор"];
	Элемент.СетевоеИмя = ДанныеФормы["СетевоеИмя"];
	Элемент.Порт = ДанныеФормы["Порт"];
	Элемент.Режим = "RAS";

КонецПроцедуры

Функция Edit() Экспорт

	Идентификатор = ЗначенияМаршрута["id"];
	Если Идентификатор = Неопределено Тогда
		Возврат Перенаправление("/agents/index");
	КонецЕсли;

	ТЗ      = ЦентральныеСерверы.ПолучитьСписок();
	Элемент = ТЗ.Найти(Идентификатор, "Идентификатор");

	Если Элемент = Неопределено Тогда
		Возврат КодСостояния(404);
	КонецЕсли;

	Если ЗапросHttp.Метод = "POST" Тогда
		
		ЗаполнитьДанные(Элемент);
		ЦентральныеСерверы.Записать(ТЗ);
		
		Возврат Перенаправление("/agents/index");
	Иначе
		// Передаем в представление "модель" - Элемент
		Возврат Представление("Item", Элемент);
	КонецЕсли;
	
КонецФункции

Функция Delete() Экспорт		

	Идентификатор = ЗначенияМаршрута["id"];
	Если Идентификатор = Неопределено Тогда
		Возврат Перенаправление("/agents/index");
	КонецЕсли;

	ТЗ      = ЦентральныеСерверы.ПолучитьСписок();
	Элемент = ТЗ.Найти(Идентификатор, "Идентификатор");

	Если Элемент = Неопределено Тогда
		Возврат КодСостояния(404);
	КонецЕсли;

	ТЗ.Удалить(Элемент);	
	ЦентральныеСерверы.Записать(ТЗ);
	
	Возврат Перенаправление("/agents/index");

КонецФункции