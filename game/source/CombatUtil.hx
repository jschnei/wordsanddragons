package;

import sys.io.File;

class CombatUtil
{
    public static var LETTER_FREQ:Array<Float> = [.08167, .01492, .02782, .04253, .12702, .02228, .02015, .06094, .06966, .00153, .00772, .04025, .02406, .06749, .07507, .01929, .00095, .05987, .06327, .09056, .02758, .00978, .02361, .00150, .01974, .00074];
    public static inline var WORDLIST_FILE:String = "assets/data/sowpods.txt";
    public static var WORDLIST:Array<String>;

    public static function initialize(wordlistFile:String=WORDLIST_FILE):Void
    {
        WORDLIST = sys.io.File(wordlistFile).split('\n');
    }

    public static function getTriangleDamage(attack:String):Int
    {
        attackLen = attack.length;
        return (attackLen-1)*(attackLen-2)/2;
    }
}
