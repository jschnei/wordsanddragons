from models.player import Player
from models.enemies import Enemy, DoubleLetterEnemy
from models.skills import skill_recycle, skill_spawn_enemy

import util

class GameState(object):
    def __init__(self):
        self.player = Player()
        self.enemies = [Enemy(), DoubleLetterEnemy()]
        self.pool = util.generate_pool()
        self.skills = [skill_spawn_enemy()]
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
            # apply attack skills
            for skill in self.player.skills:
                if skill.trigger=='attack':
                    skill.activate(self, word=attack)

            # player attack enemies
            for enemy in self.enemies:
                damage = enemy.calculate_damage_taken(attack)
                enemy.take_damage(damage)
            self.enemies = [enemy for enemy in self.enemies if enemy.alive]

            # update the pool
            self.pool = util.generate_pool(new_pool)

    def tick(self):
        for skill in self.player.skills:
            if skill.trigger=='tick':
                skill.tick(self)

        # assuming here that all skill bar skills are actives
        for skill in self.player.skill_bar.values():
            skill.tick(self)

        for enemy in self.enemies:
            for skill in enemy.skills:
                if skill.trigger=='tick':
                    skill.tick(self)

        for skill in self.skills:
            if skill.trigger=='tick':
                skill.tick(self)

    def is_game_over(self):
        return not self.player.alive or len(self.enemies) == 0
