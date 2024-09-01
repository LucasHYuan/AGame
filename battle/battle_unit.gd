extends Node2D
class_name BattleUnit


@export var hurtbox: Hurtbox
@export var team: GlobalInfo.Team = GlobalInfo.Team.player
@export var max_health: int = 1
var health: int = 1

var invincible: bool = false

signal health_changed()
signal unit_hurt(attack: AttackItem)
signal unit_dead()


func _ready() -> void:
	health = max_health
	hurtbox.hurt.connect(_on_hurtbox_hurt)
	_init_collision()

func _init_collision() -> void:
	if team == GlobalInfo.Team.player:
		hurtbox.collision_layer = 1 << GlobalInfo.Team.player
	elif team == GlobalInfo.Team.enemy:
		hurtbox.collision_layer = 1 << GlobalInfo.Team.enemy

# 通用受击逻辑
func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	var attacker: Node2D = hitbox.owner as Node2D
	var attack = AttackItem.new(attacker.atk, attacker)
	print("检测到受击，攻击者:", attacker, "  攻击力:", attacker.atk)
	_process_atk(attack)
	print("当前生命值:", health, "  最大生命值：", max_health)

# 伤害结算逻辑
func _process_atk(attack: AttackItem) -> void:
	if invincible:
		# 无敌状态下不受伤
		return

	health -= attack.atk
	
	health_changed.emit()
	unit_hurt.emit(attack)

	if health <= 0:
		health = 0
		unit_dead.emit()
