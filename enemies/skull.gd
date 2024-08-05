extends Enemy

func hurt_effect(dmg: Damage) -> void:
	# 击退效果
	var dir = dmg.source.global_position.direction_to(global_position)
	velocity = dir * KNOCKBACK_AMOUNT

