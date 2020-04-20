import sqlalchemy
import math

db = sqlalchemy.create_engine('sqlite:///zipcodes.db')
db.echo = False

def build_metadata():
    metadata = sqlalchemy.MetaData(db)
    metadata.bind.echo = False
    metadata.bind.text_factory = str

    return metadata

def select_zipcode(zipcode):
    fields = (
        'zip',
        'city',
        'state',
        'lat',
        'long',
        'timezone',
        'dst',
        )
    metadata = build_metadata()
    zipcodes_table = sqlalchemy.Table('zipcodes', metadata, autoload=True)
    result = zipcodes_table.select(zipcodes_table.c.zip == zipcode)
    try:
        return dict(zip(fields,result.execute().fetchone()))
    except (TypeError, sqlalchemy.exc.OperationalError):
        return False

def haversine(lat1, long1, lat2, long2):
    """
    haversine formula to calculate the distance from lat/long coords on a sphere.
    Because the earth is somewhat elliptical can give errors up to 0.3%
    """
    radius = 3963.1676 #Radius of earth in miles
    lat1, long1, lat2, long2 = map(math.radians, [lat1, long1, lat2, long2])
    dlat = lat2 - lat1
    dlong = long2 - long1

    a = math.sin(dlat/2) * math.sin(dlat/2) + math.cos(math.radians(lat1)) \
        * math.cos(math.radians(lat2)) * math.sin(dlong/2) * math.sin(dlong/2)
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a))
    d = radius * c

    return d
