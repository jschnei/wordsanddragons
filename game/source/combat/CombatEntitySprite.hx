package combat;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class CombatEntitySprite extends FlxTypedGroup<FlxSprite>
{
    public static inline var HP_FONT_SIZE = 10;
    public static inline var HP_BAR_HEIGHT = 20;
    public static var MAX_HP_COLOR = new FlxColor(0xFF440000);
    public static var CUR_HP_COLOR = new FlxColor(0xFFDD0000);


    public var entity:CombatEntity;
    public var imageFile:String;
    public var showHP:Bool;

    private var _sprite:FlxSprite;
    private var _maxHealthBar:FlxSprite;
    private var _curHealthBar:FlxSprite;
    private var _healthText:FlxText;

    public function new(?X:Float=0,
                        ?Y:Float=0,
                        entity:CombatEntity,
                        imageFile:String,
                        showHP:Bool=true)
    {
        super();

        this.entity = entity;
        this.showHP = showHP;
        this.imageFile = imageFile;

        _sprite = new FlxSprite(X, Y, imageFile);
        add(_sprite);

        if(showHP)
        {
            _maxHealthBar = new FlxSprite();
            _curHealthBar = new FlxSprite();
            _healthText = new FlxText(0,0, 0, "", HP_FONT_SIZE);

            add(_maxHealthBar);
            add(_curHealthBar);
            add(_healthText);

            updateHealthBar();
        }
    }

    public function getWidth():Float
    {
        return _sprite.width;
    }

    public function setPosition(X:Float, Y:Float):Void
    {
        _sprite.x = X;
        _sprite.y = Y;
    }

    public function updateHealthBar():Void
    {
        _maxHealthBar.makeGraphic(cast _sprite.width, HP_BAR_HEIGHT, MAX_HP_COLOR);
        _maxHealthBar.x = _sprite.x;
        _maxHealthBar.y = _sprite.y + _sprite.height;

        var curWidth:Int = cast _sprite.width*(entity.HP/entity.maxHP);
        _curHealthBar.makeGraphic(curWidth, HP_BAR_HEIGHT, CUR_HP_COLOR);
        _curHealthBar.x = _sprite.x;
        _curHealthBar.y = _sprite.y + _sprite.height;

        _healthText.text = entity.dispStr();
        _healthText.x = _maxHealthBar.x + (_maxHealthBar.width - _healthText.width)/2;
        _healthText.y = _maxHealthBar.y + (_maxHealthBar.height - _healthText.height)/2;
    }

    public function getCenterX():Float
    {
        return _sprite.x+(_sprite.width/2);
    }

    public function getCenterY():Float
    {
        return _sprite.y+(_sprite.height/2);
    }
}
