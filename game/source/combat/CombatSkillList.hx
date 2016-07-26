package combat;

//I would just extend Array<CombatSkill> but apparently it's a basic type?
class CombatSkillList
{
    public var owner:CombatEntity;
    public var skillList:Array<CombatSkill>;

    public function new(owner:CombatEntity)
    {
        this.owner = owner;
        skillList = new Array<CombatSkill>();
    }

    public function push(skill:CombatSkill):Void
    {
        skill.setOwner(owner);
        skillList.push(skill);
    }

    public function iterator()
    {
        return skillList.iterator();
    }
}