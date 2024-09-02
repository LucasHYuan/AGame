extends Area2D

signal find_target(target: Node2D)

@onready var team: GlobalInfo.Team = owner.team

# 获取最近的battle_unit
func get_neareast_target():
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_team()

	area_entered.connect(_on_area_entered)


func _set_team() -> void:
	# 搜索敌人
	collision_mask &= ~(1 << team)

func _on_area_entered(_area: Area2D) -> void:
	# 进行范围搜索
	var areas = get_overlapping_areas()
	print(areas.size())
	print(areas)
	for area in areas:
		if areas is Hurtbox:
			break