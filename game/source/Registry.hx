package;

import combat.CombatState;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class Registry
{
    public static var playStateData:Null<PlayState.PlayStateData>;
    public static var globalDict:Map<String, String> = new Map<String, String>();

    //only use this variable for NPCScripts!!!
    public static var currPlayState:PlayState;

    public static function playState():PlayState
    {
        return currPlayState;
    }
}
