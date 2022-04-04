package com.scala.tensai.demo

import java.text.SimpleDateFormat

import org.apache.log4j.Logger
import org.apache.spark.sql.{DataFrame, SaveMode, SparkSession}
import org.apache.spark.sql.functions._
import org.apache.hadoop.fs.{FileSystem, Path}
/**
 *
 * @author Rock 
 * @date 3/6/22 12:34 PM
 * @description TODO
 */
object rds_reward {
  private val logger: Logger = Logger.getLogger(this.getClass)

  def main(args: Array[String]): Unit = {
    logger.info("start")
    val startTS = System.currentTimeMillis()
    val day = new SimpleDateFormat("yyyyMMdd").format(startTS)
    val spark: SparkSession = SparkSession.builder().appName("rds_reward").enableHiveSupport().getOrCreate()
    import spark.implicits._
    spark.sqlContext.setConf("spark.sql.hive.convertMetastoreParquet","false")
    spark.sqlContext.setConf("hive.exec.dynamic.partition.mode","nonstrict")
    val df: DataFrame = spark.read.format("json").option("inferSchema", "true").option("multiLine", "true").load("/warehouse/solana_source/rewards_demo.json")
    val rewardsDF: DataFrame = df.withColumn("rewards", explode($"rewards"))
    val finalDF: DataFrame = rewardsDF
      .withColumn("commission", $"rewards".getItem("commission"))
      .withColumn("lamports", $"rewards".getItem("lamports"))
      .withColumn("postBalance", $"rewards".getItem("postBalance"))
      .withColumn("pubkey", $"rewards".getItem("pubkey"))
      .withColumn("rewardType", $"rewards".getItem("rewardType"))
      .withColumn("day",lit(day)).drop("rewards")

    /**
     * overwrite
     */
    spark.sql(s"ALTER TABLE solana_rds.rds_reward_demo DROP IF EXISTS PARTITION (day=$day)")

    val fs = FileSystem.get(spark.sparkContext.hadoopConfiguration)
    val path = new Path(s"/warehouse/solana_rds/rds_reward_demo/day=$day")
    if(fs.exists(path))fs.delete(path,true)

    finalDF.write.format("hive").partitionBy("day").mode(SaveMode.Append).saveAsTable("solana_rds.rds_reward_demo");

  }

}
