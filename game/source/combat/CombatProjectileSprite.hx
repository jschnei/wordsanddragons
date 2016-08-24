package combat;

import flixel.FlxSprite;
import flixel.text.FlxText;

//right now, assumes that only kind of projectile is RockProjectile
//so this class should really be called RockProjectileSprite
class CombatProjectileSprite extends CombatEntitySprite
{
    private var _rockText:FlxText;

    //this startX, startY thing is still pretty silly
    //TODO: have more flexible projectile paths
    public var startX:Float;
    public var startY:Float;

    public function new(X:Float=0,
                        Y:Float=0,
                        projectile:CombatProjectile,
                        imageFile:String)
    {
        super(X, Y, projectile, imageFile, false);

        startX = X;
        startY = Y;

        var rockProj:CombatProjectile.RockProjectile = cast projectile;
        trace("letters: " + rockProj.letters);
        _rockText = new FlxText(0, 0, 0, rockProj.letters.join(""), 15);
        add(_rockText);
    }

    public function updatePosition(endX:Float, endY:Float):Void
    {
        var rockProj:CombatProjectile.RockProjectile = cast entity;
        var frac:Float = 1-rockProj.timeToCollide/rockProj.maxTimeToCollide;
        
        _sprite.x = startX + frac*(endX-startX);
        _sprite.y = startY + frac*(endY-startY);

        _rockText.x = _sprite.x + (_sprite.width-_rockText.width)/2;
        _rockText.y = _sprite.y + _sprite.height;
    }
}