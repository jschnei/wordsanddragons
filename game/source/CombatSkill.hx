package;

class CombatSkill
{
    var cooldown:Int;
    var maxCooldown:Int;
    var trigger:String;

    public function new(trigger:String,
                        maxCooldown:Int=0)
    {
        this.maxCooldown = maxCooldown;
        if (trigger=="tick")
        {
            this.cooldown = maxCooldown;
        }
        else
        {
            this.cooldown = 0;
        }

        this.trigger = trigger;
    }

    public function skill(handler:CombatHandler, ?params:Dynamic):Void
    {
        throw "must instantiate subclass of CombatSkill";
    }

    public function activate(handler:CombatHandler):Void
    {
        if (cooldown > 0)
        {
            trace("You cooldown dummy!");
            return;
        }
        skill(handler);
        cooldown = maxCooldown;
    }

    public function tick(handler:CombatHandler):Void
    {
        if (cooldown>0)
            cooldown--;
        else
            if (trigger=="tick")
                activate(handler);
    }
}

class SkillAttackPlayer extends CombatSkill
{
    var attackDamage:Int;

    public function new(trigger:String='tick',
                        maxCooldown:Int=500,
                        attackDamage:Int=1)
    {
        super(trigger, maxCooldown);
        this.attackDamage = attackDamage;
    }

    public override function skill(handler:CombatHandler, ?params:Dynamic):Void
    {
        handler.player.takeDamage(attackDamage);
    }
}

class SkillHealPlayer extends CombatSkill
{
    var healAmount:Int;

    public function new(trigger:String='attack',
                        healAmount:Int=5)
    {
        super(trigger);
        this.healAmount = healAmount;
    }

    public override function skill(handler:CombatHandler, ?params:Dynamic):Void
    {
        var attackWord:String = params.attackWord;

        if(params.attackWord.length>0 && params.attackWord[0]=='H')
        {
            handler.player.heal(healAmount);
        }
    }
}

class SkillRecycle extends CombatSkill
{
    var numLetters:Int;

    public function new(trigger:String='skillbar',
                        maxCooldown:Int=1000,
                        numLetters:Int=3)
    {
        super(trigger, maxCooldown);
        this.numLetters = numLetters;
    }

    public override function skill(handler:CombatHandler, ?params:Dynamic):Void
    {
        handler.pool = generatePool(handler.pool.slice(numLetters));
    }
}

class SkillSpawnEnemy extends CombatSkill
{
    public function new(trigger:String='tick',
                        maxCooldown:Int=500)
    {
        super(trigger, maxCooldown);
    }

    public override function skill(handler:CombatHandler, ?params:Dynamic):Void
    {
        handler.enemies.push(new CombatEnemy.TriangleEnemy());
    }
}

class SkillThrowRock extends CombatSkill
{
    public function new(trigger:String='tick',
                        maxCooldown:Int=3000)
    {
        super(trigger, maxCooldown);
    }

    public override function skill(handler:CombatHandler, ?params:Dynamic):Void
    {
        handler.projectiles.push(new CombatProjectile.RockProjectile());
    }
}
