package combat;

class CombatSkill
{
    public var cooldown:Int;
    public var maxCooldown:Int;
    public var owner:CombatEntity;

    //note:trigger is "tick" for passive skills that get activated every x seconds
    //trigger is "attack" for passive skills that activate every attack
    //trigger is "skillbar" for active skills on the player's skillbar
    public var trigger:String;

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

    public function skill(handler:CombatHandler, ?params:Map<String, String>):Void
    {
        throw "must instantiate subclass of CombatSkill";
    }

    public function activate(handler:CombatHandler, ?params:Map<String, String>):Void
    {
        if (cooldown > 0)
        {
            trace("You cooldown dummy!");
            return;
        }
        skill(handler, params);
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

    //yeah I know it's a public variable but this is still probably good form
    public function setOwner(owner:CombatEntity):Void
    {
        this.owner = owner;
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

    public override function skill(handler:CombatHandler, ?params:Map<String, String>):Void
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

    public override function skill(handler:CombatHandler, ?params:Map<String, String>):Void
    {
        var attackWord:String = params.get('attackWord');

        if(attackWord.length>0 && attackWord.charAt(0)=='H')
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

    public override function skill(handler:CombatHandler, ?params:Map<String, String>):Void
    {
        handler.pool = CombatUtil.generatePool(handler.pool.slice(numLetters));
    }
}

class SkillSpawnEnemy extends CombatSkill
{
    public function new(trigger:String='tick',
                        maxCooldown:Int=1200)
    {
        super(trigger, maxCooldown);
    }

    public override function skill(handler:CombatHandler, ?params:Map<String, String>):Void
    {
        handler.enemies.push(new CombatEnemy.TriangleEnemy());
    }
}

class SkillThrowRock extends CombatSkill
{
    public function new(trigger:String='tick',
                        maxCooldown:Int=1400)
    {
        super(trigger, maxCooldown);
    }

    public override function skill(handler:CombatHandler, ?params:Map<String, String>):Void
    {
        handler.projectiles.push(new CombatProjectile.RockProjectile());
    }
}

class SkillMakeBomb extends CombatSkill
{
    public function new(trigger:String='tick',
                        maxCooldown:Int=600)
    {
        super(trigger, maxCooldown);
    }

    public override function skill(handler:CombatHandler, ?params:Map<String, String>):Void
    {

    }
}
