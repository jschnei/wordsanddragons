from models.player import Player
from models.enemies import Enemy, DoubleLetterEnemy
from models.passive_skills import heal_skill
from models.skills import skill_recycle, skill_spawn_enemy

import util

class GameState(object):
    def __init__(self):
        self.player = Player()
        self.enemies = [Enemy(), DoubleLetterEnemy()]
        self.pool = util.generate_pool()
        self.passives = [skill_spawn_enemy()]
        self.passive_skills = [heal_skill]
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
            # apply passive skills
            for ps in self.passive_skills:
                if ps.activated_by_func(attack, self):
                    ps.effect(self)

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

        for skill in self.player.actives:
            skill.tick(self)

        for skill in self.player.passives:
            skill.tick(self)

        for enemy in self.enemies:
            for skill in enemy.passives:
                skill.tick(self)

        for skill in self.passives:
            skill.tick(self)

    def is_game_over(self):
        return not self.player.alive or len(self.enemies) == 0
