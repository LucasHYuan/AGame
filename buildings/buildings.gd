class_name Buildings
extends StaticBody2D

@onready var interactable_area: Interactable = $Interactable_area
@export var interact_target: Node2D = null

enum State{
	UNBUILT,
	FRAME,
	BUILDING,
	IDLE,
}
var current_state: State = State.UNBUILT

func _ready() -> void:
	interactable_area.interacted.connect(interacting)
	interactable_area.uninteracted.connect(interacting_end)
	
func interacting() -> void:
	print("interacting")
func interacting_end() -> void:
	pass
