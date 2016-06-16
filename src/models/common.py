class Entity(object):
    def __init__(self, maxHP, name, attack_damage):
        self.maxHP = maxHP
        self.HP = self.maxHP
        self.name = name
        self.attack_damage = attack_damage
        self.alive = True

    def take_damage(self, damage):
        self.HP -= damage
        if self.HP <=0:
            self.die()

    def die(self):
        print("I died")
        self.alive = False

    def attack(self, target):
        target.take_damage(self.attack_damage)

    def __str__(self):
        return '['+self.name + ' ' + str(self.HP) + ']'