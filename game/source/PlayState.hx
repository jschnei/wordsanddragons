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
    public var _level:Level;
    public var _dialogueHUD:DialogueHUD;
    public var _speechUI:SpeechUI;

    public var _loading:Bool = false;

	override public function create():Void
	{
        _dialogueHUD = new DialogueHUD();
        _speechUI = new SpeechUI();

        _level = new Level("level_trivial_puzzle");

        initializeLevel();
        add(_dialogueHUD);
        add(_speechUI);

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
        FlxG.camera.setScrollBoundsRect(0, 0, _level.fullWidth, _level.fullHeight);

        add(_level.grpNPCs);

        FlxG.camera.follow(_level.player, TOPDOWN, 1);
        add(_level.player);

        _speechUI.setSpeaker(_level.player);
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
        _level.player.active = false;
        return _dialogueHUD;
    }

	override public function update(elapsed:Float):Void
	{
        super.update(elapsed);
        /*trace(_dialogueHUD.alive);*/
        if(_loading)
            return;

        if(_dialogueHUD.alive)
        {
            if(FlxG.keys.justPressed.Z)
            {
                if(!_dialogueHUD.advanceDialogue())
                {
                    _level.player.active = true;
                }
            }
            return;
        }

        if(_speechUI.alive)
        {
            if(!_speechUI.processKey(FlxG.keys.firstJustPressed()))
            {
                _level.player.active = true;

                var interactBox:FlxObject = _level.player.interactBox();
                var speech = _speechUI.lastSaid;
                for(npc in _level.grpNPCs)
                {
                    if(interactBox.overlaps(npc)){
                        npc.speak(this, speech);
                        return;
                    }
                }
            }

            return;
        }

        if(FlxG.keys.justPressed.ENTER)
        {
            _speechUI.revive();
            _speechUI.updateSpeech();
            _level.player.active = false;
            return;
        }

        if(FlxG.keys.justPressed.Z)
        {
            var interactBox:FlxObject = _level.player.interactBox();
            for(npc in _level.grpNPCs)
            {
                if(interactBox.overlaps(npc)){
                    npc.interact(this);
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
}
