---SQL day02
-------------------------------------------------------------------------
---IS NULL, IS NOT NULL 연산자
/*
   IS NULL : 비교하려는 컬럼의 값이 null 이면 true
   IS NOT NULL : 비교하려는 컬럼의 값이 NULL이 아니면 true, NULL이면 false
   
   NULL 값은 컬럼은 비교연산자와 연산이 불가능 하므로
   NULL 값은 비교 연산자가 따로 존재함
   
   col1 = null  ==> NULL 값에 대해서는 =비교 연산자 사용 불가능
   col1 != null ==> NULL 값에 대해서는 !=, <>비교 연산자 사용 불가능
*/
--- 27)어떤 직원의 mrg가 지정되지 않은 직원 정보 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.MGR
  FROM emp e
 WHERE e.MGR IS NULL
;

--mgr이 배정된
SELECT e.EMPNO
      ,e.ENAME
      ,e.MGR
  FROM emp e
 WHERE e.MGR IS NOT NULL
;-->11개의 행이 조회된다.

---그러나 IS NOT NULL 대신 <>이나 !=를 사용할 경우
SELECT e.EMPNO
      ,e.ENAME
      ,e.MGR
  FROM emp e
 WHERE e.MGR != NULL
;-->오류는 일어나지 않지만 0개의 행이 조회되므로 주의해야한다.


---BETWEEN a AND b : 범위 비교 연산자 범위 포함
--a <= sal <= b

---28)급여가 500~1200사이인 직원 정보 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
  FROM emp e
 WHERE e.SAL BETWEEN 500 AND 1200
;

--BETWEEN 500 AND 1200과 같은 결과를 내는 비교연산자
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
  FROM emp e
 WHERE e.SAL >= 500
   AND e.SAL <=1200
;

--- EXISTS 연산자: 조회한 결과가 1행 이상 있다.
--                어떤 SELECT 구문을 실행했을 때 조회 결과가 1이상 있다.
--                이 연산자의 결과가 true
--                조회 결과 : <인출된 모든 행:0> 인 경우 False
--                따라서 서브쿼리와 함께 사용된다

--- 29) 급여가 10000이 넘는 사람이 있는가?
--  (1) 급여가 10000이 넘는 사람을 찾는 구문을 작성
SELECT e.Ename
  FROM emp e
 WHERE e.SAL > 10000
;

/*
위의 쿼리 실행 결과가 1행 이라도 존재하면 화면에
"급여가 10000이 넘는 직원이 존재함"이라고 출력
*/

SELECT '급여가 3000이 넘는 직원이 존재함' as "시스템 메세지"
  FROM dual
 WHERE EXISTS(SELECT e.Ename
               FROM emp e
              WHERE e.SAL > 3000)
;


/*
위의 쿼리 실행 결과가 1행 이라도 존재하지 않으면 화면에
"급여가 10000이 넘는 직원이 존재하지 않음"이라고 출력
*/

SELECT '급여가 10000이 넘는 직원이 존재하지 않음' as "시스템 메세지"
  FROM dual
 WHERE NOT EXISTS(SELECT e.Ename
               FROM emp e
              WHERE e.SAL > 10000)
; 

-- (6) 연산자 : 결합연산자(||)
--     오라클에만 존재, 문자열 결함(접합)
--     다른 자바 등의 프로그래밍 언어에서는 or 논리 연산자로 사용됨

--오늘의 날짜를 화면에 조회
SELECT sysdate
  FROM dual
;

--오늘의 날짜를 알려주는 문장을 만들려면
SELECT '오늘의 날짜는 ' || sysdate || ' 입니다.' as "오늘의 날짜"
  FROM dual
;

--직원의 사번을 알려주는 구문을 || 연산자를 사용하여 작성
SELECT '안녕하세요' || e.ENAME || '씨, 당신의 사번은 ' || e.EMPNO || ' 입니다.' as "사번알리미"
  FROM emp e
;

--(6)연산자 : 6.집합연산자
SELECT *
   FROM dept d
  MINUS
 SELECT *
   FROM dept d
  WHERE d.DEPTNO = 10
;

--주의
SELECT *
   FROM dept d
  MINUS
 SELECT d.DEPTNO
       ,d.DNAME
   FROM dept d
  WHERE d.DEPTNO = 10
;--> ORA-01789 : "query block has incorrect number of result columns"

--서로 다른 테이블에서 조회한 결과를 집한연산 가능
--첫번째 쿼리 : emp 테이블에서 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
  FROM emp e
;

