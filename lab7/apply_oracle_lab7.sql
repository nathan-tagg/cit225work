-- Author: Nathan Tagg

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab6/apply_oracle_lab6.sql

-- Start Spooling.
SPOOL apply_oracle_lab7.txt

-- STEP 1
INSERT INTO common_lookup
( common_lookup_id
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column
, common_lookup_code)
VALUES
( common_lookup_s1.nextval
, 'YES'
, 'This price is active'
, 1001, SYSDATE, 1001, SYSDATE
, 'PRICE'
, 'ACTIVE_FLAG'
, 'Y');

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column
, common_lookup_code)
VALUES
( common_lookup_s1.nextval
, 'NO'
, 'This price is inactive'
, 1001, SYSDATE, 1001, SYSDATE
, 'PRICE'
, 'ACTIVE_FLAG'
, 'N');

COLUMN common_lookup_table  FORMAT A20 HEADING "COMMON_LOOKUP_TABLE"
COLUMN common_lookup_column FORMAT A20 HEADING "COMMON_LOOKUP_COLUMN"
COLUMN common_lookup_type   FORMAT A20 HEADING "COMMON_LOOKUP_TYPE"
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table = 'PRICE'
AND      common_lookup_column = 'ACTIVE_FLAG'
ORDER BY 1, 2, 3 DESC;

-- STEP 2
INSERT INTO common_lookup
( common_lookup_id
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column
, common_lookup_code)
VALUES
( common_lookup_s1.nextval
, '1-DAY RENTAL'
, '1-Day rental'
, 1001, SYSDATE, 1001, SYSDATE
, 'PRICE'
, 'PRICE_TYPE'
, '1');
INSERT INTO common_lookup
( common_lookup_id
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column
, common_lookup_code)
VALUES
( common_lookup_s1.nextval
, '3-DAY RENTAL'
, '3-Day rental'
, 1001, SYSDATE, 1001, SYSDATE
, 'PRICE'
, 'PRICE_TYPE'
, '3');
INSERT INTO common_lookup
( common_lookup_id
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column
, common_lookup_code)
VALUES
( common_lookup_s1.nextval
, '5-DAY RENTAL'
, '5-Day rental'
, 1001, SYSDATE, 1001, SYSDATE
, 'PRICE'
, 'PRICE_TYPE'
, '5');

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column
, common_lookup_code)
VALUES
( common_lookup_s1.nextval
, '1-DAY RENTAL'
, '1-Day rental'
, 1001, SYSDATE, 1001, SYSDATE
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '1');
INSERT INTO common_lookup
( common_lookup_id
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column
, common_lookup_code)
VALUES
( common_lookup_s1.nextval
, '3-DAY RENTAL'
, '3-Day rental'
, 1001, SYSDATE, 1001, SYSDATE
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '3');
INSERT INTO common_lookup
( common_lookup_id
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column
, common_lookup_code)
VALUES
( common_lookup_s1.nextval
, '5-DAY RENTAL'
, '5-Day rental'
, 1001, SYSDATE, 1001, SYSDATE
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '5');

COLUMN common_lookup_table  FORMAT A20 HEADING "COMMON_LOOKUP_TABLE"
COLUMN common_lookup_column FORMAT A20 HEADING "COMMON_LOOKUP_COLUMN"
COLUMN common_lookup_type   FORMAT A20 HEADING "COMMON_LOOKUP_TYPE"
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN ('PRICE','RENTAL_ITEM')
AND      common_lookup_column IN ('PRICE_TYPE','RENTAL_ITEM_TYPE')
ORDER BY 1, 3;

-- STEP 3
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'RENTAL_ITEM'
ORDER BY 2;

UPDATE   rental_item ri
SET      rental_item_type =
           (SELECT   cl.common_lookup_id
            FROM     common_lookup cl
            WHERE    cl.common_lookup_code =
              (SELECT   r.return_date - r.check_out_date
               FROM     rental r
               WHERE    r.rental_id = ri.rental_id)
            AND      cl.common_lookup_table = 'RENTAL_ITEM'
            AND      cl.common_lookup_column = 'RENTAL_ITEM_TYPE');

SELECT   ROW_COUNT
,        col_count
FROM    (SELECT   COUNT(*) AS ROW_COUNT
         FROM     rental_item) rc CROSS JOIN
        (SELECT   COUNT(rental_item_type) AS col_count
         FROM     rental_item
         WHERE    rental_item_type IS NOT NULL) cc;

