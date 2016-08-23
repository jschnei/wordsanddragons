package combat;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayerHUD extends FlxTypedGroup<FlxSprite>
{
    private static inline var FONT_PATH:String = "assets/data/Inconsolata.otf";
    private static inline var FONT_SIZE:Int = 30;

    public static inline var LETTER_MARGIN = 10.0;

    private var _player:CombatPlayer;

    private var _poolLeft:Float;
    private var _poolRight:Float;
    private var _poolY:Float;

    private var _playerSprite:CombatEntitySprite;
    private var _pool:FlxTypedSpriteGroup<LetterSprite>;
    private var _input:FlxText;
    private var _skillbar:FlxTypedGroup<FlxSprite>;


    public function new(player:CombatPlayer)
    {
        super();

        _player = player;

        //may want to pass in the .tmx file
        var hudObjects:TiledMap = new TiledMap("assets/data/combatscreen.tmx");
        var layerPlayer:TiledObjectLayer = cast hudObjects.getLayer("playerSprites");

        for (o in layerPlayer.objects)
        {
            var x:Int = o.x;
            var y:Int = o.y;

            switch(o.name)
            {
                case "player":
                    _playerSprite = new CombatEntitySprite(x, y, _player, "assets/images/alphabob.png", true);
                    for (sprite in _playerSprite)
                        add(sprite);
                case "pool":
                    _poolLeft = o.x;
                    _poolRight = o.x+o.width;
                    _poolY = o.y;
                    _pool = new FlxTypedSpriteGroup<LetterSprite>();
                    add(_pool);
                case "input":
                    _input = new FlxText(x, y, 0, "", FONT_SIZE);
                    _input.setFormat(FONT_PATH, FONT_SIZE, FlxColor.WHITE);
                    add(_input);
                case "skillbar":
                    //not implemented yet, probably want a skillbar class to make displays easier
                    _skillbar = new FlxTypedGroup<FlxSprite>();
                    for (skillSprite in _skillbar)
                        add(skillSprite);
            }
        }
    }

    public function updateEntities():Void
    {
        _playerSprite.updateHealthBar();
    }

    public function setPool(poolText:Array<String>):Void
    {
        //_pool.forEach(function(spr){ spr.destroy();});
        _pool.clear();
        for(letter in poolText)
        {
            var letterTile = new LetterSprite(letter);
            _pool.add(letterTile);
        }
        centerPool();
    }

    public function centerPool():Void
    {
        var curX:Float = _poolLeft;

        for(letter in _pool)
        {
            letter.setPosition(curX, _poolY);

            curX += letter.width + LETTER_MARGIN;
        }
        curX -= LETTER_MARGIN;

        var shift:Float = (_poolRight - curX)/2;

        //center letters
        for(letter in _pool)
        {
            letter.forEach(function(spr){ spr.x += shift;});
        }
    }

    public function setInputText(inputText:String):Void
    {
        _input.text = inputText;
    }

    public function setPoolColor(color:FlxColor):Void
    {
        //_pool.setFormat(FONT_PATH, FONT_SIZE, color);
    }

}
