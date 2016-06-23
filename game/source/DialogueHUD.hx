package;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class DialogueHUD extends FlxTypedGroup<FlxSprite>
{
    public static inline var FONT_SIZE = 20;

    private var _dialogueBox:FlxSprite;
    private var _dialogueText:FlxText;
    public function new()
    {
        super();

        _dialogueBox = new FlxSprite().makeGraphic(FlxG.width, 50, FlxColor.BLACK);
        add(_dialogueBox);

        _dialogueText = new FlxText(0, 0, 0, "blarghalakhfdl", FONT_SIZE);
        _dialogueText.screenCenter();
        add(_dialogueText);

        forEach(function(spr:FlxSprite){
            spr.scrollFactor.set(0, 0);
        });
        /*visible = false;*/
    }

    public function setDialogue(dialogue:String):Void
    {
        trace("setting dialogue text to: " + dialogue);
        _dialogueText.text = dialogue;
        _dialogueText.screenCenter();

        visible = true;
    }

    override public function update(elapsed:Float):Void
    {
        if(FlxG.keys.justPressed.Z){
            // stop the dialogue
            /*visible = false;*/
        }

        super.update(elapsed);
    }


}