ALTER TABLE rental_item
ADD CONSTRAINT fk_rental_item_7 FOREIGN KEY(rental_item_type) REFERENCES common_lookup(common_lookup_id);

COLUMN table_name      FORMAT A12 HEADING "TABLE NAME"
COLUMN constraint_name FORMAT A18 HEADING "CONSTRAINT NAME"
COLUMN constraint_type FORMAT A12 HEADING "CONSTRAINT|TYPE"
COLUMN column_name     FORMAT A18 HEADING "COLUMN NAME"
SELECT   uc.table_name
,        uc.constraint_name
,        CASE
           WHEN uc.constraint_type = 'R' THEN
            'FOREIGN KEY'
         END AS constraint_type
,        ucc.column_name
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = 'RENTAL_ITEM'
AND      ucc.column_name = 'RENTAL_ITEM_TYPE';

ALTER TABLE rental_item
MODIFY rental_item_type NUMBER CONSTRAINT nn_rental_item_8 NOT NULL;

COLUMN CONSTRAINT FORMAT A10
SELECT   TABLE_NAME
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS CONSTRAINT
FROM     user_tab_columns
WHERE    TABLE_NAME = 'RENTAL_ITEM'
AND      column_name = 'RENTAL_ITEM_TYPE';

-- STEP 4
COLUMN item_id     FORMAT 9999 HEADING "ITEM|ID"
COLUMN active_flag FORMAT A6   HEADING "ACTIVE|FLAG"
COLUMN price_type  FORMAT 9999 HEADING "PRICE|TYPE"
COLUMN price_desc  FORMAT A12  HEADING "PRICE DESC"
COLUMN start_date  FORMAT A10  HEADING "START|DATE"
COLUMN end_date    FORMAT A10  HEADING "END|DATE"
COLUMN amount      FORMAT 9999 HEADING "AMOUNT"
SELECT   
  i.item_id                         AS item_id
, af.active_flag                    AS active_flag
, cl.common_lookup_id               AS price_type
, dr.rental_days || '-DAY RENTAL'   AS price_desc
, i.release_date                    AS start_date
, (SELECT (i.release_date + 30) FROM dual WHERE af.active_flag = 'N') AS end_date
, (SELECT 
     CASE 
       WHEN i.item_id IN (1022, 1023, 1024) AND cl.common_lookup_type = '1-DAY RENTAL' THEN 3
       WHEN i.item_id IN (1022, 1023, 1024) AND cl.common_lookup_type = '3-DAY RENTAL' THEN 10
       WHEN i.item_id IN (1022, 1023, 1024) AND cl.common_lookup_type = '5-DAY RENTAL' THEN 15
       WHEN af.active_flag = 'N' AND cl.common_lookup_type = '1-DAY RENTAL' THEN 3
       WHEN af.active_flag = 'N' AND cl.common_lookup_type = '3-DAY RENTAL' THEN 10
       WHEN af.active_flag = 'N' AND cl.common_lookup_type = '5-DAY RENTAL' THEN 15
       WHEN af.active_flag = 'Y' AND cl.common_lookup_type = '1-DAY RENTAL' THEN 1
       WHEN af.active_flag = 'Y' AND cl.common_lookup_type = '3-DAY RENTAL' THEN 3
       WHEN af.active_flag = 'Y' AND cl.common_lookup_type = '5-DAY RENTAL' THEN 5
     ELSE NULL END
   FROM dual) AS amount
FROM     item i CROSS JOIN
        (SELECT 'Y' AS active_flag FROM dual
         UNION ALL
         SELECT 'N' AS active_flag FROM dual) af CROSS JOIN
        (SELECT '1' AS rental_days FROM dual
         UNION ALL
         SELECT '3' AS rental_days FROM dual
         UNION ALL
         SELECT '5' AS rental_days FROM dual) dr INNER JOIN
         common_lookup cl ON dr.rental_days = SUBSTR(cl.common_lookup_type,1,1)
WHERE    cl.common_lookup_table = 'PRICE'
AND      cl.common_lookup_column = 'PRICE_TYPE'
AND NOT  (i.item_id IN (1022, 1023, 1024) AND af.active_flag = 'N')
ORDER BY 1, 2, 3;

SPOOL OFF
