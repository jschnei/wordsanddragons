package;

import flixel.input.keyboard.FlxKey;

class CombatPlayer extends CombatEntity
{
    public var skillBar:Map<FlxKey, CombatSkill>;

	public function new(maxHP:Int=50,
                        name:String='player',
                        attack_damage:Int=1)
    {
        super(maxHP, name, attack_damage);
        skillBar = new Map<FlxKey, CombatSkill>();
    }

    public function addSkillBarSkill(key:FlxKey, skill:CombatSkill)
    {
        skillBar.set(key, skill);
    }
}
