extends Enemy

func hurt_effect(_attack_item: AttackItem) -> void:
	pass
	# 击退效果
	# var dir = _attack_item.attacker.global_position.direction_to(global_position)
	# velocity = dir * KNOCKBACK_AMOUNT

func init_stats() -> void:
	super.init_stats()
