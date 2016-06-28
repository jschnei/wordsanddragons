package;

class ActionQueue
{

    private var _actions:Array<Void->Void>;
    private var _actionInd:Int = 0;

    public function new()
    {
        _actions = new Array<Void->Void>();
    }

    public function addAction(action:Void->Void):Void
    {
        _actions.push(action);
    }

    public function next():Void
    {
        if(_actionInd < _actions.length)
        {
            var action:Void->Void = _actions[_actionInd];
            _actionInd++;
            action();
        }
    }




}
