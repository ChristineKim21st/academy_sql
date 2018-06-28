---(3) 단일행 함수
---6) CASE
--job 별로 경조사비를 급여대비 일정 비율로 지급하고 있다
--각 직원들의 경조사비 지원금을 구하자
/*
CLERK : 5%
SALESMAN:4%
MANAGER:3.7%
ANALYST:3%
PRESIDENT:1.5%
*/

--1. SIMPLE CASE 구문으로 구해보자: DECODE와 거의 유사, 동일비교만 가능
--                               괄호가 없고, 콤마 대신 키워드 WHEEN, THEN, ELSE등을 사용

SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,CASE e.JOB WHEN 'CLERK'      THEN e.SAL*0.05
                  WHEN 'SALESMAN'   THEN e.SAL*0.04
                  WHEN 'MANAGER'    THEN e.SAL*0.037
                  WHEN 'ANALYST'    THEN e.SAL*0.03
                  WHEN 'PRESIDENT'  THEN e.SAL*0.015
        END as "경조사 지원금"
  FROM emp e
;

--2.Searched CASE 구문으로 구해보자
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,CASE WHEN e.JOB = 'CLERK' THEN e.SAL*0.05
            WHEN e.JOB = 'SALESMAN'   THEN e.SAL*0.04
            WHEN e.JOB = 'MANAGER'    THEN e.SAL*0.037
            WHEN e.JOB = 'ANALYST'    THEN e.SAL*0.03
            WHEN e.JOB = 'PRESIDENT'  THEN e.SAL*0.015
            ELSE 10
        END as "경조사 지원금"
  FROM emp e
;

--CASE결과에 숫자 통화 패턴 씌우기 : $기호, 숫자 세자리 끊어 읽기, 소수점 이하 2자리
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,TO_CHAR(CASE WHEN e.JOB = 'CLERK' THEN e.SAL*0.05
                    WHEN e.JOB = 'SALESMAN'   THEN e.SAL*0.04
                    WHEN e.JOB = 'MANAGER'    THEN e.SAL*0.037
                    WHEN e.JOB = 'ANALYST'    THEN e.SAL*0.03
                    WHEN e.JOB = 'PRESIDENT'  THEN e.SAL*0.015
                    ELSE 10
        END, '$9,999.99') as "경조사 지원금"
  FROM emp e
;
 --JOB이 null인 데이터 처리하기
 SELECT e.EMPNO
      ,e.ENAME
      ,nvl(e.JOB, '미지정') as job
      ,TO_CHAR(CASE WHEN e.JOB = 'CLERK' THEN e.SAL*0.05
                    WHEN e.JOB = 'SALESMAN'   THEN e.SAL*0.04
                    WHEN e.JOB = 'MANAGER'    THEN e.SAL*0.037
                    WHEN e.JOB = 'ANALYST'    THEN e.SAL*0.03
                    WHEN e.JOB = 'PRESIDENT'  THEN e.SAL*0.015
                    ELSE 10
        END, '$9,999.99') as "경조사 지원금"
  FROM emp e
;

/*
SALGRADE 테이블의 내용: 이 회사의 급여 등급 기준 값
GRADE, LOSAL, HISAL
-------------------
1	   700	  1200
2	   1201	  1400
3	   1401	  2000
4	   2001	  3000
5	   3001	  9999
*/

--제공되는 급여 등급을 바탕으로 각 사원들의 급여 등급을 구해보자
--case를 사용하여
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
      ,CASE WHEN e.SAL >=700 AND e.SAL <=1200 THEN 1
            WHEN e.SAL >=1200 AND e.SAL <=1400 THEN 2
            WHEN e.SAL >=1400 AND e.SAL <=2000 THEN 3
            WHEN e.SAL >=2000 AND e.SAL <=3000 THEN 4
            WHEN e.SAL >=3000 AND e.SAL <=9999 THEN 5
            ELSE 0
        END as "급여 등급"
  FROM emp e
ORDER BY "급여 등급" DESC
;

--WHEN안의 구문으로 EETWEEN AND구문으로 변경
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
      ,CASE WHEN e.SAL BETWEEN 700  AND 1200 THEN 1
            WHEN e.SAL BETWEEN 1201 AND 1400 THEN 2
            WHEN e.SAL BETWEEN 1401 AND 2000 THEN 3
            WHEN e.SAL BETWEEN 2001 AND 3000 THEN 4
            WHEN e.SAL BETWEEN 3001 AND 9999 THEN 5
            ELSE 0
        END as "급여 등급"
  FROM emp e
ORDER BY "급여 등급" DESC
;


-------2.그룹함수 (복수행 함수)
--1)COUNT(*): 특정 테이블의 행의 개수(데이터의 개수)를 세어주는 함수
--            NULL을 처리하는 <유일한> 그룹함수
--COUNT(expr): expr으로 등장한 값을 NULL을 제외하고 세어주는 함수

SELECT COUNT(*) as "부서 개수"
  FROM dept d
;

SELECT *
  FROM dept
;

SELECT COUNT(*) as "급여 등급 개수" 
  FROM salgrade s
;

--emp 테이블에서 JOB이 있는 사람 수를 카운트
SELECT COUNT(e.job) 
  FROM emp e
