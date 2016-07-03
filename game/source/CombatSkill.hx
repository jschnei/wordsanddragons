package;

class CombatSkill
{
    //todo: maybe have skill take more arguments?
    var skill:CombatHandler->Void;
    var cooldown:Int;
    var maxCooldown:Int;
    var trigger:String;

    public function new(skill:CombatHandler->Void, 
                        trigger:String, 
                        maxCooldown:Int)
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

        this.skill = skill;
        this.trigger = trigger;
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

public function makeThrowRockSkill(trigger:String="tick", cd:Int=1200):CombatSkill
{
    //var skillFunction:CombatHandler->Void = function(handler:CombatHandler) 
}