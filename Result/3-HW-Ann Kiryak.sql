--  !!! В выходной выборке должны присутствовать только запрашиваемые в условии поля.

-- 1. Напишите один запрос с использованием псевдонимов для таблиц и псевдонимов полей, 
--    выбирающий все возможные комбинации городов (CITY) из таблиц 
--    STUDENTS, LECTURERS и UNIVERSITIES
--    строки не должны повторяться, убедитесь в выводе только уникальных троек городов
--    Внимание: убедитесь, что каждая колонка выборки имеет свое уникальное имя

SELECT DISTINCT s.CITY as City_st, l.CITY as City_lect, u.CITY as City_univ
FROM STUDENTS s, LECTURERS l, UNIVERSITIES u;


-- 2. Напишите запрос для вывода полей в следущем порядке: семестр, в котором он
--    читается, идентификатора (номера ID) предмета обучения, его наименования и 
--    количества отводимых на этот предмет часов для всех строк таблицы SUBJECTS

SELECT  s.SEMESTER, s.ID, s.NAME, s.HOURS
FROM SUBJECTS s 
 

-- 3. Выведите все строки таблицы EXAM_MARKS, в которых предмет обучения SUBJ_ID равен 4

SELECT  *
FROM EXAM_MARKS
WHERE SUBJ_ID=4

-- 4. Необходимо выбирать все данные, в следующем порядке 
--    Стипендия, Курс, Фамилия, Имя  из таблицы STUDENTS, причем интересуют
--    студенты, родившиеся после '1993-07-21'

SELECT STIPEND, COURSE, SURNAME, NAME
FROM STUDENTS
WHERE BIRTHDAY>'1993-07-21'

-- 5. Вывести на экран все предметы: их наименования и кол-во часов для каждого из них
--    в 1-м семестре и при этом кол-во часов не должно превышать 41

SELECT NAME, HOURS
FROM SUBJECTS
WHERE SEMESTER=1 AND HOURS<=41

-- 6. Напишите запрос, позволяющий вывести из таблицы EXAM_MARKS уникальные 
--    значения экзаменационных оценок, которые были получены '2012-06-12'

SELECT DISTINCT MARK
FROM EXAM_MARKS
WHERE EXAM_DATE='2012-06-12'

-- 7. Выведите список фамилий студентов, обучающихся на третьем и последующих 
--    курсах и при этом проживающих не в Киеве, не Харькове и не Львове.

SELECT SURNAME
FROM STUDENTS
WHERE COURSE in (3,4,5) and CITY not in ('Киев', 'Харьков', 'Львов')


SELECT SURNAME
FROM STUDENTS
WHERE COURSE>=3 and CITY not in ('Киев', 'Харьков', 'Львов')



-- 8. Покажите данные о фамилии, имени и номере курса для студентов, 
--    получающих стипендию в диапазоне от 450 до 650, не включая 
--    эти граничные суммы. Приведите несколько вариантов решения этой задачи.

SELECT SURNAME, NAME, COURSE
FROM STUDENTS
WHERE STIPEND>450 AND STIPEND<650


SELECT SURNAME, NAME, COURSE
FROM STUDENTS
WHERE STIPEND BETWEEN 450 AND 650 AND STIPEND not in (450, 650)

SELECT SURNAME, NAME, COURSE, STIPEND
FROM STUDENTS
WHERE STIPEND>451 AND STIPEND<649


-- 9. Напишите запрос, выполняющий выборку из таблицы LECTURERS всех фамилий
--    преподавателей, проживающих во Львове, либо же преподающих в университете
--    с идентификатором 14

SELECT SURNAME
FROM LECTURERS
WHERE CITY='Львов' OR UNIV_ID=14

-- 10. Выясните в каких городах (названия) расположены университеты,  
--     рейтинг которых составляет 528 +/- 47 баллов.

SELECT DISTINCT CITY
FROM UNIVERSITIES
WHERE RATING BETWEEN (528-47) AND (528+47)

-- 11. Отобрать список фамилий киевских студентов, их имен и дат рождений 
--     для всех нечетных курсов.

SELECT SURNAME, NAME, BIRTHDAY
FROM STUDENTS
WHERE COURSE in (1,3,5) AND CITY='Киев';

SELECT SURNAME, NAME, BIRTHDAY
FROM STUDENTS
WHERE COURSE %2<>0 AND CITY='Киев';

-- 12. Упростите выражение фильтрации (избавтесь от NOT) и дайте логическую формулировку запроса?
-- SELECT * FROM STUDENTS WHERE (STIPEND < 500 OR NOT (BIRTHDAY >= '1993-01-01' AND ID > 9))
-- Подсказка: после упрощения, запрос должен возвращать ту же выборку, что и оригинальный


-- Вывести всех студентов из таблицы STUDENTS у которых стипендия не превышает 500 или при этом студентов которые родились до '1993-01-01' или их идентификатор не превышает 9
SELECT * 
FROM STUDENTS 
WHERE (STIPEND < 500 OR (BIRTHDAY < '1993-01-01' OR ID <= 9))

-- 13. Упростите выражение фильтрации (избавтесь от NOT) и дайте логическую формулировку запроса?
-- SELECT * FROM STUDENTS WHERE NOT ((BIRTHDAY = '1993-06-07' OR STIPEND > 500) AND ID >= 9)
-- Подсказка: после упрощения, запрос должен возвращать ту же выборку, что и оригинальный


-- Вывести всех студентов из таблицы STUDENTS которые не родились '1993-06-07' и стипендия не должна превышать 500 или при этом идентификатор студента не должен превышать 9
SELECT *  
FROM STUDENTS 
WHERE (BIRTHDAY <> '1993-06-07' AND STIPEND <=500) OR ID <= 9