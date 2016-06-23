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

    private var _loading:Bool = false;

	override public function create():Void
	{
        _level = new Level("level_test");

        initializeLevel();

        _dialogueHUD = new DialogueHUD();
        add(_dialogueHUD);

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
        FlxG.worldBounds.set(-10, -10, _level.fullWidth+20, _level.fullHeight+20);

        add(_level.grpNPCs);

        FlxG.camera.follow(_level.player, TOPDOWN, 1);
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
        _dialogueHUD.revive();
        return _dialogueHUD;
    }

	override public function update(elapsed:Float):Void
	{
        super.update(elapsed);
        /*trace(_dialogueHUD.alive);*/
        if(_loading)
            return;



        if(!_dialogueHUD.alive)
        {
            if(FlxG.keys.justPressed.Z)
            {
                var interactBox:FlxObject = _level.player.interactBox();
                for(npc in _level.grpNPCs)
                {
                    if(interactBox.overlaps(npc)){
                        npc.onInteract(this);
                        _level.player.active = false;
                        return;
                    }
                }
            }

            if(_level.player.active)
            {
                _level.player.movement();

                FlxG.collide(_level.mObstacles, _level.player);
                FlxG.collide(_level.mSurface, _level.player);
                FlxG.collide(_level.player, _level.grpNPCs);

                FlxG.overlap(_level.player, _level.grpDoors, playerUseDoor);
            }
        }
        else
        {
            if(FlxG.keys.justPressed.Z)
            {

                if(!_dialogueHUD.advanceDialogue())
                {
                    _level.player.active = true;
                }
            }
        }

	}
}
