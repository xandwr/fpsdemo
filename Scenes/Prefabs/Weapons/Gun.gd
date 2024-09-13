class_name Gun extends Weapon

@export var ammo_count: int
@export var max_ammo: int
@export var shoot_sound: AudioStream
@export var reload_sound: AudioStream

@onready var shoot_audio_player: AudioStreamPlayer3D = $ShootAudioPlayer
@onready var reload_audio_player: AudioStreamPlayer3D = $ReloadAudioPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var particle_emitter: GPUParticles3D = $MuzzleFlash/GPUParticles3D
@onready var muzzle_flash_light: OmniLight3D = $MuzzleFlash/OmniLight3D
@onready var camera: Camera3D = $"../.."

var can_reload: bool = false
var is_reloading: bool = false  # Track if reload is happening
var is_firing: bool = false  # New variable to track if firing animation is in progress
var gun_ray_length: float = 1000.0


func _ready() -> void:
	shoot_audio_player.stream = shoot_sound
	reload_audio_player.stream = reload_sound
	muzzle_flash_light.visible = false


func _process(_delta: float) -> void:
	can_reload = ammo_count < max_ammo


func fire():
	if not get_tree().paused:
		# Prevent firing if reloading, if fire cooldown is active, or if firing animation is in progress
		if ammo_count > 0 and can_fire and not is_reloading and not is_firing:
			# Block input until the firing process is done
			is_firing = true  # Set firing state to block further input
			
			# Play shoot sound
			shoot_audio_player.play()
			
			# Play particle emitter and enable muzzle flash light
			particle_emitter.emitting = true
			muzzle_flash_light.visible = true
			
			# Cast raycast
			var screen_center = get_viewport().get_camera_3d().get_window().size / 2
			var from = camera.project_ray_origin(screen_center)
			var direction = camera.project_ray_origin(screen_center)
			var to = from + direction * gun_ray_length
			var space_state = get_world_3d().direct_space_state
			var params = PhysicsRayQueryParameters3D.new()
			params.from = from
			params.to = to
			var result = space_state.intersect_ray(params)
			
			if result.size() > 0:
				var hit_position = result.position
				print("Hit at: ", hit_position)
			
			# Play fire animation
			if not animation_player.is_playing() or animation_player.current_animation != "shoot":
				animation_player.play("shoot")
			
			await get_tree().create_timer(0.1).timeout
			muzzle_flash_light.visible = false
			
			# Reduce ammo and start cooldown
			ammo_count -= 1
			can_fire = false  # Disable firing until the cooldown is over
			
			# Wait for cooldown and end firing state
			await start_fire_cooldown()
		elif ammo_count == 0:
			print("No ammo")


func reload():
	if not get_tree().paused:
		# Prevent reloading if already reloading or if no need to reload
		if can_reload and not is_reloading:
			is_reloading = true  # Set reloading flag
			reload_audio_player.play()
			animation_player.play("reload")
			can_reload = false
			can_fire = false  # Disable firing during reload
			await start_reload_cooldown()


func start_fire_cooldown() -> void:
	# Wait for the fire animation to complete
	await get_tree().create_timer(animation_player.get_animation("shoot").length).timeout
	is_firing = false  # Allow firing again after animation finishes
	
	# After the cooldown, check if reloading is still happening
	if not is_reloading:
		# Add a small debounce to the animation to prevent glitches when spammed
		await get_tree().create_timer(0.05).timeout
		can_fire = true


func start_reload_cooldown() -> void:
	# Wait for the reload animation to finish
	await get_tree().create_timer(animation_player.get_animation("reload").length).timeout
	
	# After the animation finishes, refill ammo and allow firing again
	ammo_count = max_ammo
	
	# Add a small debounce to the animation to prevent glitches when spammed
	await get_tree().create_timer(0.05).timeout
	can_reload = true
	can_fire = true  # Allow firing after reload completes
	is_reloading = false  # Reset reloading flag
