import json
import logging

import requests

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):

    reseponse = requests.get(url="https://example.com")

    logger.info("response: %s", reseponse)

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(
            {"message": "Hello world! from shiun, omg, make a change123456789"}
        ),
    }


if __name__ == "__main__":
    pass
