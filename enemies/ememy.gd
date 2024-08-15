class_name Enemy
extends CharacterBody2D

enum Direction {
	LEFT = -1,
	RIGHT = +1,
	UP = -1,
	DOWN = 1,
}

enum State {
	TARGET,
	IDLE,
	DEATH,
	HIT,
}

signal enemy_death(stats: Stats)

@export var health: int = 1
@export var atk: int = 1
@export var max_exp: int = 1
@export var init_coin: int = 0

@export var max_speed: float = 30
var target: Node2D # 追踪目标
@export var target_groups := ["Player_Group", "Building_Group"] # 要追踪的组列表
@onready var graphics: Node2D = $Graphics
@onready var state_machine: StateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var stats: Stats = $Stats
@onready var hurtbox: Hurtbox = $Graphics/Hurtbox

var pending_damage: Array = []
var current_state: State
const KNOCKBACK_AMOUNT := 1200.0

func _ready() -> void:
	hurtbox.hurt.connect(_on_hurtbox_hurt)
	GlobalSignal.add_emitter("enemy_death", self)
	init_stats()

func init_stats() -> void:
	pass

#region 移动&目标控制
func get_target() -> Node2D:
	return get_closest_target()

func get_closest_target() -> Node2D:
	var closest_target: Node2D = null
	var closest_distance = INF

	for group in target_groups:
		var objects = get_tree().get_nodes_in_group(group)
		for obj in objects:
			var distance = global_position.distance_to(obj.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_target = obj
	return closest_target
	
func move_towards_target(cur_target: Node2D, _delta: float) -> void:
	var direction = (cur_target.global_position - global_position).normalized()
	if direction.x < 0:
		animation_player.play("left")
	else: animation_player.play("right")
	if direction.y < 0:
		animation_player.play("up")
	else: animation_player.play("down")
	velocity = direction * max_speed
	move_and_slide()
#endregion

#region 状态机控制
func get_next_state(state: State) -> State:
	match state:
		State.TARGET:
			if stats.health <= 0:
				return State.DEATH
			if pending_damage.size() > 0:
				transition_state(state, State.HIT)
				return State.HIT
		State.HIT:
			if not animation_player.is_playing():
				return State.TARGET
	return state
				
func tick_physics(state: State, delta: float) -> void:
	target = get_target()
	match state:
		State.TARGET:
			move_towards_target(target, delta)
	
func transition_state(_from: State, to: State) -> void:
	current_state = to
	match to:
		State.HIT:
			animation_player.play("hit")
			if pending_damage.size() > 0:
				# 扣血
				var dmg = pending_damage.pop_front()
				stats.health -= dmg.amount
				hurt_effect(dmg)
				move_and_slide()
		State.DEATH:
			die()
			animation_player.play("death")
		State.TARGET, State.IDLE:
			animation_player.play("RESET")

func hurt_effect(_dmg: Damage) -> void:
	print("存在未实现的怪物受击")
	pass
#endregion

func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	var attacker: Node2D = hitbox.owner as Node2D
	var new_dmg = Damage.new(attacker.atk, attacker)
	pending_damage.append(new_dmg)

func die() -> void:
	enemy_death.emit(stats)
	queue_free()
