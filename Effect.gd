extends Resource

class_name Effect

enum ETypes {Cards, Amount, Type, buffHealth, BuffAttackDamage, EffectCommand, EffectOption, Category}

@export var Command: String
@export var RequiredVars: Array[String]
@export var VarsTypes: Array[ETypes]


@export var OptionLimit: Array[int] # if Etype is EffectCommand, how many effects that can be used.


func ConvertToJSON() -> Dictionary:
	return {"Command": Command}
