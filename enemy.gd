extends StaticBody2D

var dead = false;

func _ready():
	if name != "player":
		get_tree().get_root().get_node("game").add_enemy(self);

func die():
	dead = true;
	get_node("sprite").play("ded");
	get_tree().get_root().get_node("game").on_kill();
