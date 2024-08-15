class_name CycleController

extends Node2D
signal day
signal night

@onready var day_night_modulate: CanvasModulate = $DayNightModulate
@onready var state_timer: Timer = $StateTimer
@onready var one_second_timer: Timer = $OneSecondTimer
@onready var transition_timer: Timer = $TransitionTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var countdown: Label = $CanvasLayer/Countdown

@export var night_time: float = 60.0
@export var day_time: float = 60.0
@export var transition_time : float = 12
@export var colors: Array = [
	Color(0, 0.431, 1),
	Color(0.161,0.573,0.769),
	Color(0.224, 0.243, 0.333),
	Color(0.867, 0.741, 0.525),
	Color(1,1,1), #Mid day
	Color(0.843, 0.798, 0.688), #Afternoon
	Color(0.554, 0.589, 0.709), #Dusk
]
@export var current_state: State = State.NIGHT
@export var start_state: State = State.NIGHT
enum State{
	DAY,
	NIGHT,
}

var color_index: int = 0

func _ready() -> void:
	# 监听GM指令
	GlobalSignal.add_listener("gmChangeTime", self, "_on_timer_timeout")

	# 注册全局指令
	GlobalSignal.add_emitter("day", self)
	GlobalSignal.add_emitter("night", self)

	day_night_modulate.color = colors[color_index]
	state_timer.start(night_time)
	state_timer.timeout.connect(_on_timer_timeout)
	one_second_timer.timeout.connect(_one_second_pass)
	transition_timer.timeout.connect(_transition_time_out)
	transition_timer.start(0.0)
	one_second_timer.start(1.0)
	countdown.text = str(int(state_timer.time_left))

func _one_second_pass() -> void:
	var remaining_time: int = int(state_timer.time_left)
	if remaining_time > 0:
		remaining_time -= 1
		countdown.text = str(remaining_time)
		
	
func _transition_time_out() -> void:
	color_index = (color_index + 1) % colors.size()
	transition_to_color(colors[color_index])
	transition_timer.start(transition_time)
	
# 日夜交替
func _on_timer_timeout() -> void:
	next_state()
	color_index = (color_index + 1) % colors.size()
	transition_to_color(colors[color_index])
	transition_timer.start(transition_time)

func next_state() -> void:
	if current_state == State.DAY:
		start_night()
	else:
		start_day()

func start_day() -> void:
	current_state = State.DAY
	state_timer.start(day_time)
	day.emit()

func start_night() -> void:
	current_state = State.NIGHT
	state_timer.start(night_time)
	night.emit()
	

func transition_to_color(target_color: Color) -> void:
	var anim = animation_player.get_animation("transition")
	if anim:
		anim.length = transition_time
		var track_index = 0
		anim.track_insert_key(0, 0, day_night_modulate.color)
		anim.track_insert_key(0, transition_time, target_color)
		animation_player.stop()
		animation_player.play("transition")


	
