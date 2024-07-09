extends Enemy

var pending_damage: Damage

func get_next_state(state: State) -> State:
	return state
				
func tick_physics(state: State, delta:float) -> void:
	target = get_closest_target()
	match state:
		State.TARGET:
			move_towards_target(target, delta)
	
func transition_state(from: State, to: State) -> void:
	pass
	
func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	stats.health -= hitbox.owner.stats.dmg
	if stats.health == 0:
		queue_free()
	
