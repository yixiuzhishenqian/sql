-- 1. 查询" 01 "课程比" 02 "课程成绩高的学生的信息及课程分数
select s.sid,s.sname,sc.cid1,sc.score1,sc.cid2,sc.score2 from Student s join (select sc1.sid sid,sc1.score score1,sc2.score score2,sc1.cid cid1,sc2.cid cid2 from SC sc1 join SC sc2 on sc1.cid = '01' and sc2.cid = '02' and sc1.score > sc2.score and sc1.sid = sc2.sid) sc on s.sid = sc.sid;
-- 1.1 查询同时存在" 01 "课程和" 02 "课程的情况
select s.sid,s.sname,sc.cid1,sc.score1,sc.cid2,sc.score2 from Student s join (select sc1.sid sid,sc1.score score1,sc2.score score2,sc1.cid cid1,sc2.cid cid2 from SC sc1 join SC sc2 on sc1.cid = '01' and sc2.cid = '02' and sc1.sid = sc2.sid) sc on s.sid = sc.sid;
-- 1.2 查询存在" 01 "课程但可能不存在" 02 "课程的情况(不存在时显示为 null )
select * from SC sc1 left join 
(select sc1.sid from SC sc1 join SC sc2 on sc1.cid = '01' and sc2.cid = '02' and sc1.sid = sc2.sid) sc2 on sc1.sid = sc2.sid  where cid = '01' 
-- 1.3 查询不存在" 01 "课程但存在" 02 "课程的情况
select * from SC where sid not in (select sc1.sid from SC sc1 join SC sc2 on sc1.cid = '01' and sc2.cid = '02' and sc1.sid = sc2.sid) and cid = '02'
-- 2. 查询平均成绩大于等于 60 分的同学的学生编号和学生姓名和平均成绩
select s.*,sc.ascore from Student s join (select sid,avg(score) ascore from SC group by sid having ascore >= 60) sc on s.sid = sc.sid;
-- 3. 查询在 SC 表存在成绩的学生信息
select * from Student where sid in (select DISTINCT sid from SC where score is not null);
-- 4. 查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩(没成绩的显示为 null )
select s.*,sc.sscore,sc.cou from Student s left join (select sid,sum(score) sscore,count(score) cou from SC group by sid) sc on s.sid = sc.sid;
-- 4.1 查有成绩的学生信息
select * from Student where sid in (select DISTINCT sid from SC where score is not null);
-- 5. 查询「李」姓老师的数量
select count(*) from Teacher where tname like '李%';
-- 6. 查询学过「张三」老师授课的同学的信息
select * from Student s join SC sc on s.sid = sc.sid and sc.cid in (select cid from Teacher t join Course c on t.tid = c.tid and t.tname = '张三');
-- 7. 查询没有学全所有课程的同学的信息
(select sid from SC group by sid having count(cid) < (select count(*) from Course))
-- 8. 查询至少有一门课与学号为" 01 "的同学所学相同的同学的信息
(select distinct sid from SC where cid in (select cid from SC where sid = '01') and sid != '01')
-- 9. 查询和" 01 "号的同学学习的课程 完全相同的其他同学的信息
select * from Student where sid not in (select distinct t1.sid from (select Student.sid,t.cid from Student,(select sid,cid from SC where sid = '01') t) t1 left join SC sc on t1.sid = sc.sid and t1.cid = sc.cid where sc.sid is null)

select * from Student where SId in (select distinct SId from SC where SId not in (select distinct SId from SC where CId not in (select CId from SC where SId = "01")) group by SId having count(CId) = (select count(CId) from SC where SId = "01") and SId !='01')
-- 10. 查询没学过"张三"老师讲授的任一门课程的学生姓名
select * from Student s where s.sid not in (select sid from SC sc where sc.cid in (select cid from Teacher t join Course c on t.tid = c.tid and t.tname = '张三'));
-- 11. 查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select * from Student s join (select sid,avg(score) from SC where score < 60 group by sid having count(*) > 1) sc on s.sid = sc.sid;
-- 12. 检索" 01 "课程分数小于 60，按分数降序排列的学生信息
select * from SC sc join Student s on sc.sid = s.sid where cid = '01' and score < 60 order by score desc;
-- 13. 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
select sc1.*,sc2.ascore from SC sc1 join (select sid,avg(score) ascore from SC group by sid) sc2 on sc1.sid = sc2.sid order by sc2.ascore desc
-- 14. 查询各科成绩最高分、最低分和平均分：
-- 以如下形式显示：课程 ID，课程 name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
-- 及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
-- 要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
select cid,count(*),max(score),min(score),avg(score),concat(round(sum(case when score >= 60 then 1 else 0 end)/count(*) * 100,2),'%') 及格率,concat(round(sum(case when score >= 70 and score < 80 then 1 else 0 end)/count(*) * 100,2),'%') 中等率,concat(round(sum(case when score >= 80 and score < 90 then 1 else 0 end)/count(*) * 100,2),'%') 优良率,concat(round(sum(case when score >= 80 and score < 90 then 1 else 0 end)/count(*) * 100,2),'%') 优秀率 from SC group by cid order by count(*) desc,cid;
-- 15. 按各科成绩进行排序，并显示排名， Score 重复时保留名次空缺
select sc.SId,sc.CId ,case when @pre_parent_code=sc.CId then @curRank:=@curRank+1 when @pre_parent_code:=sc.CId then  @curRank:=1  end as rank,sc.score from (select @curRank:=0,@pre_parent_code:='') as t ,SC sc ORDER by sc.CId,sc.score desc;
-- 15.1 按各科成绩进行排序，并显示排名， Score 重复时合并名次
select sc.SId,sc.CId, CASE when @pre_parent_code=sc.CId then (case when @prefontscore=sc.score then @curRank when @prefontscore:=sc.score then @curRank:=@curRank+1 end ) when  @prefontscore:=sc.score then  @curRank:=1 end as rank ,sc.score,@pre_parent_code:=sc.CId from (select @curRank:=0,@pre_parent_code:='',@prefontscore :=null) as t ,SC sc ORDER by sc.CId,sc.score desc;
-- 16. 查询学生的总成绩，并进行排名，总分重复时保留名次空缺
select t1.*,@currank:= @currank+1 as rank
from (select sc.SId, sum(score)
from SC sc
GROUP BY sc.SId 
ORDER BY sum(score) desc) as t1,(select @currank:=0) as t
-- 16.1 查询学生的总成绩，并进行排名，总分重复时不保留名次空缺
SELECT
	t1.*,
