extends CharacterBody3D
var vel=2.0
func _physics_process(delta):
	$NavigationAgent3D.target_position=get_node("../personagem").position*Vector3(1,0,1)
	var dest=$NavigationAgent3D.get_next_path_position()
	var dir = self.position.direction_to(dest)
	self.velocity=dir*vel
	self.move_and_slide()	
