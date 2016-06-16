import models.common
import models.skills

class Player(models.common.Entity):
    def __init__(self, maxHP=50, name='player', attack_damage=1):
        super(Player, self).__init__(maxHP, name, attack_damage)
        self.actives = [models.skills.skill_recycle()]
