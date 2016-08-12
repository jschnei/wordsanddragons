package;

import flixel.FlxObject;
import flixel.math.FlxRect;

class LocationTrigger extends FlxObject
{
    private var _onlyOnce:Bool;
    private var _callback:Void->Void;

    private var _activated:Bool=false;

	public function new(bounds:FlxRect,
                        callback:Void->Void,
                        onlyOnce:Bool=false):Void
	{
        super(bounds.x, bounds.y, bounds.width, bounds.height);
        this._callback = callback;
        this._onlyOnce = onlyOnce;
	}

    public function activate():Void
    {
        if(_onlyOnce && _activated)
            return;

        _callback();
        _activated=true;
    }
}

class Door extends LocationTrigger
{

	public function new(bounds:FlxRect, destMap:String, destObject:String):Void
	{
        super(bounds, Door.doorTrigger(destMap, destObject));
	}

    public static function doorTrigger(destMap:String, destObject:String):Void->Void
    {
        function trigger():Void
        {
            Registry.currPlayState.loading = true;
            Registry.currPlayState.deinitializeLevel();
            trace(destMap + " " + destObject);
            Registry.currPlayState.level = new Level(destMap, destObject);
            Registry.currPlayState.initializeLevel();
            Registry.currPlayState.loading = false;
        }
        return trigger;
    }
}
