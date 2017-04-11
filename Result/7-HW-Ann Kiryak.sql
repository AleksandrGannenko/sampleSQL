-- 1. Напишите запрос, выдающий список фамилий преподавателей английского
--    языка с названиями университетов, в которых они преподают.
--    Отсортируйте запрос по городу, где расположен университ, а
--    затем по фамилии лектора.

SELECT l.SURNAME, u.NAME
FROM LECTURERS l join SUBJ_LECT sbl on l.ID=sbl.LECTURER_ID 
join UNIVERSITIES u on u.ID=l.UNIV_ID
join SUBJECTS sb on sb.ID=sbl.SUBJ_ID and sb.NAME='Английский'
order by u.NAME, l.SURNAME;

-- 2. Напишите запрос, который выполняет вывод данных о фамилиях, сдававших экзамены 
--    студентов, учащихся в Б.Церкви, вместе с наименованием каждого сданного ими предмета, 
--    оценкой и датой сдачи.

SELECT s.SURNAME, sb.NAME, em.MARK, CONVERT(varchar, em.EXAM_DATE, 104) as DATE_EX
FROM STUDENTS s join EXAM_MARKS em on s.ID=em.STUDENT_ID
join UNIVERSITIES u on s.UNIV_ID=u.ID and u.CITY='Белая Церковь'
join SUBJECTS sb on sb.ID=em.SUBJ_ID;

-- 3. Используя оператор JOIN, выведите объединенный список городов с указанием количества 
--    учащихся в них студентов и преподающих там же преподавателей.

SELECT u.CITY, COUNT(distinct s.ID) stud, COUNT(distinct l.ID) lect
FROM STUDENTS s right join UNIVERSITIES u on s.UNIV_ID=u.ID
				left join LECTURERS l on u.ID=l.UNIV_ID
GROUP BY u.CITY
order by u.CITY;

-- 4. Напишите запрос который выдает фамилии всех преподавателей и наименование предметов,
--    которые они читают в КПИ

SELECT l.SURNAME, sb.NAME
FROM LECTURERS l join	SUBJ_LECT sbl on 
						l.ID=sbl.LECTURER_ID and l.UNIV_ID=(SELECT u.ID
															FROM UNIVERSITIES u
															WHERE u.NAME='КПИ')
				join SUBJECTS sb on sbl.SUBJ_ID=sb.ID;			


-- 5. Покажите всех студентов-двоешников, кто получил только неудовлетворительные оценки (2) 
--    и по каким предметам, а также тех кто не сдал ни одного экзамена. 
--    В выходных данных должны быть приведены фамилии студентов, названия предметов и 
--    оценка, если оценки нет, заменить ее на прочерк.

SELECT S.SURNAME, ISNULL(sb.NAME, '-') as SUBJEC, ISNULL(CAST(em.MARK as varchar), '-') as MARKS
FROM STUDENTS S
JOIN EXAM_MARKS EM ON S.ID=EM.STUDENT_ID and s.ID in (SELECT em.STUDENT_ID FROM EXAM_MARKS em 
														group by em.STUDENT_ID
														having Max(EM.MARK)=2) 
JOIN SUBJECTS SB ON EM.SUBJ_ID=SB.ID
UNION
SELECT k.SURNAME, ISNULL(NULL, '-') ggggg, ISNULL(NULL, '-') dfgh
FROM (	SELECT * FROM STUDENTS S
		where s.ID not in (SELECT em.STUDENT_ID
		FROM EXAM_MARKS em)) k;



-- 6. Напишите запрос, который выполняет вывод списка университетов с рейтингом, 
--    превышающим 490, вместе со значением максимального размера стипендии, 
--    получаемой студентами в этих университетах.

SELECT u.NAME, MAX(s.STIPEND) as max_stip
FROM UNIVERSITIES u join STUDENTS s on u.ID=s.UNIV_ID and u.RATING>490 
GROUP BY u.NAME;

-- 7. Расчитать средний бал по оценкам студентов для каждого университета, 
--    умноженный на 100, округленный до целого, и вычислить разницу с текущим значением
--    рейтинга университета.

SELECT u.NAME, CAST(ROUND(AVG(em.MARK)*100, 0) as decimal(12,0)) as Raiting_NEW, u.RATING-CAST(ROUND(AVG(em.MARK)*100, 0) as decimal(12,0)) as DIFF
FROM UNIVERSITIES u join STUDENTS s on u.ID=s.UNIV_ID 
join EXAM_MARKS em on s.ID=em.STUDENT_ID 
GROUP BY u.NAME, u.RATING;

-- 8. Написать запрос, выдающий список всех фамилий лекторов из Киева попарно. 
--    При этом не включать в список комбинации фамилий самих с собой,
--    то есть комбинацию типа "Коцюба-Коцюба", а также комбинации фамилий, 
--    отличающиеся порядком следования, т.е. включать лишь одну из двух 
--    комбинаций типа "Хижна-Коцюба" или "Коцюба-Хижна".

SELECT l.SURNAME+ '-' + fe.SURNAME as FAM
FROM (SELECT * FROM LECTURERS l WHERE l.CITY = 'Киев') l CROSS JOIN (SELECT * FROM LECTURERS l WHERE l.CITY = 'Киев') fe 
WHERE l.SURNAME<>fe.SURNAME and l.SURNAME+ '-' + fe.SURNAME < fe.SURNAME + '-' + l.SURNAME
order by FAM;

-- 9. Выдать информацию о всех университетах, всех предметах и фамилиях преподавателей, 
--    если в университете для конкретного предмета преподаватель отсутствует, то его фамилию
--    вывести на экран как прочерк '-' (воспользуйтесь ф-ей isnull)

SELECT u.NAME, sb.NAME, ISNULL(k.SURNAME, '-') as LECT
FROM UNIVERSITIES u cross join SUBJECTS sb
					left join (SELECT *
								FROM LECTURERS l  join SUBJ_LECT sbl on sbl.LECTURER_ID=l.ID) as k 
								on k.SUBJ_ID=sb.ID and k.UNIV_ID=u.ID;

-- 10. Кто из преподавателей и сколько поставил пятерок за свой предмет?

-- 11. Добавка для уверенных в себе студентов: показать кому из студентов какие экзамены
--     еще досдать.
