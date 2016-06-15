import util

class Enemy:
    def __init__(self):
        self.HP = 10
        self.name = 'standard_enemy'
        self.attack_damage = 1
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

class Player:
    def __init__(self):
        self.HP = 50
        self.name = 'player'
        self.attack_damage = 1
        self.alive = True

    def take_damage(self, damage):
        self.HP -= damage
        if self.HP <=0:
            self.die()

    def die(self):
        print("I died")
        self.alive = False

    def __str__(self):
        return '['+self.name + ' ' + str(self.HP) + ']'

class GameState:
    def __init__(self):
        self.player = Player()
        self.enemies = {Enemy()}
        self.pool = util.generate_pool()
        self.turn = 0

    def pretty_print(self):
        print(self.pool)
        print(self.player)
        for enemy in self.enemies:
            print(enemy)

    def process_attack(self, attack):
        new_pool = util.check_attack(attack, self.pool)
        if not new_pool:
            print("You dumbo!")
        else:
            # resolve combat
            damage = util.get_damage(attack)

            # player attack enemies
            for enemy in self.enemies:
                enemy.take_damage(damage)
            self.enemies = {enemy for enemy in self.enemies if enemy.alive}

            # enemies attack player
            # TODO: put on timer


            # update the pool
            self.pool = util.generate_pool(new_pool)


    def tick(self):
        self.turn += 1
        for enemy in self.enemies:
            enemy.attack(self.player)

        if self.turn % 10 == 0:
            self.enemies.add(Enemy())
