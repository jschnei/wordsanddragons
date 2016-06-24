package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class NPCScripts
{
    public static function interactGuard(npc:NPCSprite, playState:PlayState):Void
    {
        var dialogueHUD:DialogueHUD = playState.startDialogue();
        dialogueHUD.addLine("I AM THE GUARD!");
        dialogueHUD.addLine("WHAT IS THE PASSWORD?");
        dialogueHUD.addLine("ANSWER INCORRECTLY, AND DIE!");
        dialogueHUD.advanceDialogue();
    }

    public static function speakGuard(npc:NPCSprite, playState:PlayState, speech:String)
    {
        var dialogueHUD:DialogueHUD = playState.startDialogue();
        dialogueHUD.addLine("YOU SAID " + speech + ".");
        if(speech=="SWORDFISH")
        {
            dialogueHUD.addLine("THAT IS THE PASSWORD.");
            dialogueHUD.addLine("YOU MAY PROCEED.");
            npc.immovable = false;
        }
        else
        {
            dialogueHUD.addLine("INCORRECT!");
            playState._level.player.kill();
        }
        dialogueHUD.advanceDialogue();
    }

    public static function interactTeller(npc:NPCSprite, playState:PlayState):Void
    {
        var dialogueHUD:DialogueHUD = playState.startDialogue();
        dialogueHUD.addLine("psst.");
        dialogueHUD.addLine("the password is");
        dialogueHUD.addLine("SWORDFISH");
        dialogueHUD.advanceDialogue();
    }

    public static function speakBob(npc:NPCSprite, playState:PlayState, speech:String)
    {
        var dialogueHUD:DialogueHUD = playState.startDialogue();
        dialogueHUD.addLine("You said " + speech);
        dialogueHUD.addLine("I like " + speech + "!");
        if(speech=="SWORDFISH")
        {
            dialogueHUD.addLine("You solved the puzzle!");
        }
        dialogueHUD.advanceDialogue();
    }

    public static function interactBob(npc:NPCSprite, playState:PlayState):Void
    {
        var dialogueHUD:DialogueHUD = playState.startDialogue();
        dialogueHUD.addLine("Yo, I'm " + npc.name + "!");
        dialogueHUD.addLine("Who are you?");
        dialogueHUD.advanceDialogue();
    }

}
