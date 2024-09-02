class_name Enemy
extends CharacterBody2D

const KNOCKBACK_AMOUNT := 30.0

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

signal enemy_death(enemy: Enemy)

# 固定属性：生命、攻击、经验、金币
@export var EXP: int = 1
@export var coin: int = 1

@export var speed: float = 30
@export var target_groups := ["Player_Group", "Building_Group"] # 要追踪的组列表

@onready var graphics: Node2D = $Graphics
@onready var battle_unit: BattleUnit = $BattleUnit
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

var target: Node2D # 追踪目标
var is_dead: bool = false:
	get:
		return battle_unit.is_dead
var flag_hit = false

func _ready() -> void:
	init_stats()
	game_connect()
	

#region 属性管理
func init_stats() -> void:
	pass
#endregion

#region 主入口
func _physics_process(delta: float) -> void:
	move_towards_target(delta)

func move_towards_target(_delta: float) -> void:
	var _target = get_target()

	# 获取方向向量
	var direction = global_position.direction_to(_target.global_position)

	# 动画机参数
	animation_move(direction)

	# 移动逻辑
	velocity = direction * speed
	move_and_slide()
#endregion

#region 游戏逻辑
func game_connect() -> void:
	battle_unit.unit_hurt.connect(_on_unit_hurt)
	battle_unit.unit_kickback.connect(_on_unit_kickback)
	battle_unit.unit_dead.connect(_on_unit_die)

	# 广播死亡事件
	GlobalSignal.add_emitter("enemy_death", self)

func _destroy() -> void:
	queue_free()

# 受击逻辑
func _on_unit_kickback(kickback: Vector2) -> void:
	translate(kickback * KNOCKBACK_AMOUNT)

func _on_unit_hurt(_attack_item: AttackItem) -> void:
	pass

func _on_unit_die() -> void:
	animation_die()
	speed = 0
	enemy_death.emit(self)

#endregion


#region 移动&目标控制
# 获取目标
func get_target() -> Node2D:
	return get_closest_target()

# 获取最近的目标
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
	
#region 动画接口
func animation_move(dir: Vector2) -> void:
	animation_tree.set("parameters/Run/blend_position", dir)

func animation_die() -> void:
	animation_tree.set("parameters/conditions/dead", true)
#endregion