from models.common import Entity

class Enemy(Entity):
    def __init__(self, maxHP=30, name='anderson', attack_damage=1):
        super(Enemy, self).__init__(maxHP, name, attack_damage)
