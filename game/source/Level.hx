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
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;


class Level extends TiledMap
{
    public var mBG:FlxTilemap;
    public var mSurface:FlxTilemap;
    public var mObstacles:FlxTilemap;

    public var grpDoors:FlxTypedGroup<Door>;
    public var grpNPCs:FlxTypedGroup<FlxSprite>;
    public var grpSpawns:FlxTypedGroup<Spawn>;

    public var player:PlayerSprite;


	public function new(levelName:String, ?spawnObj:String="start"):Void
	{
        super("assets/data/"+levelName+".tmx");

        var tileSize = tileWidth;
        var mapW = width;
        var mapH = height;

        grpDoors = new FlxTypedGroup<Door>();
        grpNPCs = new FlxTypedGroup<FlxSprite>();
        grpSpawns = new FlxTypedGroup<Spawn>();

        var layerBG:TiledTileLayer = cast getLayer("background");
        var layerSurface:TiledTileLayer = cast getLayer("surface");
        var layerObstacles:TiledTileLayer = cast getLayer("obstacles");
        var layerActors:TiledObjectLayer = cast getLayer("actors");

        mBG = processTileLayer(layerBG, tileSize, mapW, mapH);
        mSurface = processTileLayer(layerSurface, tileSize, mapW, mapH);
        mObstacles = processTileLayer(layerObstacles, tileSize, mapW, mapH);

        mSurface.setTileProperties(0, FlxObject.ANY);
        mSurface.setTileProperties(1, FlxObject.NONE, 200);

        processObjectLayer(layerActors);

        trace("Spawns:");
        for(s in grpSpawns)
        {
            trace(s.name);
        }

        trace("Doors:");
        for(d in grpDoors)
        {
            trace(d.destMap + " " + d.destObject + " " + d.x + " " + d.y + " " + d.width + " " + d.height);
        }

        var spawn = getSpawnByName(spawnObj);
        if(spawn!=null)
        {
            player = new PlayerSprite(spawn.X, spawn.Y);
        }
        else
        {
            trace("spawn object not found!");
            trace(spawnObj + " " + levelName);
            player = new PlayerSprite(512, 512);
        }
	}

    private function getSpawnByName(name:String):Spawn
    {
        for(spawn in grpSpawns)
        {
            if(spawn.name==name)
            {
                trace("woo found it");
                return spawn;
            }
        }
        return null;
    }

    private function processTileLayer(layer:TiledTileLayer,
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

    private function processObjectLayer(layer:TiledObjectLayer)
    {
        for(o in layer.objects)
        {
            var x:Int = o.x;
            var y:Int = o.y;
            /*y-= o.height;*/
            // get upper-left corner of Tiled box

            switch(o.type)
            {
                case "npc":
                    var npc = new FlxSprite(x, y, "assets/images/bob.png");
                    grpNPCs.add(npc);

                case "spawn":
                    var spawn = new Spawn(x, y, o.name);
                    grpSpawns.add(spawn);

                case "door":
                    var bounds = new FlxRect(x, y, o.width, o.height);
                    var destMap = o.properties.get("destMap");
                    var destObject = o.properties.get("destObject");
                    var door = new Door(bounds, destMap, destObject);
                    grpDoors.add(door);

            }
        }
    }
}
