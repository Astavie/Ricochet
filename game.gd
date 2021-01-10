extends Node2D

var player: Node2D;
var enemies = [];
var doors = [];

var done = false;

var levels = [
	preload("res://levels/level1.tscn"),
	preload("res://levels/level2.tscn"),
	preload("res://levels/level3.tscn"),
	preload("res://levels/level4.tscn"),
	preload("res://levels/level5.tscn"),
	preload("res://levels/level6.tscn"),
	
	preload("res://levels/levelend.tscn"),
]

var start_text = [
	"Welcome test subject!\nYou have been assigned to train our Laser Defense SystemⓇ(TM).\nTry to disintegrate the red circle. Good luck!",
	"This room contains a special door:\nit opens once a number of circles has been destroyed.\nLike all doors in real life, these are extremely reflective.",
	"",
	"This door is not like other doors, it *closes* when circles are destroyed!",
	"",
	"Here's something you might not expect: a door... behind a door!",
	
	"Thanks for playing!\n...\nThis room is impossible, btw."
]

var end_text = [
	"Congratulations, you know how to point and fire.",
	"The eventual goal of the Laser Defense SystemⓇ(TM)\nis to be able to operate on its own.",
	"By controlling the Laser Defense SystemⓇ(TM) manually,\nyou're training its artificial intelligence.",
	"And those are basically all the elements in this test environment:\nmirrors and doors.",
	"Did you know some rooms have multiple solutions?\nThis room did not.",
	"The Double Doors of Doom have been defeated."
]

var end_dead_text = [
	"Ehrm, I suppose that counts as disintegrating the red circle...\nTry not to destroy the Laser Defense SystemⓇ(TM) next time, though.",
	"How did you manage to do that? (Unexpected outcome)",
	"How did you manage to do that? (Unexpected outcome)",
	"How did you manage to do that? (Unexpected outcome)",
	"If you tried your best, you might've saved the Laser Defense SystemⓇ(TM).",
	"Did you really go out of your way to destroy the Laser Defense SystemⓇ(TM)?",
]

var level = 0;
var level_node: Node2D;

var destroyed = [
	"FYI, the blue circle is our Laser Defense SystemⓇ(TM).\nIf you destroy it, you can't shoot any more lasers.",
	"Please refrain from destroying our Laser Defense SystemⓇ(TM)\nbefore all red circles have been destroyed.",
	"Did you know that repairing the Laser Defense SystemⓇ(TM) costs money?",
	"There are still some red circles left, try again!",
]

var d_count = 0;

func set_player(p):
	p.dialog = get_node("CanvasLayer/dialog");
	player = p;

func add_door(d):
	doors.push_back(d);

func _ready():
	load_level(true);

func add_enemy(enemy):
	enemies.push_back(enemy);

func _process(delta):
	if player.time <= 0 and !get_node("CanvasLayer/dialog").visible: # make sure the laser animation has finished
		
		# Check if all enemies died
		for enemy in enemies:
			if not enemy.dead:
				if player.get_parent().dead:
					# The player died before completing the level!
					on_death();
				return;
		
		# The level has been completed!
		on_complete(player.get_parent().dead);

func on_complete(player_dead):
	done = true;
	if player_dead:
		get_node("CanvasLayer/dialog").show_dialog(end_dead_text[level]);
	else:
		get_node("CanvasLayer/dialog").show_dialog(end_text[level]);
	pass;

func on_death():
	if level == levels.size() - 1:
		get_node("CanvasLayer/dialog").show_dialog(start_text[level]);
	else:
		get_node("CanvasLayer/dialog").show_dialog(destroyed[d_count]);
		if d_count < destroyed.size() - 1:
			d_count += 1;

func dialog_end():
	if done: # Player completed level
		# Next level
		level += 1;
		if level < levels.size():
			load_level(true);
		else:
			get_tree().quit(0);
	elif player.get_parent().dead: # Player died
		# Reset level
		get_node("CanvasLayer/dialog").visible = false;
		load_level(false);
		pass;
	else: # Intro text
		# Hide dialog
		get_node("CanvasLayer/dialog").visible = false;

func load_level(show_text):
	if level_node != null:
		remove_child(level_node);
		player = null;
		enemies = [];
		doors = [];
		done = false;
	
	level_node = levels[level].instance();
	add_child(level_node);
	
	if show_text:
		get_node("CanvasLayer/dialog").show_dialog(start_text[level]);

func on_kill():
	for door in doors:
		door.on_kill();
