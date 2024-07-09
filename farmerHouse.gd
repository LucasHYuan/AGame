extends Buildings

@onready var sprite_2d: Sprite2D = $Graphics/Sprite2D
@onready var stats: Stats = $Stats
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var detector: Area2D = $Area2D

var is_player_here = false

func _ready() -> void:
	# 调试信息，确保变量初始化
	detector.connect("body_entered",_on_area_entered)

func _on_area_entered(body: Node) -> void:
	if body.is_in_group("Player_Group"):
		is_player_here = true

func _on_area_exited(body: Node2D) -> void:
	if body.is_in_group("Player_Group"):
		is_player_here = false

func get_next_state(state: State) -> State:
	match state:
		State.UNBUILT:
			if is_player_here:
				return State.FRAME
		State.FRAME:
			if not is_player_here:
				return State.UNBUILT
			if Input.is_action_just_pressed("ui_select"):
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



