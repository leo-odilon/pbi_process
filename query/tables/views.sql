CREATE VIEW unique_incident_records AS
SELECT * from incident_records
where source_timestamp = (select max(source_timestamp) from incident_records);