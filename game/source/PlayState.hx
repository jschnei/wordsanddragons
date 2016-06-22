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
    private var _level:Level;
    private var _loading:Bool = false;

	override public function create():Void
	{
        _level = new Level("level_test");

        initialize();

		super.create();
	}

    private function deinitialize():Void
    {
        remove(_level.mBG);
        remove(_level.mSurface);
        remove(_level.mObstacles);

        remove(_level.grpNPCs);
        remove(_level.player);
        _level = null;
    }

    private function initialize():Void
    {
        add(_level.mBG);
        add(_level.mSurface);
        add(_level.mObstacles);

        add(_level.grpNPCs);

        FlxG.camera.follow(_level.player);
        add(_level.player);
    }

    private function playerUseDoor(player:PlayerSprite, door:Door):Void
    {
        _loading = true;
        deinitialize();
        trace(door.destMap + " " + door.destObject);
        _level = new Level(door.destMap, door.destObject);
        initialize();
        _loading = false;
    }

	override public function update(elapsed:Float):Void
	{
        if(!_loading)
        {
            super.update(elapsed);
            _level.mObstacles.overlapsWithCallback(_level.player, FlxObject.separate);
            _level.mSurface.overlapsWithCallback(_level.player, FlxObject.separate);
            for(door in _level.grpDoors)
            {
                if(_level.player.overlaps(door)){
                    playerUseDoor(_level.player, door);
                }
            }
            /*FlxG.overlap(_level.player, _level.grpDoors, playerUseDoor);

            if(FlxG.keys.anyPressed([L])){
                trace("Player: " + _level.player);
                for(door in _level.grpDoors){
                    trace(_level.player.overlaps(door));
                    trace("Door: " + door);
                }
            }*/

        }
	}
}
