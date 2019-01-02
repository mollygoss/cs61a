create table parents as
  select "abraham" as parent, "barack" as child union
  select "abraham"          , "clinton"         union
  select "delano"           , "herbert"         union
  select "fillmore"         , "abraham"         union
  select "fillmore"         , "delano"          union
  select "fillmore"         , "grover"          union
  select "eisenhower"       , "fillmore";

create table dogs as
  select "abraham" as name, "long" as fur, 26 as height union
  select "barack"         , "short"      , 52           union
  select "clinton"        , "long"       , 47           union
  select "delano"         , "long"       , 46           union
  select "eisenhower"     , "short"      , 35           union
  select "fillmore"       , "curly"      , 32           union
  select "grover"         , "short"      , 28           union
  select "herbert"        , "curly"      , 31;

create table sizes as
  select "toy" as size, 24 as min, 28 as max union
  select "mini",        28,        35        union
  select "medium",      35,        45        union
  select "standard",    45,        60;

-------------------------------------------------------------
-- PLEASE DO NOT CHANGE ANY SQL STATEMENTS ABOVE THIS LINE --
-------------------------------------------------------------

-- The size of each dog
create table size_of_dogs as
  select d.name, s.size FROM dogs AS d, sizes AS s
  WHERE d.height > s.min AND d.height <= s.max;

-- All dogs with parents ordered by decreasing height of their parent
create table by_height as
  select p.child FROM dogs AS d, parents AS p WHERE d.name = p.parent ORDER BY d.height DESC;

-- Sentences about siblings that are the same size
create table sentences as
  with siblings(first, second) as (
    select a.child, b.child FROM parents as a, parents as b
    WHERE a.parent = b.parent AND a.child < b.child
  )
  select s.first || ' and ' || s.second || ' are ' || x.size || ' siblings'
  FROM siblings AS s, size_of_dogs AS x, size_of_dogs AS y WHERE s.first = x.name
  AND s.second = y.name AND x.size = y.size;

-- Ways to stack 4 dogs to a height of at least 170, ordered by total height
create table stacks as
  with stack_builder(dogs, curr, total, n) as (
    select d.name, d.height, d.height, 1 FROM dogs AS d union
    select sb.dogs || ', ' || d.name, d.height, sb.total + d.height, n + 1
    FROM stack_builder AS sb, dogs AS d
    WHERE curr < d.height AND curr <> d.height AND n < 4
  )
  select dogs, total FROM stack_builder WHERE total > 170 ORDER BY total;

-- Heights and names of dogs that are above average in height among
-- dogs whose height has the same first digit.
create table above_average as
  with avrgs(class, val) as (
    select (height - height % 10) / 10, avg(height) FROM dogs GROUP BY (height - height % 10) / 10
  )
  select d.height, d.name FROM dogs AS d, avrgs AS a WHERE
  ((d.height - d.height % 10) / 10) = a.class AND d.height > a.val;

-- All non-parent relations ordered by height difference
-- create table non_parents as
  -- select d.name, dg.name FROM dogs AS d, dogs AS dg, parents AS p, parents AS pa WHERE
  -- d.name = p.parent OR d.name = p.child AND dg.name = pa.parent OR dg.name = pa.child
  -- p.parent = pa.child OR p.child = pa.parent AND d.name != dg.name ORDER BY d.height - dg.height;

create table ints as
    with i(n) as (
        select 1 union
        select n+1 from i limit 100
    )
    select n from i;

-- Question 1: Composites --
create table composites as
   select distinct a.n * b.n as c FROM ints AS a, ints AS b WHERE c <= 100 and a.n < c and b.n < c;

create table multiples as
   select c as m from composites union all select n from ints;

-- Question 2: Primes --
create table primes as
   select m as p from multiples where p > 1 group by m having count(*) = 1;
