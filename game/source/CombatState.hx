package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class CombatState extends FlxState
{
	override public function create():Void
	{
        CombatUtil.initialize();
        trace(CombatUtil.generatePool());
        trace(CombatUtil.randomWord(6));
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
