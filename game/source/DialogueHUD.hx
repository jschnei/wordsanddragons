package;

import flixel.addons.text.FlxTypeText;
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

    private var _lines:Array<String>;
    private var _lineInd:Int = 0;

    private var _dialogueBox:FlxSprite;
    private var _dialogueText:FlxTypeText;

    private var _callback:Void->Void;

    public function new()
    {
        super();

        _dialogueBox = new FlxSprite(0, FlxG.height-50).makeGraphic(FlxG.width, 50, FlxColor.BLACK);
        add(_dialogueBox);

        _dialogueText = new FlxTypeText(_dialogueBox.x + 30, _dialogueBox.y + 15, 0, "", FONT_SIZE);
        add(_dialogueText);

        _lines = new Array<String>();

        forEach(function(spr:FlxSprite){
            spr.scrollFactor.set(0, 0);
        });

        kill();
    }

    public function setCallback(callback:Void->Void)
    {
        _callback = callback;
    }

    public function addLine(line:String):Void
    {
        _lines.push(line);
    }

    //returns true if dialogue is still active afterwards
    public function advanceDialogue():Bool
    {
        if(_lineInd < _lines.length)
        {
            _dialogueText.resetText(_lines[_lineInd]);
            _dialogueText.start();
            _lineInd++;
            return true;
        }
        else
        {
            kill();
            if(_callback!=null)
            {
                _callback();
                setCallback(null);
            }
            return false;
        }
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }


}
