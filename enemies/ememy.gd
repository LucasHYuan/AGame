class_name Enemy
extends CharacterBody2D
enum Direction{
	LEFT = -1,
	RIGHT = +1,
	UP = -1,
	DOWN = 1,	
}

enum State{
	TARGET,
	IDLE,
	DEATH,
	HIT,
}

@export var direction:= Direction.LEFT:
	set(v):
		direction = v

@export var max_speed: float = 30
var target: Node2D  # 追踪目标
@export var target_groups := ["Player_Group", "Building_Group"]  # 要追踪的组列表
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
	
func move_towards_target(target: Node2D, delta: float) -> void:
	var direction = (target.global_position - global_position).normalized()
	if direction.x<0:
		animation_player.play("left")
	else: animation_player.play("right")
	if direction.y<0:
		animation_player.play("up")
	else: animation_player.play("down")
	velocity = direction * max_speed
	move_and_slide()

func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	var attacker: Node2D = hitbox.owner as Node2D
	var new_dmg = Damage.new(attacker.atk,attacker)
	pending_damage.append(new_dmg)

func die() -> void:
	var player = get_node("../../Player") #it's not good, but to test func just put it here
	if player!=null:
		player._on_enemy_death(stats)
	queue_free()


