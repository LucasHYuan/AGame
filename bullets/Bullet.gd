extends Node2D


var dir = Vector2.ZERO
var speed = 1
var atk = 1
var team: GlobalInfo.Team

@onready var hitbox: Hitbox = $Hitbox
@onready var timer_destroy = $TimerDestroy

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)

	_set_team()
	hitbox.hit.connect(_on_hitbox_hit)

func _set_team() -> void:
	hitbox.collision_mask &= ~(1 << team)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += (dir * speed) * delta

func _on_hitbox_hit(_hurtbox: Hurtbox) -> void:
	queue_free()


func _on_timer_destroy_timeout():
	queue_free()
