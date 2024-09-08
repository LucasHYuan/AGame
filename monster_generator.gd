extends Node2D
class_name MonsterGenerator

@onready var interval_timer: Timer = $IntervalTimer
@onready var wave_interval_timer: Timer = $WaveIntervalTimer

@export var enemy_path: Path2D
@export var enemy_spawn_location: PathFollow2D

@export var scene: PackedScene
@export var enemy_prototype: PackedScene = preload("res://enemies/skull.tscn")

@export var cycle_controller: CycleController

const SPAWN_RADIUS = 10

# 两种刷怪模式
# 1. 持续不断地以低频刷怪
# 2. 在一定时间周期内分波次刷怪

# 拿着所有怪物的引用，执行全体操作

var enemy_list: Array = []
var interval_enemy_list: Array = [enemy_prototype]
var wave_enemy_list: Array = [enemy_prototype]
var wave_data: Array = [[1, 2, 3], [10, 10]] # 每夜怪物的数量
var wave_index: int = 0 # 夜晚数
var wave_inner_index: int = 0 # 夜晚的波次数


func _ready() -> void:
	interval_timer.timeout.connect(_on_interval_timeout)
	wave_interval_timer.timeout.connect(_on_wave_interval_timeout)

	# cycle_controller.day.connect(_generate_by_interval)
	cycle_controller.night.connect(_generate_next_wave)


func _generate_next_wave(duration: float) -> void:
	print("夜晚开始，持续时间:", duration)
	_generate_by_wave(wave_index, duration) # 在N秒内刷出对应波次的怪物

# 在duration中刷出对应波次的怪物
func _generate_by_wave(index: int, duration: float):
	var data = wave_data[index]
	var size = data.size()

	var interval = duration / size / 2
	wave_interval_timer.wait_time = interval # 每波怪物的间隔

	_add_wave_enemy(wave_index, 0)
	wave_interval_timer.start()


func _on_wave_interval_timeout() -> void:
	if wave_inner_index >= wave_data[wave_index].size() - 1:
		# 刷完了 下一波
		print("刷完一夜的怪物，准备下一波")
		wave_index += 1
		wave_interval_timer.stop()
		return
	else:
		wave_inner_index += 1

	_add_wave_enemy(wave_index, wave_inner_index)
	

func _add_wave_enemy(wave: int, index: int) -> void:
	print("刷怪,夜晚：", wave, " 波次", index)
	var enemy_index = randi()%wave_enemy_list.size()
	_add_enemy_random_pos(enemy_index, wave_data[wave][index])

		
# 以一定频率刷怪
func _generate_by_interval(interval: float) -> void:
	interval_timer.wait_time = interval
	interval_timer.start()

func _on_interval_timeout() -> void:
	_add_random_enemy()

func _stop_generate() -> void:
	interval_timer.stop()

func _add_random_enemy():
	var enemy_index = randi()%interval_enemy_list.size() # 随机选择一个怪物
	_add_enemy_random_pos(enemy_index) # 随机位置生成一只

# 在随机位置生成几只怪物
func _add_enemy_random_pos(index: int, num: int = 1):
	print("在随机位置生成怪物数量:", num)
	var enemy = interval_enemy_list[index]
	var pos = _get_random_point()
	for i in range(num):
		var e = enemy.instantiate()
		e.position = pos + _get_random_offset()
		enemy_list.append(e)
		add_child(e)

func _get_random_offset() -> Vector2:
	return Vector2(randi_range(-SPAWN_RADIUS, SPAWN_RADIUS), randi_range(-SPAWN_RADIUS, SPAWN_RADIUS))

func _get_random_point() -> Vector2:
	enemy_spawn_location.progress_ratio = randf()
	return enemy_spawn_location.position
