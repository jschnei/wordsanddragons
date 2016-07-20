package combat;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using Lambda;

class EnemyHUD extends FlxTypedGroup<FlxSprite>
{
    public static inline var ENEMY_MARGIN = 10.0;

    private var _handler:CombatHandler;
    private var _enemySprites:Map<CombatEnemy, CombatEntitySprite>;

    private var _enemiesLeft:Float;
    private var _enemiesRight:Float;
    private var _enemiesY:Float;


    public function new(handler:CombatHandler)
    {
        super();

        _handler = handler;

        _enemySprites = new Map<CombatEnemy, CombatEntitySprite>();
        for(enemy in _handler.enemies)
        {
            addEnemySprite(enemy);
        }

        //may want to pass in the .tmx file
        var hudObjects:TiledMap = new TiledMap("assets/data/combatscreen.tmx");
        var layer:TiledObjectLayer = cast hudObjects.getLayer("enemySprites");

        for (o in layer.objects)
        {
            switch(o.name)
            {
                case "enemy":
                    _enemiesY = o.y;
                    _enemiesLeft = o.x;
                    _enemiesRight = o.x+o.width;
            }
        }

        updateEntities();
    }

    public function addEnemySprite(enemy:CombatEnemy):Void
    {
    //    trace("NEW ENEMY!");
        var enemySprite = new CombatEntitySprite(enemy, "assets/images/alphabob.png", true);
        _enemySprites.set(enemy, enemySprite);
        for(sprite in enemySprite)
            add(sprite);
    }

    public function destroyEnemySprite(enemy:CombatEnemy):Void
    {
    //    trace("DESTRUCTION!");
        var enemySprite:CombatEntitySprite = _enemySprites.get(enemy);
        _enemySprites.remove(enemy);
        for(sprite in enemySprite)
            remove(sprite);
        enemySprite.destroy();
    }

    public function updateEntities():Void
    {
        var curX:Float = _enemiesLeft;

        for(enemy in _handler.enemies)
        {
            if(!_enemySprites.exists(enemy))
            {
                addEnemySprite(enemy);
            }

            var enemySprite:CombatEntitySprite = _enemySprites.get(enemy);

            enemySprite.setPosition(curX, _enemiesY);
            enemySprite.updateHealthBar();

            curX += enemySprite.getWidth() + ENEMY_MARGIN;
        }

        // garbage collection
        for(enemy in _enemySprites.keys())
        {
            if(!_handler.enemies.exists(function(e) return e==enemy))
            {
                destroyEnemySprite(enemy);
            }
        }
    }

}
