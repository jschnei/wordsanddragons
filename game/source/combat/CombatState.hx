package combat;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxMath;

class CombatState extends FlxState
{
    var handler:CombatHandler;
    var attackString:String;
    var gameOver:Bool;

    var playerHUD:PlayerHUD;
    var enemyHUD:EnemyHUD;

    var callback:Void->Void;

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

        attackString = "";
        gameOver = false;

        playerHUD = new PlayerHUD(handler.player);
        add(playerHUD);

        enemyHUD = new EnemyHUD(handler);
        add(enemyHUD);

        handler.prettyPrint();
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if(handler.isGameOver())
        {
            callback();
            trace("going back to playstate");
            trace(GameGlobals.playState);
            FlxG.switchState(GameGlobals.playState);
        }

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
            if (handler.combatMode==OFFENSE)
                playerHUD.setPoolColor(FlxColor.WHITE);
            else if (handler.combatMode==DEFENSE)
                playerHUD.setPoolColor(FlxColor.GRAY);
        }

        playerHUD.setPoolText(handler.pool.join(""));
        playerHUD.setInputText(attackString);

        playerHUD.updateEntities();
        enemyHUD.updateEntities();

        handler.tick();
	}

    public function setCallback(callback:Void->Void)
    {
        this.callback = callback;
    }
}
