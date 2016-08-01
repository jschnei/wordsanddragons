package;

import combat.CombatState;

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
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

using Lambda;


class PlayState extends FlxState
{
    public var level:Level;
    public var dialogueHUD:DialogueHUD;
    public var speechUI:SpeechUI;
    public var inventoryHUD:InventoryHUD;

    public var loading:Bool = false;

	override public function create():Void
	{
        trace("making a playstate");

        dialogueHUD = new DialogueHUD();
        speechUI = new SpeechUI();
        inventoryHUD = new InventoryHUD();

        if(Registry.playStateData==null)
        {
            level = new Level("level_test");
            Registry.playStateData = new PlayStateData();
        }
        else
        {
            loadPlayState();
        }

        initializeLevel();
        add(dialogueHUD);
        add(speechUI);
        add(inventoryHUD);

        Registry.currPlayState = this;

		super.create();
	}

    private function loadPlayState():Void
    {
        var psData:PlayStateData = Registry.playStateData;
        level = new Level(psData.levelName);
        level.player.setPosition(psData.playerLocation.x, psData.playerLocation.y);
        for(npc in level.grpNPCs)
        {
            if(psData.npcLocations.exists(npc.name))
            {
                var npcLocation = psData.npcLocations.get(npc.name);
                npc.setPosition(npcLocation.x, npcLocation.y);
            }
            else
            {
                npc.kill();
            }
        }
    }

    private function savePlayState():Void
    {
        var psData:PlayStateData = Registry.playStateData;
        psData.levelName = level.levelName;
        psData.playerLocation = level.player.getPosition();
        for(npc in level.grpNPCs)
        {
            if (npc.exists)
                psData.npcLocations.set(npc.name, npc.getPosition());
        }
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

    public function startCombat(?callback:Void->Void):Void
    {
        loading = true;
        trace("leaving playstate");
        savePlayState();
        var combatState = new CombatState();
        combatState.setCallback(callback);
        FlxG.switchState(combatState);
    }

    public function startDialogue(?callback:Void->Void):Void
    {
        dialogueHUD.revive();
        dialogueHUD.setCallback(callback);
        level.player.active = false;
        dialogueHUD.advanceDialogue();
    }

    public static inline function sqDist(spr1:FlxSprite, spr2:FlxSprite):Float
    {
        var dx = (spr1.x - spr2.x) + (spr1.width - spr2.width)/2;
        var dy = (spr1.y - spr2.y) + (spr1.height - spr2.height)/2;
        return dx*dx + dy*dy;
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
                // if there is no more dialogue to advance, return control to player
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
            // note: speechUI.processKey returns false iff ENTER was just pressed
            if(!speechUI.processKey(FlxG.keys.firstJustPressed()))
            {
                level.player.active = true;

                var interactBox:FlxObject = level.player.interactBox();
                var speech = speechUI.lastSaid;
                if (speech=="")
                    return;


                var canSpeakNPCs = level.grpNPCs.members.filter(
                    function(npc:NPCSprite){
                        return (npc.alive && npc.canSpeak() && interactBox.overlaps(npc));
                    });
                if (canSpeakNPCs.length == 0)
                    return;

                var npc:NPCSprite = canSpeakNPCs.fold(
                    function(npc1:NPCSprite, npc2:NPCSprite):NPCSprite
                    {
                        var dist1:Float = sqDist(npc1, level.player);
                        var dist2:Float = sqDist(npc2, level.player);
                        if(dist1 < dist2)
                        {
                            return npc1;
                        }
                        else
                        {
                            return npc2;
                        }
                    }, canSpeakNPCs[0]);

                npc.speak(speech);
                return;

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

        if(FlxG.keys.justPressed.C)
        {
            startCombat(function(){ trace("combat is over");});
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

            var canInteractNPCs = level.grpNPCs.members.filter(
                function(npc:NPCSprite){
                    return (npc.alive && npc.canInteract() && interactBox.overlaps(npc));
                });
            if (canInteractNPCs.length == 0)
                return;

            var npc:NPCSprite = canInteractNPCs.fold(
                function(npc1:NPCSprite, npc2:NPCSprite):NPCSprite
                {
                    var dist1:Float = sqDist(npc1, level.player);
                    var dist2:Float = sqDist(npc2, level.player);
                    if(dist1 < dist2)
                    {
                        return npc1;
                    }
                    else
                    {
                        return npc2;
                    }
                }, canInteractNPCs[0]);

            npc.interact();
            return;
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

class PlayStateData
{
    public var levelName:String;
    public var playerLocation:FlxPoint;
    public var npcLocations:Map<String,FlxPoint>;

    public function new()
    {
        levelName = "";
        playerLocation = new FlxPoint();
        npcLocations = new Map<String,FlxPoint>();
    }
}
