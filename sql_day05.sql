--day05 : SQL
--------------------------------------------
--ORACLE의 특별한 컬럼

--1. ROWID : 물리적으로 디스크에 저장된 위치를 가리키는 값 
--           물리적으로 저장된 위치이므로 한 행당 반드시 유일 할 수 밖에 없다
--           ORDER BY 절에 의해서 변경되지않는 값
-- 예) emp 테이블에서 'SMITH'인 사람의 정보를 조회
SELECT e.rowid
      ,e.empno
      ,e.ename
  FROM emp e
 WHERE e.ENAME = 'SMITH'
;  
--rowid는 ORDER BY에 의해 변경되지 않는다
SELECT e.rowid
      ,e.empno
      ,e.ename
  FROM emp e
ORDER BY e.ENAME
;  
/*
AAAE8GAAEAAAAFdAAB	7499	ALLEN
AAAE8GAAEAAAAFdAAF	7698	BLAKE
AAAE8GAAEAAAAFdAAG	7782	CLARK
AAAE8GAAEAAAAFdAAK	7902	FORD
AAAE8GAAEAAAAFbAAB	8888	J
AAAE8GAAEAAAAFbAAC	7777	J%JONES
AAAE8GAAEAAAAFdAAJ	7900	JAMES
AAAE8GAAEAAAAFbAAD	6666	JJ
AAAE8GAAEAAAAFdAAD	7566	JONES
AAAE8GAAEAAAAFbAAA	9999	J_JUNE
AAAE8GAAEAAAAFdAAH	7839	KING
AAAE8GAAEAAAAFdAAE	7654	MARTIN
AAAE8GAAEAAAAFdAAL	7934	MILLER
AAAE8GAAEAAAAFdAAA	7369	SMITH
AAAE8GAAEAAAAFdAAI	7844	TURNER
AAAE8GAAEAAAAFdAAC	7521	WARD
*/

SELECT e.rowid
      ,e.empno
      ,e.ename
  FROM emp e
ORDER BY e.EMPNO
; 
/*
AAAE8GAAEAAAAFbAAD	6666	JJ
AAAE8GAAEAAAAFdAAA	7369	SMITH
AAAE8GAAEAAAAFdAAB	7499	ALLEN
AAAE8GAAEAAAAFdAAC	7521	WARD
AAAE8GAAEAAAAFdAAD	7566	JONES
AAAE8GAAEAAAAFdAAE	7654	MARTIN
AAAE8GAAEAAAAFdAAF	7698	BLAKE
AAAE8GAAEAAAAFbAAC	7777	J%JONES
AAAE8GAAEAAAAFdAAG	7782	CLARK
AAAE8GAAEAAAAFdAAH	7839	KING
AAAE8GAAEAAAAFdAAI	7844	TURNER
AAAE8GAAEAAAAFdAAJ	7900	JAMES
AAAE8GAAEAAAAFdAAK	7902	FORD
AAAE8GAAEAAAAFdAAL	7934	MILLER
AAAE8GAAEAAAAFbAAB	8888	J
AAAE8GAAEAAAAFbAAA	9999	J_JUNE
*/
--2. ROWNUM : 조회된 결과의 첫번째 행부터 1로 증가하는 값
SELECT rownum
      ,e.EMPNO
      ,e.ENAME
  FROM emp e
 WHERE e.ENAME = 'SMITH'
;

SELECT rownum
      ,e.EMPNO
      ,e.ENAME
  FROM emp e
 WHERE e.ENAME LIKE 'J%'
;

SELECT rownum
      ,e.EMPNO
      ,e.ENAME
  FROM emp e
 WHERE e.ENAME LIKE 'J%'
 ORDER BY e.ENAME
;
/*
2	8888	J
3	7777	J%JONES
6	7900	JAMES
4	6666	JJ
5	7566	JONES
1	9999	J_JUNE
*/

--위의 두 결과를 비교하면 rownum도 ORDER BY에 영향을 
--받지 않는 것 처럼 보일 수 있으나
--SUB-QUERY를 사용할 때 영향을 받음

SELECT rownum
      ,a.EMPNO
      ,a.ENAME
  FROM (SELECT e.EMPNO
              ,e.ENAME
          FROM emp e
         WHERE e.ENAME LIKE 'J%'
      ORDER BY e.ENAME) a
;

SELECT rownum
      ,a.EMPNO
      ,a.ENAME
      ,a.deli
      ,a.numrow
  FROM (SELECT e.EMPNO
              ,e.ENAME
              ,'|' as deli
              ,rownum as numrow
          FROM emp e
         WHERE e.ENAME LIKE 'J%'
      ORDER BY e.ENAME) a
