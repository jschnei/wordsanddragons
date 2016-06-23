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
    public var onInteract:PlayState->Void;

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

    public static function interactBob(playState:PlayState):Void
    {
        var dialogueHUD:DialogueHUD = playState.startDialogue();
        dialogueHUD.setDialogue("Yo, I'm Bob!");
    }

}
