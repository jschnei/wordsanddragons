package;

using Lambda;

enum CombatMode
{
	OFFENSE;
	DEFENSE;
}

class CombatHandler
{
    public var player:CombatPlayer;
    var enemies:Array<CombatEnemy>;
    var pool:Array<String>;
    var combatMode:CombatMode;

	public function new()
    {
        player = new CombatPlayer();
        enemies = new Array<CombatEnemy>();
        enemies.push(new CombatEnemy.TriangleEnemy());
        pool = CombatUtil.generatePool();
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
            for (enemy in enemies)
            {
                var damage = enemy.calculateDamageTaken(attackWord);
                enemy.takeDamage(damage);
            }
            enemies = enemies.filter(function(enemy) return enemy.alive);

            pool = CombatUtil.generatePool(CombatUtil.processAttack(attackWord,pool));
        }
    }

}
