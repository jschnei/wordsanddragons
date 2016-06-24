package;

import flixel.addons.text.FlxTypeText;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class SpeechUI extends FlxTypedGroup<FlxSprite>
{
    public static inline var FONT_SIZE = 20;

    public static inline var OFFSET_X = 0;
    public static inline var OFFSET_Y = -30;

    public var lastSaid:String = "";

    private var _speechBuffer:String = "";
    private var _speaker:FlxObject;

    private var _speechBG:FlxSprite;
    private var _speechText:FlxText;
    public function new()
    {
        super();

        _speechBG = new FlxSprite(0, 0);
        add(_speechBG);

        _speechText = new FlxText(0, 0, -1, FONT_SIZE);
        add(_speechText);

        kill();
    }

    public function setSpeaker(speaker:FlxObject):Void
    {
        _speaker = speaker;
    }

    public function processKey(key:Int):Bool
    {
        if((key >= cast FlxKey.A) && (key <= cast FlxKey.Z))
        {
            _speechBuffer += String.fromCharCode(key);
        }
        else if(key == FlxKey.BACKSPACE)
        {
            var len:Int = _speechBuffer.length;
            if(len > 0)
            {
                _speechBuffer = _speechBuffer.substring(0, len-1);
            }
        }
        else if(key == FlxKey.ENTER)
        {
            lastSaid = _speechBuffer;
            _speechBuffer = "";
            kill();
            return false;
        }

        updateSpeech();
        return true;
    }

    public function updateSpeech():Void
    {
        _speechText.text = _speechBuffer;
        _speechText.x = _speaker.x + OFFSET_X;
        _speechText.y = _speaker.y + OFFSET_Y;

        _speechBG.x = _speechText.x;
        _speechBG.y = _speechText.y;
        _speechBG.makeGraphic(cast _speechText.width, FONT_SIZE+10, FlxColor.BLACK);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }


}
