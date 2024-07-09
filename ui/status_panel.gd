extends HBoxContainer

@export var stats: Stats

@onready var health_bar: TextureProgressBar = $Health_and_Exp/HealthBar
@onready var exp_bar: TextureProgressBar = $Health_and_Exp/ExpBar
@onready var coin_text: Label = $coin_text
@onready var level_text: Label = $VBoxContainer/level_text


func _ready() -> void:
	stats.health_changed.connect(update_health)
	stats.exp_changed.connect(update_exp)
	stats.coin_changed.connect(update_coin)
	stats.level_changed.connect(update_level)
	update_health()
	update_exp()
	update_coin()
	update_level()
	

func update_health() -> void:
	var health_percentage := stats.health / float(stats.max_health)
	health_bar.value = health_percentage
	
func update_exp() -> void:
	var exp_percentage := stats.exp / float(stats.max_exp)
	exp_bar.value = exp_percentage
	
func update_coin() -> void:
	coin_text.text = str(stats.coin)

func update_level() -> void:
	level_text.text = "Level " + str(stats.level)
