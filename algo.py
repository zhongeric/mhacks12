#
# Users with alike or similar ranks will be shown to each other ( 7 will be shown to 6, 8)
# Optimize for people to like, or message
#
# Users are ranked by:
#   - the % of people that "liked" you and their own rating
#   - the % of poeple who "liked" you back (matches) and their rating
#   - user activity within the app (if you like everyone, penalize. safe area = 30-70% like)
#   - user activity with engaging (starting messages)

class User(object):
    def __init__(self):
        self.score = 0

    def history(self):
        # return history, previous matches
        pass

    def currentGroup(self):
        # return currentGroup being constructed
        pass

    def changeScore(self, change):
        self.score += change
