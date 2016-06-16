class PassiveSkill(object):
    def __init__(self, effect, activated_by_func):
        self.effect = effect
        self.activated_by_func = activated_by_func



heal_amount = 5

def heal_effect(gstate):
    gstate.player.heal(heal_amount)

def heal_abf(word, gstate):
    if len(word) > 0:
        return word[0] == 'H'
    else:
        return False

heal_skill = PassiveSkill(heal_effect, heal_abf)
