import util

class Entity(object):
    def __init__(self, maxHP, name, attack_damage):
        self.maxHP = maxHP
        self.HP = self.maxHP
        self.name = name
        self.attack_damage = attack_damage
        self.alive = True

    def calculate_damage_taken(self, attack_word):
        return util.get_triangle_damage(attack_word)

    def take_damage(self, damage):
        self.HP -= damage
        if self.HP <=0:
            self.die()

    def die(self):
        print(self.name + " died")
        self.alive = False

    def attack(self, target):
        target.take_damage(self.attack_damage)

    def __str__(self):
        return '['+self.name + ' ' + str(self.HP) + ']'

class Enemy(Entity):
    def __init__(self, maxHP=30, name='anderson', attack_damage=1):
        super(Enemy, self).__init__(maxHP, name, attack_damage)


class Player(Entity):
    def __init__(self, maxHP=50, name='player', attack_damage=1):
        super(Player, self).__init__(maxHP, name, attack_damage)

# recycle first 3 in pool
def skill_recycle(num=3):
    def skill(gstate):
        gstate.pool = gstate.pool[num:] + [util.sample_letter() for _ in range(num)]
    return skill

class Skill(object):
    def __init__(self, skill, max_cooldown=5):
        self.max_cooldown = max_cooldown
        self.cooldown = 0
        self.skill = skill

    def activate(self, gstate):
        if self.cooldown > 0:
            print('You cooldown dummy!')
            return
        self.skill(gstate)
        self.cooldown = self.max_cooldown

    def tick(self):
        if self.cooldown > 0:
            self.cooldown -= 1
