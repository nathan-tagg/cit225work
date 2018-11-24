-- Create a table.
CREATE TABLE item_lab
( item_lab_id                     NUMBER
, item_barcode                    VARCHAR2(14) CONSTRAINT nn_item_lab_1 NOT NULL
, item_type                       NUMBER       CONSTRAINT nn_item_lab_2 NOT NULL
, item_title                      VARCHAR2(60) CONSTRAINT nn_item_lab_3 NOT NULL
, item_subtitle                   VARCHAR2(60)
, item_rating                     VARCHAR2(8)  CONSTRAINT nn_item_lab_4 NOT NULL
, item_release_date               DATE         CONSTRAINT nn_item_lab_5 NOT NULL
, created_by                      NUMBER       CONSTRAINT nn_item_lab_6 NOT NULL
, creation_date                   DATE         CONSTRAINT nn_item_lab_7 NOT NULL
, last_updated_by                 NUMBER       CONSTRAINT nn_item_lab_8 NOT NULL
, last_update_date                DATE         CONSTRAINT nn_item_lab_9 NOT NULL
, CONSTRAINT pk_item_lab_1        PRIMARY KEY(item_lab_id)
, CONSTRAINT fk_item_lab_1        FOREIGN KEY(item_type)       REFERENCES common_lookup_lab(common_lookup_lab_id)
, CONSTRAINT fk_item_lab_2        FOREIGN KEY(created_by)      REFERENCES system_user_lab(system_user_lab_id)
, CONSTRAINT fk_item_lab_3        FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));

-- Create a sequence.
CREATE SEQUENCE item_lab_s1 START WITH 1001;

-- Confirm
SET NULL ''
COLUMN table_name   FORMAT A18
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
WHERE    table_name = 'ITEM_LAB'
ORDER BY 2;

COLUMN constraint_name   FORMAT A22
COLUMN search_condition  FORMAT A36
COLUMN constraint_type   FORMAT A1
SELECT   uc.constraint_name
,        uc.search_condition
,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('item_lab')
AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
,        uc.constraint_name;

COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A38 HEADING "References:| Table.Column"
SELECT   uc.constraint_name||CHR(10)
||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
,       'REFERENCES'||CHR(10)
||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
,        user_cons_columns ucc1
,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
AND      uc.r_constraint_name = ucc2.constraint_name
AND      ucc1.POSITION = ucc2.POSITION -- Correction for multiple column primary keys.
AND      uc.constraint_type = 'R'
AND      ucc1.table_name = UPPER('item_lab')
ORDER BY ucc1.table_name
,        uc.constraint_name;

COLUMN sequence_name FORMAT A20 HEADING "Sequence Name"
SELECT   sequence_name
FROM     user_sequences
WHERE    sequence_name = UPPER('item_lab_s1');
