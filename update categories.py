import logging
import sensorsanalytics
import os
import pandas as pd

lg = logging.getLogger(__name__)
logging.basicConfig(level=logging.DEBUG)

SA_SERVER_URL = 'https://datasink.vovaapp.com/sa?project=test'
consumer = sensorsanalytics.AsyncBatchConsumer(SA_SERVER_URL)
sa = sensorsanalytics.SensorsAnalytics(consumer)

cat_file = 'dataprep/cat_id清洗后商品分类.xlsx'
cat_df = pd.read_excel(cat_file)
cat_df = cat_df.fillna('Empty')

item_type = 'cat'
property_list = [
    'compcat1',
    'compcat2',
    'compcat3',
    'compcat4',
]
for cat in cat_df.iterrows():
    cat_id = cat[1]['cat_id']
    properties = {x: cat[1][x] for x in property_list}

    lg.debug(cat_id)
    lg.debug(properties)

    sa.item_set(item_type, cat_id, properties)

sa.close()