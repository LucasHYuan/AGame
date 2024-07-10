extends CollisionShape2D

@onready var attack_range = $"."
@onready var shoot_timer = $ShootTimer
@onready var shoot_point = $ShootPoint

@onready var bullet = preload("res://bullets/Bullet.tscn")

var shoot_time=2
var bullet_speed=200
var bullet_damage=1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _on_shoot_timer_timeout():
	var new_bullet = bullet.instantiate()
	new_bullet.speed = bullet_speed
	new_bullet.damage = bullet_damage
	new_bullet.position = shoot_point.global_position
	
	new_bullet.dir = Vector2(1,0)
	get_tree().root.add_child(new_bullet)
