package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class PlayerSprite extends FlxSprite
{
    public var speed:Float = 200;

    private var _marginInteract:Int = 5;

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
        makeGraphic(64, 64, FlxColor.BLUE);
        drag.x = 3000;
        drag.y = 3000;
        setSize(64, 64);
    }

    public function interactBox():FlxObject
    {
        return new FlxObject(x-_marginInteract, y-_marginInteract, width+2*_marginInteract, height+2*_marginInteract);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

    public function movement():Void
    {
        var _up:Bool = false;
        var _down:Bool = false;
        var _left:Bool = false;
        var _right:Bool = false;


        _up = FlxG.keys.anyPressed([UP, W]);
        _down = FlxG.keys.anyPressed([DOWN, S]);
        _left = FlxG.keys.anyPressed([LEFT, A]);
        _right = FlxG.keys.anyPressed([RIGHT, D]);

        if (_up && _down)
            _up = _down = false;
        if (_left && _right)
            _left = _right = false;

        if (_up || _down || _left || _right){
            var mA:Float = 0;
            if(_up){
                mA = -90;
                if (_left){
                    mA -= 45;
                }else if(_right){
                    mA += 45;
                }
                facing = FlxObject.UP;
            }else if(_down){
                mA = 90;
                if(_left){
                    mA += 45;
                }else if(_right){
                    mA -= 45;
                }
                facing = FlxObject.DOWN;
            }else if(_left){
                mA = 180;
                facing = FlxObject.LEFT;
            }else if(_right){
                mA = 0;
                facing = FlxObject.RIGHT;
            }
            velocity.set(speed, 0);
            velocity.rotate(FlxPoint.weak(0,0), mA);

            if ((velocity.x !=0 || velocity.y !=0) && touching == FlxObject.NONE) {
                switch (facing) {
                    case FlxObject.LEFT, FlxObject.RIGHT:
                        animation.play("lr");
                    case FlxObject.UP:
                        animation.play("u");
                    case FlxObject.DOWN:
                        animation.play("d");
                }
            }

        }
    }
}
