package;

class CombatEntity
{
    var maxHP:Int;
    var HP:Int;
    var name:String;
    var attack_damage:Int;
    var alive:Bool;

	public function new(maxHP:Int,
                        name:String,
                        attack_damage:Int)
    {
        this.maxHP = maxHP;
        this.HP = this.maxHP;
        this.name = name;
        this.attack_damage = attack_damage;
        this.alive = true;
    }

    public function heal(amount):Void
    {
        HP += amount;
        if(HP > maxHP)
            HP = maxHP;
    }

    public function take_damage(amount):Void
    {
        HP -= amount;
        if(HP <= 0)
            die();
    }

    public function die():Void
    {
        trace(name + " died.");
        alive = False;
    }

    public function attack(target:CombatEntity)
    {
        target.take_damage(attack_damage);
    }

    public function disp_str():String
    {
        return (HP + '/' + maxHP);
    }
}
