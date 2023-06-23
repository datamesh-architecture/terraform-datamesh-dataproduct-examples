// required to set up a kafka cluster and the topic 'stock' for this example on confluent cloud
module "confluent_kafka" {
  source = "./confluent_kafka"

  topics = [ "stock" ]
}

module "kafka_to_s3" {
  source    = "datamesh-architecture/dataproduct-confluent-kafka-to-aws-s3/aws"
  version = "0.1.0"

  aws       = var.aws
  confluent = var.confluent
  kafka     = module.confluent_kafka.kafka

  domain = "fulfillment"
  name = "stock_updated"
  input = [
    {
      topic      = "stock"
      format     = "JSON"
      table_name = "stock_updated"
      schema     = "schema/stock_updated.schema.json"
    }
  ]
  output = {
    grant_access  = [ "<aws_account_id>" ]
  }
}
