tool

extends StaticBody2D

export(bool) var open = false setget set_open;
export(int) var num = 1 setget set_num;

func _ready():
	if not Engine.editor_hint:
		set_open(open);
		set_num(num);
		get_tree().get_root().get_node("game").add_door(self);

func set_open(new_open):
	open = new_open;
	if get_node("AnimatedSprite") != null:
		if open:
			get_node("AnimatedSprite").play("open");
			get_node("CollisionShape2D").disabled = true;
		else:
			get_node("AnimatedSprite").play("default");
			get_node("CollisionShape2D").disabled = false;

func set_num(new_num):
	num = new_num;
	if get_node("AnimatedSprite") != null:
		get_node("Node2D/Label").text = str(num);

func on_kill():
	if not Engine.editor_hint and num > 0:
		set_num(num - 1);
		if num <= 0:
			set_open(!open);
