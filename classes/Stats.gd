class_name Stats
extends Node
signal health_changed
signal exp_changed
signal level_changed
signal coin_changed
signal enemy_death(enemy_stats:Stats)

@export var max_health: int = 3
@export var atk: int = 1
@export var max_exp: int = 3
@export var init_coin: int = 50
var max_coin: int = 999

@onready var health: int = max_health:
	set(v):
		v = clampi(v, 0, max_health)
		if health == v:
			return
		health = v
		health_changed.emit()

@onready var exp: int = 0:
	set(v):
		if v <= 0:
			return
		exp = v
		if exp>=max_exp:
			exp-=max_exp
			level+=1
		exp_changed.emit()

@onready var coin: int = init_coin:
	set(v):
		v = clampi(v, 0, max_coin)
		if coin == v:
			return
		coin = v
		coin_changed.emit()
		
@onready var level: int = 0:
	set(v):
		if v <= 0:
			return
		level = v
		level_changed.emit()
