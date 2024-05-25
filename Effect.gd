extends Resource

class_name Effect

enum ETypes {Cards, Amount, Type, buffHealth, BuffAttackDamage, EffectCommand, EffectOption, Category}


@export var Command: String

# the var name 
@export var RequiredVars: Array[String]
# Types of the vars 
@export var VarsTypes: Array[ETypes]
@export var Variables: Dictionary = {}
@export var OptionLimit: Array[int] # if Etype is EffectCommand, how many effects that can be used.


func ConvertToJSON() -> Dictionary:
	var Dict = {"Command": Command}
	if Variables != {}:
		Dict[Command] = Variables
	return Dict
