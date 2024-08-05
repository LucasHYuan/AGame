extends Enemy

func hurt_effect(dmg: Damage) -> void:
	# 击退效果
	var dir = dmg.source.global_position.direction_to(global_position)
	velocity = dir * KNOCKBACK_AMOUNT


func init_stats()->void:
	# 初始化怪物属性
	stats.health = 2
	stats.atk = 1
	stats.max_exp = 1
	stats.init_coin = 1