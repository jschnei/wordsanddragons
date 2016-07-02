package;

import sys.io.File;
using Lambda;
using StringTools;

class CombatUtil
{
    public static inline var ALPHABET:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    public static var LETTER_FREQ:Array<Float> = [.08167, .01492, .02782, .04253, .12702, .02228, .02015, .06094, .06966, .00153, .00772, .04025, .02406, .06749, .07507, .01929, .00095, .05987, .06327, .09056, .02758, .00978, .02361, .00150, .01974, .00074];
    public static inline var POOL_SIZE:Int = 10;
    public static inline var WORDLIST_FILE:String = "assets/data/sowpods.txt";
    public static var WORDLIST:Array<String>;

    public static function initialize(wordlistFile:String=WORDLIST_FILE):Void
    {
        WORDLIST = sys.io.File.getContent(wordlistFile).split('\n');
        WORDLIST = WORDLIST.map(function(str) return str.trim());
    }

    public static function randomWord(?length:Int):String
    {
        if (length==null)
        {
            return WORDLIST[Std.random(WORDLIST.length)];
        }
        else
        {
            var culled_list:Array<String> = WORDLIST.filter(function(word) return word.length==length);
            return culled_list[Std.random(culled_list.length)];
        }
    }

    public static function getTriangleDamage(attack:String):Int
    {
        var attackLen:Int = attack.length;
        return cast (attackLen-1)*(attackLen-2)/2;
    }

    public static function sampleLetter(letter_freq:Array<Float>):String
    {
        if (letter_freq.length!=ALPHABET.length)
        {
            throw("letter_freq array not correct length");
        }

        var sum = letter_freq.fold(function(a:Float,b:Float) return a+b, 0.0);
        var rand = Math.random()*sum;
        var upto:Float = 0.0;
        for (i in 0...letter_freq.length)
        {
            upto += letter_freq[i];
            if (upto>=rand)
                return ALPHABET.charAt(i);
        }

        throw("weightedChoice screwed up somehow");
    }

    //the pool should be an array of single letter strings
    public static function generatePool(?partialPool:Array<String>):Array<String>
    {
        if (partialPool==null)
            partialPool = [];
        if (partialPool.length>POOL_SIZE)
        {
            throw("pool was too large somehow");
        }

        var letter_weights = [for (i in 0...ALPHABET.length) Math.pow(.5, partialPool.count(function(c) return c==ALPHABET.charAt(i)))];
        var adj_freqs = [for (i in 0...LETTER_FREQ.length) LETTER_FREQ[i]*letter_weights[i]];
        return partialPool.concat([for (_ in 0...POOL_SIZE-partialPool.length) sampleLetter(adj_freqs)]);
    }
}
