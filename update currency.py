import logging
import sensorsanalytics
import os
import pandas as pd

lg = logging.getLogger(__name__)
logging.basicConfig(level=logging.DEBUG)

SA_SERVER_URL = 'https://datasink.vovaapp.com/sa?project=test'
consumer = sensorsanalytics.AsyncBatchConsumer(SA_SERVER_URL)
sa = sensorsanalytics.SensorsAnalytics(consumer)

currency_file = '维度表+维度字典.xlsx'
currency_df = pd.read_excel(currency_file, sheet_name='币种维度表')

item_type = 'currency'

for c in currency_df.iterrows():
    item_id = c[1]['currency_id']
    properties = {'exchange_rate': c[1]['exchange_rate']}
    lg.debug(item_id)
    lg.debug(properties)

    sa.item_set(item_type, item_id, properties)

sa.close()