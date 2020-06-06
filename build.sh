cd flaskServer/
pip install -r requirements.txt
pytest --cov=app --cov-report term-missing tests/
