# 用途

利用神策分析的维度表，更新两个维度表：
1. `update categories.py` 更新商品类目维度表
2. `update currency.py` 更新币种维度表

```
│  update categories.py
│  update currency.py
│  
├─analysis
│      scratch.py
│      util.py
│      
├─dataprep
│      cat_id清洗.sql
│      cat_id清洗后商品分类.xlsx
│      维度表+维度字典.xlsx
│      
├─first_day_test
│      events_simulator.py
│      users.py
```
