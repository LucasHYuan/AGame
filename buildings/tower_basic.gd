extends Building
class_name TowerBasic

@export var shoot_time:float=2 # 射击间隔
@export var bullet_speed:float=200 # 子弹速度
@export var bullet_damage:int=1 # 子弹伤害 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
