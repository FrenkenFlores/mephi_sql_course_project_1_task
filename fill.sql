insert into countries (short_name, full_name, region) values
('RUS', 'Россия', 'Европа'),
('BRA', 'Бразилия', 'Южная и Латинская Америка'),
('ESP', 'Испания', 'Европа'),
('ARG', 'Аргентина', 'Южная и Латинская Америка'),
('JPN', 'Япония', 'Азия');

insert into clubs (short_name, full_name) values
('RMA', 'Реал Мадрид'),
('FCB', 'Барселона'),
('ZEN', 'Зенит');

insert into roles (name) values
('Вратарь'),
('Защитник'),
('Полузащитник'),
('Нападающий');

insert into players (first_name, last_name, born_date, country_id) values
('Винисиус', 'Жуниор', '2000-07-12', 2),
('Джуд', 'Беллингем', '2003-06-29', 3),
('Лионель', 'Месси', '1987-06-24', 4),
('Александр', 'Головин', '1996-05-30', 1),
('Такефуса', 'Кубо', '2001-06-04', 5),
('Тибо', 'Куртуа', '1992-05-11', 3),
('Педри', 'Гонсалес', '2002-11-25', 3),
('Игорь', 'Акинфеев', '1986-04-08', 1);

insert into commands (club_id, country_id) values
(1, null),
(2, null),
(3, null),
(null, 2),
(null, 4);

insert into command_players (command_id, player_id, role_id) values
(1, 1, 4),
(1, 2, 3),
(1, 6, 1),
(2, 7, 3),
(3, 4, 3),
(3, 8, 1),
(4, 1, 4),
(5, 3, 4);

insert into games (command_a_id, command_b_id, day, time, location, level) values
(1, 2, '2026-05-10', '21:00:00', 'Сантьяго Бернабеу, Мадрид', 'Лига Чемпионов'),
(4, 5, '2026-06-15', '19:30:00', 'Маракана, Рио-де-Жанейро', 'Чемпионат Мира'),
(3, 1, '2026-07-02', '18:00:00', 'Газпром Арена, Санкт-Петербург', 'Товарищеский матч');

insert into game_results (game_id, command_id, goals_score, penalty_score) values
(1, 1, 2, null),
(1, 2, 1, null),
(2, 4, 1, 4),
(2, 5, 1, 5),
(3, 3, 0, null),
(3, 1, 3, null);
