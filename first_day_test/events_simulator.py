import logging
import sensorsanalytics
import os
import json

from users import ids

lg = logging.getLogger(__name__)
logging.basicConfig(level=logging.DEBUG)

SA_SERVER_URL = 'https://datasink.vovaapp.com/sa?project=test'
consumer = sensorsanalytics.AsyncBatchConsumer(SA_SERVER_URL)
sa = sensorsanalytics.SensorsAnalytics(consumer)


distinct_id = ids[0]
properties = {
    'page_code': 'email_sent',
    'button_name': '测试首日访问2',
    'button_content': None,
    '$is_first_day': True,
    '$is_first_time': True,
}

lg.debug(distinct_id)
lg.debug(properties)

sa.track(distinct_id, 'buttonClick', properties, is_login_id=True)

sa.flush()
sa.close()