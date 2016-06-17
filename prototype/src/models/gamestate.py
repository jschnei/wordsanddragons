from models.player import Player
from models.enemies import TriangleEnemy, DoubleLetterEnemy
from models.skills import skill_recycle, skill_spawn_enemy

from enum import Enum
import util

class GameMode(Enum):
    OFFENSE = 1
    DEFENSE = 2

class GameState(object):
    def __init__(self):
        self.player = Player()
        self.enemies = [TriangleEnemy(), DoubleLetterEnemy()]
        self.projectiles = []
        self.pool = util.generate_pool()
        self.skills = [skill_spawn_enemy()]
        self.game_mode = GameMode.OFFENSE
        self.turn = 0

    def switch_modes(self):
        if self.game_mode == GameMode.OFFENSE:
            self.game_mode = GameMode.DEFENSE
        elif self.game_mode == GameMode.DEFENSE:
            self.game_mode = GameMode.OFFENSE

    def pretty_print(self):
        print(self.pool)
        print(self.player)
        for enemy in self.enemies:
            print(enemy)
        for proj in self.projectiles:
            print(proj)

    def process_defense(self, defense):
        if not self.projectiles:
            return

        target = max(self.projectiles, key=lambda pr: pr.defense_priority(defense))
        target.process_defense(defense, self)

        self.projectiles = [pr for pr in self.projectiles if pr.alive]


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

        for projectile in self.projectiles:
            projectile.tick(self)
        self.projectiles = [pr for pr in self.projectiles if pr.alive]

        for skill in self.skills:
            if skill.trigger=='tick':
                skill.tick(self)



    def is_game_over(self):
        return not self.player.alive
