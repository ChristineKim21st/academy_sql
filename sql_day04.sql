--1.오라클 

--2.

--3.

--4.JOIN ~ON을 사용하는 구조:표준 SQL구문
SELECT [별칭1.]컬럼명1, [별칭2]컬럼명2[,...]
FROM 테이블1 별칭1 JOIN 테이블2 별칭2 ON (별칭1.공통컬럼2 = 별칭n.공통컬럼2)
                 [JOIN 테이블n 별칭n ON 별칭1.공통컬럼n = 별칭n.공통컬럼n]
;                 
                 
--------------------------------------------------------------------
----4) NON-EQUI JOIN : WHERE 조건절에 join attribute을 사용하는 대신
--                     다른 비교연산자를 사용하여 여러 테이블을 엮는 기법

--문제) emp, salgrade테이블을 사용하여 직원의 급여에 따른 등급을 함께 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
      ,s.salgrade
  FROM emp e
      ,salgrade S
 WHERE e.SAL BETWEEN s.LOSAL AND s.LOSAL
;

--5)OUTER JOIN : 조인 대상 테이블 중 공통 컬럼에 NULL 값인 데이터의 경우도 출력을 원할 때
--  연산자 : (+)< LEFT OUTER JOIN, RIGHT OUTER JOIN
------1. (+): 오라클이 사용하는 전통적인 OUTER JOIN,연산자
--            왼쪽, 오른쪽 어느쪽에나 NULL값을 출력하기 원하는 쪽에
--            붙여서 사용
--------(2) (+) 연산자 사용시 JOIN구문 구조
SELECT.....
  FROM 테이블1 별칭1, 테이블2 별칭2 
 WHERE 별칭1.공통컬럼(+) = 별칭2.공통컬럼  --RIGHT OUTER JOIN, 왼쪽 테이블의 NULL 데이터 출력
[WHERE 별칭1.공통컬럼 = 별칭2.공통컬럼(+)  --LEFT OUTER JOIN, 오른쪽 테이블의 NULL 데이터 출력]
;
-- RIGHT OUTER JOIN ~B ON구문 구조
SELECT ....
  FROM 테이블1 별칭1 RIGHT OUTER JOIN 테이블2 별칭2
  ON 별칭1.공통컬럼 = 별칭2.공통컬럼
;


--문제) 직원중에 부서가 배치되지 않은 사람이 있을 때
--1. 일반 조인(EQUI-JOIN)을 걸면 조회가 되지 않는다.
SELECT e.EMPNO
      ,e.ENAME
      ,e.DEPTNO
      ,d.DNAME
  FROM emp e
      ,dept d
WHERE e.DEPTNO = d.DEPTNO
;

--2.LEFT OUTER JOIN (+)연산자로 해결
SELECT e.EMPNO
      ,e.ENAME
      ,e.DEPTNO
      ,d.DNAME
  FROM emp e
      ,dept d
WHERE e.DEPTNO = d.DEPTNO(+)-->오른쪽에 있는 데이터가 부족: 왼쪽 데이터를 다 보여주고 오른쪽에 데이터가 없어도 추가로 보여달라
;
--(+)연산자는 오른쪽에 붙이고 이는 NULL 상태로 출력될 테이블을 결정한다.
--전체 데이터를 기준삼는 테이블이 왼쪽이기 때문에 LEFT OUTER JOIN 발생

--3.LEFT OUTER JOIN ~ON으로 --> WHERE 대신에 ON을 걸어준다
SELECT e.EMPNO
      ,e.ENAME
      ,e.DEPTNO
      ,d.DNAME
  FROM emp e LEFT OUTER JOIN dept d
    ON e.DEPTNO = d.DEPTNO
;

--문제) 아직 아무도 배치되지 않은 부서가 있어도
--      부서를 다 조회하고 싶다면
--1.(+)연산자로 해결
SELECT e.EMPNO
      ,e.ENAME
      ,e.DEPTNO
      ,d.DNAME
  FROM emp e
      ,dept d
 WHERE e.DEPTNO(+) = d.DEPTNO
;

--2.RIGHT OUTER JOIN ON으로 해결
SELECT e.EMPNO
      ,e.ENAME
      ,e.DEPTNO
      ,'|'
      ,d.DEPTNO
      ,d.DNAME
  FROM emp e RIGHT OUTER JOIN dept d
    ON e.DEPTNO = d.DEPTNO
;

--FULL OUTER JOIN ~ ON
SELECT e.EMPNO
      ,e.ENAME
      ,d.DNAME
  FROM emp e FULL OUTER JOIN dept d
    on e.DEPTNO = d.DEPTNO
;

--ORA-01468: a predicate may reference only one outer-joined table
SELECT e.EMPNO
      ,e.ENAME
      ,e.DEPTNO
      ,d.DNAME
  FROM emp e
      ,dept d
 WHERE e.DEPTNO(+) = d.DEPTNO(+)
;


---6) SELF JOIN : 한 테이블 내에서 
--emp테이블에서 mgr에 해당하는 상사의 이름을 같이 조회하려면
SELECT e1.EMPNO "직원 사번"
      ,e1.ENAME "직원 이름"
      ,e1.MGR   "상사 사번"
      ,e2.ENAME "상사 이름"
  FROM emp e1
      ,emp e2
 WHERE e1.MGR = e2.EMPNO
