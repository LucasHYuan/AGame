extends Enemy

func hurt_effect(_attack_item: AttackItem) -> void:
	# 击退效果
	var dir = _attack_item.attacker.global_position.direction_to(global_position)
	velocity = dir * KNOCKBACK_AMOUNT


func init_stats() -> void:
	super.init_stats()
	# 初始化怪物属性
	# stats.health = health
	# stats.atk = atk
	# stats.max_exp = max_exp
	# stats.exp = max_exp
	# stats.init_coin = init_coin
	# stats.coin = init_coin
