extends Buildings
class_name BaseCamp


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	GlobalObjects.SetObject("base_camp", self)


#region 游戏逻辑
func _on_unit_die() -> void:
	super._on_unit_die()
	# 建筑被摧毁
	print("基地被摧毁")

	call_deferred("_reload_scene")

func _reload_scene() -> void:
	get_tree().reload_current_scene()
#endregion
