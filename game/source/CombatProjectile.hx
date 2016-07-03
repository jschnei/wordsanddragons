package;

class CombatProjectile extends CombatEntity
{
    var timeToCollide:Int;
    public function new(maxHP:Int,
                        name:String,
                        attackDamage:Int,
                        time:Int)
    {
        super(maxHP, name, attackDamage);
        timeToCollide = time;
    }

    public function getDefensePriority(attackWord:String)
    {
        
    }
}