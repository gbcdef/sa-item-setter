import logging
import sensorsanalytics
import os
import pandas as pd

lg = logging.getLogger(__name__)
logging.basicConfig(level=logging.DEBUG)

log_dir = os.path.join('data/', 'sa/')
os.makedirs(log_dir, exist_ok=True)
log_path = os.path.join(log_dir, 'item.log')

consumer = sensorsanalytics.LoggingConsumer(log_path)

sa = sensorsanalytics.SensorsAnalytics(consumer)

cat_file = 'cat_id维度表.xlsx'
cat_list = pd.read_excel(cat_file)

property_list = [
    'cat_name'
    # , 'cat_goods_name'
    , 'depth'
    # , 'keywords'
    # , 'cat_desc'
    # , 'parent_id'
    # , 'sort_order'
    # , 'is_show'
    # , 'party_id'
    # , 'config'
    # , 'erp_cat_id'
    # , 'erp_top_cat_id'
    # , 'pk_cat_id'
    # , 'is_accessory'
    # , 'last_update_time'
]
item_type = 'cat'
for cat in cat_list.iterrows():
    cat_id = cat[1]['cat_id']

    properties = {x: cat[1][x] for x in property_list}

    lg.debug(cat_id)
    lg.debug(properties)

    sa.item_set(item_type, cat_id, properties)
