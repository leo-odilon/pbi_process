CREATE SCHEMA hive.pbi;

--drop table if exists hive.pbi.incident_records;
CREATE TABLE hive.pbi.incident_records (
	incident_id VARCHAR,
	open_time_timezone_based TIMESTAMP,
	open_group VARCHAR,
	resolve_time_timezone_based TIMESTAMP,
	resolve_group VARCHAR,
	affected_ci_id VARCHAR,
	affected_ci_name VARCHAR,
	tag_1 VARCHAR,
	tag_6 VARCHAR,
   source_timestamp TIMESTAMP
)
WITH (
   format = 'PARQUET',
   external_location = 'file:///parquet/pbi/incident_records/'
);

--drop table if exists hive.pbi.ir_activity;
CREATE TABLE hive.pbi.ir_activity (
   incident_id VARCHAR,
   date_time_timezone_based TIMESTAMP,
   type VARCHAR,
   assignment_group VARCHAR,
   source_timestamp TIMESTAMP
)
WITH (
   format = 'PARQUET',
   external_location = 'file:///parquet/pbi/ir_activity/'
);

--drop table if exists hive.pbi.ibm_queue;
CREATE TABLE hive.pbi.ibm_queue (
	row_labels VARCHAR,
   empresa VARCHAR,
   modulo VARCHAR,
   sdm VARCHAR,
   source_timestamp TIMESTAMP
)
WITH (
    format = 'PARQUET',
    external_location = 'file:///parquet/pbi/ibm_queue/'
);