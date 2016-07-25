package combat;

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
        skills.push(new CombatSkill.SkillThrowRock());
    }

    public override function calculateDamageTaken(attackWord:String):Int
    {
        return CombatUtil.getTriangleDamage(attackWord);
    }
}

class BombEnemy extends CombatEnemy
{
    public function new(maxHP:Int=8,
                        name:String="bob",
                        attackDamage:Int=0)
    {
        super(maxHP, name, attackDamage);
        skills.push(new CombatSkill.SkillMakeBomb());
    }

    public override function calculateDamageTaken(attackWord:String):Int
    {
        return CombatUtil.getTriangleDamage(attackWord);
    }  
}