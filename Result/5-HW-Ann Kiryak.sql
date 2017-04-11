-- 0. Отобразите для каждого из курсов количество парней и девушек. 

SELECT COURSE, COUNT(case
				WHEN GENDER='f' THEN 'F'
				END) as F, 
			COUNT(case
				WHEN GENDER='m' THEN 'M'
				END) as M
FROM STUDENTS
GROUP BY COURSE;

-- Второй вариант
SELECT s.COURSE, COUNT(s.GENDER) count_gender, 'f' gend
FROM STUDENTS s
WHERE s.GENDER='f'
GROUP BY s.COURSE
UNION
SELECT s.COURSE, COUNT(s.GENDER), 'm'
FROM STUDENTS s
WHERE s.GENDER='m'
GROUP BY s.COURSE;
--KSN OK Есть еще классический case
--select 
--    COURSE, 
--	gender,
--	case when gender='m' then COUNT(gender) 
--	  else count(GENDER) 
--	end gend_count
--from STUDENTS
--  group by gender,course;

-- 1. Напишите запрос для таблицы EXAM_MARKS, выдающий даты, для которых средний балл 
--    находиться в диапазоне от 4.22 до 4.77. Формат даты для вывода на экран: 
--    день месяць, например, 05 Jun.

SELECT LEFT(CONVERT(varchar, em.EXAM_DATE, 06), 6) as date_em
FROM EXAM_MARKS em
group by LEFT(CONVERT(varchar, em.EXAM_DATE, 06), 6)
HAVING AVG(em.MARK) between 4.22 and 4.77;

--KSN OK

-- 2. Напишите запрос, который по таблице EXAM_MARKS позволяет найти промежуток времени (*),
--    который занял у студента в течении его сессии, кол-во всех попыток сдачи экзаменов, 
--    а также их максимальные и минимальные оценки. В выборке дожлен присутствовать 
--    идентификатор студента.
--    Примечание: таблица оценок - покрывает одну сессию, (*) промежуток времени -
--    количество дней, которые провел студент на этой сессии - от первого до 
--    последнего экзамена включительно
--    Примечание-2: функция DAY() для решения не подходит! 


SELECT em.STUDENT_ID, DATEDIFF(dd, MIN(em.EXAM_DATE), MAX(em.EXAM_DATE)+1) as day_session, MAX(em.MARK) max_mark, MIN(em.MARK) min_mark, COUNT(em.MARK) count_mark
FROM EXAM_MARKS em
WHERE em.STUDENT_ID in (
						SELECT s.ID
						FROM STUDENTS s)
GROUP BY em.STUDENT_ID;
--KSN OK

-- 3. Покажите список идентификаторов студентов, которые имеют пересдачи. 


SELECT em.STUDENT_ID
FROM EXAM_MARKS em
group by em.STUDENT_ID
HAVING COUNT(distinct em.SUBJ_ID)< COUNT(em.SUBJ_ID);
--HAVING COUNT(*)>1

--KSN OK

-- 4. Напишите запрос, отображающий список предметов обучения, вычитываемых за самый короткий 
--    промежуток времени, отсортированный в порядке убывания семестров. Поле семестра в 
--    выходных данных должно быть первым, за ним должны следовать наименование и 
--    идентификатор предмета обучения.

SELECT sub.SEMESTER, sub.NAME, sub.ID
FROM SUBJECTS sub
WHERE sub.HOURS = (SELECT MIN(HOURS)
					FROM SUBJECTS)
ORDER BY sub.SEMESTER desc;
--KSN OK


-- 5. Напишите запрос с подзапросом для получения данных обо всех положительных оценках(4, 5) Марины 
--    Шуст (предположим, что ее персональный номер неизвестен), идентификаторов предметов и дат 
--    их сдачи.

SELECT em.SUBJ_ID, CONVERT(varchar, em.EXAM_DATE, 104) as d, em.MARK 
FROM EXAM_MARKS em
WHERE em.STUDENT_ID IN (
						SELECT s.ID 
						FROM STUDENTS s
						WHERE s.SURNAME='Шуст')
group by em.SUBJ_ID, CONVERT(varchar, em.EXAM_DATE, 104), em.MARK
having em.MARK in (4,5);
--KSN OK

-- 6. Покажите сумму баллов для каждой даты сдачи экзаменов, при том, что средний балл не равен 
--    среднему арифметическому между максимальной и минимальной оценкой. Данные расчитать только 
--    для студенток. Результат выведите в порядке убывания сумм баллов, а дату в формате dd/mm/yyyy.

SELECT CONVERT(varchar, em.EXAM_DATE, 103) as em_dates, SUM(em.MARK) as sum_mark
FROM EXAM_MARKS em
WHERE em.STUDENT_ID in (
						SELECT s.ID
						FROM STUDENTS s
						WHERE s.GENDER='f')
