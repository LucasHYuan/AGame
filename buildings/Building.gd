class_name Building
extends Node2D

@export var buildingName: String = "建筑名称"
@export var price: int = 2

@onready var buildShow: Sprite2D = $BuildShow
@onready var building: Node2D = $Building
var buildC: BuildComponent = null

enum State {
	UNBUILT,
	BUILDING,
	IDLE,
}

var current_state: State = State.UNBUILT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buildC = $BuildComponent
	if buildC:
		_init_build()
	else:
		# 自动建造
		_on_build()

func _init_build() -> void:
	# 作为需要建造的建筑初始化
	current_state = State.UNBUILT

	buildC.build.connect(_on_build)
	buildC.show_ui.connect(_on_build_show_ui)
	buildC.hide_ui.connect(_on_build_hide_ui)

	# 隐藏建筑
	_set_building_active(false)
	building.visible = false
	for child in building.get_children():
		if child is CollisionShape2D:
			child.disabled = true

func _on_build_show_ui() -> void:
	# 展示预览图
	buildShow.visible = true

func _on_build_hide_ui() -> void:
	# 隐藏建筑
	buildShow.visible = false

func _on_build() -> void:
	# 开始建造
	_set_building_active(true)

func _set_building_active(active: bool) -> void:
	# 激活建筑
	building.visible = active
	for child in building.get_children():
		if child is CollisionShape2D:
			child.disabled = not active
