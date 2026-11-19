drop table if exists countries cascade;
drop table if exists clubs cascade;
drop table if exists players cascade;
drop table if exists roles cascade;
drop table if exists commands cascade;
drop table if exists command_players cascade;
drop table if exists games cascade;
drop table if exists game_results cascade;
drop table if exists violations cascade;
drop table if exists goals cascade;

create table countries (
	country_id int generated always as identity,
	short_name varchar not null,
	full_name varchar not null,
	region varchar,
	
	constraint country_id_pk primary key(country_id),
	constraint chk_region check(
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
	
	constraint pk_role_id primary key(role_id),
	constraint uq_role_name unique(name)
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
	constraint chk_fk_parent check(
		club_id is not null and country_id is null or
		club_id is null and country_id is not null
	)
);

create table command_players(
	link_id int generated always as identity,
	command_id int not null,
	player_id int not null,
	player_number int not null,
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
	) references roles(role_id),
	constraint chk_player_number_positive check(player_number > 0),
	constraint uq_command_number unique(command_id, player_number)
);

create table games(
    game_id int generated always as identity,
    command_a_id int not null,
    command_b_id int not null,
    day date not null,
    time time not null,
    location varchar not null,
    level varchar not null,
    group_name varchar,

    constraint pk_game_commands_ab primary key(game_id),
    constraint fk_command_a_id foreign key(command_a_id)
        references commands(command_id),
    constraint fk_command_b_id foreign key(command_b_id)
        references commands(command_id),

    constraint chk_commands check(command_a_id != command_b_id),

    constraint chk_games_level check(
        level in (
            'групповой раунд',
            '1/8 финала',
            '¼ финала',
            'полуфинал',
            'финал',
            'игра за 3-е место'
        )
    ),

    constraint chk_games_group_name check(
        (level = 'групповой раунд'
            and group_name is not null
            and btrim(group_name) <> '')
        or
        (level <> 'групповой раунд'
            and group_name is null)
    )
);

create table game_results(
    result_id int generated always as identity,
    game_id int not null,
    command_id int not null,
    goals_score int not null default 0,
    penalty_score int,
    points int,

    constraint pk_result_id primary key(result_id),
    constraint fk_game_id foreign key(game_id)
        references games(game_id),
    constraint fk_command_id foreign key(command_id)
        references commands(command_id),

    constraint uq_game_results_game_command unique(game_id, command_id),

    constraint chk_goals_score_nonnegative check(goals_score >= 0),
    constraint chk_penalty_score_nonnegative check(
        penalty_score is null or penalty_score >= 0
    ),
    constraint chk_points_nonnegative check(
        points is null or points >= 0
    ),

    constraint chk_points_group_only check(
        points is null or points >= 0
    )
);

create table goals(
    goal_id int generated always as identity,
    game_id int not null,
    command_id int not null,
    player_id int not null,
    minute int not null,

    constraint pk_goal_id primary key(goal_id),
    constraint fk_goal_game_id foreign key(game_id)
        references games(game_id),
    constraint fk_goal_command_id foreign key(command_id)
        references commands(command_id),
    constraint fk_goal_player_id foreign key(player_id)
        references players(player_id),

    constraint chk_goal_minute check(minute > 0)
);

create table violations(
    violation_id int generated always as identity,
    game_id int not null,
    command_id int not null,
    player_id int not null,
    card_type varchar not null,
    minute int not null,

    constraint pk_violation_id primary key(violation_id),
    constraint fk_violation_game_id foreign key(game_id)
        references games(game_id),
    constraint fk_violation_command_id foreign key(command_id)
        references commands(command_id),
    constraint fk_violation_player_id foreign key(player_id)
        references players(player_id),

    constraint chk_violation_card_type check(
        card_type in ('жёлтая', 'красная')
    ),
    constraint chk_violation_minute check(minute > 0)
);
