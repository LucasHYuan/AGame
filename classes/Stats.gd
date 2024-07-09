class_name Stats
extends Node

@export var max_health: int = 3
@export var atk: int = 1
@onready var health: int = max_health:
	set(v):
		v = clampi(v, 0, max_health)
		if health == v:
			return
		else:
			health = v
