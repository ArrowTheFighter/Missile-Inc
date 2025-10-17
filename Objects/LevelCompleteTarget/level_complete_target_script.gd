extends Node3D

signal TargetHit
func take_damage(value):
	TargetHit.emit()
