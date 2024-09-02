extends Area2D
class_name BulletShooter

@onready var attack_range = $"."
@onready var shoot_timer = $ShootTimer
@onready var shoot_point = $ShootPoint

@onready var bullet = preload("res://bullets/bullet.tscn")

var shoot_time = 2
var bullet_speed = 200
var bullet_damage = 1

var target_enemy: Enemy = null

func _ready():
	shoot_timer.wait_time = shoot_time
	shoot_timer.start()
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

# 跟BattleUnit同级放置
func _init_data_from_parent() -> void:
	shoot_time = get_parent().shoot_time
	bullet_speed = get_parent().bullet_speed
	bullet_damage = get_parent().bullet_damage


func get_distance(o):
	return (o.global_position - shoot_point.global_position).length()

func get_nearest_enemy():
	var res = null
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body is Enemy == false:
			continue
		# 排除已经没血的敌人
		if body.is_dead:
			continue
		
		if res == null: # 第一个遍历到的敌人
			res = body
		else: # 逐个比较，留在最小的
			if get_distance(body) < get_distance(res):
				res = body
	return res

func _on_shoot_timer_timeout():
	# 隐藏则不射击
	if get_parent().visible == false:
		return
	else:
		_shoot()

func _shoot() -> void:
	target_enemy = get_nearest_enemy()
	
	if target_enemy != null:
		# 发射子弹，并初始化数据
		var new_bullet = bullet.instantiate()
		new_bullet.speed = bullet_speed
		new_bullet.atk = bullet_damage
		new_bullet.position = shoot_point.global_position
		new_bullet.team = get_parent().team

		
		new_bullet.dir = (target_enemy.global_position - shoot_point.global_position).normalized()
		get_tree().root.add_child(new_bullet)
