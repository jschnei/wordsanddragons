import util

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
            
# recycle first 3 in pool
def skill_recycle(num=3):
    def skill(gstate):
        gstate.pool = gstate.pool[num:] + [util.sample_letter() for _ in range(num)]
    return Skill(skill)