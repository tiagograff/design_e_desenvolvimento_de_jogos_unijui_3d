extends CPUParticles3D

var t=1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	emitting=true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t-=delta
	if t<=0:
		queue_free()
