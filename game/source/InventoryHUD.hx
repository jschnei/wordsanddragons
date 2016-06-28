package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class InventoryHUD extends FlxTypedGroup<FlxSprite>
{
    //obviously this sucks right now
    public static inline var INV_WIDTH = 200;
    public static inline var INV_HEIGHT = 300;
    public static inline var FONT_SIZE = 20;

    public var inventory:FlxTypedGroup<Item>;

    private var _invBack:FlxSprite;
    private var _itemText:FlxText;

    public function new()
    {
        super();
        _invBack = new FlxSprite().makeGraphic(INV_WIDTH, INV_HEIGHT, FlxColor.WHITE);
        _invBack.drawRect(1, 1, INV_WIDTH-2, INV_HEIGHT-2, FlxColor.BLACK);
        add(_invBack);
        _itemText = new FlxText(_invBack.x+5, _invBack.y+5, 0, "", 20);
        add(_itemText);

        inventory = new FlxTypedGroup<Item>();
        inventory.add(new Item("ABBOTT"));
        inventory.add(new Item("BEAR"));
        inventory.add(new Item("DOODAD"));
        inventory.add(new Item("ENTREE"));
        inventory.add(new Item("LOLLIPOP"));
        inventory.add(new Item("SPOONS"));
        
        forEach(function(spr:FlxSprite){
            spr.scrollFactor.set(0, 0);
        });

        kill();
    }

    public function updateText():Void
    {
        _itemText.text = generateText();
    }

    private function generateText():String
    {
        var text:String = "";
        for (item in inventory)
        {
            text += (item.name.toUpperCase()+"\n");
        }
        return text;
    }
}