package;
import combat.CombatState;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(640, 480, PlayState, 1, 60, 60, false));
        //addChild(new FlxGame(640, 480, PlayState, 1, 60, 60, true));
	}
}
