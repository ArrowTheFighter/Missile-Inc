@abstract class_name Bullet_Base
extends Node3D

@export var CollisionArea : Area3D
@export var speed := 1
@export var damage_strength := 1
@export var deal_damage_on_touch := true
var target_pos : Vector3

@export_category("Death Particle")
@export var death_particle : PackedScene


func _ready() -> void:
	if CollisionArea != null:
		CollisionArea.area_entered.connect(on_hit)
	

func _process(delta: float) -> void:
	_move_bullet(delta)

@abstract func _move_bullet(delta : float)

func on_hit(area : Area3D):
	if !deal_damage_on_touch: return
	if area.get_parent() != null:
		if area.get_parent().has_method("take_damage"):
			area.get_parent().call("take_damage",1)
