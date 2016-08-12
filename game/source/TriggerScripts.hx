package;
import combat.CombatHandler;
import combat.CombatScripts;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
using Lambda;

class TriggerScripts
{
    public static function triggerInstructions():Void
    {
        var actionQueue:ActionQueue = new ActionQueue();
        var lines:Array<String> = ["Use WASD/arrow keys to walk around.",
                                   "Press Z to interact with people.",
                                   "Press ENTER to speak to them."];
        actionQueue.addAction(NPCActions.speakLines(lines, actionQueue));
        actionQueue.next();
    }
}
