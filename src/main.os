﻿#Использовать "model"

Процедура ПриНачалеРаботыСистемы()
	
	ИспользоватьСтатическиеФайлы();
	ИспользоватьМаршруты("ОпределениеМаршрутов");

КонецПроцедуры

Процедура ОпределениеМаршрутов(КоллекцияМаршрутов)
	КоллекцияМаршрутов.Добавить("Основной","{controller=agents}/{action=Index}/{id?}");
КонецПроцедуры
