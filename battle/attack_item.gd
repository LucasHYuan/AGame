class_name AttackItem
extends RefCounted

var atk: int
var attacker: Node2D

func _init(_atk: int, _attacker: Node2D) -> void:
	self.atk = _atk
	self.attacker = _attacker
