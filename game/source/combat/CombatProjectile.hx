package combat;

import flixel.util.FlxColor;
import haxe.ds.Vector;
using Lambda;

class CombatProjectile extends CombatEntity
{
    public var maxTimeToCollide:Int;
    public var timeToCollide:Int;
    public var owner:CombatEntity;

    public function new(maxHP:Int,
                        name:String,
                        attackDamage:Int,
                        time:Int,
                        ?owner:CombatEntity)
    {
        super(maxHP, name, attackDamage);
        maxTimeToCollide = time;
        timeToCollide = time;
        this.owner = owner;
    }

    public function getDefensePriority(defenseWord:String):Vector<Int>
    {
        return new Vector<Int>(1);
    }

    public function processDefense(defenseWord:String, handler:CombatHandler):Void
    {
        return;
    }

    public function tick(handler:CombatHandler):Void
    {
        timeToCollide--;
        if (timeToCollide==0)
            collide(handler);
    }

    public function collide(handler:CombatHandler):Void
    {
        handler.player.takeDamage(attackDamage);
        die();
    }

    // returns true if priority1 > priority2
    public static function comparePriority(priority1:Vector<Int>, priority2:Vector<Int>):Bool
    {
        for(i in 0...priority1.length)
        {
            if(i>=priority2.length)
                return true;

            if(priority1[i]>priority2[i])
                return true;

            if(priority1[i]<priority2[i])
                return false;
        }

        return false;
    }

    public function createSprite(X:Float=0, Y:Float=0):CombatProjectileSprite
    {
        var sprite:CombatProjectileSprite = new CombatProjectileSprite(X, Y, this, "assets/images/trashcan.png");
        return sprite;
    }
}

class RockProjectile extends CombatProjectile
{
    public var letters:Array<String>;
    
    public function new(maxHP:Int=1,
                        name:String="rock",
                        attackDamage:Int=6,
                        time:Int=900,
                        length:Int=6,
                        ?owner:CombatEntity)
    {
        super(maxHP, name, attackDamage, time, owner);

        var randomWord:String = CombatUtil.randomWord(length);
        letters = CombatUtil.shuffleLetters([for (i in 0...randomWord.length) randomWord.charAt(i)]);
        trace("QUICK ANAGRAM THIS: " + letters);
    }

    public override function getDefensePriority(defenseWord:String):Vector<Int>
    {
        if (!CombatUtil.WORDLIST.exists(function(word) return word==defenseWord))
        {
            return new Vector<Int>(1);
        }

        var defenseFreq = CombatUtil.generateFreqTable(CombatUtil.stringToArray(defenseWord));
        var lettersFreq = CombatUtil.generateFreqTable(letters);

        if (!CombatUtil.containedIn(defenseFreq, lettersFreq))
        {
            return new Vector<Int>(1);
        }

        var returnVec:Vector<Int> = new Vector<Int>(2);
        returnVec.set(0, 1);
        returnVec.set(1, -timeToCollide);
        return returnVec;
    }

    public override function processDefense(defenseWord:String, handler:CombatHandler):Void
    {
        handler.player.takeDamage(attackDamage-defenseWord.length);
        die();
    }

    public override function createSprite(X:Float=0, Y:Float=0):CombatProjectileSprite
    {
        var sprite:CombatProjectileSprite = new CombatProjectileSprite(X, Y, this, "assets/images/trashcan.png");
        return sprite;
    }

    public function getLetterString():String
    {
        return letters.join("");
    }
}

class ColorProjectile extends CombatProjectile
{
    public static var COLORS:Array<FlxColor> = [FlxColor.RED, FlxColor.BLUE, FlxColor.LIME, FlxColor.PURPLE, FlxColor.YELLOW, FlxColor.ORANGE, FlxColor.BROWN];
    public static var COLORNAMES:Array<String> = ["RED", "BLUE", "GREEN", "PURPLE", "YELLOW", "ORANGE", "BROWN"];

    public var colorIndex:Int;
    public var letters:Array<String>;
    public var color:FlxColor;

    public function new(maxHP:Int=1,
                        name:String="colorRock",
                        attackDamage:Int=10,
                        time:Int=900,
                        ?owner:CombatEntity)
    {
        super(maxHP, name, attackDamage, time, owner);
        colorIndex = Std.random(COLORS.length);
        var textIndex:Int = Std.random(COLORNAMES.length);
        color = COLORS[colorIndex];
        letters = COLORNAMES[textIndex].split("");
    }

    public override function getDefensePriority(defenseWord:String):Vector<Int>
    {
        if (!COLORNAMES.has(defenseWord))
            return new Vector<Int>(1);
        var returnVec:Vector<Int> = new Vector<Int>(2);
        returnVec.set(0, 1);
        returnVec.set(1, -timeToCollide);
        return returnVec;
    }

    public override function processDefense(defenseWord:String, handler:CombatHandler):Void
    {
        var chosenColorIndex:Int = COLORNAMES.indexOf(defenseWord);
        if (chosenColorIndex!=colorIndex)
            handler.player.takeDamage(attackDamage);
        die();
    }

    public override function createSprite(X:Float=0, Y:Float=0):CombatProjectileSprite
    {
        var sprite = new CombatProjectileSprite.ColorProjectileSprite(X, Y, this, "assets/images/trashcan.png");
        return sprite;
    }
}
