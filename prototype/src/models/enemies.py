import models.common
import models.skills
import util

class Enemy(models.common.Entity):
    def __init__(self, maxHP, name, attack_damage):
        super(Enemy, self).__init__(maxHP, name, attack_damage)

    def calculate_damage_taken(self, attack_word):
        raise NotImplementedError

class TriangleEnemy(Enemy):
    def __init__(self, maxHP=30,
                       name='anderson',
                       attack_damage=1):
        super(TriangleEnemy, self).__init__(maxHP, name, attack_damage)
        self.skills.append(models.skills.skill_throw_rock())

    def calculate_damage_taken(self, attack_word):
        return util.get_triangle_damage(attack_word)

class DoubleLetterEnemy(Enemy):
    def __init__(self, maxHP=20,
                       name='phillip',
                       attack_damage=1):
        super(DoubleLetterEnemy, self).__init__(maxHP, name, attack_damage)
        self.skills.append(models.skills.skill_attack_player(attack_damage))

    def calculate_damage_taken(self, attack_word):
        has_double_letter = False
        for i in range(len(attack_word)-1):
            if attack_word[i]==attack_word[i+1]:
                has_double_letter = True

        if has_double_letter:
            return 2*len(attack_word)
        else:
            return 1
