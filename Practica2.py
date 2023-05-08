# Practica2.py
# Laura Villarroya-06/05/2023

import sqlalchemy
from sqlalchemy import create_engine, Column, Integer, String, ForeignKey
from sqlalchemy.orm import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import inspect
from sqlalchemy import text

# Crea la conexión a la base de datos Sakila.
engine = create_engine('mysql+pymysql://root:bd22223@localhost/sakila')
Session = sessionmaker(bind=engine)
session = Session()

# Verifica la conexión a la base de datos.
try:
    engine.connect()
    print("Conexión exitosa a la base de datos")
except sqlalchemy.exc.OperationalError as e:
    print("Error al conectar a la base de datos:", str(e))

# Crea la clase "Base".
Base = declarative_base()

# Define las clases.
class Country(Base):
    __tablename__ = 'country'
    country_id = Column(Integer, primary_key=True)
    country = Column(String(50), nullable=False)

class City(Base):
    __tablename__ = 'city'
    city_id = Column(Integer, primary_key=True)
    city = Column(String(50), nullable=False)
    country_id = Column(Integer, ForeignKey('country.country_id'))

class User(Base):
    __tablename__ = 'usuario'
    usuario_id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    name = Column(String(50))
    age = Column(Integer)
    email = Column(String(50), unique=True)
    
# Define las funciones para el menú principal.
def crear_pais(nombre):
    session = Session()
    pais = Country(country=nombre)
    session.add(pais)
    session.commit()
    session.close()
    print("Se ha creado el pais.")

def listar_paises():
    session = Session()
    paises = session.query(Country).all()
    for pais in paises:
        print(pais.country_id, pais.country)

    session.close()

def eliminar_pais(id_pais):
    session = Session()
    pais_buscado = session.query(Country).filter_by(country_id=id_pais).first()
    if pais_buscado:
    	# Foreign Key deshabilitada.
    	session.execute(text("SET FOREIGN_KEY_CHECKS = 0"))
    	session.delete(pais_buscado)
    	session.commit()
    	print("Se ha eliminado el país.")
    	session.close()
    else:
    	print("No se ha encontrado un país con ese id.")
    	session.close()

def crear_ciudad(nombre, id_pais):
    session = Session()
    pais_buscado = session.query(Country).filter_by(country_id=id_pais).first()
    if pais_buscado is None:
    	print("No existe un país con el id proporcionado.")
    	return
    ciudad = City(country_id=id_pais, city=nombre)
    session.add(ciudad)
    session.commit()
    session.close()
    print("Se ha creado la ciudad.")

def listar_ciudades():
    session = Session()
    ciudades = session.query(City).all()
    for ciudad in ciudades:
        pais_buscado = session.query(Country).filter_by(country_id=ciudad.country_id).first()
        if pais_buscado:
            print(ciudad.city_id, ciudad.country_id, ciudad.city, pais_buscado.country)
        else:
            print(ciudad.city_id, ciudad.country_id, ciudad.city)

    session.close()

def eliminar_ciudad(id_ciudad):
    session = Session()
    ciudad_buscada = session.query(City).filter_by(city_id=id_ciudad).first()
    if ciudad_buscada:
    	# Elimina las filas relacionadas con la tabla "city".
    	session.query(City).filter_by(country_id=id_ciudad).delete()
    	
    	# Foreign Key deshabilitada.
    	session.execute(text("SET FOREIGN_KEY_CHECKS = 0"))
    	# Elimina las filas relacionadas con la tabla "address".
    	session.execute(text("DELETE FROM address WHERE city_id = :city_id"), {"city_id": ciudad_buscada.city_id})
    		
    	session.delete(ciudad_buscada)
    	session.commit()
    	print("Se ha eliminado la ciudad.")
    	session.close()
    else:
        print("No se ha encontrado una ciudad con ese id.")
        session.close()

def crear_tabla_usuarios():
	obtener_informacion = inspect(engine)
	if 'usuario' not in obtener_informacion.get_table_names():
		Base.metadata.tables['usuario'].create(bind=engine, checkfirst=True)
		print("Tabla de usuarios creada.")
	else:
		print("Ya hay una tabla de usuarios creada.")
		   
def borrar_tabla_usuarios():
	obtener_informacion = inspect(engine)
	if 'usuario' in obtener_informacion.get_table_names():
		Base.metadata.tables['usuario'].drop(bind=engine, checkfirst=True)
		print("Tabla de usuarios eliminada.")
	else:
		print("La tabla de usuarios no se puede eliminar porque no existe.")    

def mostrar_estructura_tabla():
    obtener_informacion = inspect(engine)
    if 'usuario' in obtener_informacion.get_table_names():
    	tabla_usuarios = Base.metadata.tables['usuario']
    	for column in tabla_usuarios.c:
    		print(f"{column.name}: {column.type}")
    else:
    	print("No se puede mostrar la estructura de la tabla porque no existe la tabla usuarios.")

# Menú
while True:
    print("** Menú principal **\n"
          "1. Crear país\n"
          "2. Listar países\n"
          "3. Eliminar país\n"
          "4. Crear ciudad\n"
          "5. Listar ciudades\n"
          "6. Eliminar ciudad\n"
          "7. Crear tabla usuarios\n"
          "8. Borrar tabla usuarios\n"
          "9. Mostrar estructura tabla\n"
          "0. Salir")

    opcion = input("Introduzca el número de la operación que desea realizar: ")

    if opcion == "1":
        nombre = input("Introduzca el nombre del país que desea crear:")
        crear_pais(nombre)

    elif opcion == "2":
        listar_paises()

    elif opcion == "3":
        id_pais = input("Introduzca el id del país que desea eliminar:")
        eliminar_pais(id_pais)

    elif opcion == "4":
        nombre = input("Introduzca el nombre de la ciudad que desea crear:")
        id_pais = input("Ahora introduzca el id del país de la ciudad introducida:")
        crear_ciudad(nombre, id_pais)

    elif opcion == "5":
        listar_ciudades()

    elif opcion == "6":
        id_ciudad = input("Introduzca el id de la ciudad que desea eliminar:")
        eliminar_ciudad(id_ciudad)
    
    elif opcion == "7":
        crear_tabla_usuarios()

    elif opcion == "8":
        borrar_tabla_usuarios()

    elif opcion == "9":
        mostrar_estructura_tabla()

    elif opcion == "0":
        break

    else:
        print("Opción no válida, vuelve a introducir el número de la operación que desea realizar.")
