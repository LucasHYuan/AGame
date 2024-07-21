extends Enemy

func get_next_state(state: State) -> State:
	match state:
		State.TARGET:
			if stats.health <= 0:
				return State.DEATH
			if pending_damage.size()>0:
				transition_state(state, State.HIT)
				return State.HIT
		State.HIT:
			if not animation_player.is_playing():
				return State.TARGET
	return state
				
func tick_physics(state: State, delta:float) -> void:
	target = get_closest_target()
	match state:
		State.TARGET:
			move_towards_target(target, delta)
	
func transition_state(from: State, to: State) -> void:
	current_state = to
	match to:
		State.HIT:
			animation_player.play("hit")
			if pending_damage.size() > 0: 
				# 扣血
				var dmg = pending_damage.pop_front()
				stats.health -= dmg.amount
				# 击退效果
				var dir = dmg.source.global_position.direction_to(global_position)
				velocity = dir * KNOCKBACK_AMOUNT
				move_and_slide()
		State.DEATH:
			animation_player.play("death")
		State.TARGET, State.IDLE:
			animation_player.play("RESET")
		

	