;
----------------------------------------------------
--DML: 데이터 조작어
----------------------------------------------------
--1)INSERT: 테이블에 데이터 행(ROW)를 추가하는 명령
DROP TABLE member;
CREATE TABLE member
( member_id    VARCHAR2(3)   
 ,member_name  VARCHAR2(15)  NOT NULL
 ,phone        VARCHAR2(4) -- NULL 허용시 제약조건 비우면 됨
 ,reg_date     DATE          DEFAULT sysdate
 ,address      VARCHAR2(30)
 ,birth_month  NUMBER(2)
 ,gender       VARCHAR2(1)   
 ,CONSTRAINT pk_member PRIMARY KEY  (member_id)
 ,CONSTRAINT ck_member_gender CHECK (gender IN('M','F'))
 ,CONSTRAINT ck_member_birth  CHECK (birth_month> 0 AND birth_month <=12)
);
desc member;

---1. INTO 구문에 컬럼이름 생략시 데이터 추가
--전체 데이터 추가 구문
INSERT INTO member
VALUES ('M01', '전현찬', '5250', sysdate, '덕명동', 11, 'M');

INSERT INTO member
VALUES ('M02', '조성철', '9034', sysdate, '오정동', 8, 'M');

INSERT INTO member
VALUES ('M03', '김승유', '5219', sysdate, '오정동', 1, 'M');

--몇몇 컬럼에 NULL데이터 추가
INSERT INTO member
VALUES ('M04', '박길수', '4003', sysdate, NULL, NULL, 'M');

INSERT INTO member
VALUES ('M05', '강현',  NULL, NULL, '홍도동', 6, 'M');

INSERT INTO member
VALUES ('M06', '김소민', NULL, sysdate, '월평동', NULL, NULL);

--조회
SELECT m.*
  FROM member m
;

--CHECK 옵션에 위배되는 데이터 추가 시도
INSERT INTO member
VALUES ('M07', '강병우', '2260', sysdate, '사정동', 2, 'N');--gender 컬럼 위반
-->ORA-02290: check constraint (SCOTT.CK_MEMBER_GENDER) violated

INSERT INTO member
VALUES ('M08', '정준호', NULL, sysdate, '나성동', 0, NULL);--birth_date 위반
--> ORA-02290: check constraint (SCOTT.CK_MEMBER_BIRTH) violated

-->>>수정
INSERT INTO member
VALUES ('M07', '강병우', '2260', sysdate, '사정동', 2, 'M');

INSERT INTO member
VALUES ('M08', '정준호', NULL, sysdate, '나성동', 1, NULL);


---2. INTO 구문에 컬럼이름 명시하여 데이터 추가
--VALUES절에 INTO의 순서대로
--값의 타입, 개수를 맞추어서 작성
INSERT INTO member(MEMBER_ID, MEMBER_NAME, GENDER)
VALUES ('M09', '윤홍식', 'M');
/*
M01	전현찬	5250	18/07/02	덕명동	11	M
M02	조성철	9034	18/07/02	오정동	8	M
M03	김승유	5219	18/07/02	오정동	1	M
M04	박길수	4003	18/07/02			    M
M06	김소민		    18/07/02	월평동		
M05	강현			                홍도동	6	M
M07	강병우	2260	18/07/02	사정동	2	M
M08	정준호		    18/07/02	나성동	1	
M09	윤홍식		    18/07/02			    M
*/
--reg_date컬럼은 DEFAULT 설정이 작동하여 시스템 날짜가 자동으로 입력
--phone, address 컬럼: NULL 값으로 입력되는 것 확인

--INTO절에 컬럼 나열시 테이블 정의 순서와 별개로 나열 가능
INSERT INTO member(MEMBER_NAME, ADDRESS, MEMBER_ID)
VALUES('이주영', '용전동', 'M10');
--마찬가지로 reg_date컬럼은 DEFAULT 설정이 작동하여 시스템 날짜가 자동으로 입력

--PK값이 중복되는 입력시도
INSERT INTO member(MEMBER_NAME, MEMBER_ID)
VALUES('남정규', 'M10');
-->ORA-00001: unique constraint (SCOTT.PK_MEMBER) violated

-->>수정: BUT 이름 컬럼에 주소가 들어가는 데이터
--       이름과 주소 모두 문자 데이터이기 때문에 형이 맞아서
INSERT INTO member(MEMBER_NAME, MEMBER_ID)
VALUES('목동', 'M11');

