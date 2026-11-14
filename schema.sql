drop table if exists countries cascade;
drop table if exists clubs cascade;
drop table if exists players cascade;
drop table if exists roles cascade;
drop table if exists commands cascade;
drop table if exists command_players cascade;
drop table if exists games cascade;
drop table if exists game_results cascade;

create table countries (
	country_id int generated always as identity,
	short_name varchar not null,
	full_name varchar not null,
	region varchar not null,
	
	constraint country_id_pk primary key(country_id),
	constraint region_check check(
		region in (
			'Азия',
			'Европа',
			'Африка',
			'Австралия и Океания',
			'Северная Америка',
			'Южная и Латинская Америка'
		)
	)
);

create table clubs(
	club_id int generated always as identity,
	short_name varchar not null,
	full_name varchar not null,
	
	constraint pk_club_id primary key(club_id)
);

create table players (
	player_id int generated always as identity,
	first_name varchar not null,
	last_name varchar not null,
	born_date date not null,
	country_id int not null,
	
	constraint player_id_pk primary key(player_id),
	constraint country_id_fk foreign key(
		country_id
	) references countries(country_id)
);

create table roles (
	role_id int generated always as identity,
	name varchar not null,
	
	constraint pk_role_id primary key(role_id)
);

create table commands(
	command_id int generated always as identity,
	club_id int,
	country_id int,
	
	constraint pk_command_player primary key(
		command_id
	),
	constraint fk_club_id foreign key(
		club_id
	) references clubs(club_id),
	constraint fk_country_id foreign key(
		country_id
	) references countries(country_id),
	constraint fk_parent_check check(
		club_id is not null and country_id is null or
		club_id is null and country_id is not null
	)
);

create table command_players(
	link_id int generated always as identity,
	command_id int not null,
	player_id int not null,
	role_id int not null,

	constraint pk_link_id primary key(link_id),
	constraint fk_command_id foreign key(
		command_id
	) references commands(command_id),
	constraint fk_player_id foreign key(
		player_id
	) references players(player_id),
	constraint fk_role_id foreign key(
		role_id
	) references roles(role_id)
);

create table games(
	game_id int generated always as identity,
	command_a_id int not null,
	command_b_id int not null,
	day date not null,
	time time not null,
	location varchar not null,
	level varchar not null,
	
	constraint pk_game_commands_ab primary key(
		game_id
	),
	constraint fk_command_a_id foreign key(
		command_a_id
	) references commands(command_id),
	constraint fk_command_b_id foreign key(
		command_b_id
	) references commands(command_id),
	constraint check_commands check(
		command_a_id != command_b_id		
	)
);

create table game_results(
	result_id int generated always as identity,
	game_id int not null,
	command_id int not null,
	goals_score int,
	penalty_score int,
	
	constraint pk_result_id primary key(result_id),
	constraint fk_game_id foreign key(
		game_id
	) references games(game_id),
	constraint fk_command_id foreign key(
		command_id
	) references commands(command_id)
);
