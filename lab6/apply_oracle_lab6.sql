-- ----------------------------------------------------------------------
-- Author: Nathan Tagg
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab5/apply_oracle_lab5.sql

-- Start Spooling.
SPOOL lab6.txt

-- STEP 1
ALTER TABLE rental_item
ADD (rental_item_type NUMBER)
ADD (rental_item_price NUMBER);

-- CONFIRM
SET NULL ''
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

-- STEP 2
CREATE TABLE price
( price_id                        NUMBER       CONSTRAINT nn_price_1  NOT NULL
, item_id                         NUMBER       CONSTRAINT nn_price_2  NOT NULL
, price_type                      NUMBER       
, active_flag                     VARCHAR2(1)  CONSTRAINT nn_price_3  NOT NULL
, start_date                      DATE         CONSTRAINT nn_price_4  NOT NULL
, end_date                        DATE
, amount                          NUMBER       CONSTRAINT nn_price_5  NOT NULL
, created_by                      NUMBER       CONSTRAINT nn_price_6  NOT NULL
, creation_date                   DATE         CONSTRAINT nn_price_7  NOT NULL
, last_updated_by                 NUMBER       CONSTRAINT nn_price_8  NOT NULL
, last_update_date                DATE         CONSTRAINT nn_price_9  NOT NULL
, CONSTRAINT pk_price_1 PRIMARY KEY(price_id)
, CONSTRAINT fk_price_1 FOREIGN KEY(item_id)         REFERENCES item(item_id)
, CONSTRAINT fk_price_2 FOREIGN KEY(price_type)      REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_price_3 FOREIGN KEY(created_by)      REFERENCES system_user(system_user_id)
, CONSTRAINT fk_price_4 FOREIGN KEY(last_updated_by) REFERENCES item(item_id)
, CONSTRAINT yn_price CHECK(active_flag IN ('Y', 'N')));

-- CONFIRM
SET NULL ''
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
WHERE    table_name = 'PRICE'
ORDER BY 2;

COLUMN constraint_name   FORMAT A16
COLUMN search_condition  FORMAT A30
SELECT   uc.constraint_name
,        uc.search_condition
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('price')
AND      ucc.column_name = UPPER('active_flag')
AND      uc.constraint_name = UPPER('yn_price')
AND      uc.constraint_type = 'C';

-- STEP 3a
ALTER TABLE item RENAME COLUMN item_release_date TO release_date;

-- CONFIRM
SET NULL ''
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
WHERE    table_name = 'ITEM'
ORDER BY 2;

-- STEP 3b
INSERT INTO item
( ITEM_ID
, ITEM_BARCODE
, ITEM_TYPE
, ITEM_TITLE
, ITEM_SUBTITLE
, ITEM_RATING
, RELEASE_DATE
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE)
VALUES 
( item_s1.NEXTVAL
, '0000-00000-0'
, (SELECT common_lookup_id 
  FROM common_lookup
  WHERE common_lookup_type = 'DVD_WIDE_SCREEN')
, 'Tron'
, 'Legacy'
, 'PG-13'
, (TRUNC(SYSDATE) - 1)
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO item
( ITEM_ID
, ITEM_BARCODE
, ITEM_TYPE
, ITEM_TITLE
, ITEM_SUBTITLE
, ITEM_RATING
, RELEASE_DATE
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE)
VALUES 
( item_s1.NEXTVAL
, '0000-00000-1'
, (SELECT common_lookup_id 
  FROM common_lookup
  WHERE common_lookup_type = 'DVD_WIDE_SCREEN')
, 'Ender''s Game'
, ''
, 'PG-13'
, (TRUNC(SYSDATE) - 1)
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO item
( ITEM_ID
, ITEM_BARCODE
, ITEM_TYPE
, ITEM_TITLE
, ITEM_SUBTITLE
, ITEM_RATING
, RELEASE_DATE
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE)
VALUES 
( item_s1.NEXTVAL
, '0000-00000-2'
, (SELECT common_lookup_id 
   FROM common_lookup
   WHERE common_lookup_type = 'DVD_WIDE_SCREEN')
, 'Elysium'
, ''
, 'PG-13'
, (TRUNC(SYSDATE) - 1)
, 1001
, SYSDATE
, 1001
, SYSDATE);

-- CONFIRM
SELECT   i.item_title
,        SYSDATE AS today
,        i.release_date
FROM     item i
WHERE   (SYSDATE - i.release_date) < 31;

-- STEP 3c
 INSERT INTO member
( MEMBER_ID
, MEMBER_TYPE
, ACCOUNT_NUMBER
, CREDIT_CARD_NUMBER
, CREDIT_CARD_TYPE
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE)
VALUES
( member_s1.nextval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type = 'GROUP')
, 'A000-0001'
, '0000-0000-0000-0001'
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type = 'VISA_CARD')
, 1001
, SYSDATE
, 1001
, SYSDATE);

