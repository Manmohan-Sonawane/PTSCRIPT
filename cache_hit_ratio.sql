SELECT
    name,
    physical_reads,
    db_block_gets,
    consistent_gets,
    (1 - (physical_reads / (db_block_gets + consistent_gets))) * 100 AS cache_hit_ratio
FROM
    V$BUFFER_POOL_STATISTICS
WHERE
    name = 'DEFAULT';

