-- 1. 查询" 01 "课程比" 02 "课程成绩高的学生的信息及课程分数
select * from sc sc1 join (select sid,score from sc where cid = '02') sc2 on sc1.sid = sc2.sid where sc1.cid = '01' and sc1.score > sc2.score;
-- 1.1 查询同时存在" 01 "课程和" 02 "课程的情况
select * from sc sc1 join (select sid,cid,score from sc where cid = '02') sc2 on sc1.sid = sc2.sid where sc1.cid = '01';
-- 1.2 查询存在" 01 "课程但可能不存在" 02 "课程的情况(不存在时显示为 null )
select * from sc sc1 left join (select sid,cid,score from sc where cid = '02') sc2 on sc1.sid = sc2.sid where sc1.cid = '01';
-- 1.3 查询不存在" 01 "课程但存在" 02 "课程的情况
select * from sc where sid not in (select sid from sc where cid = '01') and sid in (select sid from sc where cid = '02');
-- 2. 查询平均成绩大于等于 60 分的同学的学生编号和学生姓名和平均成绩
select * from student s join (select sid,avg(score) avgs from sc group by sid having avg(score) >= 60) sc on s.sid = sc.sid
-- 3. 查询在 SC 表存在成绩的学生信息
select * from student where sid in (select DISTINCT sid from sc where score is not null);
-- 4. 查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩(没成绩的显示为 null )
select * from student s left join (select sid,count(*),sum(score) from sc group by sid) sc on s.sid = sc.sid;
-- 4.1 查有成绩的学生信息
-- 5. 查询「李」姓老师的数量
select count(*) from teacher where tname like '李%';
-- 6. 查询学过「张三」老师授课的同学的信息
select s.* from student s join sc on s.sid = sc.sid join course c on sc.cid = c.cid join teacher t on c.tid = t.tid where t.tname = '张三'
-- 7. 查询没有学全所有课程的同学的信息
select sid,count(*) from sc group by sid having count(*) = (select count(*) from course)
-- 8. 查询至少有一门课与学号为" 01 "的同学所学相同的同学的信息
select * from sc where cid in (select cid from sc where sid = '01') and sid != '01'
-- 9. 查询和" 01 "号的同学学习的课程 完全相同的其他同学的信息
select * from student where sid not in (select distinct t1.sid from (select student.sid,t.cid from student,(select sid,cid from sc where sid = '01') t) t1 left join sc sc on t1.sid = sc.sid and t1.cid = sc.cid where sc.sid is null)

select *
from student 
where student.SId not in (
select t1.SId
from 
(select student.SId,t.CId
from student ,(select sc.CId from sc where sc.SId='01') as t )as t1 
left join sc on t1.SId=sc.SId and t1.CId=sc.CId
where sc.CId is null )
and student.SId !='01'

select * from student where SId in (select distinct SId from sc where SId not in (select distinct SId from sc where CId not in (select CId from sc where SId = "01")) group by SId having count(CId) = (select count(CId) from sc where SId = "01") and SId !='01')
-- 10. 查询没学过"张三"老师讲授的任一门课程的学生姓名
select * from student s where s.sid not in (select s.sid from student s join sc on s.sid = sc.sid join course c on sc.cid = c.cid join teacher t on c.tid = t.tid where t.tname = '张三')
-- 11. 查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select * from student s join (select sid,count(*),avg(score) from sc where score < 60 group by sid having count(*) >= 2) sc on s.sid = sc.sid;
-- 12. 检索" 01 "课程分数小于 60，按分数降序排列的学生信息
select * from student s join sc on s.sid = sc.sid where sc.score <= 60 and sc.cid = '01' order by score desc;
-- 13. 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
select sc1.sid,score,avgs from sc sc1 join (select sid,avg(score) avgs from sc group by sid) sc2 on sc1.sid = sc2.sid order by avgs
-- 14. 查询各科成绩最高分、最低分和平均分：
-- 以如下形式显示：课程 ID，课程 name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
-- 及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
-- 要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
select sc.cid 课程编号,c.cname 课程名称,max(score) 最高分,min(score) 最低分,avg(score) 平均分,count(*) 选修人数,concat(round((sum(case when score >= 60 then 1 else 0 end) / count(*)) * 100,2),'%') 及格率,concat(round((sum(case when score >= 70 and score < 80 then 1 else 0 end) / count(*)) * 100,2),'%') 中等率,concat(round((sum(case when score >= 80 and score < 90 then 1 else 0 end) / count(*)) * 100,2),'%') 优良率, concat(round((sum(case when score >= 90 then 1 else 0 end) / count(*)) * 100,2),'%') 优秀率 from sc join course c on c.cid = sc.cid group by c.cid,c.cname
-- 17. 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比

-- 18. 查询各科成绩前三名的记录
select cid,max(score) from sc group by cid

