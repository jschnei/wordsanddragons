from models.common import Entity

class Player(Entity):
    def __init__(self, maxHP=50, name='player', attack_damage=1):
        super(Player, self).__init__(maxHP, name, attack_damage)
