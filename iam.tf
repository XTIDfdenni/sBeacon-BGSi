#
# Generic policy documents
#
data "aws_iam_policy_document" "main-apigateway" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

#
# submitDataset Lambda Function
#
data "aws_iam_policy_document" "lambda-submitDataset" {
  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:GetItem",
    ]
    resources = [
      aws_dynamodb_table.datasets.arn,
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:CreateMultipartUpload",
      "s3:UploadPart",
      "s3:CompleteMultipartUpload",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "lambda:InvokeFunction",
    ]
    resources = [module.lambda-indexer.lambda_function_arn]
  }
}

#
# getInfo Lambda Function
#
data "aws_iam_policy_document" "lambda-getInfo" {
  statement {
    actions = [
      "dynamodb:Scan",
    ]
    resources = [
      aws_dynamodb_table.datasets.arn,
    ]
  }
}

#
# getConfiguration Lambda Function
#
data "aws_iam_policy_document" "lambda-getConfiguration" {
  statement {
    actions = [
      "dynamodb:Scan",
    ]
    resources = [
      aws_dynamodb_table.datasets.arn,
    ]
  }
}

#
# getMap Lambda Function
#
data "aws_iam_policy_document" "lambda-getMap" {
  statement {
    actions = [
      "dynamodb:Scan",
    ]
    resources = [
      aws_dynamodb_table.datasets.arn,
    ]
  }
}

#
# getEntryTypes Lambda Function
#
data "aws_iam_policy_document" "lambda-getEntryTypes" {
  statement {
    actions = [
      "dynamodb:Scan",
    ]
    resources = [
      aws_dynamodb_table.datasets.arn,
    ]
  }
}

#
# getFilteringTerms Lambda Function
#
data "aws_iam_policy_document" "lambda-getFilteringTerms" {
  statement {
    actions   = []
    resources = []
  }
}

#
# getAnalyses Lambda Function
#
data "aws_iam_policy_document" "lambda-getAnalyses" {
  statement {
    actions = [
      "dynamodb:Query",
    ]
    resources = [
      "${aws_dynamodb_table.datasets.arn}/index/*",
      "${aws_dynamodb_table.variant_query_responses.arn}/index/*"
    ]
  }

  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
    ]
    resources = [
      aws_dynamodb_table.variant_queries.arn,
    ]
  }

  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem"
    ]
    resources = [
      aws_dynamodb_table.datasets.arn,
      aws_dynamodb_table.variant_queries.arn,
      aws_dynamodb_table.variant_query_responses.arn
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "lambda:InvokeFunction",
    ]
    resources = [module.lambda-splitQuery.lambda_function_arn]
  }

  statement {
    actions = [
      "SNS:Publish",
    ]
    resources = [
      aws_sns_topic.splitQuery.arn,
    ]
  }
}

#
# getGenomicVariants Lambda Function
#
data "aws_iam_policy_document" "lambda-getGenomicVariants" {
  statement {
    actions = [
      "dynamodb:Query",
    ]
    resources = [
      "${aws_dynamodb_table.datasets.arn}/index/*",
      "${aws_dynamodb_table.variant_query_responses.arn}/index/*"
    ]
  }

  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
    ]
    resources = [
      aws_dynamodb_table.variant_queries.arn,
    ]
  }

  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:BatchGetItem"
    ]
    resources = [
      aws_dynamodb_table.datasets.arn,
      aws_dynamodb_table.variant_queries.arn,
      aws_dynamodb_table.variant_query_responses.arn
    ]
  }

  statement {
    actions = [
      "lambda:InvokeFunction",
    ]
    resources = [module.lambda-splitQuery.lambda_function_arn]
  }

  statement {
    actions = [
      "SNS:Publish",
    ]
    resources = [
      aws_sns_topic.splitQuery.arn,
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = ["*"]
  }
}

#
# getIndividuals Lambda Function
#
data "aws_iam_policy_document" "lambda-getIndividuals" {
  statement {
    actions = [
      "dynamodb:Query",
    ]
    resources = [
      "${aws_dynamodb_table.datasets.arn}/index/*",
      "${aws_dynamodb_table.variant_query_responses.arn}/index/*"
    ]
  }

  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
    ]
    resources = [
      aws_dynamodb_table.variant_queries.arn,
    ]
  }

  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem"
    ]
    resources = [
      aws_dynamodb_table.datasets.arn,
      aws_dynamodb_table.variant_queries.arn,
      aws_dynamodb_table.variant_query_responses.arn
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "lambda:InvokeFunction",
    ]
    resources = [module.lambda-splitQuery.lambda_function_arn]
  }

  statement {
    actions = [
      "SNS:Publish",
    ]
    resources = [
      aws_sns_topic.splitQuery.arn,
    ]
  }
}

