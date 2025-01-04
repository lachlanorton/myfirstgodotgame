extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var health = 3
var died = false
var is_being_hit = false
var is_healing = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var reset_game_timer: Timer = %ResetGameTimer
@onready var health_bar: AnimatedSprite2D = $HealthBar

# This function handles player death. Either called from here when player health reaches 0
# or called from killzone.gd when player enters WorldVoid.
# Slows game time, plays death animation, shows label, then starts reset game timer.
func playerDied():
	died = true
	Engine.time_scale = 0.5
	animated_sprite.play("death")
	animation_player.play("audio_hit")
	animation_player.play("anim_SFX_death")
	self.get_node("CollisionShape2D").queue_free()
	var death_label = self.get_node("Camera2D/DeathLabel")
	death_label.visible = true
	reset_game_timer.start()

# This function handles player taking damage. 
# It is called from killzone.gd when the killzone is not a WorldVoid.
func playerHit():
	if is_being_hit:
		return
	is_being_hit = true
	health -= 1
	health_bar.set_frame(int(health))
	if health <= 0:
		playerDied()
	else:
		animation_player.play("audio_hit")
		animated_sprite.play("hit")
		var hit_anim_fin = animated_sprite.animation_finished
		await(hit_anim_fin)
		is_being_hit = false

# This function handles player healing. It is called from fruit.gd when body collides with fruit.
func playerHeal():
	if is_healing:
		return
	if health == 3:
		return
	else:
		health += 1
		# Update health bar animated sprite
		health_bar.set_frame(int(health))
		# Run heal animation, wait until animation is finished, then continue
		# This allows for heal animation to run, rather than being overruled by idle/jump/run animations
		animated_sprite.play("heal")
		var heal_anim_fin = animated_sprite.animation_finished
		await(heal_anim_fin)
		is_healing = false

# This function handles player movement and animation.
func _physics_process(delta: float) -> void:
	if died:
		# Stop player momentum
		velocity = Vector2.ZERO
	if !died:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump and related sfx.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			animation_player.play("anim_jump")

		# Get the input direction and handle the movement/deceleration.
		# move right means direction = 1
		# move left means direction = -1
		var direction := Input.get_axis("move_left", "move_right")
	
		# update sprite animation based on action
		# First check that player is not currently being hit or healing
		if !is_being_hit and !is_healing:
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
	
		# If a direction is being input, move player in that direction	
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		move_and_slide()
	

# This function runs after the reset_game_timer has completed. It restarts the level.
func _on_reset_game_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

# When player loads in, health bar animated sprite is set to current health
func _on_ready() -> void:
	health_bar.set_frame(int(health))
