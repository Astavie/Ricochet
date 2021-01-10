extends StaticBody2D

export(Vector2) var normal = Vector2.DOWN;

func is_correct_orientation(vec: Vector2):
	return abs(vec.angle_to(normal.rotated(rotation))) < 0.01;
