class_name Hitbox
extends Area2D
signal hit(hurtbox)

var hit_time: int = -1 # >0时允许碰撞，=0时禁用碰撞，<0时不限制

func _init() -> void:
	area_entered.connect(_on_area_entered)
	

func _on_area_entered(hurtbox: Hurtbox) -> void:
	if hit_time == 0:
		disable_mode = DISABLE_MODE_REMOVE
		return
	hit_time -= 1
	
	hit.emit(hurtbox)
	hurtbox.hurt.emit(self)
