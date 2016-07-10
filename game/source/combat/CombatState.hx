package combat;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class CombatState extends FlxState
{
    var handler:CombatHandler;
    var enemyText:FlxText;
    var playerText:FlxText;
    var poolText:FlxText;
    var attackText:FlxText;
    var attackString:String;
    var gameOver:Bool;

	override public function create():Void
	{
        CombatUtil.initialize();
        /* Stuff to test combat utils
        trace(CombatUtil.generatePool());
        trace(CombatUtil.randomWord(6));
        var attackWordSample = "HELLO";
        var poolSample = ["A", "E", "L", "L", "I", "O", "U", "H", "E", "H"];
        trace(CombatUtil.processAttack(attackWordSample, poolSample));*/
        handler = new CombatHandler();

        attackText = new FlxText(0,0,0,"",20);
        attackText.screenCenter();
        add(attackText);
        attackString = "";
        gameOver = false;
        handler.prettyPrint();
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        var key = FlxG.keys.firstJustPressed();
        if((key >= cast FlxKey.A) && (key <= cast FlxKey.Z))
        {
            attackString += String.fromCharCode(key);
        }
        else if(key == FlxKey.BACKSPACE)
        {
            var len:Int = attackString.length;
            if(len > 0)
            {
                attackString = attackString.substring(0, len-1);
            }
        }
        else if(key == FlxKey.ENTER)
        {
            if (handler.combatMode == CombatHandler.CombatMode.OFFENSE)
                handler.processAttack(attackString);
            else if (handler.combatMode == CombatHandler.CombatMode.DEFENSE)
                handler.processDefense(attackString);
            attackString = "";
            handler.prettyPrint();
        }
        else if(key == FlxKey.TAB)
        {
            handler.switchModes();
        }

        attackText.text = attackString;
        attackText.screenCenter();

        handler.tick();
	}
}
