extends Node2D

@onready var hitbox: Hitbox = $Hitbox

var dir=Vector2.ZERO
var speed=1
var atk=1



# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)
	hitbox.hit.connect(_on_hitbox_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += (dir * speed) * delta

func _on_hitbox_hit(hurtbox:Hurtbox) -> void:
	queue_free()
