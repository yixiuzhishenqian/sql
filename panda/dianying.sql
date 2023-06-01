CREATE TABLE category
(
 cid INT PRIMARY KEY AUTO_INCREMENT,
 cname VARCHAR(20)
);
CREATE TABLE film
(
 fid INT PRIMARY KEY AUTO_INCREMENT,
 fname VARCHAR(20),
 director VARCHAR(20),   #导演
 price DECIMAL(10,2),
 showtime DATE,
 cid INT,
 FOREIGN KEY(cid) REFERENCES category(cid)
);
CREATE TABLE USER
(
 uid INT PRIMARY KEY AUTO_INCREMENT,
 uname VARCHAR(20),
 birthday DATE,
 gender ENUM('男','女'),
 address VARCHAR(20),
 cellphone CHAR(11)
);
CREATE TABLE user_category
(
  uid INT,
  cid INT,
  FOREIGN KEY(uid) REFERENCES USER(uid),
  FOREIGN KEY(cid) REFERENCES category(cid),
  PRIMARY KEY(uid,cid)
);

CREATE TABLE emp
(
  eid INT PRIMARY KEY AUTO_INCREMENT,
  ename VARCHAR(20),
  gender ENUM('男','女'),
  hiredate DATE,
  sal DECIMAL(10,2),
  address VARCHAR(20)
);

CREATE TABLE sal_grade
(
  gid INT PRIMARY KEY AUTO_INCREMENT,
  minsal DECIMAL(10,2),
  maxsal DECIMAL(10,2)
);


CREATE TABLE orders
(
  eid INT,
  uid INT,
  fid INT,
  num INT,
  odate DATE
);


INSERT INTO category VALUES(NULL, '喜剧');
INSERT INTO category VALUES(NULL, '动作');
INSERT INTO category VALUES(NULL, '悬疑');
INSERT INTO category VALUES(NULL, '恐怖');
INSERT INTO category VALUES(NULL, '科幻');
INSERT INTO category VALUES(NULL, '战争');
INSERT INTO category VALUES(NULL, '爱情');
INSERT INTO category VALUES(NULL, '灾难');

INSERT INTO film VALUES(NULL, '天下无贼','冯小刚',50,'2008-12-12',1);
INSERT INTO film VALUES(NULL, '功夫','周星驰',150,'2009-12-12',2);
INSERT INTO film VALUES(NULL, '大话西游','周星驰',20,'2012-3-12',3);
INSERT INTO film VALUES(NULL, '我不是潘金莲','冯小刚',30,'2007-5-31',1);
INSERT INTO film VALUES(NULL, '道士下山','陈凯歌',40,'2004-8-9',8);
INSERT INTO film VALUES(NULL, '火锅英雄','陈凯歌',60,'2011-11-11',7);
INSERT INTO film VALUES(NULL, '寻龙诀','冯小刚',100,'2007-7-7',7);
INSERT INTO film VALUES(NULL, '老炮儿','陈凯歌',80,'2005-9-2',1);
INSERT INTO film VALUES(NULL, '我是证人','周星驰',90,'2010-10-5',2);
INSERT INTO film VALUES(NULL, '叶问','冯小刚',120,'2012-6-3',3);

INSERT INTO USER VALUES(NULL,'刘欢','1950-1-1','男','北大街','13312345678');
INSERT INTO USER VALUES(NULL,'张学友','1955-2-3','男','南大街','13312345676');
INSERT INTO USER VALUES(NULL,'刘嘉玲','1970-11-21','女','北大街','13312345675');
INSERT INTO USER VALUES(NULL,'李嘉欣','1988-9-3','女','南大街','13312345673');
INSERT INTO USER VALUES(NULL,'刘德华','1953-2-11','男','北大街','13312345672');
INSERT INTO USER VALUES(NULL,'张国立','1999-12-31','男','东大街','13312345671');
INSERT INTO USER VALUES(NULL,'张国荣','1988-3-23','男','西大街','13312345670');
INSERT INTO USER VALUES(NULL,'刘建国','1970-6-22','男','西大街','13312345679');

