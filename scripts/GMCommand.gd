extends Node2D

signal playerLevelUp
signal changeTime

@onready var button_lv_up: Button = $CanvasLayer/ButtonLvUp
@onready var button_change_time: Button = $CanvasLayer/ButtonChangeTime

func _ready() -> void:
	# 注册信号
	GlobalSignal.add_emitter("playerLevelUp", self)
	GlobalSignal.add_emitter("changeTime", self)

	# 绑定按钮事件
	button_lv_up.pressed.connect(_on_button_lv_up_pressed)
	button_change_time.pressed.connect(_on_button_change_time_pressed)
	
func _on_button_lv_up_pressed():
	GMPrint("升级！")
	playerLevelUp.emit()

func _on_button_change_time_pressed():
	GMPrint("昼夜交替！")
	changeTime.emit()


func GMPrint(text):
	print("GM指令：" + text)
