"""Cloud founction : generate fake data"""
import os
import logging
import json
from datetime import datetime
from google.cloud import storage
from dgt.utils.fake_data import FakerDataGenerator
import random

logging.basicConfig(level=logging.INFO,
                    format="%(asctime)s %(levelname)s %(name)s: %(message)s",
                    datefmt='%y/%m/%d %H:%M:%S')

logger = logging.getLogger()

ENV_VAR = json.loads(os.getenv("ENV_VAR"))
LIST_BUCKET_NAME = ENV_VAR.get("LIST_BUCKET_NAME")
N_ROWS = random.randint(1000, 2000)
STORAGE_CLIENT = storage.Client()
SOURCES = [
    "meteo", "train_rides", "fuel_economy", "resto_orders", 
    "stock_prices", "elec_consump", "nps", "stock_orders",
    "bank_oper", "bank_trans", "vehicle"
    ]

FORMATS = ["csv", "parquet"]

def generate_fake_data(source_name: str, output_format:str="csv", sep=";") -> str:
    """Generate fake data and save it in Cloud Storage (GCS)
    
    Parameters
    ----------
    source_name: str, {'meteo', 'train_rides', 'fuel_economy', ..}
        Name of source to generate
    ouput_format: str, {'csv', 'parquet'}, optional, default 'csv'
        Format for the ouput file
    
    Return
    ------
       str: OK or FAILURE if data are generated and save in GCS
        Name of source to generate
    """

    if source_name not in SOURCES:
        raise ValueError("The source name must be in %s", SOURCES)

    if output_format not in ["csv", "parquet"]:
        raise ValueError("The format for the output file must be in %s", FORMATS)

    generator = FakerDataGenerator(source_name=source_name, n_rows=N_ROWS)
    now = datetime.now()
    now_str = now.strftime("%Y%m%d%H%M%S")
    generator.apply()
    filename = f"{source_name}_{now_str}.{output_format}"
    path_filename = f"{source_name}/{now:%Y}/{now:%m}/{now:%d}"
    dfm = generator.generate_data(to_return=True)

    if output_format == 'csv':
        dfm.to_csv(path_or_buf=filename, index=False, sep=sep)
    else:
        dfm.to_parquet(filename)
    
    for bucket_name in LIST_BUCKET_NAME:
        gcs_bucket = STORAGE_CLIENT.bucket(bucket_name)
        try:
            blob = gcs_bucket.blob(f"{path_filename}/{filename}")
            _ = blob.upload_from_filename(filename)
            logger.info("%s is uploaded !", blob.name)
            status = 'OK'
        except Exception as e:
            status = 'FAILURE'
            logger.info("errorMessage : %s", str(e))

    os.remove(filename)

    return status

if __name__ == '__main__':
    print(generate_fake_data(source_name='meteo', output_format='csv'))
    print(generate_fake_data(source_name='fuel_economy', output_format='parquet'))