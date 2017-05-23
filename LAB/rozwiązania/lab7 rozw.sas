data pracownik;
do id = 1 to 100;
dzial = ((1<>abs(floor(rannor(10) * 4)))><5);
nazwisko = put(md5(id),$hex32.);
output;
end;
run;

data place;
do id = 1 to 100;
data = today() - floor(ranuni(10)*60);
dochod = 2000 + round(abs(rannor(10) * 10000),0.01);
output;
data = today() - (300 + floor(ranuni(10)*60));
dochod = 2000 + round(abs(rannor(10) * 8000),0.01);
output;
end;
run;

data dzial;
infile cards;
input dzial nazwa $ 50.;
cards;
1 Blacharnia
2 Magazyn
3 Mechanika
4 Kadry
5 Lakiernia
;
run;







/* idea rozwiazania: self-join z warunkiem nierownosciowym w ramach grup */
data x; /* zbior pomocniczy */
do group = 1 to 5;
    do i=1 to 10;
        id = group*100 + i ;
        x = round(100 + rannor(1) * 10, 0.01);
        output;
        id = group*100 + i + 500;
        output;
    end;
end;
run;
proc sql; /* rozwiazanie */
create table y1 as
select group, id, x , (maxxx - j)+1 as orderer
from
    (
    select *, max(j) as maxxx
    from
        (
        select distinct x1.*, count(*) as j
        from
        x as x1,
        x as x2
        where
        x1.group = x2.group
        and
        x1.x > x2.x
        group by x1.group, x1.id
        )
    group by x1.group
    )
having calculated orderer <= 3
order by group, orderer
;
quit;
















proc sql;
create view w1 as 
(
select distinct pl.id, pr.nazwisko, pr.dzial, avg(dochod) as average 
from place as pl,
     pracownik as pr
where pl.id = pr.id
group by pl.id, pr.dzial
)
;


create table xxxx1 as
select x1.*
        from
        w1 as x1,
        w1 as x2
        where
        x1.dzial = x2.dzial
        and
        x1.average > x2.average
;
create table xxxx2 as
select distinct x1.*, count(*) as j
        from
        w1 as x1,
        w1 as x2
        where
        x1.dzial = x2.dzial
        and
        x1.average > x2.average
        group by x1.dzial, x1.id
;


create view w2 as
select t2.nazwa, t1.id, t1.nazwisko, t1.average , (t1.maxxx - t1.j)+1 as orderer
from
    (
    select *, max(j) as maxxx
    from
        (
        select distinct x1.*, count(*) as j
        from
        w1 as x1,
        w1 as x2
        where
        x1.dzial = x2.dzial
        and
        x1.average > x2.average
        group by x1.dzial, x1.id
        )
    group by x1.dzial
    ) as t1,
dzial as t2
where t1.dzial = t2.dzial
having calculated orderer between 1 and 3
order by t2.nazwa, orderer
;


quit;




/* inne podejscie podzapytane skorelowane 
kod Natalia Œcieszko */
proc sql;
create view dane_a as
select  id, nazwisko, dzial, sred 
from 
(
select 
distinct a.id, nazwisko, c.dzial, avg(dochod) as sred 
from place a
join pracownik b on a.id=b.id
join dzial c on c.dzial=b.dzial
group by b.id
)
order by dzial, sred desc;

create view view_1 as
select dzial, id, nazwisko, sred as srednia_brutto, put(today(),date10.) as data_gen_zest 
from
(
select id, nazwisko, dzial, sred, 
(select count(distinct id)+1 from dane_a b where b.sred>a.sred and a.dzial=b.dzial) as rank

from dane_a a
having calculated rank < 4
)
;
quit;
