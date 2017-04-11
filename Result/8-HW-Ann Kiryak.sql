-- /* Везде, где необходимо данные придумать самостоятельно. */
--Для каждого задания (кроме 4-го) можете использовать конструкцию
-------------------------
-- начать транзакцию
begin transaction
-- проверка до изменений
SELECT * FROM EXAM_MARKS
-- изменения
-- insert into SUBJECTS (ID,NAME,HOURS,SEMESTER) values (25,'Этика',58,2),(26,'Астрономия',34,1)
-- insert into EXAM_MARKS ...
-- delete from EXAM_MARKS where SUBJ_ID in (...)
-- проверка после изменений
SELECT * FROM EXAM_MARKS --WHERE STUDENT_ID > 120
-- отменить транзакцию
rollback


-- 1. Необходимо добавить двух новых студентов для нового учебного 
--    заведения "Винницкий Медицинский Университет".

begin transaction;

INSERT INTO UNIVERSITIES
					(ID, NAME, RATING, CITY)
VALUES
					(16, 'ВНУ', 500,'Винница')


insert into STUDENTS 
					(ID, SURNAME, NAME, GENDER,STIPEND,COURSE,CITY,BIRTHDAY,UNIV_ID) 
values 
					(46,'Шевченко', 'Тарас', 'm', 450, 1, 'Винница', '1990-11-01 00:00:00.000', 16),
					(47,'Марченко', 'Василь', 'm', 550, 2, 'Винница', '1993-11-01 00:00:00.000', 16)

rollback;


SELECT * FROM STUDENTS
SELECT * FROM UNIVERSITIES

-- 2. Добавить еще один институт для города Ивано-Франковск, 
--    1-2 преподавателей, преподающих в нем, 1-2 студента,
--    а так же внести новые данные в экзаменационную таблицу.

BEGIN TRANSACTION;

INSERT INTO UNIVERSITIES
					(ID, NAME, RATING, CITY)
VALUES
					(50, 'ИНУ', 650,'Ивано-Франковск')


INSERT INTO LECTURERS
					(ID, SURNAME, NAME, CITY, UNIV_ID)
VALUES
					(40, 'Яременко', 'Иван', 'Ивано-Франковск', 50),
					(41, 'Шелест', 'Максим', 'Ивано-Франковск', 50)


insert into STUDENTS 
					(ID, SURNAME, NAME, GENDER,STIPEND,COURSE,CITY,BIRTHDAY,UNIV_ID) 
values 
					(50,'Шевченко', 'Тарас', 'm', 450, 1, 'Ивано-Франковск', '1990-11-01 00:00:00.000', 50),
					(51,'Марченко', 'Василь', 'm', 550, 2, 'Ивано-Франковск', '1993-11-01 00:00:00.000', 50)


insert into SUBJ_LECT
					(LECTURER_ID, SUBJ_ID) 
values 
					(40, 1),
					(41, 2)

SET IDENTITY_INSERT EXAM_MARKS on

insert into EXAM_MARKS
					(ID, STUDENT_ID, SUBJ_ID, MARK, EXAM_DATE) 
values 
					(150, 50, 1, 5, '2012-06-06 00:00:00.000'),
					(151, 51, 2, 4, '2012-06-17 00:00:00.000')

SET IDENTITY_INSERT EXAM_MARKS off

COMMIT;
ROLLBACK;

SELECT * FROM STUDENTS
SELECT * FROM UNIVERSITIES
SELECT * FROM LECTURERS
SELECT * FROM EXAM_MARKS
SELECT * FROM SUBJ_LECT

-- 3. Известно, что студенты Павленко и Пименчук перевелись в ОНПУ. 
--    Модифицируйте соответствующие таблицы и поля.

BEGIN TRANSACTION;

UPDATE STUDENTS
SET UNIV_ID=(SELECT ID FROM UNIVERSITIES WHERE NAME = 'ОНПУ')
WHERE SURNAME='Павленко' or SURNAME='Пименчук'


COMMIT;
ROLLBACK;

SELECT * FROM STUDENTS
SELECT * FROM UNIVERSITIES

-- 4. В учебных заведениях Украины проведена реформа и все студенты, 
--    у которых средний бал не превышает 3.5 балла - отчислены из институтов. 
--    Сделайте все необходимые удаления из БД.
--    Примечание: предварительно "отчисляемых" сохранить в архивационной таблице

BEGIN TRANSACTION;


INSERT INTO STUDENTS_ARCHIVE
SELECT * FROM STUDENTS WHERE ID IN
								(SELECT STUDENT_ID 
								FROM EXAM_MARKS 
								GROUP BY STUDENT_ID
								HAVING AVG(MARK)<3.5)



DELETE FROM EXAM_MARKS 
where STUDENT_ID in (
			SELECT STUDENT_ID
			FROM EXAM_MARKS 
			GROUP BY STUDENT_ID
			HAVING AVG(MARK)<3.5)



DELETE FROM STUDENTS
WHERE ID in (
			SELECT ID
			FROM STUDENTS_ARCHIVE)


COMMIT;
ROLLBACK;

SELECT * FROM STUDENTS_ARCHIVE
SELECT * FROM EXAM_MARKS
SELECT * FROM STUDENTS


-- 5. Студентам со средним балом 4.75 начислить 12.5% к стипендии,
--    со средним балом 5 добавить 200 грн.
--    Выполните соответствующие изменения в БД.

BEGIN TRANSACTION;
UPDATE STUDENTS
SET STIPEND=STIPEND*1.125 
WHERE ID in (SELECT STUDENT_ID
							FROM EXAM_MARKS
							GROUP BY STUDENT_ID
							HAVING AVG(MARK)=4.75) 
UPDATE STUDENTS
SET STIPEND=STIPEND+200
WHERE ID in (SELECT STUDENT_ID
							FROM EXAM_MARKS
							GROUP BY STUDENT_ID
							HAVING AVG(MARK)=5) 						
							
	
SELECT * FROM STUDENTS	
					
COMMIT;
ROLLBACK;

-- 6. Необходимо удалить все предметы, по котором не было получено ни одной оценки.
--    Если таковые отсутствуют, попробуйте смоделировать данную ситуацию.

BEGIN TRANSACTION;

insert into SUBJECTS
					(ID, NAME, HOURS, SEMESTER) 
values 
					(15, 'Биология', 90, 1),
					(16, 'Химия', 34, 3)


DELETE FROM SUBJECTS
WHERE ID not in (
				SELECT SUBJ_ID FROM EXAM_MARKS)


COMMIT;
ROLLBACK;

SELECT * FROM SUBJECTS
SELECT * FROM SUBJ_LECT
SELECT * FROM EXAM_MARKS

-- 7. Лектор 3 ушел на пенсию, необходимо корректно удалить о нем данные.

BEGIN TRANSACTION;

DELETE FROM SUBJ_LECT
WHERE LECTURER_ID=3

DELETE FROM LECTURERS
WHERE ID=3


COMMIT;
ROLLBACK;

SELECT * FROM LECTURERS
SELECT * FROM SUBJ_LECT