extends Object

var _length = 300;

const mirror = preload("mirror.gd");
const door = preload("door.gd");
const enemy = preload("enemy.gd");

func calc(current: Vector2, dir: Vector2, state: Physics2DDirectSpaceState, exclude: Array):
	var points = [];
	var enemies_hit = [];
	
	points.push_back(current);
	
	while (true):
		# Get next object in path
		var intersect = state.intersect_ray(current, current + dir * _length, exclude);
		if intersect:
			current = intersect.position;
			exclude = [intersect.collider];
			
			# If its an enemy, log and continue forwards
			if intersect.collider is enemy:
				enemies_hit.push_back(intersect.collider);
			
			# Else either reflect or stop
			else:
				points.push_back(current);
				if (intersect.collider is mirror and intersect.collider.is_correct_orientation(intersect.normal)) or intersect.collider is door:
					dir = (-dir).reflect(intersect.normal);
				else:
					break;
	
	return {
		"points": points,
		"enemies": enemies_hit
	};
