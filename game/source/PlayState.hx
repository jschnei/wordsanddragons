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
    private var _dialogueHUD:DialogueHUD;

    private var _inDialogue:Bool = false;
    private var _loading:Bool = false;

	override public function create():Void
	{
        _level = new Level("level_test");

        initializeLevel();

        _dialogueHUD = new DialogueHUD();
        add(_dialogueHUD);

        /*var blah = new FlxText(0, 0, 0, "blarghalakhfdl", 20);
        blah.screenCenter();
        blah.scrollFactor.set(0, 0);
        add(blah);*/

		super.create();
	}

    private function deinitializeLevel():Void
    {
        remove(_level.mBG);
        remove(_level.mSurface);
        remove(_level.mObstacles);

        remove(_level.grpNPCs);
        remove(_level.player);
        _level = null;
    }

    private function initializeLevel():Void
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
        deinitializeLevel();
        trace(door.destMap + " " + door.destObject);
        _level = new Level(door.destMap, door.destObject);
        initializeLevel();
        _loading = false;
    }

    public function startDialogue():DialogueHUD
    {
        _inDialogue = true;
        return _dialogueHUD;
    }

	override public function update(elapsed:Float):Void
	{
        if(!_loading && !_inDialogue)
        {
            _level.player.movement();

            _level.mObstacles.overlapsWithCallback(_level.player, FlxObject.separate);
            _level.mSurface.overlapsWithCallback(_level.player, FlxObject.separate);
            FlxG.overlap(_level.player, _level.grpNPCs, FlxObject.separate);


            for(door in _level.grpDoors)
            {
                if(_level.player.overlaps(door)){
                    playerUseDoor(_level.player, door);
                }
            }

            if(FlxG.keys.justPressed.Z)
            {
                var interactBox:FlxObject = _level.player.interactBox();
                for(npc in _level.grpNPCs)
                {
                    if(interactBox.overlaps(npc)){
                        npc.onInteract(this);
                    }
                }
            }


        }
        super.update(elapsed);
	}
}