--두번째 쿼리: dept테이블에서 조회
SELECT d.DEPTNO 
      ,d.DNAME
      ,d.LOC
  FROM dept d
;

--서로 다른 테이블의 조회 내용을 UNION
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
  FROM emp e
UNION
SELECT d.DEPTNO 
      ,d.DNAME
      ,d.LOC
  FROM dept d
;

--서로 다른 테이블의 조회 내용을 MINUS
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
  FROM emp e
MINUS
SELECT d.DEPTNO 
      ,d.DNAME
      ,d.LOC
  FROM dept d
;
/*
EMPNO,  ENAME,  JOB
------------------------
7369	SMITH	CLERK
7499	ALLEN	SALESMAN
7521	WARD	SALESMAN
7566	JONES	MANAGER
7654	MARTIN	SALESMAN
7698	BLAKE	MANAGER
7777	J%JONES	CLERK
7782	CLARK	MANAGER
7839	KING	PRESIDENT
7844	TURNER	SALESMAN
7900	JAMES	CLERK
7902	FORD	ANALYST
7934	MILLER	CLERK
8888	J	CLERK
9999	J_JUNE	CLERK
*/

--서로 다른 테이블의 조회 내용을 INTERSECT
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
  FROM emp e
INTERSECT
SELECT d.DEPTNO 
      ,d.DNAME
      ,d.LOC
  FROM dept d
;-->조회되 결과 없음(no row selected)

--(6)연산자 : 7. 연산자 우선순위
/*
주어진 조건 3가지
1.mgr = 7698
2.job = 'CLERK'
3.sal >1300

*/

--1.매니저가 7698번이며 직무는 일반사원(CLERK)이거나 
--  급여가 1300이 넘는 조건을 만족하는 직원의 정보를 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.SAL
      ,e.MGR
  FROM emp e
  WHERE e.mgr=7698
    AND e.JOB = 'CLERK'
     OR e.SAL > 1300
;
/*
EMPNO,  ENAME,  JOB,        SAL,    MGR
7499	ALLEN	SALESMAN	1600	7698
7566	JONES	MANAGER	    2975	7839
7698	BLAKE	MANAGER 	2850	7839
7782	CLARK	MANAGER	    2450	7839
7839	KING	PRESIDENT	5000	    -->>MGR에는 해당이 없으나 급여가 1300이 높은 사람
7844	TURNER	SALESMAN	1500	7698
7900	JAMES	CLERK	    950	    7698
7902	FORD	ANALYST	    3000	7566
*/
--2.매니저가 7698번인 직원중에서
--  직무가 CLERK이거나 급여가 1300이 넘는 조건을 만족하는 직원 정보
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.SAL
      ,e.MGR
  FROM emp e
  WHERE e.MGR = 7698
    AND (e.JOB = 'CLERK' OR e.SAL >1300)
;
/*
EMPNO,  ENAME,  JOB,        SAL,    MGR
7499	ALLEN	SALESMAN	1600	7698
7844	TURNER	SALESMAN	1500	7698
7900	JAMES	CLERK	    950	    7698
*/

--3.직무가 CLERK이거나 
--  급여가 1300이 넘으면서 매니저가 7698인 사람
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.SAL
      ,e.MGR
  FROM emp e
  WHERE e.JOB = 'CLERK'
     OR (e.SAL > 1300 ANd e.MGR = 7698)
;
/*
EMPNO,  ENAME,  JOB,        SAL,    MGR
----------------------------------------
9999	J_JUNE	CLERK	    500	
8888	J	    CLERK	    400	
7777	J%JONES	CLERK	    300	
7369	SMITH	CLERK	    800	    7902
7499	ALLEN	SALESMAN	1600	7698
7844	TURNER	SALESMAN	1500	7698
7900	JAMES	CLERK	    950	    7698
7934	MILLER	CLERK	    1300	7782
*/


------------6.함수
--(2)dual 테이블 : 1행 1열로 구성된 시스템 테이블 
DESC dual;

SELECT *   --> duummy 컬러에 X값이 하나 들어있음을 확인 할 수 있다.
  FROM dual
;

--dual 테이블을 사용하여 날짜 조회
SELECT sysdate
  FROM dual
;

--(3)단일행 함수
---1) 숫자함수 : 1.MOD(m, n) : m을 n으로 나눈 나머지 계산 함수
SELECT mod(10, 3) as resualt
  FROM dual
;

SELECT mod(10, 3) as resualt
  FROM dept
;


--각 사원의 급여를 3으로 나눈 나머지를 조회
SELECT e.EMPNO
      ,e.ENAME
      ,MOD(e.SAL, 3) as "Resualt"
  FROM emp e
