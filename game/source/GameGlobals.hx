package;

import combat.CombatState;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class GameGlobals
{
    public static var playState:PlayState;
    public static var combatState:CombatState = new CombatState();
}