-- Harry Poter
INSERT INTO contact
( CONTACT_ID
, MEMBER_ID
, CONTACT_TYPE
, FIRST_NAME
, MIDDLE_NAME
, LAST_NAME
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE)
VALUES
( contact_s1.nextval
, member_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type = 'CUSTOMER')
, 'Harry'
, 'James'
, 'Potter'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO address
( ADDRESS_ID
, CONTACT_ID
, ADDRESS_TYPE
, CITY
, STATE_PROVINCE
, POSTAL_CODE
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE)
VALUES
( address_s1.nextval
, contact_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type = 'HOME')
, 'Provo'
, 'Utah'
, '84606'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO street_address
( STREET_ADDRESS_ID 
, ADDRESS_ID 
, STREET_ADDRESS
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE)
VALUES
( street_address_s1.nextval
, address_s1.currval
, '123 Sesame Street'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO telephone
( TELEPHONE_ID 
, CONTACT_ID
, ADDRESS_ID
, TELEPHONE_TYPE
, COUNTRY_CODE
, AREA_CODE
, TELEPHONE_NUMBER
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE)
VALUES
( telephone_s1.nextval
, contact_s1.currval
, address_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type = 'HOME')
, 'USA'
, '000'
, '000-0001'
, 1001
, SYSDATE
, 1001
, SYSDATE);

-- Ginny Potter
INSERT INTO contact
( CONTACT_ID
, MEMBER_ID
, CONTACT_TYPE
, FIRST_NAME
, MIDDLE_NAME
, LAST_NAME
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE)
VALUES
( contact_s1.nextval
, member_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type = 'CUSTOMER')
, 'Ginny'
, 'Weasly'
, 'Potter'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO address
( ADDRESS_ID
, CONTACT_ID
, ADDRESS_TYPE
, CITY
, STATE_PROVINCE
, POSTAL_CODE
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE)
VALUES
( address_s1.nextval
, contact_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type = 'HOME')
, 'Provo'
, 'Utah'
, '84606'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO street_address
( STREET_ADDRESS_ID 
, ADDRESS_ID 
, STREET_ADDRESS
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE)
VALUES
( street_address_s1.nextval
, address_s1.currval
, '123 Sesame Street'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO telephone
( TELEPHONE_ID 
, CONTACT_ID
, ADDRESS_ID
, TELEPHONE_TYPE
, COUNTRY_CODE
, AREA_CODE
, TELEPHONE_NUMBER
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE)
VALUES
( telephone_s1.nextval
, contact_s1.currval
, address_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type = 'HOME')
, 'USA'
, '000'
, '000-0001'
, 1001
, SYSDATE
, 1001
, SYSDATE);

-- Lily Potter
INSERT INTO contact
( CONTACT_ID
, MEMBER_ID
, CONTACT_TYPE
, FIRST_NAME
, MIDDLE_NAME
, LAST_NAME
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE)
VALUES
( contact_s1.nextval
, member_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type = 'CUSTOMER')
, 'Lily'
, 'Luna'
, 'Potter'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO address
( ADDRESS_ID
, CONTACT_ID
, ADDRESS_TYPE
, CITY
, STATE_PROVINCE
, POSTAL_CODE
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE)
VALUES
( address_s1.nextval
, contact_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type = 'HOME')
, 'Provo'
, 'Utah'
, '84606'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO street_address
( STREET_ADDRESS_ID 
, ADDRESS_ID 
, STREET_ADDRESS
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE)
VALUES
( street_address_s1.nextval
, address_s1.currval
, '123 Sesame Street'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO telephone
( TELEPHONE_ID 
, CONTACT_ID
, ADDRESS_ID
, TELEPHONE_TYPE
, COUNTRY_CODE
, AREA_CODE
, TELEPHONE_NUMBER
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE)
VALUES
( telephone_s1.nextval
, contact_s1.currval
, address_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type = 'HOME')
, 'USA'
, '000'
, '000-0001'
, 1001
, SYSDATE
, 1001
, SYSDATE);

