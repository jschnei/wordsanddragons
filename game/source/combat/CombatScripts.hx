package combat;

class CombatScripts
{
    //set things like enemies in combat and skills
    public static function getBobHandler():CombatHandler
    {
        var handler:CombatHandler = new CombatHandler();
        handler.enemies.push(new CombatEnemy.DoubleLetterEnemy());
        handler.enemies.push(new CombatEnemy.TriangleEnemy());

        return handler;
    }
}