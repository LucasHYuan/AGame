extends Area2D
class_name BulletShooter

@onready var attack_range = $"."
@onready var shoot_timer = $ShootTimer
@onready var shoot_point = $ShootPoint
@onready var team: GlobalInfo.Team = owner.team
@export var bullet_scene = preload("res://bullets/bullet.tscn")

@export var battle_unit: BattleUnit

var shoot_time = 1
var bullet_speed = 200
var bullet_damage = 1
var is_shooting = false
var target_enemy: BattleUnit = null

func _ready():
	shoot_timer.wait_time = shoot_time
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

	area_entered.connect(_start_shooting)

	_set_team()


func _set_team() -> void:
	# 搜索敌人
	collision_mask &= ~(1 << team)

# 跟BattleUnit同级放置
func _init_data_from_parent() -> void:
	shoot_time = battle_unit.get_parent().shoot_time
	bullet_speed = battle_unit.get_parent().bullet_speed
	bullet_damage = battle_unit.get_parent().bullet_damage

func _start_shooting(_area: Area2D) -> void:
	if is_shooting:
		return
	else:
		is_shooting = true
		_shoot()
		shoot_timer.start()


func get_distance(o):
	return (o.global_position - shoot_point.global_position).length()

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

func _on_shoot_timer_timeout():
	_shoot()

func _shoot() -> void:
	if get_parent().visible == false:
		return

	target_enemy = get_nearest_enemy()
	
	if target_enemy != null:
		# 发射子弹，并初始化数据
		var bullet = bullet_scene.instantiate()
		bullet.set_team(battle_unit.team)

		bullet.atk = bullet_damage
		bullet.speed = bullet_speed
		bullet.position = shoot_point.global_position
		bullet.dir = (target_enemy.global_position - shoot_point.global_position).normalized()

		get_tree().root.call_deferred("add_child", bullet)
	else:
		# 没有敌人，停止射击
		shoot_timer.stop()
		is_shooting = false
