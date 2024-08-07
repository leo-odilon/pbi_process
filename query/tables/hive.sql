CREATE SCHEMA pbi;

--drop table if exists hive.pbi.incident_records;
CREATE EXTERNAL TABLE pbi.incident_records (
	incident_id STRING,
	open_time_timezone_based STRING,
	open_group STRING,
	resolve_time_timezone_based STRING,
	resolve_group STRING,
	affected_ci_id STRING,
	affected_ci_name STRING,
	tag_1 STRING,
	tag_6 STRING,
  source_timestamp STRING
)
STORED AS PARQUET
LOCATION '/data/parquet/pbi/incident_records/';

--drop table if exists hive.pbi.ir_activity;
CREATE EXTERNAL TABLE pbi.ir_activity (
   incident_id STRING,
   date_time_timezone_based TIMESTAMP,
   type STRING,
   assignment_group STRING,
   source_timestamp TIMESTAMP
)
STORED AS PARQUET
LOCATION '/data/parquet/pbi/ir_activity/';

--drop table if exists hive.pbi.ibm_queue;
CREATE EXTERNAL TABLE pbi.ibm_queue (
	row_labels STRING,
   empresa STRING,
   modulo STRING,
   sdm STRING,
   source_timestamp TIMESTAMP
)
STORED AS PARQUET
LOCATION '/data/parquet/pbi/ibm_queue/';