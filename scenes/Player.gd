extends CharacterBody2D
class_name Player

const RUN_SPEED := 50.0
const KNOCKBACK_AMOUNT := 30.0
var pending_damage: Array = []
var interacting_with: Node2D
var atk_growth_rate = 1.1
var health_growth_rate = 1.2

@export var atk: float = 1
@export var shoot_time: float = 1
@export var attacker_speed: float = 200
@onready var sprite_2d = $Graphics/PlayerSprite
@onready var animation_player = $AnimationPlayer
@onready var data: PlayerData = $Data
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
var team: GlobalInfo.Team=GlobalInfo.Team.player
var current_state: State = State.IDLE

func _ready() -> void:
	GlobalObjects.SetObject("player", self)
	gm_connect()
	game_connect()
	init_stats()

#region 属性管理
func init_stats() -> void:
	data.default_init()
	#等级升级时处理逻辑
	data.level_changed.connect(player_level_up)
	
func player_level_up() -> void:
	print("升级了！")
	self.atk *= atk_growth_rate
	battle_unit.max_health *= health_growth_rate
	battle_unit.health = battle_unit.max_health
#endregion

#region 游戏逻辑
func game_connect() -> void:
	# 自己的战斗单位
	battle_unit.unit_dead.connect(_player_die)
	battle_unit.unit_hurt.connect(_on_unit_hurt)
	battle_unit.unit_kickback.connect(_on_unit_kickback)
	
	# 所有的敌人死亡
	GlobalSignal.add_listener("enemy_death", self, "_on_enemy_death")

#region 受击逻辑
func _on_unit_hurt(_attack: AttackItem) -> void:
	flag_hit = true

func _on_unit_kickback(kickback: Vector2) -> void:
	translate(kickback * KNOCKBACK_AMOUNT)

func _player_die() -> void:
	print("玩家死亡")
	# get_tree().reload_current_scene()
#endregion

func _on_enemy_death(enemy: Enemy) -> void:
	print("玩家检测到敌人死亡,获得金币:", enemy.coin, "  经验:", enemy.EXP)
	data.coin += enemy.coin
	data.EXP += enemy.EXP
#endregion

#region GM指令注册
func gm_connect() -> void:
	#GlobalSignal.add_listener("playerLevelUp", self, "_on_player_level_up")
	GlobalSignal.add_listener("gmPlayerLevelUp", self, "_on_player_level_up")

#
func _on_player_level_up() -> void:
	print("玩家执行升级！")
	data.level+=1
#endregion


#region 状态机控制
func _physics_process(delta: float) -> void:
	tick_physics(current_state, delta)

func tick_physics(state: State, delta: float) -> void:
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

func move(_delta: float) -> void:
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
		State.ATTACK:
			animation_player.play("attack")
		State.DEATH:
			animation_player.play("death")
#endregion
