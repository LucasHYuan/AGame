extends Node2D

@onready var enemy_timer: Timer = $EnemyTimer
@export var enemy_path: Path2D
@export var enemy_spawn_location: PathFollow2D
@export var scene: PackedScene
@export var enemy_prototype = preload("res://enemies/skull.tscn")
@export var spawn_interval: float = 1.0
@export var cycle_controller: CycleController

var enemy_list: Array = []
func _ready() -> void:
	enemy_timer.timeout.connect(_on_enemy_timer_timeout)
	enemy_timer.start(spawn_interval)
	cycle_controller.day.connect(clear_all_enemies)
	cycle_controller.night.connect(start_generate)

func _on_enemy_timer_timeout():
	var enemy = enemy_prototype.instantiate()
	enemy_spawn_location.progress_ratio = randf()
	enemy.position = enemy_spawn_location.position
	enemy_list.append(enemy)
	add_child(enemy)
	
func clear_all_enemies() -> void:
	for enemy in enemy_list:
		if enemy!=null:
			enemy.die()
	enemy_timer.stop()

func start_generate() -> void:
	enemy_timer.start(spawn_interval)
	
	
	
