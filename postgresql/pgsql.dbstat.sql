DO LANGUAGE plpgsql $$
DECLARE
	ver integer;
	res text;
BEGIN
	SELECT current_setting('server_version_num') INTO ver;

	IF (ver >= 120000) THEN
		SELECT json_object_agg(datname, row_to_json(T)) INTO res FROM (
			SELECT COALESCE( NULLIF(datname,'') , 'shared_objects' ) AS datname,
					numbackends AS numbackends,
					xact_commit AS xact_commit,
					xact_rollback AS xact_rollback,
					blks_read AS blks_read,
					blks_hit AS blks_hit,
					tup_returned AS tup_returned,
					tup_fetched AS tup_fetched,
					tup_inserted AS tup_inserted,
					tup_updated AS tup_updated,
					tup_deleted AS tup_deleted,
					conflicts AS conflicts,
					temp_files AS temp_files,
					temp_bytes AS temp_bytes,
					deadlocks AS deadlocks,
					blk_read_time AS blk_read_time,
					blk_write_time AS blk_write_time,
					checksum_failures AS checksum_failures,
					checksum_last_failure AS checksum_last_failure
			FROM pg_stat_database) T;

	ELSE
		SELECT json_object_agg(datname, row_to_json(T)) INTO res FROM (
			SELECT datname,
					numbackends AS numbackends,
					xact_commit AS xact_commit,
					xact_rollback AS xact_rollback,
					blks_read AS blks_read,
					blks_hit AS blks_hit,
					tup_returned AS tup_returned,
					tup_fetched AS tup_fetched,
					tup_inserted AS tup_inserted,
					tup_updated AS tup_updated,
					tup_deleted AS tup_deleted,
					conflicts AS conflicts,
					temp_files AS temp_files,
					temp_bytes AS temp_bytes,
					deadlocks AS deadlocks,
					blk_read_time AS blk_read_time,
					blk_write_time AS blk_write_time
			FROM pg_stat_database) T;
	END IF;

	perform set_config('zbx_tmp.conn_json_res', res, false);
END $$;

select current_setting('zbx_tmp.conn_json_res');