;--> 15

SELECT *
  FROM emp
; -->16개의 데이터 출력


--회사에 매니저가 배정된 직원이 몇명인가
SELECT COUNT(e.MGR) as "상사가 있는 직원 수"
  FROM emp e
;

--매니저 직을 맡고 있는 사람의 수는 몇명인가
--1.mgr칼럼을 중복제거하여 조회
SELECT DISTINCT e.MGR
  FROM emp e
;
--2.그때의 결과를 카운트
SELECT COUNT(DISTINCT e.MGR) as "매니저의 수"
  FROM emp e
; 

--부서가 배정된 직원이 몇명이나 있는가
SELECT COUNT(e.DEPTNO) as "부서 배정 인원"
  FROM emp e
;

--COUNT(*)가 아닌 COUNT(expre)를 사용한 경우엔느 
SELECT e.DEPTNO
  FROM emp e
 WHERE e.DEPTNO IS NOT NULL
;
--을 수행한 결과를 카운트 한 것으로 생각 할 수 있다.


SELECT COUNT(e.DEPTNO) as "부서 배정 인원"
      ,COUNT(*)-COUNT(e.DEPTNO) "부서 미배정 인원"
  FROM emp e
;

--2)SUM() : NULL항목 제외하고
--          합산 가능한 행을 모두 더한 결과를 출력
--SALESMAN 들의 수당 총합을 구해보자
SELECT SUM(e.COMM)
  FROM emp e
 WHERE e.JOB = 'SALESMAN'
;

--수당 총합 결과에 숫자 출력 패턴, 별칭
SELECT TO_CHAR(SUM(e.COMM), '$9,999') as "수당 총합"
  FROM emp e
 WHERE e.JOB = 'SALESMAN'
;

--3)AVG(expr) : NULL 값 제외하고 연산 가능한 항목의 산술 평균을 구함
--수당 평균을 구해보자
SELECT AVG(e.COMM) as "수당 평균"
  FROM emp e
;

SELECT TO_CHAR(AVG(e.COMM), '$9,999') as "수당 평균"
  FROM emp e
;

--4)MAX(expr) : expr에 등장한 값 중 최댓값을 구함
--              ,expr이 문자인 경우 알파벳순 뒷쪽에 위치한 글자를 최댓값으로 계산

--이름이 가장 나중인 직원
SELECT MAX(e.ENAME) 
  FROM emp e
;

----------3. GROUP BY 절의 사용
--1)emp테이블에서 각 부서별로 급여의 총합을 조회
--총합을 구하기 위하여 SUM()을 사용
--그룹화 기준을 부서번호(DEPTNO)를 사용
--그룹화 기준으로 잡은 부서번호가 GROUP BY 절에 등장해야 함

--a) 먼저 emp테이블에서 급여 총합 구하는 구문을 작성
SELECT SUM(e.SAL)
  FROM emp e
;  
--b)부서번호를 기준으로 그룹화를 진행
--  SUM()은 그룹함수이므로 GROUP BY절을 조합하면 그룹화가 가능하다
SELECT  e.DEPTNO
       ,SUM(e.SAL) as "급여의 총합"
  FROM  emp e
GROUP BY e.DEPTNO
;

--(만약에 그룹화 기준 컬럼으로 잡지 않은)GROUP BY절에 등장하지 않은 컬럼이 SELECT에 등장하면 오류, 실행 불가
SELECT  e.DEPTNO, e.JOB
       ,SUM(e.SAL) as "급여의 총합"
  FROM  emp e
GROUP BY e.DEPTNO
;-->ORA-00979: not a GROUP BY expression

--부서별 급여의 총합, 평균, 최대급여, 최소급여를 구하자
SELECT SUM(e.SAL) "급여 총합"
      ,AVG(e.SAL) "급여 평균"
      ,MAX(e.SAL) "최대 급여"
      ,MIN(e.SAL) "최소 급여"
  FROM emp e
  GROUP BY e.DEPTNO
;
--위 쿼리는 수행은 되지만 정확하게 어느 부서의 결과인지 알 수 가 없다는 단점이 존재한다.
/*
GROUP BY절에 등장하는 그룹화 기준 컬럼은 반드시 SELECT절에 똑같이 등장해야 한다.

하지만 위의 쿼리가 실행되는 이유는
SELECT절에 나열된 컬럼 중에서 그룹함수가 사용되지 않은 컬럼이 없기 때문
즉, 모두 다 그룹함수가 사용된 컬럼들이기 때문이다.
*/
SELECT e.DEPTNO   "부서 번호"
      ,SUM(e.SAL) "급여 총합"
      ,AVG(e.SAL) "급여 평균"
      ,MAX(e.SAL) "최대 급여"
      ,MIN(e.SAL) "최소 급여"
  FROM emp e
  GROUP BY e.DEPTNO
  ORDER BY e.DEPTNO 
;

--결과에 숫자 패턴 씌우기
SELECT SUM(e.SAL) "급여 총합"
      ,TO_CHAR(AVG(e.SAL), '$9,999.99') "급여 평균"
      ,MAX(e.SAL) "최대 급여"
      ,MIN(e.SAL) "최소 급여"
  FROM emp e
  GROUP BY e.DEPTNO
;