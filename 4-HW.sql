-- Внимание! Во всех результирующих выборках должны быть учтены все записи, даже
-- те, которые содержать NULL поля, однако, склейка не должна быть NULL записью!
-- Для этого используйте либо CASE, либо функцию 
-- ISNULL(<выражение>, <значение по умолчанию>) -- Microsoft SQL Server
-- IFNULL(<выражение>, <значение по умолчанию>) -- MySQL
-- Соблюдать это условие достаточно для двух полей BIRTHDAY и UNIV_ID.

-- 1. Составьте запрос для таблицы STUDENT таким образом, чтобы выходная таблица 
--    содержала один столбец типа varchar, содержащий последовательность разделенных 
--    символом ';' (точка с запятой) значений столбцов этой таблицы, и при этом 
--    текстовые значения должны отображаться прописными символами (верхний регистр), 
--    то есть быть представленными в следующем виде: 
--    1;КАБАНОВ;ВИТАЛИЙ;550;4;ХАРЬКОВ;01/12/1990;2.
--    ...
--    примечание: в выборку должны попасть студенты из любого города из 5 букв


-- 2. Составьте запрос для таблицы STUDENT таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде: 
--    В.КАБАНОВ;местожительства-ХАРЬКОВ;родился-01.12.90
--    ...
--    примечание: в выборку должны попасть студенты, фамилия которых содержит вторую
--    букву 'е' и предпоследнюю букву 'и', либо же фамилия заканчивается на 'ц'


-- 3. Составьте запрос для таблицы STUDENT таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде:
--    т.цилюрик;местожительства-Херсон; учится на IV курсе
--    ...
--    примечание: курс указать римскими цифрами, отобрать студентов, стипендия 
--    которых кратна 200


-- 4. Составьте запрос для таблицы STUDENT таким образом, чтобы выборка 
--    содержала столбец в следующего вида:
--     Нина Федосеева из г.Днепропетровск родилась в 1992 году
--     ...
--     Дмитрий Коваленко из г.Хмельницкий родился в 1993 году
--     ...
--     примечание: для всех городов, в которых более 8 букв


-- 5. Вывести фамилии, имена студентов и величину получаемых ими стипендий, 
--    при этом значения стипендий первокурсников должны быть увеличены на 17.5%


-- 6. Вывести наименования всех учебных заведений и их расстояния 
--    (придумать/нагуглить/взять на глаз) до Киева.


-- 7. Вывести все учебные заведения и их две последние цифры рейтинга.


-- 8. Составьте запрос для таблицы UNIVERSITY таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде:
--    Код-1;КПИ-г.Киев;Рейтинг относительно ДНТУ(501) +756
--    ...
--    Код-11;КНУСА-г.Киев;рейтинг относительно ДНТУ(501) -18
--    ...
--    примечание: рейтинг вычислить относительно ДНТУшного, а также должен 
--    присутствовать знак (+/-), рейтинг ДНТУ заранее известен = 501


-- 9. Составьте запрос для таблицы UNIVERSITY таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде:
--    Код-1;КПИ-г.Киев;рейтинг состоит из 12 сотен
--    Код-2;КНУ-г.Киев;рейтинг состоит из 6 сотен
--    ...
--    примечание: в рейтинге необходимо указать кол-во сотен
