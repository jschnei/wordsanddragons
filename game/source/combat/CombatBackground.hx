package combat;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.tile.FlxTilemap;

class CombatBackground extends TiledMap
{
    public var mBG:FlxTilemap;

    public function new(combatScreenName:String):Void
    {
        super("assets/data/"+combatScreenName+".tmx");

        var tileSize = tileWidth;
        var mapW = width;
        var mapH = height;

        var layerBG:TiledTileLayer = cast getLayer("background");

        mBG = processTileLayer(layerBG, tileSize, mapW, mapH);
    }

    private function processTileLayer(layer:TiledTileLayer,
                                      tileSize:Int,
                                      mapW:Int,
                                      mapH:Int):FlxTilemap
    {
        var layerData:Array<Int> = layer.tileArray;
        var tilesheetFile:String = layer.properties.get("tileset");
        var tilesheetPath:String = "assets/images/" + tilesheetFile;

        var tilemap:FlxTilemap = new FlxTilemap();
        tilemap.loadMapFromArray(layerData, mapW, mapH, tilesheetPath, tileSize, tileSize, OFF, 1);
        return tilemap;
    }
}