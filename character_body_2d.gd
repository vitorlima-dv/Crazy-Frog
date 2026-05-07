extends CharacterBody2D

const VELOCIDADE = 300.0
const VELOCIDADE_PULO = -700.0
const GRAVIDADE = 1500.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer

var crouch := false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVIDADE * delta

	# Agachar só no chão
	crouch = Input.is_action_pressed("crouch") and is_on_floor()

	var direcao := Input.get_axis("move_left", "move_right")

	# Bloqueia movimento horizontal ao agachar
	if crouch:
		velocity.x = 0.0
	else:
		velocity.x = direcao * VELOCIDADE

	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not crouch:
		velocity.y = VELOCIDADE_PULO

	if direcao != 0.0:
		sprite.flip_h = direcao < 0.0

	_atualizar_animacao()
	move_and_slide()

func _atualizar_animacao() -> void:
	if crouch:
		_tocar("crouch")
	elif not is_on_floor():
		if velocity.y < 0:
			_tocar("jump")
		else:
			_tocar("fall")
	elif velocity.x != 0.0:
		_tocar("move")
	else:
		_tocar("idle")

func _tocar(nome: String) -> void:
	if anim.current_animation != nome:
		anim.play(nome)
