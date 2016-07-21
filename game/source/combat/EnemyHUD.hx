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
    private var _projectiles:Map<CombatProjectile, CombatProjectileSprite>;

    private var _enemiesLeft:Float;
    private var _enemiesRight:Float;
    private var _enemiesY:Float;

    private var _projectileStartX:Float;
    private var _projectileStartY:Float;
    private var _projectileEndX:Float;


    public function new(handler:CombatHandler)
    {
        super();

        _handler = handler;

        _enemySprites = new Map<CombatEnemy, CombatEntitySprite>();
        _projectiles = new Map<CombatProjectile, CombatProjectileSprite>();

        for(enemy in _handler.enemies)
        {
            addEnemySprite(enemy);
        }
        for(proj in _handler.projectiles)
        {
            addProjSprite(proj);
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
                case "projectile":
                    _projectileStartX = o.x;
                    _projectileStartY = o.y;
                    _projectileEndX = o.x+o.width;
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

    public function addProjSprite(proj:CombatProjectile):Void
    {
        var projSprite = new CombatProjectileSprite(proj, "assets/images/trashcan.png");
        _projectiles.set(proj, projSprite);
        for(sprite in projSprite)
            add(sprite);
    }

    public function destroyProjSprite(proj:CombatProjectile):Void
    {
        var projSprite:CombatProjectileSprite = _projectiles.get(proj);
        _projectiles.remove(proj);
        for(sprite in projSprite)
            remove(sprite);
        projSprite.destroy();
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

        var shift:Float = (_enemiesRight - curX)/2;

        //center enemies
        forEach(function(spr:FlxSprite){
            spr.x = spr.x + shift;
        });

        for(proj in _handler.projectiles)
        {
            if (!_projectiles.exists(proj))
            {
                addProjSprite(proj);
            }

            var projSprite:CombatProjectileSprite = _projectiles.get(proj);
            projSprite.updatePosition(_projectileStartX, _projectileStartY, _projectileEndX);
        }

        // garbage collection
        for(enemy in _enemySprites.keys())
        {
            if(!_handler.enemies.exists(function(e) return e==enemy))
            {
                destroyEnemySprite(enemy);
            }
        }

        for(proj in _projectiles.keys())
        {
            if(!_handler.projectiles.exists(function(p) return p==proj))
            {
                destroyProjSprite(proj);
            }
        }
    }

}
