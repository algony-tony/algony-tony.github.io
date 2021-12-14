---
layout: post
title: 计算连续天数的一个SQL技巧
categories: 软件技术
tags: SQL
---
用SQL来计算某个行为在一定周期粒度上连续发生的次数有一个巧妙的方法，主要参考下面链接的解答。

假设要计算每个人登录的最大连续天数，首先将数据表清洗为存储用户和登录日期的表（t_login_log），如下：

| user_id | login_date |
| --- | --- |
| user01 | 2020-01-02 |
| user01 | 2020-01-03 |
| user01 | 2020-01-04 |
| user01 | 2020-01-06 |
| user02 | 2020-01-03 |
| user02 | 2020-01-05 |
| user02 | 2020-01-06 |

{% highlight sql linedivs %}
select h.user_id
    ,max(h.cnt) as max_continuous_days
from (
    select t.user_id
        ,t.hang_date
        ,sum(1) as cnt
    from (
        select tll.user_id
            ,tll.login_date
            ,date_sub(tll.login_date, row_number() over (partition by tll.user_id order by tll.login_date)) as hang_date
        from t_login_log tll
        ) t
    group by t.user_id, t.hang_date
    ) h
group by h.user_id;
{% endhighlight %}

三层嵌套子查询中主要要理解最内层的 hang_date 列的计算意义：对每个人而言，连续的日期会得到相同的 hang_date 值，以此将统计连续出现的天数的问题转换为统计相同日期出现的次数的问题。

| user_id | login_date | hang_date |
| --- | --- | --- |
| user01 | 2020-01-02 | 2020-01-01 |
| user01 | 2020-01-03 | 2020-01-01 |
| user01 | 2020-01-04 | 2020-01-01 |
| user01 | 2020-01-06 | 2020-01-02 |
| user02 | 2020-01-03 | 2020-01-02 |
| user02 | 2020-01-05 | 2020-01-03 |
| user02 | 2020-01-06 | 2020-01-03 |

### 参考
[SQL语句求连续天数](https://bbs.csdn.net/topics/390506222)