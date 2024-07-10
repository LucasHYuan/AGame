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
	


func _on_shoot_timer_timeout():
	if target_enemy!=null:
		
		var new_bullet = bullet.instantiate()
		new_bullet.speed = bullet_speed
		new_bullet.damage = bullet_damage
		new_bullet.position = shoot_point.global_position
		
		
		
		new_bullet.dir = (target_enemy.global_position- shoot_point.global_position).normalized()
		print("发射方向:%s"%new_bullet.dir)
		get_tree().root.add_child(new_bullet)


func _on_body_entered(body:Enemy):
	if target_enemy==null:
		target_enemy=body
		print("锁定新的敌人")

func _on_body_exited(body:Enemy):
	if target_enemy==body:
		target_enemy=null
		print("之前的敌人离开")
