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