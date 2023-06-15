#https://ieeexplore.ieee.org/document/7152411
#https://www.youtube.com/watch?v=p3jDJ9FtTyM&ab_channel=JumpTrajectory
#https://github.com/gasgiant/Aircraft-Physics

extends Node
class_name AeroSurface

@export var config: AeroSurfaceConfig = null
@export var IsControlSurface: bool
@export var InputMultiplier: float = 1.0

var Active: bool = false

func _init():
	self.Active = true

var flapAngle :float

func SetFlapAngle(angle: float) -> void:
	flapAngle = clampf(angle, -deg_to_rad(50), deg_to_rad(50))

func CalculateForces(worldAirVelocity: Vector3, airDensity: float, relativePosition: Vector3) -> Vector3:
	var forceAndTorque: Vector3 = Vector3()
	if not Active or config == null:
		return forceAndTorque

	var correctedLiftSlope: float = config.liftSlope * config.aspectRatio \
	/(config.aspectRatio + 2 * (config.aspectRatio + 4) / (config.aspectRatio + 2))

	var theta: float = acos(2 * config.flapFraction -1)
	var flapEffectiveness: float = 1 - (theta - sin(theta)) / PI
	var deltaLift: float = correctedLiftSlope * flapEffectiveness * FlapEffectivenessCorrection(flapAngle) * flapAngle

	#Need to figure out if this is supposed to be deg_2_rad(config.zeroLiftAoA) or some multiplication factor.
	#Refer to IEEE link in header
	zeroLiftAoABase = config.zeroLiftAoA * deg_to_rad