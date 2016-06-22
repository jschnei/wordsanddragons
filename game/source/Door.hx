package;

import flixel.FlxObject;
import flixel.math.FlxRect;

class Door extends FlxObject
{

    public var destMap:String;
    public var destObject:String;

	public function new(bounds:FlxRect, destMap:String, destObject:String):Void
	{
        super(bounds.x, bounds.y, bounds.width, bounds.height);
        this.destMap = destMap;
        this.destObject = destObject;
	}
}
