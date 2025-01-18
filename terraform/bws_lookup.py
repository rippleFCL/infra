import json
import logging
import os
import sys

import requests


class InvalidToken(Exception):
    pass


if os.environ.get("TF_LOG") == "1":
    logging.basicConfig(
        filename="bws-lookup.log",
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        encoding="utf-8",
        level=logging.ERROR,
    )

logger = logging.getLogger(__name__)

access_token = os.environ.get("BWS_ACCESS_TOKEN")
if not access_token:
    raise InvalidToken("Token is not set")

bws_cache_url = os.environ.get("BWS_CACHE_URL", "http://localhost:5000")
key_name = json.load(sys.stdin)["key"].split(",")

logger.info(key_name)
results = {}

for key in key_name:
    bws_response = requests.get(
        f"{bws_cache_url}/key/{key}",
        headers={"Authorization": f"Bearer {access_token}"},
        timeout=10,
    ).json()

    logger.debug(bws_response)
    logger.debug("tiggie")
    try:
        results[key] = bws_response["value"]
    except KeyError as exc:
        raise InvalidToken(
            "Token is invalid or does not have permissions to read value"
        ) from exc

logger.debug(msg=results)
print(json.dumps(results))
