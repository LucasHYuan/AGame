extends Buildings

var is_player_here = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coin: AnimatedSprite2D = $coin
@onready var coin_text: Label = $coin/coin_text


#Override _ready from Buildings
func _ready() -> void:
	interactable_area.interacted.connect(interacting)
	interactable_area.uninteracted.connect(interacting_end)
	coin.visible = false

#Override interacting from Buildings
func interacting() -> void:
	is_player_here = true

#Override interacting_end from Buildings
func interacting_end() -> void:
	is_player_here = false

func get_next_state(state: State) -> State:
	match state:
		State.UNBUILT:
			if is_player_here:
				return State.FRAME
		State.FRAME:
			if not is_player_here:
				coin.visible = false
				return State.UNBUILT
			coin.visible = true
			if (interact_target.stats.coin >= int(coin_text.text)) and Input.is_action_just_pressed("ui_select"):
				interact_target.stats.coin -= int(coin_text.text)
				coin.visible = false
				return State.BUILDING
		State.BUILDING:
			if not animation_player.is_playing():
				return State.IDLE
		State.IDLE:
			pass
	return state

func tick_physics(state: State, delta: float) -> void:
	match state:
		State.UNBUILT:
			pass
		State.FRAME:
			pass
		State.BUILDING:
			pass
		State.IDLE:
			pass

func transition_state(from: State, to: State) -> void:
	current_state = to
	match to:
		State.UNBUILT:
			animation_player.play("unbuilt")
		State.FRAME:
			animation_player.play("frame")
		State.BUILDING:
			animation_player.play("building")
		State.IDLE:
			animation_player.play("idle")



