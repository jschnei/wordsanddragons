package combat;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class LetterSprite extends FlxSpriteGroup
{
    private static inline var FONT_PATH:String = "assets/data/Inconsolata.otf";
    public static inline var FONT_SIZE = 20;
    public static var FONT_COLOR = new FlxColor(0xFF000000);
    public static var TILE_COLOR = new FlxColor(0xFFDDEEDD);

    private var _tileSprite:FlxSprite;
    // todo: add border FlxStuff?
    private var _letterText:FlxText;

    public function new(?X:Float=0,
                        ?Y:Float=0,
                        ?width:Int=32,
                        ?height:Int=32,
                        letter:String)
    {
        super();

        _tileSprite = new FlxSprite(X, Y);
        _tileSprite.makeGraphic(width, height, TILE_COLOR);

        _letterText = new FlxText(0, 0, 0, letter, FONT_SIZE);
        _letterText.setFormat(FONT_PATH, FONT_SIZE, FONT_COLOR);
        centerText();

        add(_tileSprite);
        add(_letterText);
    }

    public function updateText(letter:String):Void
    {
        _letterText.text = letter;
        centerText();
    }

    /*public override function setPosition(X:Float, Y:Float):Void
    {
        _tileSprite.x = X;
        _tileSprite.y = Y;
        centerText();
    }*/

    public function centerText():Void
    {
        _letterText.x = _tileSprite.x + (_tileSprite.width - _letterText.width)/2;
        _letterText.y = _tileSprite.y + (_tileSprite.height - _letterText.height)/2;
    }


}
