#!/usr/bin/env bash

partition=$( date +%Y%m%d )


spark-submit --class com.scala.tensai.demo.rds_reward \
--master yarn \
--deploy-mode cluster \
--driver-memory 1g --driver-cores 1 --num-executors 1 --executor-cores 1 --executor-memory 1g \
--conf "spark.port.maxRetries=128" \
--conf "spark.sql.adaptive.enabled=true" \
--conf "spark.sql.shuffle.partitions=400" \
--conf "spark.sql.adaptive.shuffle.targetPostShuffleInputSize=830000000" \
--conf "spark.sql.hive.convertMetastoreParquet=false" \
--conf "hive.exec.dynamic.partition.mode=nonstrict" \
/home/rockwxp/solanadata_process.jar




gcloud dataproc jobs submit spark \
--cluster=hadoop-cluster-01 \
--region=us-central1 \
--class=com.scala.tensai.demo.rds_reward \
--jars=hdfs://hadoop-cluster-01-m/jar/solanadata_process.jar -- 1000