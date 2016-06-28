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
    public var level:Level;
    public var dialogueHUD:DialogueHUD;
    public var speechUI:SpeechUI;
    public var inventoryHUD:InventoryHUD;

    public var loading:Bool = false;

	override public function create():Void
	{
        dialogueHUD = new DialogueHUD();
        speechUI = new SpeechUI();
        inventoryHUD = new InventoryHUD();

        level = new Level("level_itempuzzle");
        initializeLevel();
        add(dialogueHUD);
        add(speechUI);
        add(inventoryHUD);

		super.create();
	}

    private function deinitializeLevel():Void
    {
        remove(level.mBG);
        remove(level.mSurface);
        remove(level.mObstacles);

        remove(level.grpNPCs);
        remove(level.player);
        level = null;
    }

    private function initializeLevel():Void
    {
        add(level.mBG);
        add(level.mSurface);
        add(level.mObstacles);
        FlxG.worldBounds.set(-10, -10, level.fullWidth+20, level.fullHeight+20);
        FlxG.camera.setScrollBoundsRect(0, 0, level.fullWidth, level.fullHeight);

        add(level.grpNPCs);

        FlxG.camera.follow(level.player, TOPDOWN, 1);
        add(level.player);

        speechUI.setSpeaker(level.player);
    }

    private function playerUseDoor(player:PlayerSprite, door:Door):Void
    {
        loading = true;
        deinitializeLevel();
        trace(door.destMap + " " + door.destObject);
        level = new Level(door.destMap, door.destObject);
        initializeLevel();
        loading = false;
    }


    public function startDialogue(?callback:Void->Void):Void
    {
        dialogueHUD.revive();
        dialogueHUD.setCallback(callback);
        level.player.active = false;
        dialogueHUD.advanceDialogue();
    }

	override public function update(elapsed:Float):Void
	{
        super.update(elapsed);
        /*trace(_dialogueHUD.alive);*/
        if(loading)
            return;

        if(dialogueHUD.alive)
        {
            if(FlxG.keys.justPressed.Z)
            {
                if(!dialogueHUD.advanceDialogue())
                {
                    level.player.active = true;
                }
            }
            return;
        }

        if (inventoryHUD.alive)
        {
            if(FlxG.keys.justPressed.I)
            {
                inventoryHUD.kill();
                level.player.active = true;
            }
            return;
        }

        if(speechUI.alive)
        {
            if(!speechUI.processKey(FlxG.keys.firstJustPressed()))
            {
                level.player.active = true;

                var interactBox:FlxObject = level.player.interactBox();
                var speech = speechUI.lastSaid;
                if (speech=="")
                    return;
                for(npc in level.grpNPCs)
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
            speechUI.revive();
            speechUI.updateSpeech();
            level.player.active = false;
            return;
        }

        if(FlxG.keys.justPressed.I)
        {
            inventoryHUD.updateText();
            inventoryHUD.revive();
            level.player.active = false;
            return;
        }

        if(FlxG.keys.justPressed.Z)
        {
            var interactBox:FlxObject = level.player.interactBox();
            for(npc in level.grpNPCs)
            {
                if(interactBox.overlaps(npc)){
                    npc.interact(this);
                    return;
                }
            }
        }

        if(level.player.active)
        {
            level.player.movement();

            FlxG.collide(level.mObstacles, level.player);
            FlxG.collide(level.mSurface, level.player);
            FlxG.collide(level.player, level.grpNPCs);

            FlxG.overlap(level.player, level.grpDoors, playerUseDoor);
        }


	}
}