#
# getBiosamples Lambda Function
#
data "aws_iam_policy_document" "lambda-getBiosamples" {
  statement {
    actions = [
      "dynamodb:Query",
    ]
    resources = [
      "${aws_dynamodb_table.datasets.arn}/index/*",
      "${aws_dynamodb_table.variant_query_responses.arn}/index/*"
    ]
  }

  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
    ]
    resources = [
      aws_dynamodb_table.variant_queries.arn,
    ]
  }

  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem"
    ]
    resources = [
      aws_dynamodb_table.datasets.arn,
      aws_dynamodb_table.variant_queries.arn,
      aws_dynamodb_table.variant_query_responses.arn
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "lambda:InvokeFunction",
    ]
    resources = [module.lambda-splitQuery.lambda_function_arn]
  }

  statement {
    actions = [
      "SNS:Publish",
    ]
    resources = [
      aws_sns_topic.splitQuery.arn,
    ]
  }
}

#
# getDatasets Lambda Function
#
data "aws_iam_policy_document" "lambda-getDatasets" {
  statement {
    actions = [
      "dynamodb:Query",
    ]
    resources = [
      "${aws_dynamodb_table.datasets.arn}/index/*",
      "${aws_dynamodb_table.variant_query_responses.arn}/index/*"
    ]
  }

  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
    ]
    resources = [
      aws_dynamodb_table.variant_queries.arn,
    ]
  }

  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem"
    ]
    resources = [
      aws_dynamodb_table.datasets.arn,
      aws_dynamodb_table.variant_queries.arn,
      aws_dynamodb_table.variant_query_responses.arn
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "lambda:InvokeFunction",
    ]
    resources = [module.lambda-splitQuery.lambda_function_arn]
  }

  statement {
    actions = [
      "SNS:Publish",
    ]
    resources = [
      aws_sns_topic.splitQuery.arn,
    ]
  }
}

#
# getCohorts Lambda Function
#
data "aws_iam_policy_document" "lambda-getCohorts" {
  statement {
    actions = [
      "dynamodb:Query",
    ]
    resources = [
      "${aws_dynamodb_table.datasets.arn}/index/*",
      "${aws_dynamodb_table.variant_query_responses.arn}/index/*"
    ]
  }

  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
    ]
    resources = [
      aws_dynamodb_table.variant_queries.arn,
    ]
  }

  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem"
    ]
    resources = [
      aws_dynamodb_table.datasets.arn,
      aws_dynamodb_table.variant_queries.arn,
      aws_dynamodb_table.variant_query_responses.arn
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = ["*"]
  }
}

#
# getRuns Lambda Function
#
data "aws_iam_policy_document" "lambda-getRuns" {
  statement {
    actions = [
      "dynamodb:Query",
    ]
    resources = [
      "${aws_dynamodb_table.datasets.arn}/index/*",
      "${aws_dynamodb_table.variant_query_responses.arn}/index/*"
    ]
  }

  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
    ]
    resources = [
      aws_dynamodb_table.variant_queries.arn,
    ]
  }

  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem"
    ]
    resources = [
      aws_dynamodb_table.datasets.arn,
      aws_dynamodb_table.variant_queries.arn,
      aws_dynamodb_table.variant_query_responses.arn
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "lambda:InvokeFunction",
    ]
    resources = [module.lambda-splitQuery.lambda_function_arn]
  }

  statement {
    actions = [
      "SNS:Publish",
    ]
    resources = [
      aws_sns_topic.splitQuery.arn,
    ]
  }
}

#
# indexer Lambda Function
#
data "aws_iam_policy_document" "lambda-indexer" {
  statement {
    actions = [
      "SNS:Publish",
    ]
    resources = [
      aws_sns_topic.indexer.arn,
    ]
  }
}

#
# splitQuery Lambda Function
#
data "aws_iam_policy_document" "lambda-splitQuery" {
  statement {
    actions = [
      "lambda:InvokeFunction",
    ]
    resources = [module.lambda-performQuery.lambda_function_arn]
  }

  statement {
    actions = [
      "SNS:Publish",
    ]
    resources = [
      aws_sns_topic.performQuery.arn,
    ]
  }
}

