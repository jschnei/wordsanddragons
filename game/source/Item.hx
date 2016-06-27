package;

import flixel.FlxBasic;

class Item extends FlxBasic
{
    //TODO: may want to include link to imagepath here, or even make Item extend FlxSprite instead
    //if we don't want to do the above, then obviously we don't need a separate class for this
    public var name:String;

    public function new(name:String)
    {
        super();
        this.name = name;
    }
}