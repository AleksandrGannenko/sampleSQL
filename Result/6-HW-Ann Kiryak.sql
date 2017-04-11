-- 1. Напишите запрос с EXISTS, позволяющий вывести данные обо всех студентах, 
--    обучающихся в вузах с рейтингом не попадающим в диапазон от 488 до 571

SELECT *
FROM STUDENTS s
WHERE NOT EXISTS (SELECT *
				FROM UNIVERSITIES u
				WHERE u.RATING BETWEEN 488 and 571 and s.UNIV_ID=u.ID);


-- 2. Напишите запрос с EXISTS, выбирающий всех студентов, для которых в том же городе, 
--    где живет и учится студент, существуют другие университеты, в которых он не учится.

SELECT *
FROM STUDENTS s
WHERE exists (
				SELECT *
				FROM UNIVERSITIES u
				WHERE	s.CITY=u.CITY and 
						s.UNIV_ID=u.ID and exists (
													SELECT *
													FROM UNIVERSITIES u
													WHERE s.CITY=u.CITY and s.UNIV_ID<>u.ID) );


-- 3. Напишите запрос, выбирающий из таблицы SUBJECTS данные о названиях предметов обучения, 
--    экзамены по которым были хоть как-то сданы более чем 12 студентами, за первые 10 дней сессии. 
--    Используйте EXISTS. Примечание: по возможности выходная выборка должна быть без пересдач.

SELECT sb.NAME
FROM SUBJECTS sb
WHERE exists (
			SELECT *
			FROM EXAM_MARKS em
			WHERE sb.ID=em.SUBJ_ID and em.EXAM_DATE<(
													SELECT MIN(em.EXAM_DATE)+10
													FROM EXAM_MARKS em )
			HAVING COUNT(distinct em.STUDENT_ID)>12 );


-- 4. Напишите запрос EXISTS, выбирающий фамилии всех лекторов, преподающих в университетах
--    с рейтингом, превосходящим рейтинг каждого харьковского универа.

SELECT L.SURNAME
FROM LECTURERS L
WHERE EXISTS (SELECT RATING
				FROM UNIVERSITIES
				WHERE RATING >ALL(SELECT RATING
								FROM UNIVERSITIES
								WHERE CITY='Харьков') and l.UNIV_ID=ID) and l.CITY=CITY;

-- 5. Напишите 2 запроса, использующий ANY и ALL, выполняющий выборку данных о студентах, 
--    у которых в городе их постоянного местожительства нет университета.

SELECT *
FROM STUDENTS s
WHERE s.CITY > ALL (SELECT u.CITY
				FROM UNIVERSITIES u
				where s.CITY=u.CITY);

SELECT *
FROM STUDENTS s
WHERE NOT s.CITY <= ANY (SELECT u.CITY
				FROM UNIVERSITIES u
				where s.CITY=u.CITY);

-- 6. Напишите запрос выдающий имена и фамилии студентов, которые получили
--    максимальные оценки в первый и последний день сессии.
--    Подсказка: выборка должна содержать по крайне мере 2х студентов.

-----Comment: Мой запрос выводит одну лишнюю фамилию. Не могу от нее избавиться(

SELECT s.NAME, s.SURNAME
FROM STUDENTS s
WHERE s.ID in (SELECT em.STUDENT_ID
				FROM EXAM_MARKS em 
				WHERE em.MARK=(SELECT MAX(em.MARK)
							   FROM EXAM_MARKS em) and 
					  em.EXAM_DATE= (SELECT MIN(em.EXAM_DATE)
									 FROM EXAM_MARKS em)
				GROUP BY em.STUDENT_ID )
UNION 
SELECT s.NAME, s.SURNAME
FROM STUDENTS s
WHERE s.ID in (SELECT em.STUDENT_ID
				FROM EXAM_MARKS em 
				WHERE exists (SELECT MAX(em.MARK)
							   FROM EXAM_MARKS em) and 
					  em.EXAM_DATE= (SELECT MAX(em.EXAM_DATE)
									 FROM EXAM_MARKS em))



-- 7. Напишите запрос EXISTS, выводящий кол-во студентов каждого курса, которые успешно 
--    сдали экзамены, и при этом не получивших ни одной двойки.

SELECT s.COURSE, COUNT(s.COURSE) as Count_ST
FROM STUDENTS s
WHERE EXISTS (SELECT STUDENT_ID
				FROM EXAM_MARKS 
				WHERE STUDENT_ID not in (SELECT STUDENT_ID
										 FROM EXAM_MARKS 
										 WHERE MARK=2) and s.ID=STUDENT_ID)
group by s.COURSE;


-- 8. Напишите запрос EXISTS на выдачу названий предметов обучения, 
--    по которым было получено максимальное кол-во оценок.

---Comment: через EXISTS не могу придумать как сделать((((

SELECT sub.NAME
FROM SUBJECTS sub 
WHERE sub.ID = ( SELECT TOP 1 with ties em.SUBJ_ID
					FROM EXAM_MARKS em
					group by em.SUBJ_ID 
					order by COUNT(*)  desc);


-- 9. Напишите команду, которая выдает список фамилий студентов по алфавиту, 
--    с колонкой комментарием: 'успевает' у студентов , имеющих все положительные оценки, 
--    'не успевает' для сдававших экзамены, но имеющих хотя бы одну 
--    неудовлетворительную оценку, и комментарием 'не сдавал' – для всех остальных.
--    Примечание: по возможности воспользуйтесь операторами ALL и ANY.

SELECT s.SURNAME, case
WHEN s.ID =ANY (SELECT em.STUDENT_ID
				FROM EXAM_MARKS em 
				GROUP BY em.STUDENT_ID
				HAVING MIN(em.MARK)>2) THEN 'успевает'
WHEN s.ID =ANY (SELECT em.STUDENT_ID
				FROM EXAM_MARKS em
				GROUP BY em.STUDENT_ID 
				HAVING MIN(em.MARK)=2) THEN 'не успевает'					
ELSE 'не сдавал'				
END Marks
FROM STUDENTS s	
ORDER BY s.SURNAME;	

-- 10. Создайте объединение двух запросов, которые выдают значения полей 
--     NAME, CITY, RATING для всех университетов. Те из них, у которых рейтинг 
--     равен или выше 500, должны иметь комментарий 'Высокий', все остальные – 'Низкий'.

SELECT NAME, CITY, RATING,'Высокий' Rait
FROM UNIVERSITIES
WHERE RATING>=500
UNION
SELECT NAME, CITY, RATING, 'Низкий' Rait
FROM UNIVERSITIES
WHERE RATING<500;

-- 11. Напишите UNION запрос на выдачу списка фамилий студентов 4-5 курсов в виде 3х полей выборки:
--     SURNAME, 'студент <значение поля COURSE> курса', STIPEND
--     включив в список преподавателей в виде
--     SURNAME, 'преподаватель из <значение поля CITY>', <значение зарплаты в зависимости от города проживания (придумать самим)>
--     отсортировать по фамилии
--     Примечание: достаточно учесть 4-5 городов.

SELECT s.SURNAME, 'студент ' + CAST(s.COURSE as varchar) + ' курса' as Kurs, s.STIPEND
FROM STUDENTS s
WHERE COURSE in (4,5)
union
SELECT l.SURNAME, 'преподаватель из ' + l.CITY as Kurs,
Case
WHEN CITY='Львов' THEN 2000
WHEN CITY='Луцк' THEN 1500
WHEN CITY='Луганск' THEN 1800
WHEN CITY='Киев' THEN 3000
ELSE 0
END Zarplata
FROM LECTURERS l
order by SURNAME asc;