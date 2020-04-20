import pytest
import sys, os
import hashlib

sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from app import *


def test_initial():
    password = hashlib.sha512(("test").encode('utf-8')).hexdigest()
    email = 'notvalidemail'
    assert verify(email, password) == False
