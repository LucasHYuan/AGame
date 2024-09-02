extends Hitbox
class_name HitAttacker

@export var atk: float = 1
@export var kickback: float = 1

var team: GlobalInfo.Team

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if owner && owner.get("team"):
		team = owner.team
		_set_team()

func set_team(_team: GlobalInfo.Team) -> void:
	self.team = _team
	_set_team()

func _set_team() -> void:
	# 避免自己伤害自己
	collision_mask &= ~(1 << team)
