package;

import flixel.FlxObject;
import flixel.math.FlxRect;

class LocationTrigger extends FlxObject
{
    private var _triggerName:String;

    //_onlyOnce is true if and only if the trigger should activate the first time and never again
    //note: still haven't implemented triggers that can activate multiple times but are not continnuous
    private var _onlyOnce:Bool;
    private var _callback:Void->Void;

    //private var _activated:Bool=false;

	public function new(?funcName:String,
                        bounds:FlxRect,
                        callback:Void->Void,
                        onlyOnce:Bool=false):Void
	{
        super(bounds.x, bounds.y, bounds.width, bounds.height);
        this._triggerName = funcName;
        this._callback = callback;
        this._onlyOnce = onlyOnce;
        if (_onlyOnce==true && _triggerName==null)
        {
            throw("single-use triggers must have a name");
        }
	}

    public function activate():Void
    {
        if(_onlyOnce && Registry.globalDict.get(_triggerName)=="activated")
            return;

        _callback();
        if (_triggerName!=null)
            Registry.globalDict.set(_triggerName, "activated");
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
