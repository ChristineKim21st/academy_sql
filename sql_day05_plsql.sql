-------------------------------------------------
--PL/SQL
-------------------------------------------------
--1. ANONYMOUS PROCEDURE : 이름 없이 1회 실행 저장 프로시저
--   출력 설정 SQL*PLUS 설정
SHOW SERVEROUTPUT
;
--ON 설정으로 변경
SET  SeRVEROUTPUT ON
;

--1)변수선언이 있는 ANNOYMOUS PROCEDURE 작성
DECLARE
    --변수 선언부
    name VARCHAR2(20) := 'Hannam Univ'; --선언과 동시에 저장
    year NUMBER;                         --선언만 하고 값을 저장하지 않음
BEGIN
     --프로시저에서 실행할 로직을 작성
     --일반적으로 SQL구문처리가 들어감
     --변수처리, 비교, 반복등의 로직이 들어감
    year := 1956;
    
    --화면 출력
    DBMS_OUTPUT.PUT_line(name||'since'||year);
END;
/
/*
Hannam Univsince1956


PL/SQL 프로시저가 성공적으로 완료되었습니다.
*/

------------------------------------
--DECLARE에서는 변수만 선언
--BEGIN에서는 변수의 값을 저장
--출력
DECLARE
    --변수 선언부
    name VARCHAR2(20); --선언만 하고 값을 저장하지 않음
    year NUMBER;       --선언만 하고 값을 저장하지 않음
BEGIN
     --프로시저에서 실행할 로직을 작성
     --일반적으로 SQL구문처리가 들어감
     --변수처리, 비교, 반복등의 로직이 들어감
    name  := 'somin';
    year := 1996;
    
    DBMS_OUTPUT.PUT_line(name||' since '||year);--화면 출력
END;
/
