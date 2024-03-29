import random

ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
LETTER_FREQ = [.08167, .01492, .02782, .04253, .12702, .02228, .02015, .06094, .06966, .00153, .00772, .04025, .02406, .06749, .07507, .01929, .00095, .05987, .06327, .09056, .02758, .00978, .02361, .00150, .01974, .00074]
POOL_SIZE = 10
WORDLIST_FILE = '../sowpods.txt'

# generate wordlist
WORDLIST = {line.strip() for line in open(WORDLIST_FILE, 'r')}

# check if letters in freq1 are a subset of letters in freq2
def contained_in(freq1, freq2):
    return all([freq1[c] <= freq2[c] for c in ALPHABET])

def get_freq(letters):
    freq = {c: 0 for c in ALPHABET}
    for c in letters:
        freq[c]+=1
    return freq

def random_word(length=None):
    if not length:
        return random.choice(list(WORDLIST))
    else:
        return random.choice([word for word in WORDLIST if len(word)==length])

def weighted_choice(choices):
    total = sum(w for c, w in choices)
    r = random.uniform(0, total)
    upto = 0
    for c, w in choices:
        if upto + w >= r:
            return c
        upto += w
    assert False, "Shouldn't get here"

def sample_letter(freq=LETTER_FREQ):
    assert len(freq)==26, "Freq array has size != 26"
    return weighted_choice(list(zip(ALPHABET, freq)))

def generate_pool(partial=[]):
    assert len(partial) <= POOL_SIZE, "Too many letters in partial pool"
    adj_freq = [LETTER_FREQ[i] * (1./2. ** partial.count(ALPHABET[i])) for i in range(26)] # magic number testing
    return partial + [sample_letter(adj_freq) for _ in range(POOL_SIZE - len(partial))]

def check_attack(attack, pool):
    if attack not in WORDLIST:
        return False

    used_pool = [[p, False] for p in pool]

    for letter in attack:
        try:
            letter_index = used_pool.index([letter, False])
        except ValueError:
            return False
        used_pool[letter_index][1] = True

    new_pool = [p[0] for p in used_pool if not p[1]]
    return new_pool

def get_triangle_damage(attack):
    attack_len = len(attack)
    return (attack_len-1)*(attack_len-2)//2
