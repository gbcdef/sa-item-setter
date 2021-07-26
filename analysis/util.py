from requests import get, post
from io import BytesIO
import pandas as pd

API_SECRET = 'b666bca5c1d64e0c015b41283410b4031313d463df134eb922fe419382446f78'
WEB_URL = 'analytics.vova.com.hk'
PROJECT = 'production'
API_URL = 'sql/query'
url = f'https://{WEB_URL}/api/{API_URL}?token={API_SECRET}&project={PROJECT}'


def hive(sql):
    data = {'q': sql, 'format': 'csv'}
    res = post(url, data=data)
    buffer = BytesIO(res.content)
    return pd.read_csv(buffer, sep='\t')


__all__ = [
    'hive'
]
