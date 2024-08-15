extends Area2D

@onready var attack_range = $"."
@onready var shoot_timer = $ShootTimer
@onready var shoot_point = $ShootPoint

@onready var bullet = preload("res://bullets/Bullet.tscn")

var shoot_time=2
var bullet_speed=200
var bullet_damage=1

var target_enemy:Enemy=null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_distance(o):
	return (o.global_position - shoot_point.global_position).length()

func get_nearest_enemy():
	var res = null
	var bodies = get_overlapping_bodies()
	for body:Enemy in bodies:
		# 排除已经没血的敌人
		if body.current_state == Enemy.State.DEATH:
			continue
		
		if res == null: # 第一个遍历到的敌人
			res = body
		else: # 逐个比较，留在最小的
			if get_distance(body) < get_distance(res):
				res = body
	return res

func _on_shoot_timer_timeout():
	target_enemy = get_nearest_enemy()
	
	if target_enemy!=null:
		var new_bullet = bullet.instantiate()
		new_bullet.speed = bullet_speed
		new_bullet.atk = bullet_damage
		new_bullet.position = shoot_point.global_position
		
		new_bullet.dir = (target_enemy.global_position- shoot_point.global_position).normalized()
		#print("发射方向:%s"%new_bullet.dir)
		get_tree().root.add_child(new_bullet)
