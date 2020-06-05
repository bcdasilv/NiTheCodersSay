import pytest
import sys, os
import hashlib

sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from app import *


def test_initial():
    password = hashlib.sha512(("test").encode('utf-8')).hexdigest()
    email = 'notvalidemail'
    assert verify(email, password) == False


def test_new_matchings():
    match = Matchings(1, 0)
    assert match.matcherId == 1
    assert match.matcheeId == 0


def test_new_profiles():
    profile = Profiles("About Me", "Bio")
    assert profile.about_me == "About Me"
    assert profile.bio == "Bio"


def test_new_users():
    user = Users("email", "username", "password", "zipcode", "dob", "name")
    assert user.email == "email"
    assert user.username == "username"
    assert user.password == "password"
    assert user.zipcode == "zipcode"
    assert user.dob == "dob"
    assert user.name == "name"