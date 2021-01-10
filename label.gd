extends Node2D

func _ready():
	rotation -= get_global_transform().get_rotation();
