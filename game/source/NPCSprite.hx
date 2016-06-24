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

    public var onInteract:NPCSprite->PlayState->Void;
    public var onSpeak:NPCSprite->PlayState->String->Void;

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

    public function interact(playState:PlayState)
    {
        if(onInteract==null)
            return;
        onInteract(this, playState);
    }

    public function speak(playState:PlayState, speech:String)
    {
        if(onSpeak==null)
            return;
        onSpeak(this, playState, speech);
    }

}
