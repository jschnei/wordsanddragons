package;

class CombatPlayer extends CombatEntity
{
	public function new(maxHP:Int=50,
                        name:String='player',
                        attack_damage:Int=1)
    {
        super(maxHP, name, attack_damage);
    }
}
