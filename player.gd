extends Node2D

var laser = preload("res://laser.gd").new();

var points = [];
var enemies = [];

var time = 0;

var dialog;

func _ready():
	get_tree().get_root().get_node("game").set_player(self);
	upd();

func _process(delta):
	if time > 0:
		time -= delta;
		if time <= 0:
			upd();

func upd():
	# Update laser
	var space_state = get_world_2d().direct_space_state;
	var pos = get_global_transform().get_origin();
	var dir = pos.direction_to(get_global_mouse_position());
	var result = laser.calc(pos, dir, space_state, [get_parent()]);
	points = result.points;
	enemies = result.enemies;
	update();

func _draw():
	if time > 0 || !get_parent().dead:
		var pos = get_global_transform().get_origin();
		for i in range(points.size() - 1):
			var thick = 1;
			if time > 0:
				thick = 2;
			draw_line(points[i] - pos, points[i + 1] - pos, Color.red, thick);

func _input(event):
	if time <= 0 and !get_parent().dead:
		if event is InputEventMouseMotion:
			upd();
		elif ((event is InputEventMouseButton and event.pressed) or event.is_action_pressed("ui_accept")) and !dialog.visible:
			# DIE!
			get_node("AudioStreamPlayer").play();
			time = 0.5;
			for enemy in enemies:
				enemy.die();
			update();
