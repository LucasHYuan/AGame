extends Node

@export var hitbox: Hitbox
@export var battle_unit: BattleUnit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_team()

func _set_team() -> void:
	hitbox.collision_mask &= ~(1 << battle_unit.team)
