extends Bullet_Base


func _move_bullet(delta):
	global_translate(transform.basis.y * speed * delta)