-- CONFIRM
COLUMN full_name FORMAT A20
COLUMN city      FORMAT A10
COLUMN state     FORMAT A10
SELECT   c.last_name || ', ' || c.first_name AS full_name
,        a.city
,        a.state_province AS state
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN street_address sa
ON       a.address_id = sa.address_id INNER JOIN telephone t
ON       c.contact_id = t.contact_id
WHERE    c.last_name = 'Potter';

-- STEP 3d
INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Harry')
, TRUNC(SYSDATE), TRUNC(SYSDATE) + 1
, 1001, SYSDATE, 1001, SYSDATE);

-- Harry Potter
INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
, rental_s1.currval
, (SELECT item_id
   FROM item
   WHERE item_title = 'Tron')
, 1001, SYSDATE, 1001, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
, rental_s1.currval
, (SELECT item_id
   FROM item
   WHERE item_title = 'Tron')
, 1001, SYSDATE, 1001, SYSDATE);

INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Ginny')
, TRUNC(SYSDATE), TRUNC(SYSDATE) + 3
, 1001, SYSDATE, 1001, SYSDATE);

-- Ginerva Potter
INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
, rental_s1.currval
, (SELECT item_id
   FROM item
   WHERE item_title = 'Elysium')
, 1001, SYSDATE, 1001, SYSDATE);


INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Lily')
, TRUNC(SYSDATE), TRUNC(SYSDATE) + 5
, 1001, SYSDATE, 1001, SYSDATE);

-- Lily Potter
INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
, rental_s1.currval
, (SELECT item_id
   FROM item
   WHERE item_title = 'Ender''s Game')
, 1001, SYSDATE, 1001, SYSDATE);

-- CONFIRM
COLUMN full_name   FORMAT A18
COLUMN rental_id   FORMAT 9999
COLUMN rental_days FORMAT A14
COLUMN rentals     FORMAT 9999
COLUMN items       FORMAT 9999
SELECT   c.last_name||', '||c.first_name||' '||c.middle_name AS full_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL' AS rental_days
,        COUNT(DISTINCT r.rental_id) AS rentals
,        COUNT(ri.rental_item_id) AS items
FROM     rental r INNER JOIN rental_item ri
ON       r.rental_id = ri.rental_id INNER JOIN contact c
ON       r.customer_id = c.contact_id
WHERE   (SYSDATE - r.check_out_date) < 15
AND      c.last_name = 'Potter'
GROUP BY c.last_name||', '||c.first_name||' '||c.middle_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL'
ORDER BY 2;


-- STEP 4a
DROP INDEX common_lookup_n1;
DROP INDEX common_lookup_u2;

-- CONFIRM
COLUMN table_name FORMAT A14
COLUMN index_name FORMAT A20
SELECT   table_name
,        index_name
FROM     user_indexes
WHERE    table_name = 'COMMON_LOOKUP';

-- STEP 4b
ALTER TABLE common_lookup
ADD (common_lookup_table  VARCHAR2(30))
ADD (common_lookup_column VARCHAR2(30))
ADD (common_lookup_code   VARCHAR2(30));

-- CONFIRM
SET NULL ''
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
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

-- STEP 4c
UPDATE common_lookup SET common_lookup_table = common_lookup_context
WHERE  common_lookup_context != 'MULTIPLE';
UPDATE common_lookup SET common_lookup_table = 'ADDRESS'
WHERE  common_lookup_context  = 'MULTIPLE';

