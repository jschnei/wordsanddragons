import models.enemies
import util

class Skill(object):
    def __init__(self, skill, trigger=None, max_cooldown=0):
        self.max_cooldown = max_cooldown
        self.cooldown = 0
        self.skill = skill
        self.trigger = trigger

    def activate(self, gstate, **kwargs):
        if self.cooldown > 0:
            print('You cooldown dummy!')
            return
        self.skill(gstate, **kwargs)
        self.cooldown = self.max_cooldown

    def tick(self, gstate, passive=False):
        if self.cooldown > 0:
            self.cooldown -= 1
        else:
            if passive:
                self.activate()




### 'attack' skills
def skill_heal(heal_amount=5):
    def heal_effect(gstate):
        gstate.player.heal(heal_amount)

    def heal_condition(gstate, word):
        if len(word) > 0:
            return word[0] == 'H'
        else:
            return False

    def skill(gstate, **kwargs):
        word = kwargs.get('word', '')
        if heal_condition(gstate, word):
            heal_effect(gstate)
    return Skill(skill, trigger='attack')


### 'tick' skills
# attack the player
def skill_attack_player(attack_damage=1):
    def skill(gstate):
        gstate.player.take_damage(attack_damage)
    return Skill(skill, trigger='tick', max_cooldown=500)

# spawn an enemy
def skill_spawn_enemy():
    def skill(gstate):
        gstate.enemies.append(models.enemies.Enemy())
    return Skill(skill, trigger='tick', max_cooldown=1000)

### 'skillbar' skills
# recycle first num letters in pool
def skill_recycle(num=3):
    def skill(gstate):
        gstate.pool = gstate.pool[num:] + [util.sample_letter() for _ in range(num)]
    return Skill(skill, max_cooldown=1000)
