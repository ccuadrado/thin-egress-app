import json
import boto3
import os

from datetime import datetime
from rain_api_core.general_util import get_log
log = get_log()

client = boto3.client('lambda')
TEA_LAMBDA_NAME = os.getenv('TEA_LAMBDA_NAME')

def lambda_handler(event, context):

    log.info('teabumper!')

    egress_env = client.get_function_configuration(
        FunctionName=TEA_LAMBDA_NAME,
    )['Environment']

    egress_env['Variables'].update({'BUMP': f'{str(datetime.utcnow())}, {context.aws_request_id}'})

    log.debug(f"envvar for {TEA_LAMBDA_NAME}: {egress_env['Variables']}")
    response = client.update_function_configuration(
        FunctionName=TEA_LAMBDA_NAME,
        Environment=egress_env
    )
    log.debug(response)


def version():
    return json.dumps({'version_id': '<BUILD_ID>'})
