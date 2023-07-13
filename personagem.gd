extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var rotate_speed=0.005
var explosao_comp=preload("res://explosao.tscn")
var explosao2_comp=preload("res://explosao2.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity.
	if Input.is_action_just_pressed("tiro"):
		if $Camera3D/ray.is_colliding():
			var p = $Camera3D/ray.get_collision_point()
			var explosao2=explosao2_comp.instantiate()
			explosao2.position=p
			get_node("..").add_child(explosao2)
			var c=$Camera3D/ray.get_collider()
			if c.is_in_group("inimigo"):
				c.queue_free()
				var explosao=explosao_comp.instantiate()
				explosao.position=p
				get_node("..").add_child(explosao)				
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("esq", "dir", "cima", "baixo")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	
func _unhandled_input(event):	
	if event is InputEventMouseMotion:
		rotate(Vector3.DOWN, event.relative.x * rotate_speed)
		rotate(transform.basis * Vector3.RIGHT, -event.relative.y * rotate_speed)



func _on_hitbox_body_entered(body):
	if body.is_in_group("inimigo"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_node("../gameover").visible=true
		get_tree().paused=true
		
