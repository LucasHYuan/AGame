extends HitAttacker


var dir = Vector2.ZERO
var speed = 1
var team: GlobalInfo.Team

@onready var timer_destroy = $TimerDestroy

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	set_as_top_level(true)
	hit.connect(_on_hitbox_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += (dir * speed) * delta

func _on_hitbox_hit(_hurtbox: Hurtbox) -> void:
	queue_free()


func _on_timer_destroy_timeout():
	queue_free()
