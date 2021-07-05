
---
/* 
获取父级分类情况

各级分类的从属关系是跳跃的，4级分类可能直接挂到1级分类上，也可能先挂到3级上，再从3级直接挂到1级分类上
意味着商品可能直接挂到1级分类上，也可能直接挂到3级分类上
 */

select c1.cat_id, c1.cat_name, c1.depth, c1.parent_id
,c2.cat_id, c2.cat_name, c2.depth, c2.parent_id
,c3.cat_id, c3.cat_name, c3.depth, c3.parent_id
,c4.cat_id, c4.cat_name, c4.depth, c4.parent_id
from categories c1
left outer join categories c2 on c1.parent_id = c2.cat_id and c2.depth=3
left outer join categories c3 on c1.parent_id = c3.cat_id and c3.depth=2
left outer join categories c4 on c1.parent_id = c4.cat_id and c4.depth=1
order by c1.depth desc

---
/*
从1级分类开始往下，找1级分类的下一级直接作为二级分类，不管下一级分类是3级还是4级
实际：根分类除了root还有other，所以要从0级分类开始向下查找


*/
DROP VIEW IF EXISTS `categories_tmp1`;
CREATE VIEW `categories_tmp1` AS SELECT
c0.cat_id AS `cat0`,
c1.cat_id AS `cat1`,
c2.cat_id AS `cat2`,
c3.cat_id AS `cat3`,
c4.cat_id AS `cat4`,
COALESCE ( c4.cat_id, c3.cat_id, c2.cat_id, c1.cat_id ) AS cat_id,
COALESCE ( c1.cat_name, c0.cat_name ) AS `compcat1`,
COALESCE ( c2.cat_name, c1.cat_name, c0.cat_name ) AS `compcat2`,
COALESCE ( c3.cat_name, c2.cat_name, c1.cat_name, c0.cat_name ) AS `compcat3`,
COALESCE ( c4.cat_name, c3.cat_name, c2.cat_name, c1.cat_name, c0.cat_name ) AS `compcat4` 
FROM
	categories c0
	LEFT OUTER JOIN categories c1 ON c0.cat_id = c1.parent_id
	LEFT OUTER JOIN categories c2 ON c1.cat_id = c2.parent_id
	LEFT OUTER JOIN categories c3 ON c2.cat_id = c3.parent_id
	LEFT OUTER JOIN categories c4 ON c3.cat_id = c4.parent_id 
WHERE
	c0.depth = 0;
	
/*
上述视图只包含含有子分类的品类

如果一个商品挂在2级分类，那么该商品没有3级分类，即便该2级分类下含有3级分类。
针对这种情况，需要增加子节点为空的分类树
*/

-- 三级品类
SELECT DISTINCT
	a1.cat_id,
	a2.compcat1,
	a2.compcat2,
	a2.compcat3,
	NULL AS `compcat4` 
FROM
	(
	SELECT
		c1.cat_id,
		c1.cat_name,
		c1.depth 
	FROM
		categories c1
		LEFT OUTER JOIN categories_tmp1 c2 ON c1.cat_id = c2.cat_id 
	WHERE
		c2.cat_id IS NULL 
		AND c1.depth = 3 
	) a1
	LEFT OUTER JOIN categories_tmp1 a2 ON a1.cat_id = a2.cat3 UNION-- 二级品类
SELECT DISTINCT
	a1.cat_id,
	a2.compcat1,
	a2.compcat2,
	NULL AS `compcat3`,
	NULL AS `compcat4` 
FROM
	(
	SELECT
		c1.cat_id,
		c1.cat_name,
		c1.depth 
	FROM
		categories c1
		LEFT OUTER JOIN categories_tmp1 c2 ON c1.cat_id = c2.cat_id 
	WHERE
		c2.cat_id IS NULL 
		AND c1.depth = 2 
	) a1
	LEFT OUTER JOIN categories_tmp1 a2 ON a1.cat_id = a2.cat2 UNION-- 一级品类
SELECT DISTINCT
	a1.cat_id,
	a2.compcat1,
	NULL AS `compcat2`,
	NULL AS `compcat3`,
	NULL AS `compcat4` 
FROM
	(
	SELECT
		c1.cat_id,
		c1.cat_name,
		c1.depth 
	FROM
		categories c1
		LEFT OUTER JOIN categories_tmp1 c2 ON c1.cat_id = c2.cat_id 
	WHERE
		c2.cat_id IS NULL 
		AND c1.depth = 1 
	) a1
	LEFT OUTER JOIN categories_tmp1 a2 ON a1.cat_id = a2.cat1 UNION-- 四级品类
SELECT
	cat_id,
	compcat1,
	compcat2,
	compcat3,
	compcat4 
FROM
	categories_tmp1;