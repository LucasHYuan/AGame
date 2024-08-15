class_name BuildComponent
extends Node2D

@onready var ui: Container = $CanvasLayer/VBoxContainer
@onready var interactable_area: Interactable = $Interactable_area
@onready var button: Button = $CanvasLayer/VBoxContainer/Button
@onready var label: Label = $CanvasLayer/VBoxContainer/Label
@onready var labelDescription: Label = $CanvasLayer/VBoxContainer/Description

# signal build_ask(price: int) # 向玩家请求建造
signal build # 建造
signal show_ui
signal hide_ui

var price: int = 0
var nameLabel: String = "未命名"
var descriptionLabel: String = "未命名"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 绑定interactable
	interactable_area.interacted.connect(interacting)
	interactable_area.uninteracted.connect(interacting_end)
	button.pressed.connect(_on_Button_pressed)

	price = get_parent().price
	nameLabel = get_parent().buildingName
	descriptionLabel = get_parent().descriptionLabel
	button.text = str(price)
	label.text = nameLabel
	labelDescription.text = descriptionLabel

	# 初始化
	ui.visible = false

func interacting() -> void:
	show_ui.emit()
	ui.visible = true

func interacting_end() -> void:
	hide_ui.emit()
	ui.visible = false

func _on_Button_pressed() -> void:
	# 检查钱够不够
	# build_ask.emit(price)
	var player = GlobalObjects.GetObject("player")
	if player:
		if player.stats.coin >= price:
			player.stats.coin -= price
			_on_build()


func _on_build() -> void:
	# 钱够,建造
	build.emit()
	self.queue_free()
	pass
