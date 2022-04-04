CREATE EXTERNAL TABLE IF NOT EXISTS solana_rds.rds_reward_demo
(
    commission  string,
    lamports    INT,
    postBalance BIGINT,
    pubkey      string,
    rewardType  string
)
 PARTITIONED BY (day String) STORED AS PARQUET
LOCATION '/warehouse/solana_rds/rds_reward_demo';




 CREATE EXTERNAL TABLE IF NOT EXISTS solana_rds.rds_reward_demo_01
 (
     commission  string,
     lamports    INT,
     postBalance BIGINT,
     pubkey      string,
     rewardType  string
 )
PARTITIONED BY (day string)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
LOCATION '/warehouse/solana_rds/rds_reward_demo_01';
alter table solana_rds.rds_reward_demo_01 add partition(day=20220306);

CREATE TABLE solana_rds.rds_reward_demo_01(     commission  string,
                                  lamports    INT,
                                  postBalance BIGINT,
                                  pubkey      string,
                                  rewardType  string
                                )
    PARTITIONED BY (`day` string)
    ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
    STORED AS
        INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat'
        OUTPUTFORMAT
            'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
    tblproperties ("compress"="SNAPPY");


load data inpath '/warehouse/solana_rds/rds_reward_demo_01/day=20220306/rds_reward_demo_01.json' into table solana_rds.rds_reward_demo_01 partition (day='20220306');