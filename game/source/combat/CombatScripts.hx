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

    public static function getGoblinHandler(name:String):CombatHandler
    {
        var handler:CombatHandler = new CombatHandler();
        if (name=="Gob the Goblin")
        {
            handler.enemies.push(new CombatEnemy.DoubleLetterEnemy(15));
        }
        else if (name=="Bob the Goblin")
        {
            var triangleEnemy:CombatEnemy = new CombatEnemy.TriangleEnemy();
            triangleEnemy.skills.push(new CombatSkill.SkillThrowRock(200));
            handler.enemies.push(triangleEnemy);
        }
        return handler;
    }
}