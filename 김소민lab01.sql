--실습 1)
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.SAL
  FROM emp e
  ORDER BY e.SAL desc
;

--실습 2)
SELECT e.EMPNO
      ,e.ENAME
      ,e.HIREDATE
  FROM emp e
  ORDER BY e.HIREDATE
;

--실습 3)
SELECT e.EMPNO
      ,e.ENAME
      ,e.COMM
  FROM emp e
  ORDER BY e.COMM
;  
  
--실습 4)
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
  FROM emp e
  ORDER BY e.SAL DESC
;  

--실습 5)
SELECT e.EMPNO as 사번
      ,e.ENAME as 이름
      ,e.SAL as 급여
      ,e.HIREDATE as 입사일
  FROM emp e
;  

--실습 6)
SELECT *
  FROM emp
;


--실습 7)
SELECT *
  FROM emp e
 WHERE e.ENAME = 'ALLEN'
;


--실습 8)
SELECT e.EMPNO
      ,e.ENAME
      ,e.DEPTNO
  FROM emp e
 WHERE e.DEPTNO = 20
;


--실습 9)
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
      ,e.DEPTNO
  FROM emp e
 WHERE e.DEPTNO = 20 
   AND e.SAL < 3000
;


--실습 10)
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL + e.COMM as "급여와 커미션 합"
  FROM emp e
;


--실습 11)
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL*12 as "년 급여"
  FROM emp e
;


--실습 12)
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.SAL
      ,e.COMM
  FROM emp e
 WHERE e.ENAME = 'MARTIN' 
    OR e.ENAME ='BLAKE'
;


--실습 13)
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.SAL + e.COMM as "급여와 커미션 합"
  FROM emp e
 WHERE e.ENAME = 'MARTIN' 
    OR e.ENAME ='BLAKE'
;


--실습 14)
SELECT *
  FROM emp e
 WHERE NOT e.COMM = 0
;


--실습 15)
SELECT * 
  FROM emp e
 WHERE e.COMM IS NOT NULL
;


--실습 16)
SELECT *
  FROM emp e
  WHERE e.DEPTNO = 20 
    AND e.SAL > 2500
;


--실습 17)
SELECT *
  FROM emp e
 WHERE e.JOB = 'MANAGER' OR 
        e.DEPTNO = 10
;


--실습 18)
SELECT *
  FROM emp e
  WHERE e.JOB  
     IN ('MANAGER', 'CLERK', 'SALESMAN')
;


--실습 19)
SELECT *
  FROM emp e
  WHERE e.ENAME 
   LIKE 'A%'
;


--실습 20)
SELECT *
  FROM emp e
 WHERE e.ENAME 
  LIKE '%A%'
;


--실습 21)
SELECT *
  FROM emp e
 WHERE e.ENAME LIKE '%S'
;


--실습 22)
SELECT *
  FROM emp e
  WHERE e.ENAME 
   LIKE '%E_'
;
