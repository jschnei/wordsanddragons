package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class NPCSprite extends FlxSprite
{
    public var name:String;

    public var onInteract:String->Void;
    public var onSpeak:String->String->Void;

    public function new(?X:Float=0, ?Y:Float=0, filePath:String, name:String)
    {
        super(X, Y, filePath);
        this.name = name;
        immovable=true;
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

    public function interact():Void
    {
        if(onInteract==null)
            return;
        onInteract(name);
    }

    public function speak(speech:String):Void
    {
        if(onSpeak==null)
            return;
        onSpeak(name, speech);
    }

    public function canInteract():Bool
    {
        return (onInteract!=null);
    }

    public function canSpeak():Bool
    {
        return (onSpeak!=null);
    }

}
