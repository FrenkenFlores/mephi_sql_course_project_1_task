/*
Евлоев Сайфуддин Магомедович
Вариант 26
Выберите матчи (все поля таблицы), в которых разница в забитых мячах превысила 
5 голов и отсортируйте результат по времени их проведения в обратном порядке. 
Выберите команду (или команды, если их несколько), выигравшие 
наибольшее число раз. 
*/

select
	games.*
from games
join game_results as gr_a on
	gr_a.game_id = games.game_id and
	gr_a.command_id = games.command_a_id
join game_results as gr_b on
	gr_b.game_id = games.game_id and
	gr_b.command_id = games.command_b_id
where abs(gr_a.goals_score - gr_b.goals_score) > 5
order by games.day desc, games.time desc;


select
	c.*
from
	commands as c
join
	game_results as g_a on
		g_a.command_id = c.command_id
join
	game_results as g_b on
		g_b.command_id != c.command_id and
		g_b.command_id != g_a.command_id
where
	g_a.game_id = g_b.game_id and g_a.goals_score > g_b.goals_score
group by c.command_id
having count(c.*) = (
	select max(count_agregation.wins) from (
		select
			count(c.*) as wins
		from
			commands as c
		join
			game_results as g_a on g_a.command_id = c.command_id
		join
			game_results as g_b on g_b.command_id != c.command_id
		where
			g_a.game_id = g_b.game_id and g_a.goals_score > g_b.goals_score
		group by c.command_id
	) as count_agregation
);
