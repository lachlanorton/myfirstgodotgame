extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var health = 3
var died = false
var is_being_hit = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var reset_game_timer: Timer = %ResetGameTimer
@onready var health_bar: AnimatedSprite2D = $HealthBar

func playerDied():
	died = true
	Engine.time_scale = 0.5
	animated_sprite.play("death")
	animation_player.play("anim_SFX_death")
	self.get_node("CollisionShape2D").queue_free()
	var death_label = self.get_node("Camera2D/DeathLabel")
	death_label.visible = true
	reset_game_timer.start()

func playerHit():
	if is_being_hit:
		return
	is_being_hit = true
	health -= 1
	animation_player.play("audio_hit")
	animated_sprite.play("hit")
	var hit_anim_fin = animated_sprite.animation_finished
	health_bar.set_frame(int(health))
	if health <= 0:
		playerDied()
	else:
		await(hit_anim_fin)
		is_being_hit = false

func playerVoid():
	health == 0
	playerDied()

func _physics_process(delta: float) -> void:
	if died:
		# Stop player momentum
		velocity = Vector2.ZERO
	if !died:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			animation_player.play("anim_jump")

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		# move right = direction = 1
		# move left = direction = -1
		var direction := Input.get_axis("move_left", "move_right")
	
		# update sprite animation based on action
		if !is_being_hit:
			if is_on_floor():
				if direction == 0:
					animated_sprite.play("idle")
				else:
					animated_sprite.play("run")
			else:
				animated_sprite.play("jump")
		
		# Flip sprite based on direction player is moving
		if direction > 0:
			animated_sprite.flip_h = false
		if direction < 0:
			animated_sprite.flip_h = true
	
			
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	


func _on_reset_game_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _on_ready() -> void:
	health_bar.set_frame(int(health))
