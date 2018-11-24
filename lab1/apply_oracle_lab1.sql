-- ----------------------------------------------------------------------
-- Instructions:
-- ----------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab1.sql
--
-- ----------------------------------------------------------------------

SPOOL apply_oracle_lab1.txt

-- Call the setup scripts.
@/home/student/Data/cit225/oracle/lib/cleanup_oracle.sql
@/home/student/Data/cit225/oracle/lib/create_oracle_store.sql
@/home/student/Data/cit225/oracle/lib/seed_oracle_store.sql

SELECT   table_name
FROM     user_tables
WHERE    table_name NOT IN ('EMP','DEPT')
AND NOT  table_name LIKE 'DEMO%'
AND NOT  table_name LIKE 'APEX%'
ORDER BY table_name;

SPOOL OFF