;


----2.ROUND(m, n)
SELECT ROUND(1234.56, 1) FROM dual;
SELECT ROUND(1234.56, 0) FROM dual;
SELECT ROUND(1234.46, 0) FROM dual;
--ROUND(m) : n값을 생략하면 소수점 이하 첫째자리 반올림 바로 수행
--           즉, n값을 0으로 수정함

----3.TRUNC(m, n) : 실수 m을 n에서 지정한 자리 이하 소수점 버림
SELECT TRUNC(1234.56, 1) FROM dual;
--n을 생략하면 0으로 수행한다.

----4.CEIL(n) : 입력된 실수 n에서 같거나 가장 큰 가까운 정수
SELECT CEIL(1234.56) FROM dual;
SELECT CEIL(1234) FROM dual;
SELECT CEIL(1234.001) FROM dual;

----5.FLOOR(n) : 입력된 실수 n에서 같거나 가장 가까운 작은 정수
SELECT FLOOR(1234.56) FROM dual;
SELECT FLOOR(1234) FROM dual;
SELECT FLOOR(1234.001) FROM dual;

----6.WIDTH_BUKET(expr, min, max, bukets)
--:min, max 값 사이를 bukets 개수만큼의 구간으로 나누고
--expr이 출력하는 값이 어느 구간인지 위치를 숫자로 구해줌

--급여 범위를 0~5000으로 잡고, 5개의 구간으로 나누어서
--각 직원의 급여가 어느 구간에 해당하는지 보고서를 출력해보자
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
      ,WIDTH_BUCKET(e.SAL, 0, 5000, 5) as "급여 구간"    
  FROM emp e
ORDER BY "급여 구간"
 ; 
 
----2)문자함수
----1. INITCAP(str): String의 첫 글자를 대문자화(영문인 경우)
SELECT INITCAP('the saop') FROM dual; --The Saop

----2. LOWER(str): str을 소문자화(영문인경우)
SELECT LOWER('MR. SCCOT MCMILLAN') "소문자로 변경" FROM dual;

----3. UPPER(str):str을 대문자화(영문인경우)
SELECT UPPER('lee') "대문자로 변경" FROM dual;

----4. LENGTH(str), LENGTHB(st):str의 글자길이를 계산, 글자의 byte길이를 계산
SELECT LENGTH('hello, sql') as "글자길이" FROM dual;
--oracle에서 한글은 3byte이다.
SELECT LENGTHB('안녕오라클') as "글자 byte" FROM dual;
SELECT LENGTHB('hello, sql') as "글자 byte" FROM dual;
----5. CONCAT(str1, str2):str1, str2 문자열을 접합, ||연산자와 동일
SELECT CONCAT('안녕하세요, ','sql') FROM dual;

----6. SUBSTR(str, i, n):문자열 일부추출. str에서 i번째 위치에서 n개의 글자를 추출
---    SQL에서 문자열 인덱스를 나타내는 i는 1부터 시작에 주의함!
SELECT SUBSTR('SQL is not Coolllll', 3, 4) FROM dual;
--SUBSTR(str, i):문자열 i부터 전부 추출
SELECT SUBSTR('SQL is not Coolllll', 3) FROM dual;

----7. INSTR(str1, str2): 2번째 문자열이 1번째 문자열 어디에 위치하는가 등장하는 위치를 계산 
SELECT INSTR('sql is cooooool!', 'is') FROM dual;
--못찾는 경우 0을 리턴한다.
SELECT INSTR('sql is cooooool!', 'ia') FROM dual;

----8. LPAD, RPAD(str, n, c)
--     :입력된 str에 대해서, 전체 글자의 자릿수를 n으로 잡고 
--      남는 공간에 왼쪽, 혹은 오른쪽으로 c의 문자를 채워넣는다.
SELECT LPAD('sql is cooooool!', 20, '!') FROM dual;

----9. LTRIM, RTRIM, TRIM:입력된 문자열의 왼쪽, 오른쪽, 양쪽 공백 제거
SELECT '>' || LTRIM('    sql    ') || '<' FROM dual;
SELECT '>' || RTRIM('    sql    ') || '<' FROM dual;
SELECT '>' || TRIM('    sql    ') || '<' FROM dual;

