"""Cloud founction : main function"""
import base64
from cloudevents.http import CloudEvent
import functions_framework
from .utils import generate_fake_data, logger

@functions_framework.cloud_event
def main(cloud_event: CloudEvent) -> None:
    """
     Generate fake data and save it in Cloud Storage (GCS)
    """
    data = base64.b64decode(cloud_event.data['message']['data']).decode()
    try:
        source, format = data.split(';')
        logger.info('Generating data for %s ---------', source)
        generate_fake_data(source_name=source, output_format=format)
    except Exception as error:
        logger.info('Cannot generate data for %s ---------', data)
        logger.info('The pubsub message %s must be "source;format"', data)
        logger.info('Error message: %s', error)
