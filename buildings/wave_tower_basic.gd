extends Buildings

@export var taunt_freq:float=2 ## 嘲讽间隔
@export var wave_speed:float=200 ## 子弹速度

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
