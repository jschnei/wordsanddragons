import models.common
import models.skills

class Player(models.common.Entity):
    def __init__(self, maxHP=50, name='player', attack_damage=1):
        super(Player, self).__init__(maxHP, name, attack_damage)
        self.skills.append(models.skills.skill_heal())
        self.skill_bar = {1: models.skills.skill_recycle()}
