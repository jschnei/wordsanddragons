package combat;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayerHUD extends FlxTypedGroup<FlxSprite>
{
    private var _player:CombatPlayer;

    private var _playerSprite:CombatEntitySprite;
    private var _pool:FlxText;
    private var _input:FlxText;
    private var _skillbar:FlxTypedGroup<FlxSprite>;

    private static inline var fontPath:String = "assets/Inconsolata.otf";
    private static inline var fontSize:Int = 30;

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
                    _pool = new FlxText(x, y, 0, "", 20);
                    _pool.setFormat(fontPath, fontSize, FlxColor.WHITE);
                    add(_pool);
                case "input":
                    _input = new FlxText(x, y, 0, "", 20);
                    _input.setFormat(fontPath, fontSize, FlxColor.WHITE);
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

    public function setPoolText(poolText:String):Void
    {
        _pool.text = poolText;
    }

    public function setInputText(inputText:String):Void
    {
        _input.text = inputText;
    }

    public function setPoolColor(color:FlxColor):Void
    {
        _pool.setFormat(fontPath, fontSize, color);
    }

}
