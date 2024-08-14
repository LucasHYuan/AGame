extends Node2D

@onready var ui: Container = $CanvasLayer/VBoxContainer
@onready var interactable_area: Interactable = $Interactable_area
@onready var button: Button = $CanvasLayer/VBoxContainer/Button

signal build

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 绑定interactable
	interactable_area.interacted.connect(interacting)
	interactable_area.uninteracted.connect(interacting_end)
	button.pressed.connect(_on_Button_pressed)

	pass # Replace with function body.

func interacting() -> void:
	ui.visible = true

func interacting_end() -> void:
	ui.visible = false

func _on_Button_pressed() -> void:
	build.emit()