INSERT INTO user_category VALUES(1,2);
INSERT INTO user_category VALUES(1,3);
INSERT INTO user_category VALUES(2,8);
INSERT INTO user_category VALUES(3,1);
INSERT INTO user_category VALUES(3,5);
INSERT INTO user_category VALUES(3,7);
INSERT INTO user_category VALUES(2,1);
INSERT INTO user_category VALUES(1,7);
INSERT INTO user_category VALUES(8,8);
INSERT INTO user_category VALUES(8,7);
INSERT INTO user_category VALUES(5,7);
INSERT INTO user_category VALUES(5,3);
INSERT INTO user_category VALUES(2,6);
INSERT INTO user_category VALUES(7,1);
INSERT INTO user_category VALUES(7,2);
INSERT INTO user_category VALUES(7,3);

INSERT INTO emp VALUES(NULL, '郭靖', '男', '2002-2-3',2500,'东大街');
INSERT INTO emp VALUES(NULL, '黄蓉', '女', '2003-12-3',5500,'东大街');
INSERT INTO emp VALUES(NULL, '杨幂', '女', '2002-2-8',8500,'西大街');
INSERT INTO emp VALUES(NULL, '刘诗诗', '女', '2004-4-12',6500,'南大街');

INSERT INTO sal_grade VALUES(NULL, 1000, 2000);
INSERT INTO sal_grade VALUES(NULL, 2001, 4000);
INSERT INTO sal_grade VALUES(NULL, 4001, 5000);
INSERT INTO sal_grade VALUES(NULL, 5001, 7000);
INSERT INTO sal_grade VALUES(NULL, 7001, 9000);

INSERT INTO orders VALUES(1,2,10,1,'2016-11-11');
INSERT INTO orders VALUES(2,3,8,2,'2016-2-21');
INSERT INTO orders VALUES(3,7,10,1,'2016-3-21');
INSERT INTO orders VALUES(1,1,7,1,'2016-10-15');
INSERT INTO orders VALUES(1,8,3,1,'2016-2-17');
INSERT INTO orders VALUES(1,7,1,1,'2016-5-18');
INSERT INTO orders VALUES(4,1,1,1,'2016-5-7');
INSERT INTO orders VALUES(4,2,1,1,'2016-5-9');
INSERT INTO orders VALUES(4,3,1,1,'2016-11-10');
INSERT INTO orders VALUES(3,5,10,1,'2016-5-11');
INSERT INTO orders VALUES(2,1,1,1,'2016-7-12');
INSERT INTO orders VALUES(2,1,1,2,'2016-7-13');
INSERT INTO orders VALUES(2,1,1,3,'2016-7-14');
INSERT INTO orders VALUES(2,1,9,5,'2016-8-19');
INSERT INTO orders VALUES(2,1,8,3,'2016-8-4');
INSERT INTO orders VALUES(2,2,5,1,'2016-8-6');
INSERT INTO orders VALUES(2,2,6,1,'2016-1-22');
INSERT INTO orders VALUES(2,2,1,1,'2016-1-11');
INSERT INTO orders VALUES(2,6,3,1,'2016-2-17');
INSERT INTO orders VALUES(2,6,8,2,'2016-3-12');


