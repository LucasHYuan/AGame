extends Buildings

@export var coin_earn_day: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

func _on_day_function() -> void:
	# 玩家金币+1
	var player = GlobalObjects.GetObject("player")
	if player:
		player.stats.coin += coin_earn_day