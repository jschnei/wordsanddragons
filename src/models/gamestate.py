import util
from models.player import Player
from models.enemies import Enemy
from models.skills import skill_recycle

class GameState(object):
    def __init__(self):
        self.player = Player()
        self.enemies = [Enemy()]
        self.pool = util.generate_pool()
        self.skills = [skill_recycle()]
        self.turn = 0

    def pretty_print(self):
        print(self.pool)
        print(self.player)
        for enemy in self.enemies:
            print(enemy)

    def use_skill(self, ind):
        assert ind < len(self.skills), "invalid skill num"
        self.skills[ind].activate(self)

    def process_attack(self, attack):
        new_pool = util.check_attack(attack, self.pool)
        if not new_pool:
            print("You dumbo!")
        else:
            # player attack enemies
            for enemy in self.enemies:
                damage = enemy.calculate_damage_taken(attack)
                enemy.take_damage(damage)
            self.enemies = [enemy for enemy in self.enemies if enemy.alive]

            # update the pool
            self.pool = util.generate_pool(new_pool)

    def tick(self):
        self.turn += 1
        for enemy in self.enemies:
            enemy.attack(self.player)

        for skill in self.skills:
            skill.tick()

        if self.turn % 10 == 0:
            self.enemies.append(Enemy())

    def is_game_over(self):
        return not self.player.alive or len(self.enemies) == 0