;     
--상사가 없는 직원도 조회하고 싶다
--e1테이블이 기준 -->LEFT OUTER JOIN
--기호는(+) 오른쪽에 붙인다
SELECT e1.EMPNO "직원 사번"
      ,e1.ENAME "직원 이름"
      ,e1.MGR   "상사 사번"
      ,e2.ENAME "상사 이름"
  FROM emp e1
      ,emp e2
 WHERE e1.MGR = e2.EMPNO(+)
;      

--부하직원이 없는 사람
SELECT e1.EMPNO "직원 사번"
      ,e1.ENAME "직원 이름"
      ,e1.MGR   "상사 사번"
      ,e2.ENAME "상사 이름"
  FROM emp e1
      ,emp e2
 WHERE e1.MGR(+) = e2.EMPNO
; 

SELECT e1.EMPNO "직원 사번"
      ,e1.ENAME "직원 이름"
      ,e1.MGR   "상사 사번"
      ,e2.ENAME "상사 이름"
  FROM emp e1 RIGHT OUTER JOIN emp e2
    ON e1.MGR = e2.EMPNO
; 

-----------7.조인과 서브쿼리
--(2) 서브쿼리:SUB-QUERY
--           SLELCT, FROM, WHERE절에 사용 할 수 있다

--문제) BLAKE와 직무가 동일한 직원의 정보를 조회
--1.blake의 직무를 조회
SELECT e.JOB
  FROM emp e
 WHERE e.ENAME ='BLAKE'
;

--2.1의 결과를 WHERE 조건 절에 사용하는 메인 쿼리 작성
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
  FROM emp e
 WHERE e.JOB = (SELECT e.JOB
  FROM emp e
 WHERE e.ENAME ='BLAKE')
;

--==>메인 쿼리의 where절 ()안에 전달되는 값이 1의 결과인
-- 'Mnager' 라는 값이다


----------------------------수업중 서브쿼리 실습--------------------------
--1. 이 회사의 평균 급여보다 급여가 큰 직원들의 목록을 조회(사번 이름 급여)
--a)평균급여를 구한다
  SELECT AVG(e.SAL)
    FROM emp e
;
--b)
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
  FROM emp e
 WHERE e.SAL > (
                SELECT AVG(e.SAL)
                  FROM emp e
                )
;                
--2.급여가 평균 급여보다 크면서 사번이 7700보다 높은 직원 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
  FROM emp e
 WHERE e.SAL > (
                SELECT AVG(e.SAL)
                  FROM emp e
                ) 
  AND e.EMPNO >7700
                
;    

--3.각 직무별로 최대 급여를 받는 직원 목록을 조회(GROUP함수)(사번, 이름, 직무, 급여)
--a)최대급여
SELECT e.JOB
      ,MAX(e.SAL)
  FROM emp e
GROUP BY e.JOB
;    
--b)최대 급여가 자신의 급여와 같은지
--  그때의 직무가 나의 직무와 같은지
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.SAL
  FROM emp e
 WHERE e.SAL = (SELECT e.JOB
                      ,MAX(e.SAL)
                 FROM emp e
             GROUP BY e.JOB)
;--ORA-00913: too many values
-->WHERE 절에서 비교는 e.SAL은 한개의 컬럼
---그런데 서브쿼리에서 돌아오는 컬럼이 두개의 컬럼이라서
---1행과 6행은 비교 자체가 불가능
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.SAL
  FROM emp e
 WHERE (e.JOB, e.SAL) IN (SELECT e.JOB
                                ,MAX(e.SAL)
                            FROM emp e
                        GROUP BY e.JOB)
;

SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.SAL
  FROM emp e
 WHERE e.SAL IN (SELECT MAX(e.SAL)
                    FROM emp e
                 GROUP BY e.JOB)
;-->데이터가 다양해지면 MAX만 비교하므로 원하는 데이터가 안나옴
--예 SALSEMAN이면서 1300

--4. 
--a)입사일 데이터에서 월을 추출
SELECT TO_CHAR(e.HIREDATE, 'MMMM')
  FROM emp e
;

--b)입사 월별인원 => 그룹화 기준 월
--인원을 구하는 함수 -->COUNT(*)
SELECT TO_CHAR(E.HIREDATE, 'FMMM')
      ,COUNT(*)
  FROM emp e
GROUP BY TO_CHAR(e.HIREDATE, 'FMMM')
;

--c)입사 월 순으로 정렬
SELECT TO_NUMBER(TO_CHAR(e.HIREDATE,  'FMMM'))"입사월"
      ,COUNT(*) "인원"
  FROM emp e
GROUP BY TO_CHAR(e.HIREDATE, 'FMMM')
ORDER BY "입사월"
;

--서브쿼리로 감싸서 정렬시도
SELECT a."입사월" || '월' as "입사월"
      ,a."인원"
  FROM(SELECT TO_NUMBER(TO_CHAR(e.HIREDATE,  'FMMM'))"입사월"
             ,COUNT(*) "인원"
         FROM emp e
         GROUP BY TO_CHAR(e.HIREDATE, 'FMMM')
         ORDER BY "입사월") a
;
