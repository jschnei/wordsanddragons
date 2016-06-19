package;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;


class PlayState extends FlxState
{
    private var _player:PlayerSprite;
	override public function create():Void
	{
        var tiledLevel:TiledMap = new TiledMap("assets/data/level_test.tmx");

        var tileSize = tiledLevel.tileWidth;
        var mapW = tiledLevel.width;
        var mapH = tiledLevel.height;

        var layerBG:TiledLayer = tiledLevel.getLayer("background");
        var layerSurface:TiledLayer = tiledLevel.getLayer("surface");
        var layerObstacles:TiledLayer = tiledLevel.getLayer("obstacles");
        var layerActors:TiledLayer = tiledLevel.getLayer("actors");

        drawTiledLayer(layerBG, tileSize, mapW, mapH);
        drawTiledLayer(layerSurface, tileSize, mapW, mapH);
        drawTiledLayer(layerObstacles, tileSize, mapW, mapH);

        _player = new PlayerSprite();
        add(_player);
		super.create();
	}

    private function drawTiledLayer(layer:TiledLayer,
                                    tileSize:Int,
                                    mapW:Int,
                                    mapH:Int):Void
    {
        if (layer.type != TiledLayerType.TILE)
            return;
        var tileLayer:TiledTileLayer = cast layer;
        var layerData:Array<Int> = tileLayer.tileArray;
        var tilesheetPath:String = "assets/images/tileset.png";

        var tilemap:FlxTilemap = new FlxTilemap();

        tilemap.loadMapFromArray(layerData, mapW, mapH, tilesheetPath, tileSize, tileSize, OFF, 1);

        add(tilemap);
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