#1查询价格比2号类型所有电影平均价还低的电影
select fname from film where price < (select avg(price) from category ca join film fi on ca.cid = fi.cid where ca.cid = 2)
#2查询张学友喜欢的类型中所有电影的最高价
select max(price) from USER us join user_category uc on us.uid = uc.uid join category ca on uc.cid = ca.cid join film on ca.cid = film.cid where uname = '张学友'
#3查询所有电影，以及电影对应的类型名，要求显示出所有类型名(mysql没有完全外连接
select * from film fi left join category ca on ca.cid = fi.cid
#4查询价格大于天下无贼的电影中，每部类型各多少电影
select ca.cid,count(*) from film fi join category ca on ca.cid = fi.cid where price > (select price from film where fname = '天下无贼') group by ca.cid 
#5查询那些员工给那些会员卖了哪些电影
select ename,uname,fname from emp join orders ord on emp.eid=ord.eid join USER us on us.uid = ord.uid join film fi on ord.fid = fi.fid 
#6查询有回头客的员工
select distinct ename from (select ord.uid,count(*) from orders ord join emp em on ord.eid = em.eid  group by ord.uid having count(*)>1 ) li join orders ord on ord.uid=li.uid join emp em on ord.eid=em.eid
#7查询回头客超过一个的员工（表子查询在mysql中必须起别名，否则报错，orcale中则不需要别名）
select distinct ename from (select ord.uid,count(*) from orders ord join emp em on ord.eid = em.eid  group by ord.uid having count(*)>1 ) li join orders ord on ord.uid=li.uid join emp em on ord.eid=em.eid


#8查询价格比所有喜剧类型的平均价还高的电影
select fname from film where price > (select avg(price) from category cate join film fi on cate.cid = fi.cid where cname = '喜剧' group by fi.cid)
#9查询电影所属类型的平均价（相关子查询）
select cname,fi.cid,avg(price) from category cate join film fi on cate.cid = fi.cid group by fi.cid
#10查询价格比1号类型所有电影价格都高的电影
select fname from film where price > all (select price from film where cid = 1)
#11查询上映日期比天下无贼晚的电影中，每个导演各多少部电影
select director,count(*) from film where showtime > (select showtime from film where fname = '天下无贼') group by director
#12查询哪些用户都喜欢哪些类型
select distinct uname,cname from USER us join orders ord on us.uid = ord.uid join film fi on ord.fid=fi.fid join category cate on cate.cid=fi.cid
#13查询喜欢类型超过2种的用户
select uname from (select distinct uname,cname,ord.uid from USER us join orders ord on us.uid = ord.uid join film fi on ord.fid=fi.fid join category cate on cate.cid=fi.cid) uc join orders ord on uc.uid = ord.uid group by uname having count(*) >2
#14查询从来没有被喜欢过的类型
select cname from category where cname not in (select cname from USER us join orders ord on us.uid = ord.uid join film fi on ord.fid=fi.fid join category cate on cate.cid=fi.cid)
#15查询喜欢了所有类型的用户
-- select cname from category where cname in all(select cname from USER us join orders ord on us.uid = ord.uid join film fi on ord.fid=fi.fid join category cate on cate.cid=fi.cid)
-- 
#16查询每个销售人员的销售总额
-- select sum(price) from orders ord join emp em on ord.eid = em.eid join film fi on ord.fid = fi.fid group by ord.eid  
-- 
#17查询每个电影各被卖出多少张
select fname,count(*) from orders ord join film fi on ord.fid = fi.fid group by ord.fid
#18查询上映日期比周星驰导演所有电影都晚的电影中，每种类型电影的最低价
select cname,min(price) from category cate join film fi on cate.cid = fi.cid  where fid in (select fid from film where showtime > all(select showtime from film where director = '周星驰')) group by cate.cid
#19查询在闰年上映的电影
select fname from film where year(showtime) % 4 = 0 and year(showtime)%100!=0 or year(showtime)%400=0
#20查询上映日期中，月份比日期大的电影
select fname from film where month(showtime) > day(showtime)

#21查询价格与类型都与‘天下无贼’相同的电影
select fname from film fi join category cate on fi.cid = cate.cid where price = (select price from film where fname = '天下无贼') and cname = (select cname from film where fname = '天下无贼')
#22查询最受欢迎的类型
select cname,sum(num) he from category cate join film fi on cate.cid = fi.cid join orders ord on ord.fid = fi.fid group by ord.fid
-- #23查询每个用户各花了多少钱
-- select num*price from film fi join orders ord on fi.fid = ord.fid join USER us on us.uid = ord.uid group by uname 