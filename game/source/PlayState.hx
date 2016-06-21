package;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;


class PlayState extends FlxState
{
    private var _player:PlayerSprite;
    private var _bob:FlxSprite;

    private var _mBG:FlxTilemap;
    private var _mSurface:FlxTilemap;
    private var _mObstacles:FlxTilemap;
	override public function create():Void
	{
        var tiledLevel:TiledMap = new TiledMap("assets/data/level_test.tmx");

        var tileSize = tiledLevel.tileWidth;
        var mapW = tiledLevel.width;
        var mapH = tiledLevel.height;
        /*trace(mapW + " " + mapH + " " + tileSize);*/

        var layerBG:TiledTileLayer = cast tiledLevel.getLayer("background");
        var layerSurface:TiledTileLayer = cast tiledLevel.getLayer("surface");
        var layerObstacles:TiledTileLayer = cast tiledLevel.getLayer("obstacles");
        var layerActors:TiledObjectLayer = cast tiledLevel.getLayer("actors");

        _mBG = drawTileLayer(layerBG, tileSize, mapW, mapH);
        _mSurface = drawTileLayer(layerSurface, tileSize, mapW, mapH);
        _mObstacles = drawTileLayer(layerObstacles, tileSize, mapW, mapH);

        /*trace(_mSurface.getData());
        trace(_mSurface.getTileCollisions(0));
        trace(_mSurface.getTileCollisions(96));
        trace(FlxObject.ANY);
        trace(FlxObject.NONE);*/

        add(_mBG);
        add(_mSurface);
        add(_mObstacles);

        drawObjectLayer(layerActors);




		super.create();
	}

    private function drawTileLayer(layer:TiledTileLayer,
                                    tileSize:Int,
                                    mapW:Int,
                                    mapH:Int):FlxTilemap
    {
        var layerData:Array<Int> = layer.tileArray;
        var tilesheetPath:String = "assets/images/tileset.png";

        var tilemap:FlxTilemap = new FlxTilemap();
        tilemap.loadMapFromArray(layerData, mapW, mapH, tilesheetPath, tileSize, tileSize, OFF, 1);
        return tilemap;
    }

    private function drawObjectLayer(layer:TiledObjectLayer)
    {
        for(o in layer.objects)
        {
            var x:Int = o.x;
            var y:Int = o.y;
            y-= o.height;
            switch(o.name)
            {
                case "player":
                    _player = new PlayerSprite(x, y);
                    FlxG.camera.follow(_player);
                    add(_player);
                case "bob":
                    _bob = new FlxSprite(x, y, "assets/images/bob.png");
                    add(_bob);
            }
        }
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
        FlxG.overlap(_mObstacles, _player, FlxObject.separate);
	}
}
