extends Node2D
class_name BattleUnit


@export var hurtbox: Hurtbox
@export var team: GlobalInfo.Team = GlobalInfo.Team.player
@export var max_health: int = 1


var is_dead: bool = false:
	get:
		return health <= 0
var health: int = 1
var invincible: bool = false

signal health_changed()
signal unit_kickback(kickback: Vector2)
signal unit_hurt(attack: AttackItem)
signal unit_dead()


func _ready() -> void:
	owner.team = team
	health = max_health
	hurtbox.battle_unit = self
	hurtbox.hurt.connect(_on_hurtbox_hurt)
	set_collision()

func set_collision() -> void:
	if team == GlobalInfo.Team.player:
		hurtbox.collision_layer = 1 << GlobalInfo.Team.player
	elif team == GlobalInfo.Team.enemy:
		hurtbox.collision_layer = 1 << GlobalInfo.Team.enemy

func hide_collision() -> void:
	hurtbox.collision_layer = 0
	

# 通用受击逻辑
func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	var attacker: Node2D = hitbox
	var attack = AttackItem.new(attacker.atk, attacker)

	_process_atk(attack)
	print("当前生命值:", health, "  最大生命值：", max_health)

# 伤害结算逻辑
func _process_atk(attack: AttackItem) -> void:
	if invincible:
		# 无敌状态下不受伤
		return

	print("有效攻击，攻击者:", attack.attacker, "  攻击力:", attack.atk)
	_process_kickback(attack)

	health -= attack.atk
	
	health_changed.emit()
	unit_hurt.emit(attack)

	if health <= 0:
		health = 0
		unit_dead.emit()

# 击退逻辑
func _process_kickback(attack: AttackItem) -> void:
	if attack.kickback_volume > 0:
		print("击退量：", attack.kickback_volume)
		
		var dir = attack.attacker.global_position.direction_to(global_position)
		var kickback = dir * attack.kickback_volume
		unit_kickback.emit(kickback)
