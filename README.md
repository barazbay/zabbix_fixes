# zabbix fixes
```
deploy configs for zabbix monitoring  
see more at https://github.com/zabbix/zabbix/tree/master/templates/db/postgresql

todo: extract scram sha pass and send to userlist.txt, edit pgbouncer.conf, SIGHUP to pgbouncer

CHANGELOG
/var/lib/zabbix/postgresql/pgsql.connections.sql
add metrics:
    idle_in_transaction_aborted
    fastpath_function_call
    disabled

changed metrics:
    if version >= 90600:
        was:
            sum(CASE WHEN wait_event IS NOT NULL THEN 1 ELSE 0 END) AS waiting
        now:
            sum(CASE WHEN wait_event_type = 'Lock' AND wait_event = 'transactionid' THEN 1 ELSE 0 END) AS waiting

/var/lib/zabbix/postgresql/pgsql.connections.sum.sql
add metrics:
    idle_in_transaction_aborted
    fastpath_function_call
    disabled

changed metrics:
    if version >= 90600:
        was:
            sum(CASE WHEN wait_event IS NOT NULL THEN 1 ELSE 0 END) AS waiting
        now:
            sum(CASE WHEN wait_event_type = 'Lock' AND wait_event = 'transactionid' THEN 1 ELSE 0 END) AS waiting

/var/lib/zabbix/postgresql/pgsql.dbstat.sql
add metrics:
    if version >= 120000:
        blk_read_time
        blk_write_time
        checksum_failures
        checksum_last_failure
    else:
        blk_read_time
        blk_write_time
fix NULL datname at datid=0 if version >= 120000

/var/lib/zabbix/postgresql/pgsql.dbstat.sum.sql
add metrics:
    if version >= 120000:
        blk_read_time
        blk_write_time
        checksum_failures
    else:
        blk_read_time
        blk_write_time
/var/lib/zabbix/postgresql/pgsql.discovery.db.sql
add datallowconn at database discovery condition

/var/lib/zabbix/postgresql/pgsql.replication.lag.sql
add confition: if not pg_is_in_recovery, then replication lag is 0



<!-- known issues -->
/var/lib/zabbix/postgresql/pgsql.dbstat.sum.sql
did not found any item, related to this sql
```