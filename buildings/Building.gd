class_name Building
extends Node2D

@export var buildingName: String = "建筑名称"
@export var price: int = 2

@onready var buildShow: Sprite2D = $BuildShow
@onready var building: Node2D = $Building
var buildC: BuildComponent = null
var isBuilt: bool = false

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

	# 监听全局信号
	GlobalSignal.add_listener("day", self, "_on_day")

#region 建造基本实现
func _init_build() -> void:
	# 作为需要建造的建筑初始化
	current_state = State.UNBUILT

	buildC.build.connect(_on_build)
	buildC.show_ui.connect(_on_build_show_ui)
	buildC.hide_ui.connect(_on_build_hide_ui)

	# 隐藏建筑和预览
	_set_building_active(false)
	_on_build_hide_ui()

func _on_build_show_ui() -> void:
	# 展示预览图
	buildShow.visible = true

func _on_build_hide_ui() -> void:
	# 隐藏建筑预览
	buildShow.visible = false

func _on_build() -> void:
	# 建造建筑
	_set_building_active(true)

func _set_building_active(active: bool) -> void:
	# 激活/拆除建筑
	isBuilt = active
	building.visible = active
	for child in building.get_children():
		if child is CollisionShape2D:
			child.disabled = not active
#endregion

#region 监听信号
func _on_day() -> void:
	if isBuilt:
		print("我是{ %s }，到了新的白天" % buildingName)
		_on_day_function()

func _on_day_function() -> void:
	# 在继承类中实现
	pass