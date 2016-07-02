package;

class CombatEnemy extends CombatEntity
{
	public function new(maxHP:Int,
                        name:String,
                        attackDamage:Int)
    {
        super(maxHP, name, attackDamage);
    }

    public function calculateDamageTaken(attackWord:String):Int
    {
        throw "must instantiate subclass of CombatEnemy";
    }
}

class TriangleEnemy extends CombatEnemy
{
    public function new(maxHP:Int=30,
                        name:String='anderson',
                        attackDamage:Int=1)
    {
        super(maxHP, name, attackDamage);
    }

    public override function calculateDamageTaken(attackWord:String):Int
    {
        return CombatUtil.getTriangleDamage(attackWord);
    }
}
