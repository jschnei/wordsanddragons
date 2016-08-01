package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
using Lambda;

class NPCActions
{
    public static function moveSprite(sprite:FlxSprite, actionQueue:ActionQueue)
    {
        return function(){
            FlxTween.tween(sprite, { x: 50}, .33, { ease: FlxEase.circOut, onComplete: function(_) actionQueue.next()});
        };
    }

    public static function killSprite(sprite:FlxSprite, actionQueue:ActionQueue)
    {
        return function(){
            sprite.kill();
            actionQueue.next();
        };
    }

    public static function oneLiner(line:String, actionQueue:ActionQueue)
    {
        return function(){
            trace("can anyone hear me?");
            var playState:PlayState = Registry.currPlayState;
            playState.dialogueHUD.addLine(line);
            playState.startDialogue(actionQueue.next);
        }
    }

    public static function doCombat(sprite:FlxSprite, actionQueue:ActionQueue)
    {
        return function(){
            Registry.currPlayState.startCombat(function(){ 
                actionQueue.next();
            });
        };
    }
}
