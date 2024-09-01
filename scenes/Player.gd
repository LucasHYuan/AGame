extends CharacterBody2D
class_name Player

const RUN_SPEED := 50.0
const KNOCKBACK_AMOUNT := 1200.0
var pending_damage: Array = []
var interacting_with: Node2D

@export var max_health: int = 5
@export var atk: int = 1
@export var max_exp: int = 3
@export var max_coin: int = 999
@export var init_coin: int = 3

@onready var sprite_2d = $Graphics/PlayerSprite
@onready var animation_player = $AnimationPlayer
@onready var stats: Stats = $Stats
@onready var invincible_timer: Timer = $InvincibleTimer
@onready var graphics: Node2D = $Graphics

@onready var battle_unit: BattleUnit = $BattleUnit

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

var flag_hit = false;

var current_state: State = State.IDLE

func _ready() -> void:
	GlobalObjects.SetObject("player", self)

	stats.enemy_death.connect(_on_enemy_death)

	gm_connect()
	game_connect()
	init_stats()

#region 属性管理
func init_stats() -> void:
	stats.atk = atk
	stats.max_exp = max_exp
	stats.init_coin = init_coin
	stats.max_coin = max_coin
	stats.default_init()
#endregion

#region 游戏逻辑
func game_connect() -> void:
	# 自己的战斗单位
	battle_unit.unit_dead.connect(die)
	battle_unit.unit_hurt.connect(_on_unit_hurt)

	# 所有的敌人死亡
	GlobalSignal.add_listener("enemy_death", self, "_on_enemy_death")

func _on_enemy_death(enemy: Enemy) -> void:
	print("玩家检测到敌人死亡！")
	stats.coin += enemy.coin
	stats.exp += enemy.EXP
#endregion

#region GM指令注册
func gm_connect() -> void:
	GlobalSignal.add_listener("playerLevelUp", self, "_on_player_level_up")
#endregion

func _on_player_level_up() -> void:
	print("玩家执行升级！")

#region 状态机控制
func _physics_process(delta: float) -> void:
	tick_physics(current_state, delta)

func tick_physics(state: State, delta: float) -> void:
	if invincible_timer.time_left > 0:
		graphics.modulate.a = sin(Time.get_ticks_msec() / 20) * 0.5 + 0.5
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
	if flag_hit:
		flag_hit = false
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

func transition_state(_from: State, to: State) -> void:
	current_state = to
	match to:
		State.IDLE:
			animation_player.play("idle")
		State.RUNNING:
			animation_player.play("running")
		State.HIT:
			animation_player.play("hit")
			# move_and_slide()
			invincible_timer.start()
		State.ATTACK:
			animation_player.play("attack")
		State.DEATH:
			animation_player.play("death")
			invincible_timer.stop()
#endregion

#region 受击逻辑
func _on_unit_hurt(_attack: AttackItem) -> void:
	flag_hit = true

func die() -> void:
	get_tree().reload_current_scene()
#endregion
