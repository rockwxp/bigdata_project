drop table `decent-destiny-329402.solana_rds.rds_reward`;
CREATE EXTERNAL TABLE `decent-destiny-329402.solana_rds.rds_names`
(
  name STRING,
  gender STRING,
  count INT64,
  dt DATE
)
WITH PARTITION COLUMNS
OPTIONS(
  format="CSV",
  hive_partition_uri_prefix="gs://solana-rds-bucket/solana_rds/rds_names",
  uris=["gs://solana-rds-bucket/solana_rds/rds_names/*"]
);

CREATE EXTERNAL TABLE `decent-destiny-329402.solana_rds.rds_reward`
(
     commission  string,
     lamports    INT,
     postBalance BIGINT,
     pubkey      string,
     rewardType  string,
     day string

)
WITH PARTITION COLUMNS
OPTIONS(
  format="CSV",
  hive_partition_uri_prefix="gs://solana-rds-bucket/solana_rds/rds_reward",
  uris=["gs://solana-rds-bucket/solana_rds/rds_reward/*"]
);


SELECT
    table_name, ddl
FROM
    `decent-destiny-329402.solana_rds.INFORMATION_SCHEMA.TABLES`
WHERE
        table_name="rds_reward";