package;

import flixel.FlxBasic;

class Spawn extends FlxBasic
{
    public var X:Int;
    public var Y:Int;
    public var name:String;

	public function new(X:Int, Y:Int, name:String):Void
	{
        super();
        this.X = X;
        this.Y = Y;
        this.name = name;
	}
}