----10. NVL(expre1, expre2), NVL2(expre1, expre2, ecpre3), NULLIF(expre1, expre2)
--nvl(expr1, expr2): 첫번째 식의 값이 NULL이면 두번째 식으로 대체하여 출력
--mgr가 배정안된 직원의 경우 '매니저 없음'으로 변경해서 출력
SELECT e.EMPNO
      ,e.ENAME
      ,nvl(e.MGR, '매니저 없음') -->오류: mgr은 숫자데이터고 변경출력값은 문자
  FROM emp e
;
----------------------------------------
SELECT e.EMPNO
      ,e.ENAME
      ,nvl(e.MGR, 0) 
  FROM emp e
;
----------------------------------------
SELECT e.EMPNO
      ,e.ENAME
      ,nvl(e.MGR||'', '매니저 없음') -->숫자타입 데이터 뒤에 문자('')를 붙여서 형변환
  FROM emp e
;


--NVL2(expre1, expre2, ecpre3): 첫번째 식의 값이 NOT NULL이면 두번째 식의 값으로 대체하여 출력
--                              NULL이면 세번째 식의 값으로 대체하여 출력
SELECT e.EMPNO
      ,e.ENAME
      ,nvl2(e.MGR, '매니저 있음' , '매니저 없음') -->숫자타입 데이터 뒤에 문자('')를 붙여서 형변환
  FROM emp e
;

--NULLIF(expre1, expre2): 첫번째 식, 두번째 식의 값이 동일하면 NULL을 출력
--                        식의 값이 다르면 첫번째 식의 값을 출력
SELECT NULLIF('AAA', 'bbb')
  FROM dual
;

SELECT NULLIF('AAA', 'AAA')
  FROM dual
;
--조회된 결과 1행이 NULL인 결과를 얻게됨
--1행이라도 NULL이 조회된 결과는 인출된 모든 행: 0과는 상태가 다름!


-----3)날짜함수 : 날짜출력 패턴 조합으로 다양하게 출력 가능
SELECT sysdate FROM dual;
--TO_CHAR(): 숫자나 날짜를 문자형으로 변환
SELECT TO_CHAR (sysdate, 'YYYY') FROM dual;
SELECT TO_CHAR (sysdate, 'YY') FROM dual;
SELECT TO_CHAR (sysdate, 'MM') FROM dual;
SELECT TO_CHAR (sysdate, 'MONTH') FROM dual;
SELECT TO_CHAR (sysdate, 'DD') FROM dual;
SELECT TO_CHAR (sysdate, 'D') FROM dual;
SELECT TO_CHAR (sysdate, 'DAY') FROM dual;
SELECT TO_CHAR (sysdate, 'DY') FROM dual;

---패턴을 조합
SELECT TO_CHAR (sysdate, 'YYYY-MM-DD') FROM dual;
SELECT TO_CHAR (sysdate, 'FMYYYY-MM-DD') FROM dual;
SELECT TO_CHAR (sysdate, 'YY-MONTH-DD') FROM dual;
SELECT TO_CHAR (sysdate, 'YY-MONTH-DD DAY') FROM dual;
SELECT TO_CHAR (sysdate, 'YY-MONTH-DD DY') FROM dual;

/*시간패턴
HH:시간을 두자리
MI:분을 두자리
SS:초를 두자리
HH24:시간을 24시간 체계로 표기
AM: 오전인지 오후인지 표시
*/
SELECT TO_CHAR (sysdate, 'YYYY-MM-DD HH24:MI:SS') FROM dual;
SELECT TO_CHAR (sysdate, 'YYYY-MM-DD AM HH:MI:SS') FROM dual;

--날짜 값과 숫자의 연산: +, -연산 가능
SELECT sysdate + 10 FROM dual;--10일후
SELECT sysdate - 10 FROM dual;--10일전
SELECT  TO_CHAR(sysdate +(10/24), 'YYYY-MM-DD AM HH:MI:SS')FROM dual;--10시간 후


----1. MONTHS_BETWEEN(날짜1, 날짜2):두 날짜 사이의 달의 차이
SELECT MONTHS_BETWEEN(SYSDATE, E.HIREDATE) FROM EMP E;
----2. ADD_MONTHS(날짜1, 숫자):날짜1에 숫자만큼 더한 후의 날자를 구함
SELECT ADD_MONTHS(sysdate, 3) FROM dual;
----3. NEXT_DAY, LAST_DAY:
SELECT NEXT_DAY(sysdate, '일요일') FROM dual;
SELECT LAST_DAY(sysdate) FROM dual;
----4.ROUND, TRUNCE
SELECT TO_CHAR(ROUND(sysdate), 'YYYY-MM-DD HH:MI:SS') FROM dual;
SELECT TRUNCE(sysdate) FROM dual;

