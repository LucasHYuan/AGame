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
		current_state = State.IDLE
	pass # Replace with function body.

func _init_build() -> void:
	current_state = State.UNBUILT
	# 作为需要建造的建筑初始化
	buildC.build.connect(_on_build)
	buildC.show_ui.connect(_on_build_show_ui)
	buildC.hide_ui.connect(_on_build_hide_ui)

func _on_build_show_ui() -> void:
	# 展示预览图
	buildShow.visible = true
	pass

func _on_build_hide_ui() -> void:
	# 隐藏预览图
	buildShow.visible = false
	pass

func _on_build() -> void:
	# 开始建造
	building.visible = true
	pass
