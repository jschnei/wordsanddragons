package;

enum CombatMode
{
	OFFENSE;
	DEFENSE;
}

class CombatHandler
{
    var player:CombatPlayer;
    var enemies:Array<CombatEnemy>;
    var pool:String;
    var combatMode:CombatMode;

	public function new()
    {
        player = new CombatPlayer();
        enemies = new Array<CombatEnemy>();
        enemies.add(new TriangleEnemy());
        
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


}
