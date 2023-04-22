tool
extends Line2D
class_name WigglyAppendage2D


enum {
	PREVIOUS_POINT = 0,
	POSITION = 1,
	ROTATION = 2,
	ANGULAR_MOMENTUM = 3,
}


## Amout of segments
export(int, 1, 10) var segment_count: int = 5 setget _set_segment_count
## Length of segments
export var segment_length: float = 30.0
## How much the appendge should curve
export(float, -1.57, 1.57) var curvature: float = 0.0
export var curvature_exponent: float = 0.0
export(float, 0.0, 180.0, 0.01) var max_angle_degrees := 180.0 setget _set_per_segment_max_angle_degrees
var max_angle: float = TAU / 2 setget _set_per_segment_max_angle
export(float, 0, 6.28) var comeback_speed := 0.0
export var stiffness: float = 20.0
export var stiffness_decay: float = 0.0
export var stiffness_decay_exponent: float = 1.0
export var damping: float = 5.0
export var max_angular_momentum: float = 25.13
export var gravity := Vector2(0, 0)
export(int, 0, 10) var subdivisions: int = 2
export var only_process_when_visible := true


var bone_points: Array


func _ready():
	reset(segment_count + 1)


func _physics_process(delta):
	if (not is_visible_in_tree()) and only_process_when_visible:
		return
	for i in range(bone_points.size()):
		if i == 0:
			_process_root_point(bone_points[i], delta)
		else:
			_process_point(bone_points[i], delta, i)
	_update_line()


func reset(point_count):
	bone_points = []
	var starting_pos := get_global_position()
	var current_pos := starting_pos
	var offset_vector := Vector2(_get_true_segment_length(), 0).rotated(get_global_rotation())
	for i in range(point_count):
		offset_vector = offset_vector.rotated(_get_true_curvarute())
		current_pos += offset_vector
		var new_point := [
			null,
			current_pos,
			offset_vector.angle(),
			0.0,
		]
		if i != 0:
			new_point[PREVIOUS_POINT] = bone_points[-1]
		bone_points.append(new_point)


func get_global_point_positions() -> PoolVector2Array:
	var output := PoolVector2Array()
	for point in bone_points:
		output.append(point[POSITION])
	return output


func _process_point(point: Array, delta: float, index: int) -> void:
	var direction: Vector2 = point[PREVIOUS_POINT][POSITION].direction_to(point[POSITION])
	var point_rotation: float = direction.angle()
	var ideal_rotation: float = point[PREVIOUS_POINT][ROTATION] + _get_true_curvarute() * pow(float(index), curvature_exponent)
	ideal_rotation = fmod(ideal_rotation, TAU)
	var rotation_diff: float = _angle_difference(ideal_rotation, point_rotation)
	var actual_stiffness = (stiffness - pow(float(index), stiffness_decay_exponent) * stiffness_decay)
	actual_stiffness = max(0, actual_stiffness)
	var force: float = _signed_sqrt(rotation_diff) * actual_stiffness
	force += gravity.length() * cos(point_rotation - gravity.angle() + TAU / 4)
	if sign(force) != sign(point[ANGULAR_MOMENTUM]):
		force *= damping
	point[ANGULAR_MOMENTUM] += force * delta
	point[ANGULAR_MOMENTUM] = clamp(point[ANGULAR_MOMENTUM], - max_angular_momentum, max_angular_momentum)
	point_rotation += point[ANGULAR_MOMENTUM] * delta
	if abs(rotation_diff) > max_angle:
		point_rotation += rotation_diff - abs(max_angle) * sign(rotation_diff)
		if sign(point[ANGULAR_MOMENTUM]) != sign(rotation_diff) or abs(point[ANGULAR_MOMENTUM]) < comeback_speed:
			point[ANGULAR_MOMENTUM] = comeback_speed * sign(rotation_diff)
	point[ROTATION] = point_rotation
	point[POSITION] = point[PREVIOUS_POINT][POSITION] + Vector2(_get_true_segment_length(), 0).rotated(point_rotation)


func _process_root_point(point: Array, delta: float):
	point[POSITION] = get_global_position()
	point[ROTATION] = get_global_rotation()


func _update_line():
	var new_line_points := PoolVector2Array()
	for point in bone_points:
		new_line_points.append(to_local(point[POSITION]))
	new_line_points = _bezier_interpolate(new_line_points, subdivisions)
	points = new_line_points


func _bezier_interpolate(line: PoolVector2Array, subdivisions: int) -> PoolVector2Array:
	if subdivisions < 1: return line
	if line.size() < 3: return line
	var output := PoolVector2Array()
	for i in range(line.size() - 1):
		var a: Vector2
		var b: Vector2
		var c: Vector2
		var actual_subdivisions: int
		a = line[i]
		b = line[i + 1]
		var c_index := i + 2
		if c_index > line.size() - 1:
			var before_a := line[i - 1]
			var angle := _angle_difference((b - a).angle(), (a - before_a).angle())
			c = b + (b - a).rotated(angle)
			actual_subdivisions = (subdivisions) / 2 + 1
		else:
			c = line[c_index]
			actual_subdivisions = subdivisions
		var true_a = lerp(a, b, 0.5) if i != 0 else a
		var true_c = lerp(b, c, 0.5)
		for o in range(actual_subdivisions):
			var t: float = 1.0 / subdivisions * o
			var ab: Vector2 = lerp(true_a, b, t)
			var bc: Vector2 = lerp(b, true_c, t)
			output.append(lerp(ab, bc, t))
	return output


func _angle_difference(angle_a: float, angle_b: float) -> float:
	var diff := angle_a - angle_b
	if abs(diff) > TAU / 2.0:
		diff -= TAU * sign(diff)
	return diff


func _signed_sqrt(value: float) -> float:
	return sqrt(abs(value)) * sign(value)


func _get_true_segment_length() -> float:
	return segment_length * get_global_scale().x


func _get_true_curvarute() -> float:
	var gt = get_global_transform()
	var det = gt.x.x * gt.y.y - gt.x.y * gt.y.x
	return curvature * sign(det)


func _set_segment_count(value):
	segment_count = value
	reset(segment_count + 1)


func _set_per_segment_max_angle_degrees(value):
	max_angle_degrees = value
	max_angle = deg2rad(value)


func _set_per_segment_max_angle(value):
	max_angle = value
	max_angle_degrees = rad2deg(value)