group by CONVERT(varchar, em.EXAM_DATE, 103)
having AVG(em.MARK)<>(MAX(em.MARK)+MIN(em.MARK))/2
order by sum_mark desc;
--KSN OK


SELECT CONVERT(varchar, em.EXAM_DATE, 103) as em_dates, SUM(em.MARK) as sum_mark
FROM EXAM_MARKS em, STUDENTS s
WHERE em.STUDENT_ID = s.ID AND GENDER='f'
group by CONVERT(varchar, em.EXAM_DATE, 103)
having AVG(em.MARK)<>(MAX(em.MARK)+MIN(em.MARK))/2
order by sum_mark desc;


-- 7. Покажите имена и фамилии всех студентов, у которых средний балл по предметам
--    с идентификаторами 1 и 2 превышает средний балл этого же студента
--    по всем остальным предметам. Используйте вложенные подзапросы, а также конструкцию
--    AVG(case...), либо коррелирующий подзапрос.
--    Примечание: может так оказаться, что по "остальным" предметам (не 1ый и не 2ой) не было
--    получено ни одной оценки, в таком случае принять средний бал за 0 - для этого можно
--    использовать функцию ISNULL().


SELECT s.NAME, s.SURNAME
FROM STUDENTS S
WHERE s.ID in
			(SELECT em.STUDENT_ID
			   FROM EXAM_MARKS em
			  WHERE em.SUBJ_ID in (1,2) and em.STUDENT_ID=S.ID
		   GROUP BY em.STUDENT_ID
			 HAVING AVG(em.MARK)>
			(SELECT ISNULL(AVG(em.MARK), 0)
			   FROM EXAM_MARKS em
			  WHERE em.SUBJ_ID not in (1,2) and em.STUDENT_ID=S.ID));
--KSN OK


select s.SURNAME, s.NAME, e1.AVG_MARK as x, e2.AVG_MARK as y
from    STUDENTS s,
        (select AVG(em.MARK) as AVG_MARK, em.STUDENT_ID
           from EXAM_MARKS em
          where em.SUBJ_ID<=2
       Group by em.STUDENT_ID) as e1,
       
        (select AVG(em.MARK) as AVG_MARK, em.STUDENT_ID
           from EXAM_MARKS em
          where em.SUBJ_ID>2
       Group by em.STUDENT_ID
        union
        select 0, s.ID
        From STUDENTS s where s.id not in (select em.student_ID 
                                             from EXAM_MARKS em
                                             where em.SUBJ_ID not in (1,2))
        ) as e2
where s.ID=e1.STUDENT_ID and s.ID=e2.STUDENT_ID
  and e1.AVG_MARK>e2.AVG_MARK

  ------------

  select isnull(avg(case when em.SUBJ_ID in (1,2) then em.mark end),0) a, 
       isnull(avg(case when em.SUBJ_ID not in (1,2) then em.mark end),0) b,
       s.SURNAME, 
       s.name
FROM EXAM_MARKS em, STUDENTS s
where s.ID=em.STUDENT_ID
group by s.SURNAME, s.name
having isnull(avg(case when em.SUBJ_ID in (1,2) then em.mark end),0) > 
       isnull(avg(case when em.SUBJ_ID not in (1,2) then em.mark end),0)

-- 8. Напишите запрос, выполняющий вывод общего суммарного и среднего баллов каждого 
--    экзаменованого второкурсника, его идентификатор и кол-во полученных оценок при условии, 
--    что он успешно сдал 3 и более предметов.


SELECT em.STUDENT_ID, SUM(em.MARK) as summa, AVG(em.MARK) as avg_mark, COUNT(em.MARK) as count_mark
FROM EXAM_MARKS em
WHERE em.MARK<>2 and em.STUDENT_ID in (
						SELECT s.ID
						FROM STUDENTS s
						WHERE s.COURSE=2)
GROUP BY em.STUDENT_ID
HAVING COUNT(distinct em.SUBJ_ID)>=3;
--KSN OK

-- 9. Вывести названия всех предметов, средний балл которых превышает средний балл по всем 
--    предметам университетов г.Днепропетровска. Используйте вложенные подзапросы.

SELECT sub.NAME
FROM SUBJECTS sub
WHERE sub.ID in
			(SELECT em.SUBJ_ID
			FROM EXAM_MARKS em
			GROUP BY em.SUBJ_ID
			HAVING AVG(em.MARK)>
							(SELECT AVG(em.MARK)
							FROM EXAM_MARKS em
					        WHERE em.STUDENT_ID in
												(SELECT s.ID
												FROM STUDENTS s
												WHERE s.UNIV_ID in 
																(SELECT u.ID
																FROM UNIVERSITIES u
																WHERE u.CITY='Днепропетровск') ) ) );
--KSN OK