package;

class CombatEntity
{
    var maxHP:Int;
    var HP:Int;
    var name:String;
    var attackDamage:Int;
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
