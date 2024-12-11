select game_id,team_id,player_id,count(1)
from game_details
group by 1,2,3
having count(1)>1;

with deduped as (
select
g.game_date_est,
gd.*,
g.season,
g.home_team_id,
row_number() over(partition by gd.game_id,team_id,player_id order by g.game_date_est)
from game_details gd
join games g on gd.game_id = g.game_id
)
 select
 game_date_est,
 season,
 team_id,
 start_position,
 coalesce(position('DNP' in comment),0)>0 as dim_did_not_play,
 coalesce(position('DND' in comment),0)>0 as dim_did_not_dress,
 coalesce(position('NWT'in comment),0)>0 as dim_not_with_team,
 cast(split_part(min,':',1) as real) + cast(split_part(min,':',2) as real)/60 as minutes,
 fgm,
 fga,
 fg3m,
 fg3a,
 ftm,
 fta,
 oreb,
 dreb,
 reb,
 ast,
 stl,
 blk,
 "TO" as turnovers,
 pf,
 pts,
 plus_minus
 from deduped where row_number=1;
 
create table fact_table_details(

);