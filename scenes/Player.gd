extends CharacterBody2D

const RUN_SPEED := 120.0

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

enum Direction {
	LEFT = -1,
	RIGHT = +1,
	UP = -1,
	DOWN = 1,
}

enum State {
	IDLE,
	RUNNING,
	HIT,
	ATTACK,
	DEATH,
}

func _physics_process(delta: float) -> void:
	var movement_H := Input.get_axis("move_left", "move_right")
	var movement_V := Input.get_axis("move_up", "move_down")
	
	# 设置水平和垂直速度，忽略重力
	velocity.x = movement_H * RUN_SPEED
	velocity.y = movement_V * RUN_SPEED
	
	# 更新动画状态
	if not is_zero_approx(movement_H):
		animation_player.play("running")
		sprite_2d.flip_h = movement_H < 0
	else:
		animation_player.play("idle")
	
	# 移动角色，不考虑重力方向
	move_and_slide()
