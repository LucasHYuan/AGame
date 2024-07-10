class_name Player
extends CharacterBody2D

const RUN_SPEED :=80.0
const KNOCKBACK_AMOUNT := 1200.0
var pending_damage: Array = []
var interacting_with: Node2D

@onready var sprite_2d = $Graphics/PlayerSprite
@onready var animation_player = $AnimationPlayer
@onready var stats: Stats = $Stats
@onready var invincible_timer: Timer = $InvincibleTimer
@onready var graphics: Node2D = $Graphics

enum Direction {
	LEFT = -1,
	RIGHT = +1,
	UP = -1,
	DOWN = +1,
}

enum State {
	IDLE,
	RUNNING,
	HIT,
	ATTACK,
	DEATH,
}

var current_state: State = State.IDLE

func _physics_process(delta: float) -> void:
	tick_physics(current_state, delta)

func tick_physics(state: State, delta: float) -> void:
	if invincible_timer.time_left > 0:
		graphics.modulate.a = sin(Time.get_ticks_msec()/20) * 0.5 + 0.5
	else:
		graphics.modulate.a = 1
	match state:
		State.IDLE, State.HIT:
			move(0)
		State.DEATH:
			pass
		State.ATTACK:
			# 在 HIT 状态下不移动
			pass
		State.RUNNING:
			move(delta)

func move(delta: float) -> void:
	var movement_H := Input.get_axis("move_left", "move_right")
	var movement_V := Input.get_axis("move_up", "move_down")
	
	# 设置水平和垂直速度，忽略重力
	velocity.x = movement_H * RUN_SPEED
	velocity.y = movement_V * RUN_SPEED
	if not is_zero_approx(movement_H):
		sprite_2d.flip_h = movement_H < 0
	# 移动角色，不考虑重力方向
	move_and_slide()

func get_next_state(state: State) -> State:
	var movement_H := Input.get_axis("move_left", "move_right")
	var movement_V := Input.get_axis("move_up", "move_down")
	var is_still := is_zero_approx(movement_H) && is_zero_approx(movement_V)
	if stats.health == 0:
		return State.DEATH
	if pending_damage.size()>0:
		transition_state(state, State.HIT)
		return State.HIT
	match state:
		State.IDLE:
			if not is_still:
				return State.RUNNING
		State.RUNNING:
			if is_still:
				return State.IDLE
		State.ATTACK, State.DEATH:
			# 自定义其他状态转换逻辑
			pass
		State.HIT:
			if not animation_player.is_playing():
				return State.IDLE
	return state

func transition_state(from: State, to: State) -> void:
	current_state = to
	match to:
		State.IDLE:
			animation_player.play("idle")
		State.RUNNING:
			animation_player.play("running")
		State.HIT:
			animation_player.play("hit")
			if pending_damage.size() > 0: 
				var dmg = pending_damage.pop_front()
				stats.health -= dmg.amount
				var dir = dmg.source.global_position.direction_to(global_position)
				velocity = dir * KNOCKBACK_AMOUNT
				move_and_slide()
			invincible_timer.start()
		State.ATTACK:
			animation_player.play("attack")
		State.DEATH:
			animation_player.play("death")
			invincible_timer.stop()

func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	if invincible_timer.time_left > 0:
		return
	var attacker: Node2D = hitbox.owner as Node2D
	var new_dmg = Damage.new(attacker.stats.atk,attacker)
	pending_damage.append(new_dmg)
	#transition_state(current_state, State.HIT)
	

func die() -> void:
	get_tree().reload_current_scene()