CASE
		WHEN @fontscore = t1.sumscore THEN
		@currank 
		WHEN @fontscore := t1.sumscore THEN
		@currank := @currank + 1 
	END AS rank 
FROM
	( SELECT sc.SId, sum( score ) AS sumscore FROM SC sc GROUP BY sc.SId ORDER BY sum( score ) DESC ) AS t1,(
	SELECT
		@currank := 0,
		@fontscore := NULL 
	) AS t
-- 17. 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比
select * from Course c join (select sc.cid,sum(case when (score <= 100 and score >= 85) then 1 else 0 end),sum(case when (score < 85 and score >= 70) then 1 else 0 end),sum(case when (score < 70 and score >= 60) then 1 else 0 end),sum(case when (score < 60 and score >= 0) then 1 else 0 end) from SC sc group by sc.cid) sc on c.cid = sc.cid;
-- 18. 查询各科成绩前三名的记录
select * from SC sc where (select count(*) from SC as a where sc.CId =a.CId and sc.score < a.score ) < 3 ORDER BY CId asc,sc.score desc
-- 19. 查询每门课程被选修的学生数
select count(sid) from SC group by cid 
-- 20. 查询出只选修两门课程的学生学号和姓名
select * from Student s join (select sid from SC group by sid having count(*) = 2) sc on s.sid = sc.sid;
-- 21. 查询男生、女生人数
select ssex,count(*) from Student group by ssex;
-- 22. 查询名字中含有「风」字的学生信息
select * from Student where sname like '%风%';
-- 23. 查询同名同性学生名单，并统计同名人数
select s1.sid,count(s1.sid) from Student s1 join Student s2 on s1.sname = s2.sname and s1.sid != s2.sid group by s1.sid
-- 24. 查询 1990 年出生的学生名单
select * from Student where 1990 = year(sage)
-- 25. 查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
select cid,avg(score) from SC group by cid order by avg(score) desc,cid;
-- 26. 查询平均成绩大于等于 85 的所有学生的学号、姓名和平均成绩 
select * from Student where sid in (select sid from SC group by sid having avg(score) >= 85);
-- 27. 查询课程名称为「数学」，且分数低于 60 的学生姓名和分数
select * from Student where sid in (select sid from SC sc join Course c on sc.cid = c.cid where score < 60 and cname='数学');
-- 28. 查询所有学生的课程及分数情况（存在学生没成绩，没选课的情况）
select * from SC sc right join Student s on sc.sid = s.sid
-- 29. 查询任何一门课程成绩在 70 分以上的姓名、课程名称和分数
select * from Student s join (select * from SC where score > 70) sc on s.sid = sc.sid;
-- 30. 查询不及格的课程
select * from Course c join (select * from SC where score < 60) sc on c.cid = sc.cid;
-- 31. 查询课程编号为 01 且课程成绩在 80 分以上的学生的学号和姓名
select * from Student s join (select * from SC where score >= 80 and cid = '01') sc on s.sid = sc.sid;
-- 32. 求每门课程的学生人数
select count(sid) from SC group by cid 
-- 33. 成绩不重复，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩

-- 34. 成绩有重复的情况下，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
select * from SC where score = (select max(score) from SC sc where sc.cid in (select cid from Course c join Teacher t on c.tid = t.tid where tname = '张三')) and cid = (select cid from Course c join Teacher t on c.tid = t.tid where tname = '张三')
-- 35. 查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩
select * from SC sc1 join SC sc2 where sc1.cid != sc2.cid and sc1.score = sc2.score and sc1.sid != sc2.sid;

select * from SC as t1 where exists(select * from SC as t2 where t1.SId=t2.SId and t1.CId!=t2.CId and t1.score =t2.score )
-- 36. 查询每门功成绩最好的前两名
select * from SC sc where (select count(*) from SC as a where sc.CId =a.CId and sc.score < a.score ) < 2 ORDER BY CId asc,sc.score desc
-- 37. 统计每门课程的学生选修人数（超过 5 人的课程才统计）。
select cid,count(*) from SC group by cid having count(*) > 5;
-- 38. 检索至少选修两门课程的学生学号
select cid,count(*) from SC group by cid having count(*) >= 2;
-- 39. 查询选修了全部课程的学生信息
-- 40. 查询各学生的年龄，只按年份来算
select *,year(now())-year(sage) from Student;
-- 41. 按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一
select * , case when month(now()) >= month(sage) then year(now())-year(sage) else year(now())-year(sage)-1 end from Student
-- 42. 查询本周过生日的学生
select * from Student where WEEKOFYEAR(sage) = WEEKOFYEAR(now());
-- 43. 查询下周过生日的学生
-- 44. 查询本月过生日的学生
-- 45. 查询下月过生日的学生