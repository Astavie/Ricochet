extends Node2D

var _text: String;

var time = 0.033;
var timer = 0;

func show_dialog(text):
	visible = true;
	_text = text;
	get_node("NinePatchRect/Label").text = "";
	if text == "":
		get_node("../..").dialog_end();
		if !get_node("../../music").playing and !get_node("../../finish").playing:
			get_node("../../music").play();

func _process(delta):
	var label = get_node("NinePatchRect/Label");
	if timer <= 0 and label.text.length() < _text.length():
		timer = time;
		label.text = _text.substr(0, label.text.length() + 1);
		if !get_node("blip").playing and !get_node("../../finish").playing:
			get_node("blip").play();
		
		var last = label.text.substr(label.text.length() - 1, 1);
		if last == "." || last == "!" || last == "," || last == "?" || last == ":" || last == ";":
			timer *= 5;
	else:
		timer -= delta;

func _input(event):
	if visible:
		if (event is InputEventMouseButton and event.pressed) or event.is_action_pressed("ui_accept"):
			var label = get_node("NinePatchRect/Label");
			if label.text.length() < _text.length():
				label.text = _text;
			else:
				get_node("../..").dialog_end();
				if !get_node("../../music").playing and !get_node("../../finish").playing:
					get_node("../../music").play();