select * from sc where (select count(*) from sc a where sc.score < a.score and sc.CId = a.CId) < 3 ORDER BY CId asc,sc.score desc

select count(*) from sc join sc a on sc.cid = a.cid and sc.score < a.score;
-- 19. 查询每门课程被选修的学生数
select cid,count(*) from sc group by cid
-- 20. 查询出只选修两门课程的学生学号和姓名
select * from student where sid in (select sid from sc group by sid having count(*) = 2);
-- 21. 查询男生、女生人数
select ssex,count(*) from student group by ssex;
-- 22. 查询名字中含有「风」字的学生信息
select * from student where sname like '%风%'
-- 23. 查询同名同性学生名单，并统计同名人数
select * from student s join (select s1.sid,count(s1.sid) from student s1,student s2 where s1.sname = s2.sname and s1.ssex = s2.ssex and s1.sid != s2.sid group by s1.sid) stu on s.sid = stu.sid

select * from student s join (select sname,ssex from student group by sname,ssex having count(*) > 1) stu on s.sname = stu.sname and s.ssex = stu.ssex;
-- 24. 查询 1990 年出生的学生名单
select * from student where year(sage) = '1990'
-- 25. 查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
select cid,avg(score) avgs from sc group by cid order by avgs desc,cid;
-- 26. 查询平均成绩大于等于 85 的所有学生的学号、姓名和平均成绩
select * from student s join (select sid,avg(score) avgs from sc group by sid having avg(score) >= 85) sc on s.sid = sc.sid
-- 27. 查询课程名称为「数学」，且分数低于 60 的学生姓名和分数
select * from sc join student s on sc.sid = s.sid where cid = (select cid from course where cname = '数学') and score < 60
-- 28. 查询所有学生的课程及分数情况（存在学生没成绩，没选课的情况）
select * from student s left join sc on s.sid = sc.sid left join course c on sc.cid = c.cid;
-- 29. 查询任何一门课程成绩在 70 分以上的姓名、课程名称和分数
select * from student s join sc on s.sid = sc.sid join course c on sc.cid = c.cid where s.sid in (select DISTINCT sid from sc where score >= 70)
-- 30. 查询不及格的课程
select * from course where cid in (select distinct cid from sc where score < 60)
-- 31. 查询课程编号为 01 且课程成绩在 80 分以上的学生的学号和姓名
select * from sc join student s on s.sid = sc.sid where cid = '01' and score > 80
-- 32. 求每门课程的学生人数

-- 33. 成绩不重复，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
select * from sc join course c on sc.cid = c.cid join student s on sc.sid = s.sid where c.tid in (select tid from teacher where tname = '张三') limit 1
-- 34. 成绩有重复的情况下，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
select * from sc join student s on sc.sid = s.sid join (select sc.cid,max(score) score from sc join course c on sc.cid = c.cid join teacher t on t.tid = c.tid where tname = '张三' group by sc.cid) temp on temp.cid = sc.cid and sc.score = temp.score;
-- 35. 查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩
select sc1.sid,sc1.cid from sc sc1,sc sc2 where sc1.score = sc2.score and sc1.sid != sc2.sid and sc1.cid != sc2.cid group by sc1.sid,sc1.cid;

select * from sc sc1,sc sc2 where sc1.score = sc2.score and sc1.sid != sc2.sid and sc1.cid != sc2.cid 

select sc1.sid,sc1.cid from sc sc1,sc sc2 where sc1.score = sc2.score  and sc1.cid != sc2.cid group by sc1.sid,sc1.cid;
select sc2.sid,sc2.cid from sc sc1,sc sc2 where sc1.score = sc2.score  and sc1.cid != sc2.cid group by sc2.sid,sc2.cid;
-- 36. 查询每门功成绩最好的前两名
select * from sc where (select count(*) from sc a where sc.score < a.score and sc.CId = a.CId) < 2 ORDER BY CId asc,sc.score desc
-- 37. 统计每门课程的学生选修人数（超过 5 人的课程才统计）。
select cid,count(*) from sc group by cid having count(*) > 5
-- 38. 检索至少选修两门课程的学生学号
select sid from sc group by sid having count(*) >= 2
-- 39. 查询选修了全部课程的学生信息
select sid from sc group by sid having count(*) = (select count(*) from course)
-- 40. 查询各学生的年龄，只按年份来算
select year(now())-year(sage) from student
-- 41. 按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一

-- 42. 查询本周过生日的学生
select * from student where week(now()) = week(sage)
-- 43. 查询下周过生日的学生
select * from student where week(ADDDATE(now(),INTERVAL 1 WEEK)) = week(sage)
-- 44. 查询本月过生日的学生
select * from student where month(now()) = month(sage)
-- 45. 查询下月过生日的学生
select * from student where month(ADDDATE(now(),INTERVAL 1 month)) = month(sage)