INSERT INTO member(MEMBER_ID, MEMBER_NAME)
VALUES('M12', '이동희');

--INTO절에 나열된 컬럼과 VALUES절의 값의 개수 불일치
INSERT INTO member(member_id, member_name, gender)
VALUES ('M13', '유재성');
--SQL 오류: ORA-00947: not enough values

--INTO절에 나열된 컬럼과 VALUES절의 값의 데이터 타입 불일치
INSERT INTO member(member_id, member_name, birth_month)
VALUES('M13', '유재성', 'M');
--SQL 오류: ORA-00904: "MEMBER_NAMEM": invalid identifier

--->>수정
INSERT INTO member(member_id, member_name, birth_month)
VALUES('M13', '유재성', 3);

------------------------------------------------------
--다중행 입력:SUB-QUERY 를 사용하여 가능
--구문 구조

INSERT INTO 테이블 이름
SELECT 문장; --서브쿼리

--CREATE AS SELECT는 데이터를 복사하여 테이블을 생성
--VS
--INSERT INTO ~SELECT 는 이미 만들어진 테이블에 데이터만 복사

--휴대폰 번호가 있는 사람만 데이터 삽입
INSERT INTO new_member
SELECT m.*
  FROM member m
 WHERE m.PHONE IS NOT NULL
;-->5개 행 이(가) 삽입되었습니다.
 
INSERT INTO new_member
SELECT m.*
  FROM member m
 WHERE m.MEMBER_ID > 'M09'
;-->4개 행 이(가) 삽입되었습니다.

--NEW_MEMBER 테이블 삭제 X 버튼 클릭 후 -->데이터반영

--성이 '김'인 멤버데이터를 복사 입력
INSERT INTO new_member
SELECT m.*
  FROM member m
 WHERE m.MEMBER_NAME LIKE '김%'
;

--짝수달에 태어난 멤머데이터를 복사
INSERT INTO new_member
SELECT m.*
  FROM member m
 WHERE MOD(m.BIRTH_MONTH,2)=0
;

---------------------------------------------------
--1) UPDATE : 테이블의 행을 수정
--            WHERE조건절의 조합에 따라 1행 또는 다행 수정이 가능

--member테이블에서 이름이 잘못들어간 'M11'멤버 정보를 수정
--데이터 수정 전에 영구반영을 실행
commit;

UPDATE member m
   SET m.MEMBER_NAME = '남정규'
WHERE  m.MEMBER_ID = 'M11'
;-->1 행 이(가) 업데이트되었습니다.
commit;
--'M05' 회원의 전화번호 필드를 업데이트(실수로 WHERE조건절을 입력하지 않음)
UPDATE member m
   SET m.PHONE = '1743'
--WHERE m.MEMBER_ID = 'M05'
;
-->13개 행 이(가) 업데이트되었습니다.

--데이터상태 되돌리기
ROLLBACK;
-->롤백 완료. //마지막 commit;전상태로 돌아간다.


--'M05' 회원의 전화번호 필드를 업데이트(정상쿼리)
UPDATE member m
   SET m.PHONE = '1743'
WHERE m.MEMBER_ID = 'M05'
;-->1 행 이(가) 업데이트되었습니다.

--2개 이상의 컬럼을 한번에 업데이트 SET 절에 나열
UPDATE member m
   SET m.PHONE = '1743'
      ,m.REG_DATE = sysdate
WHERE m.MEMBER_ID = 'M05'
;-->1 행 이(가) 업데이트되었습니다.

commit;


--'월평동'에 사는 '김소민' 멤버의 NULL데이터 업데이트
UPDATE member m
   SET m.PHONE = '4724'
      ,m.BIRTH_MONTH = 1
      ,m.GENDER = 'F'
WHERE m.ADDRESS = '월평동'
;
--위의 실행 결과는 의도대로 반영되는 것 처럼
--월평동에 사는 사람이 많다면
--월평동의 모든 사람 정보가 수정될 것.
--따라서 UPDATE 구문작성시 WHERE 조건은
--주의를 기울여서 작성해야 함.


/*
DML : UPDATE, DELECT작업시 주의점

딱 하나의 데이터를 수정 및 삭제 하려면
WHERE절의 비교조건에 반드시 PK로 설정한
컬럼의 값을 비교하는 것을 권장한다.

PK행은 전체 행에서 유일하고, NOT NULL임이 보장되기 때문이다.

UPDATE, DELETE는 구문에 물리적인 오류가 없으면
WHERE조건에 맞는 전체 행 대상으로 작업하는 것이
기본이므로 ***항상 주의해야함.***
*/