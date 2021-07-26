from util import hive

#%%
# 问题：Android 2.125版本未在启动时调用sa.login()导致老用户被判定为新用户
df = hive('''
select date, $os, $app_version, count(1)
from events e, users u
where date between '2021-07-21' and '2021-07-26'
and event = '$AppInstall'
and $is_first_day = 1
and $os='Android'
and e.user_id = u.id
and u.second_id is null
group by date, $os , $app_version
order by date desc, $os, $app_version desc
''')

#%%
df = hive('''
select *
from events
where date='2021-07-21'
and event = '$ChannelMatchedInstall'
-- and event in ('$AppChannelMatching')
and $os='iOS'
limit 100
''')