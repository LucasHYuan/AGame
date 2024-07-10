extends CharacterBody2D

@onready var hitbox: Hitbox = $Hitbox

var dir=Vector2.ZERO
var speed=500
var atk=1



# Called when the node enters the scene tree for the first time.
func _ready():
	hitbox.hit.connect(_on_hitbox_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity=dir*speed
	move_and_slide()

func _on_hitbox_hit(hurtbox:Hurtbox) -> void:
	queue_free()
