package combat;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxMath;

// Responsible for displaying the combat screen and handling user input
// CombatHandler handles all combat logic, such as doing damage and storing enemies
// playerHUD and enemyHUD contain the sprites and are responsible for updating them
class CombatState extends FlxState
{
    public var combatBG:CombatBackground;

    public var handler:CombatHandler;
    var attackString:String;
    var gameOver:Bool;

    var playerHUD:PlayerHUD;
    var enemyHUD:EnemyHUD;

    var lastPool:String="";

    //a more proper name would be "callbackGenerator" but oh well
    //This is a function which takes in the combat outcome and generates
    //a callback function that will be called in the returned playstate.
    //This is used to, e.g., display dialogue after combat depending on the result
    var callback:CombatHandler.CombatOutcome->(Void->Void);

	override public function create():Void
	{
        CombatUtil.initialize();
        /* Stuff to test combat utils
        trace(CombatUtil.generatePool());
        trace(CombatUtil.randomWord(6));
        var attackWordSample = "HELLO";
        var poolSample = ["A", "E", "L", "L", "I", "O", "U", "H", "E", "H"];
        trace(CombatUtil.processAttack(attackWordSample, poolSample));*/
        if (handler == null)
        {
            handler = new CombatHandler(true);
        }

        attackString = "";
        gameOver = false;

        combatBG = new CombatBackground("combatscreen");
        add(combatBG.mBG);

        playerHUD = new PlayerHUD(handler.player);
        add(playerHUD);

        enemyHUD = new EnemyHUD(handler);
        add(enemyHUD);

        handler.prettyPrint();
		super.create();
	}

    //we are doing all updating in this function so we can have
    //full control over the order in which updates happen
    //(i.e. we're not overriding the update function in other combat classes)
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if(handler.isGameOver())
        {
            var outcome:CombatHandler.CombatOutcome = handler.getOutcome();

            var ps:PlayState = new PlayState();
            Registry.currPlayState = ps;

            //we are assuming that callback is CombatOutcome->Void->Void, so this is a Void->Void
            ps.onCreate = callback(outcome);

            FlxG.switchState(ps);
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
        else if ((key >= cast FlxKey.ONE) && (key <= cast FlxKey.NINE))
        {
            var skill:CombatSkill = handler.player.skillBar.get(key);
            if (skill!=null)
            {
                skill.activate(handler);
            }
        }
        else if(key == FlxKey.TAB)
        {
            handler.switchModes();
            trace(callback);
            if (handler.combatMode==OFFENSE)
            {
                playerHUD.setInputColor(FlxColor.RED);
                playerHUD.setPoolColor(FlxColor.BLACK);
            }
            else if (handler.combatMode==DEFENSE)
            {
                playerHUD.setInputColor(FlxColor.GREEN);
                playerHUD.setPoolColor(FlxColor.GRAY);
            }
        }

        // only update pool when it changes!
        var curPool:String = handler.pool.join("");
        if(curPool != lastPool)
        {
            playerHUD.setPool(handler.pool);
            lastPool = curPool;
        }

        playerHUD.setInputText(attackString);

        playerHUD.updateEntities();
        enemyHUD.updateEntities();

        handler.tick();
	}

    public function setCallback(callback:CombatHandler.CombatOutcome->(Void->Void))
    {
        this.callback = callback;
    }
}
