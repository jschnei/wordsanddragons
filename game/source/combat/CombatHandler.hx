package combat;

import flixel.input.keyboard.FlxKey;
import haxe.ds.Vector;

using Lambda;

enum CombatMode
{
	OFFENSE;
	DEFENSE;
}

enum CombatOutcome
{
    WIN;
    LOSS;
}

class CombatHandler
{
    public var player:CombatPlayer;
    public var enemies:Array<CombatEnemy>;
    public var projectiles:Array<CombatProjectile>;
    public var pool:Array<String>;
    public var handlerSkills:Array<CombatSkill>;

    public var combatMode:CombatMode;
    public var turn:Int;

	public function new()
    {
        player = new CombatPlayer();
        player.skills.push(new CombatSkill.SkillHealPlayer());
        player.addSkillBarSkill(FlxKey.ONE, new CombatSkill.SkillRecycle());

        pool = CombatUtil.generatePool();

        enemies = new Array<CombatEnemy>();
        enemies.push(new CombatEnemy.BombEnemy());

        handlerSkills = new Array<CombatSkill>();
        //handlerSkills.push(new CombatSkill.SkillSpawnEnemy());

        projectiles = new Array<CombatProjectile>();

        combatMode = CombatMode.OFFENSE;
        turn = 0;
    }

    public function switchModes():Void
    {
        if(combatMode==CombatMode.OFFENSE)
        {
            combatMode = CombatMode.DEFENSE;
        }
        else if(combatMode==CombatMode.DEFENSE)
        {
            combatMode = CombatMode.OFFENSE;
        }
    }

    public function prettyPrint():Void
    {
        trace(pool);
        trace(player);
        for (enemy in enemies)
            trace(enemy);
    }

    public function processAttack(attackWord:String):Void
    {
        if (!CombatUtil.checkAttack(attackWord, pool))
        {
            trace("You dumbo!");
        }
        else
        {
            // apply attack skills
            var params:Map<String, String> = new Map<String, String>();
            params.set('attackWord', attackWord);
            for (skill in player.skills)
            {
                if(skill.trigger=="attack")
                    skill.activate(this, params);
            }


            for (enemy in enemies)
            {
                var damage = enemy.calculateDamageTaken(attackWord);
                enemy.takeDamage(damage);
            }
            enemies = enemies.filter(function(enemy) return enemy.alive);

            pool = CombatUtil.generatePool(CombatUtil.processAttack(attackWord,pool));
        }
    }

    public function processDefense(defenseWord:String):Void
    {
        if(projectiles.length == 0)
            return;

        var target:CombatProjectile = projectiles[0];
        var targetPriority:Vector<Int> = projectiles[0].getDefensePriority(defenseWord);

        for(i in 1...projectiles.length)
        {
            var curPriority:Vector<Int> = projectiles[i].getDefensePriority(defenseWord);
            if(CombatProjectile.comparePriority(curPriority, targetPriority))
            {
                target = projectiles[i];
                targetPriority = curPriority;
            }
        }

        if(targetPriority[0]>0)
            target.processDefense(defenseWord, this);

        projectiles = projectiles.filter(function(pr) return pr.alive);
    }

    public function tick():Void
    {
        for(skill in player.skills)
        {
            if(skill.trigger=="tick")
                skill.tick(this);
        }

        for(skill in player.skillBar)
        {
            skill.tick(this);
        }

        for(enemy in enemies)
        {
            for(skill in enemy.skills)
            {
                if(skill.trigger=="tick")
                    skill.tick(this);
            }
        }

        for(projectile in projectiles)
        {
            projectile.tick(this);
        }
        projectiles = projectiles.filter(function(pr) return pr.alive);

        for(skill in handlerSkills)
        {
            if(skill.trigger=="tick")
                skill.tick(this);
        }

        turn++;
    }

    public function isGameOver():Bool
    {
        return (!player.alive || enemies.length==0);
    }

    //some hacky thing for now, eventually we might have situations where combatoutcome cannot be deduced from end state
    public function getOutcome():CombatOutcome
    {
        if (player.alive)
            return WIN;
        else
            return LOSS;
    }

}