#
# performQuery Lambda Function
#
data "aws_iam_policy_document" "lambda-performQuery" {
  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:GetItem",
    ]
    resources = [
      aws_dynamodb_table.datasets.arn,
      aws_dynamodb_table.variant_queries.arn,
      aws_dynamodb_table.variant_query_responses.arn,
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
    ]
    resources = ["*"]
  }
}

# 
# Generic IAM policies
# 

# Athena Full Access
# Grants access to perform queries and write to s3
# Also enables access to read query results from s3
data "aws_iam_policy_document" "athena-full-access" {
  statement {
    actions = [
      "athena:GetQueryExecution",
      "athena:GetQueryResults",
      "athena:StartQueryExecution"
    ]
    resources = [
      aws_athena_workgroup.sbeacon-workgroup.arn,
    ]
  }

  statement {
    actions = [
      "glue:*"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "s3:*",
    ]
    resources = [
      "${aws_s3_bucket.metadata-bucket.arn}",
      "${aws_s3_bucket.metadata-bucket.arn}/*"
    ]
  }
}

# DynamoDB Ontology Related Access
data "aws_iam_policy_document" "dynamodb-onto-access" {
  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem",
      "dynamodb:Scan",
    ]
    resources = [
      aws_dynamodb_table.ontologies.arn,
      aws_dynamodb_table.descendant_terms.arn,
      aws_dynamodb_table.anscestor_terms.arn,
    ]
  }
}

# DynamoDB Ontology Related Write Access
data "aws_iam_policy_document" "dynamodb-onto-write-access" {
  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:DeleteItem",
    ]
    resources = [
      aws_dynamodb_table.ontologies.arn,
      aws_dynamodb_table.descendant_terms.arn,
      aws_dynamodb_table.anscestor_terms.arn,
    ]
  }
}

# Admin Lambda Access
data "aws_iam_policy_document" "admin-lambda-access" {
  statement {
    actions = [
      "cognito-idp:*"
    ]
    resources = [
      aws_cognito_user_pool.BeaconUserPool.arn,
    ]
  }
  statement {
    actions = [
      "ses:SendEmail"
    ]
    resources = [
      "arn:aws:ses:${var.region}:${data.aws_caller_identity.this.account_id}:identity/*",
      aws_ses_configuration_set.ses_feedback_config.arn,
    ]
  }
}

# Athena Read-only Access
data "aws_iam_policy_document" "athena-readonly-access" {
  statement {
    actions = [
      "athena:GetQueryExecution",
      "athena:GetQueryResults",
      "athena:StartQueryExecution"
    ]
    resources = [
      aws_athena_workgroup.sbeacon-workgroup.arn,
    ]
  }

  statement {
    actions = [
      "glue:*"
    ]
    resources = [
      "*"
    ]
  }
}


# DataPortal Lambda Access
data "aws_iam_policy_document" "data-portal-lambda-access" {
  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:BatchGetItem",
    ]
    resources = [
      aws_dynamodb_table.projects.arn,
      aws_dynamodb_table.project_users.arn,
      aws_dynamodb_table.juptyer_notebooks.arn,
    ]
  }

  statement {
    actions = [
      "cognito-idp:ListUsers",
    ]
    resources = [
      aws_cognito_user_pool.BeaconUserPool.arn
    ]
  }

  statement {
    actions = [
      "sagemaker:CreateNotebookInstance",
      "sagemaker:DescribeNotebookInstance",
      "sagemaker:StartNotebookInstance",
      "sagemaker:StopNotebookInstance",
      "sagemaker:DeleteNotebookInstance",
      "sagemaker:ListNotebookInstances",
      "sagemaker:UpdateNotebookInstance",
      "sagemaker:CreatePresignedNotebookInstanceUrl",
      "sagemaker:AddTags",
    ]
    resources = [
      "arn:aws:sagemaker:${var.region}:${data.aws_caller_identity.this.account_id}:notebook-instance/*"
    ]
  }

  statement {
    actions = [
      "iam:PassRole"
    ]

    resources = [
      aws_iam_role.sagemaker_jupyter_instance_role.arn
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.dataportal-bucket.arn
    ]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values = [
        "projects/*",
      ]
    }
  }

  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.dataportal-bucket.arn}/projects/*"
    ]
  }
}


# SES Email Notification Logging
data "aws_iam_policy_document" "ses-sns-access" {
  statement {
    sid    = "AllowSESToPublishToSNS"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }

    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.sesDeliveryLogger.arn]

    # Removing specific conditions to see if that fixes the permission issue
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.this.account_id]
    }
  }
}