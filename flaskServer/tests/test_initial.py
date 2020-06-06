import pytest
import sys, os
import hashlib

sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from app import *


@pytest.fixture(scope='module')
def app():
    app = create_app()
    return app


def test_root(client):
    response = client.get("/")
    assert response.status_code == 200

def test_register(client):
    body = {"email": "test", "username": "test", "password": "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff", "zipcode": "93401", "dob": "2020-04-05", "name": "test"}
    response = client.post("/register", data=body)
    assert response.status_code == 200

def test_register2(client):
    body = {"email": "test2", "username": "test", "password": "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff", "zipcode": "93401", "dob": "2020-04-05", "name": "test"}
    response = client.post("/register", data=body)
    assert response.status_code == 200

def test_login(client):
    body = {"email": "test", "password": "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff"}
    response = client.post("/login", data=body)
    assert response.status_code == 200

def test_updateUser(client):
    header = {"email": "test", "password": "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff"}
    body = {"email": "test", "username": "test", "password": "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff", "zipcode": "93401", "dob": "2020-04-05", "name": "test"}
    response = client.post("/updateUser", headers=header, data=body)
    assert response.status_code == 200

def test_getUser(client):
    header = {"email": "test", "password": "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff"}
    response = client.get("/getUser", headers=header)
    assert response.status_code == 200

def test_updateProfile(client):
    header = {"email": "test", "password": "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff"}
    body = {"bio": "test bio", "pic_path": "test path", "about_me": "test about_me"}
    response = client.post("/updateProfile", headers=header, data=body)
    assert response.status_code == 200

def test_getProfile(client):
    header = {"email": "test", "password": "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff"}
    response = client.get("/getProfile", headers=header)
    assert response.status_code == 200

def test_match(client):
    header = {"email": "test", "password": "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff"}
    body = {"matcher": 1, "matchee": 2}
    response = client.post("/match", headers=header, data=body)
    assert response.status_code == 200

def test_getMatches(client):
    header = {"email": "test", "password": "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff"}
    response = client.get("/getMatches", headers=header)
    assert response.status_code == 200

def test_getNearby(client):
    header = {"email": "test", "password": "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff"}
    response = client.get("/getNearby", headers=header)
    assert response.status_code == 200

def test_makePost(client):
    header = {"email": "test", "password": "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff"}
    body = {"title": "Title", "body": "hi"}
    response = client.post("/makePost", headers=header, data=body)
    assert response.status_code == 200

def test_getPost(client):
    header = {"email": "test", "password": "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff"}
    response = client.get("/getPost", headers=header)
    assert response.status_code == 200
