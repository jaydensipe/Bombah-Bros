extends Node
class_name PhysicsUtil

# Thanks, https://youtu.be/_kA1fbBH4ug
static func calculate_arc_velocity(from, to, arc_height, gravity = ProjectSettings.get_setting("physics/2d/default_gravity")) -> Vector2:
	var linear_velocity = Vector2()
	
	var displacement = to - from
	var time_up = sqrt(-2 * arc_height / float(gravity))
	var time_down = sqrt(2 * (displacement.y - arc_height) / float(gravity))
	
	linear_velocity.y = -sqrt(-2 * gravity * arc_height)
	linear_velocity.x = displacement.x / float(time_up + time_down)
	
	return linear_velocity
	
