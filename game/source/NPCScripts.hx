package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class NPCScripts
{
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