UPDATE common_lookup SET common_lookup_column = common_lookup_context || '_TYPE'
WHERE  (common_lookup_table = 'MEMBER' AND common_lookup_type IN ('INDIVIDUAL', 'GROUP'));

UPDATE common_lookup SET common_lookup_column = 'CREDIT_CARD_TYPE'
WHERE  common_lookup_type  IN ('VISA_CARD', 'MASTER_CARD', 'DISCOVER_CARD');

UPDATE common_lookup SET common_lookup_column = 'ADDRESS_TYPE'
WHERE  common_lookup_context = 'MULTIPLE';

UPDATE common_lookup SET common_lookup_column = common_lookup_context || '_TYPE'
WHERE NOT common_lookup_context IN ('MEMBER', 'MULTIPLE');

INSERT INTO common_lookup
( COMMON_LOOKUP_ID
, COMMON_LOOKUP_CONTEXT
, COMMON_LOOKUP_TYPE
, COMMON_LOOKUP_MEANING
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE
, COMMON_LOOKUP_TABLE
, COMMON_LOOKUP_COLUMN
, COMMON_LOOKUP_CODE)
VALUES
( common_lookup_s1.nextval
, 'TELEPHONE'
, 'HOME'
, 'Home phone number'
, '1001', SYSDATE, 1001, SYSDATE
, 'TELEPHONE'
, 'TELEPHONE_TYPE'
, '');

INSERT INTO common_lookup
( COMMON_LOOKUP_ID
, COMMON_LOOKUP_CONTEXT
, COMMON_LOOKUP_TYPE
, COMMON_LOOKUP_MEANING
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE
, COMMON_LOOKUP_TABLE
, COMMON_LOOKUP_COLUMN
, COMMON_LOOKUP_CODE)
VALUES
( common_lookup_s1.nextval
, 'TELEPHONE'
, 'WORK'
, 'Work phone number'
, '1001', SYSDATE, 1001, SYSDATE
, 'TELEPHONE'
, 'TELEPHONE_TYPE'
, '');

UPDATE telephone 
SET telephone_type = 
(SELECT common_lookup_id 
 FROM common_lookup 
 WHERE common_lookup_table  = 'TELEPHONE' 
   AND common_lookup_type = 'HOME');

UPDATE address 
SET address_type = 
(SELECT common_lookup_id 
 FROM   common_lookup 
 WHERE  common_lookup_table  = 'ADDRESS' 
   AND  common_lookup_type = 'HOME');

-- CONFIRM
COLUMN common_lookup_table  FORMAT A14 HEADING "Common|Lookup Table"
COLUMN common_lookup_column FORMAT A14 HEADING "Common|Lookup Column"
COLUMN common_lookup_type   FORMAT A8  HEADING "Common|Lookup|Type"
COLUMN count_dependent      FORMAT 999 HEADING "Count of|Foreign|Keys"
COLUMN count_lookup         FORMAT 999 HEADING "Count of|Primary|Keys"
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(a.address_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     address a RIGHT JOIN common_lookup cl
ON       a.address_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'ADDRESS'
AND      cl.common_lookup_column = 'ADDRESS_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
UNION
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(t.telephone_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     telephone t RIGHT JOIN common_lookup cl
ON       t.telephone_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TELEPHONE'
AND      cl.common_lookup_column = 'TELEPHONE_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type;


-- STEP 4d
ALTER TABLE common_lookup
DROP COLUMN common_lookup_context;

ALTER TABLE common_lookup
MODIFY common_lookup_table VARCHAR2(30) CONSTRAINT nn_clookup_lab_8 NOT NULL;

ALTER TABLE common_lookup
MODIFY common_lookup_column VARCHAR2(30) CONSTRAINT nn_clookup_lab_9 NOT NULL;

-- CONFIRM
SET NULL ''
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
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

-- LAST PART
ALTER TABLE common_lookup ADD CONSTRAINT common_lookup_u2 UNIQUE (common_lookup_table, common_lookup_column, common_lookup_type);

-- CONFIRM
COLUMN table_name FORMAT A14
COLUMN index_name FORMAT A20
SELECT   table_name
,        index_name
FROM     user_indexes
WHERE    table_name = 'COMMON_LOOKUP';

SPOOL OFF
