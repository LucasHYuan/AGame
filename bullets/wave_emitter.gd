extends Area2D
class_name WaveEmitter

@onready var attack_range = $"."
@onready var emit_timer: Timer = $EmitTimer
@onready var emit_point = $EmitPoint
@onready var team: GlobalInfo.Team = owner.team
@export var wave_scene=preload("res://bullets/wave.tscn");

@export var battle_unit: BattleUnit

var emit_time = 2
var wave_speed = 0.25
var wave_damage = 1
var is_shooting = false
var target_enemy: BattleUnit = null

func _ready():
	emit_timer.wait_time = emit_time
	emit_timer.timeout.connect(_on_emit_timer_timeout)

	area_entered.connect(_start_emitting)

	_set_team()


func _set_team() -> void:
	# 搜索敌人
	collision_mask &= ~(1 << team)

# 跟BattleUnit同级放置
func _init_data_from_parent() -> void:
	emit_time = battle_unit.get_parent().shoot_time
	wave_speed = battle_unit.get_parent().wave_speed

func _start_emitting(_area: Area2D) -> void:
	if is_shooting:
		return
	else:
		is_shooting = true
		_emit()
		emit_timer.start()


func get_distance(o):
	return (o.global_position - emit_point.global_position).length()

func get_nearest_enemy() -> BattleUnit:
	var res = null

	var areas = get_overlapping_areas()
	for area in areas:
		if area is Hurtbox == false:
			continue
		var hurtbox = area as Hurtbox
		var target_unit = hurtbox.battle_unit
		if target_unit.is_dead:
			continue

		if res == null: # 第一个遍历到的敌人
			res = target_unit
		else: # 逐个比较，留在最小的
			if get_distance(target_unit) < get_distance(res):
				res = target_unit
	return res

func _on_emit_timer_timeout():
	_emit()

func _emit() -> void:
	if get_parent().visible == false:
		return

	target_enemy = get_nearest_enemy()
	
	if target_enemy != null:
		# 发射光波，并初始化数据
		var wave = wave_scene.instantiate()
		wave.set_team(battle_unit.team)

		wave.speed = wave_speed
		wave.position = emit_point.global_position

		get_tree().root.call_deferred("add_child", wave)
	else:
		# 没有敌人，停止发射
		emit_timer.stop()
		is_shooting = false
