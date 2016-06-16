import models.enemies
import util

class Skill(object):
    def __init__(self, skill, max_cooldown=500):
        self.max_cooldown = max_cooldown
        self.cooldown = 0
        self.skill = skill

    def activate(self, gstate):
        if self.cooldown > 0:
            print('You cooldown dummy!')
            return
        self.skill(gstate)
        self.cooldown = self.max_cooldown

    def tick(self, gstate, passive=False):
        if self.cooldown > 0:
            self.cooldown -= 1
        else:
            if passive:
                self.activate()

# attack the player
def skill_attack_player(attack_damage=1):
    def skill(gstate):
        gstate.player.take_damage(attack_damage)
    return Skill(skill)

# spawn an enemy
def skill_spawn_enemy():
    def skill(gstate):
        gstate.enemies.append(models.enemies.Enemy())
    return Skill(skill, max_cooldown=1000)

# recycle first num letters in pool
def skill_recycle(num=3):
    def skill(gstate):
        gstate.pool = gstate.pool[num:] + [util.sample_letter() for _ in range(num)]
    return Skill(skill, max_cooldown=1000)
