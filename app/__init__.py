import os
from dotenv import load_dotenv

from flask import Flask

from .cleanup import start_cleanup_scheduler
from .database import init_db
from .routes import bp

__author__    = 'Bairon Nicolas Calle Rivera'
__email__     = 'b41r0nn@gmail.com'
__version__   = '2.0.0'
__copyright__ = 'Copyright (c) 2026 Bairon Nicolas Calle Rivera'
__license__   = 'CC BY-NC 4.0 — Solo uso no comercial'

# Cargar variables del .env
load_dotenv()

UPLOAD_FOLDER = os.path.join(os.path.dirname(__file__), 'uploads')
DATABASE_PATH = os.path.join(os.path.dirname(__file__), 'database', 'logs.db')
MAX_CONTENT_LENGTH = 50 * 1024 * 1024  # 50 MB


def create_app():
	app = Flask(__name__)
	app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
	app.config['DATABASE_PATH'] = DATABASE_PATH
	app.config['MAX_CONTENT_LENGTH'] = MAX_CONTENT_LENGTH
	app.config['SECRET_KEY'] = os.urandom(24)
	
	# Configuración desde .env
	app.config['ADMIN_PASSWORD'] = os.getenv('ADMIN_PASSWORD', 'cambiar_esto_en_produccion')
	app.config['LOG_RETENTION_DAYS'] = int(os.getenv('DATABASE_LOG_RETENTION_DAYS', 30))
	app.config['UPLOAD_CLEANUP_DAYS'] = int(os.getenv('UPLOAD_CLEANUP_DAYS', 7))
	app.config['DEBUG'] = os.getenv('DEBUG', 'False').lower() == 'true'

	os.makedirs(UPLOAD_FOLDER, exist_ok=True)
	os.makedirs(os.path.dirname(DATABASE_PATH), exist_ok=True)

	init_db(DATABASE_PATH, retention_days=app.config['LOG_RETENTION_DAYS'])
	start_cleanup_scheduler(UPLOAD_FOLDER, DATABASE_PATH, cleanup_days=app.config['UPLOAD_CLEANUP_DAYS'])

	app.register_blueprint(bp)
	return app
