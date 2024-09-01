extends Hitbox
class_name HitAttacker

@export var atk: float = 1
@export var kickback: float = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_team()

func get_team() -> GlobalInfo.Team:
	var cur = self
	while cur.get_parent() != null:
		var target = cur.get_parent().find_child("BattleUnit")
		if target != null:
			return target.team
		cur = cur.get_parent()
	return GlobalInfo.Team.player

func _set_team() -> void:
	# 避免自己伤害自己
	collision_mask &= ~(1 << get_team())
