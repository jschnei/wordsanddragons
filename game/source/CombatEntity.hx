package;

class CombatEntity
{
    public var maxHP:Int;
    public var HP:Int;
    public var name:String;
    public var attackDamage:Int;
    public var skills:Array<CombatSkill>;
    public var alive:Bool;


	public function new(maxHP:Int,
                        name:String,
                        attackDamage:Int)
    {
        this.maxHP = maxHP;
        this.HP = this.maxHP;
        this.name = name;
        this.attackDamage = attackDamage;
        this.alive = true;
        this.skills = new Array<CombatSkill>();
    }

    public function heal(amount):Void
    {
        HP += amount;
        if(HP > maxHP)
            HP = maxHP;
    }

    public function takeDamage(amount):Void
    {
        HP -= amount;
        if(HP <= 0)
            die();
    }

    public function die():Void
    {
        trace(name + " died.");
        alive = false;
    }

    public function attack(target:CombatEntity)
    {
        target.takeDamage(attackDamage);
    }

    public function dispStr():String
    {
        return (HP + '/' + maxHP);
    }
}
