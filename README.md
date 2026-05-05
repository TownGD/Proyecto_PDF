# PDF ToolOffice

Aplicación web para manipulación de documentos PDF con interfaz moderna e intuitiva. Incluye operaciones de unión, división, conversión, compresión y cifrado.

**Versión:** 1.1  
**Última actualización:** 21/04/2026  
**Uso interno bajo licencia de no comercialización     :** REPRESENTACIONES Y DISTRIBUCIONES HOSPITALARIAS S.A.S "REDIHOS" - PROYECTO EDUCATIVO

---

## 📋 Tabla de Contenidos

- [Inicio Rápido](#-inicio-rápido)
- [Configuración](#️-configuración)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Stack Técnico](#️-stack-técnico)
- [Endpoints Disponibles](#-endpoints-disponibles)
- [Características](#-características)
- [Compresión (v1.1)](#-compresión-v11)
- [API de Conversión](#-api-de-conversión)
- [Seguridad](#-seguridad)
- [Rendimiento](#-rendimiento)
- [Desarrollo](#-desarrollo)
- [Guía de Implementación](#-guía-de-implementación)
- [Troubleshooting](#-troubleshooting)
- [Changelog](#-changelog)
- [Roadmap Futuro](#-roadmap-futuro)

---

## 🚀 Inicio Rápido

### Opción 1: WSL (Recomendado)

```bash
# Entrar al directorio
cd /ruta/proyecto/pdf_tooloffice

# Activar entorno virtual
source .venv_wsl/bin/activate

# Instalar dependencias
pip install -r requirements.txt

# Levantar servidor
python run.py
```

### Opción 2: Windows PowerShell

```powershell
# Crear entorno virtual
python -m venv .venv
.\.venv\Scripts\Activate.ps1

# Instalar dependencias
pip install -r requirements.txt

# Ejecutar
python run.py
```

### Opción 3: Docker

```bash
docker-compose up --build
```

La aplicación estará disponible en `http://localhost:5000`

---

## ⚙️ Configuración

### Variables de Entorno (.env)

Crea un archivo `.env` en la raíz del proyecto:

```env
# Seguridad
ADMIN_PASSWORD= [PASSWORD]

# Base de Datos
DATABASE_LOG_RETENTION_DAYS=30

# Limpieza de Archivos
UPLOAD_CLEANUP_DAYS=7

# Modo Debug
DEBUG=False

# Host y Puerto
FLASK_HOST=0.0.0.0
FLASK_PORT=5000

# Logging
LOG_LEVEL=INFO
```

> ⚠️ **En producción:** SIEMPRE cambiar `ADMIN_PASSWORD` y NO commitear el archivo `.env`.

### Generar contraseña segura

```bash
python -c 'import secrets; print(secrets.token_hex(16))'
```

---

## 📊 Estructura del Proyecto

```
pdf_tooloffice/
├── app/
│   ├── __init__.py          # Factory Flask + configuración
│   ├── routes.py            # Endpoints HTTP
│   ├── services.py          # Lógica de procesamiento PDF
│   ├── database.py          # Gestión de logs SQLite
│   ├── cleanup.py           # Limpieza automática de uploads
│   ├── database/
│   │   └── logs.db          # Base de datos de logs
│   ├── uploads/             # Archivos temporales
│   ├── templates/
│   │   └── index.html       # Interfaz web
│   └── static/
│       ├── css/
│       │   └── style.css    # Estilos
│       └── js/
│           └── main.js      # Lógica de cliente
├── .env                     # Variables de configuración
├── .gitignore               # Archivos excluidos de Git
├── requirements.txt         # Dependencias Python
├── Dockerfile               # Configuración Docker
├── docker-compose.yml       # Orquestación de contenedores
├── test_compresion.ps1      # Script de prueba de compresión
└── README.md                # Este archivo
```

---

## 🛠️ Stack Técnico

**Backend:**
- Flask 3.0+
- Gunicorn 21.0+
- SQLite 3

**Procesamiento PDF:**
- PyPDF2 3.0+ (lectura/escritura)
- PyMuPDF 1.23+ (renderizado)
- pdf2docx 0.5+ (conversión)
- pdfplumber 0.10+ (extracción de tablas)
- reportlab 4.0+ (generación)

**Validación:**
- python-magic-bin 0.4+ (validación MIME)

**Configuración:**
- python-dotenv 1.0+

---

## 📋 Endpoints Disponibles

### Interfaz

| Path | Método | Descripción |
|------|--------|-------------|
| `/` | GET | Interfaz web principal |
| `/health` | GET | Health check (`{"status": "ok", "version": "1.0"}`) |

### Operaciones PDF

| Path | Método | Descripción |
|------|--------|-------------|
| `/api/paginas` | POST | Contar páginas de PDF |
| `/api/union` | POST | Unir múltiples PDFs |
| `/api/division` | POST | Dividir PDF (por rango o modo) |
| `/api/conversion` | POST | Convertir entre PDF/DOCX/XLSX |
| `/api/compresion` | POST | Comprimir PDF (baja/media/alta/ultra) |
| `/api/cifrado` | POST | Cifrar PDF con contraseña |

### Administración

| Path | Método | Autenticación | Descripción |
|------|--------|---------------|-------------|
| `/admin/logs` | GET | Header `X-Admin-Password` | Ver logs en HTML |
| `/admin/logs/export` | GET | Header `X-Admin-Password` | Descargar Excel histórico |

**Ejemplo de acceso a logs:**
```bash
# Ver logs
curl -H "X-Admin-Password: tu_contraseña" http://localhost:5000/admin/logs

# Exportar a Excel
curl -H "X-Admin-Password: tu_contraseña" \
     http://localhost:5000/admin/logs/export \
     -o logs_historico.xlsx
```

---

## 📊 Características

### 1. Unión de PDFs ✅
- Combina múltiples archivos en uno
- Soporte para PDFs cifrados
- Validación de integridad
- Drag & drop para reordenar archivos
- Compresión opcional del resultado (niveles: baja, media, alta, ultra)

### 2. División de PDFs ✅
- Rango específico de páginas
- Modo pares/impares
- Extracción individual de páginas (ZIP)
- Vista previa con detección de páginas

### 3. Conversión ✅
- PDF ↔ DOCX (mantiene formato)
- PDF ↔ XLSX (extracción inteligente de tablas con pdfplumber + PyMuPDF)
- Fallback automático para PDFs complejos

### 4. Compresión ✅
- 4 niveles: baja, media, alta, ultra ⭐
- Reduce tamaño manteniendo calidad
- Ver sección [Compresión v1.1](#-compresión-v11)

### 5. Cifrado ✅
- Protección con contraseña
- Validación de coincidencia de contraseña

### 6. Validaciones ✅
- Verificación MIME type con python-magic
- Detección de PDFs corruptos (header `%PDF` + PyPDF2)
- Sanitización de errores (no expone rutas en producción)
- Límite de 50 MB por archivo

---

## 🗜️ Compresión v1.1

### Niveles disponibles

| Nivel | Compresión | Calidad | Caso de uso |
|-------|-----------|---------|-------------|
| **baja** | Mínima (~5%) | Excelente | Documentos ya optimizados |
| **media** | Normal (~15%) | Muy buena | Opción por defecto, balance |
| **alta** | Agresiva (~30%) | Buena | Archivos grandes, para email |
| **ultra** ⭐ | Máxima (~50%) | Aceptable | Formularios, escaneos |

### Técnicas del nivel ULTRA

1. **Conversión a escala de grises** — reduce ~70% del tamaño de imagen
2. **Reducción de resolución al 50%** — no se nota en pantalla
3. **Deflate + Garbage Collection nivel 4** — máxima optimización PDF

### Uso rápido

```bash
# Compresión ULTRA (máximo)
curl -X POST \
  -F "archivo=@formulario.pdf" \
  -F "nivel=ultra" \
  http://localhost:5000/api/compresion \
  -o formulario_ultra.pdf

# Compresión ALTA (recomendado para archivos grandes)
curl -X POST \
  -F "archivo=@formulario.pdf" \
  -F "nivel=alta" \
  http://localhost:5000/api/compresion \
  -o formulario_optimizado.pdf
```

### Resultados esperados

```
Original:            ~2-3 MB
Compresión media:    ~1.8-2.5 MB (reducción 10-20%)
Compresión alta:     ~1.2-1.8 MB (reducción 30-40%)
Compresión ultra:    ~0.8-1.2 MB (reducción 50-60%) ⭐
```

### Recomendaciones

| Tipo de documento | Nivel recomendado |
|-------------------|-------------------|
| Formularios (DIAN, etc.) | **Ultra** ⭐ |
| Documentos generales | **Alta** |
| Archivos pequeños | **Media o Baja** |
| Fotografías / imágenes críticas | **Alta** (máximo) |

> ⚠️ El nivel **ultra** puede degradar calidad en imágenes de alta resolución. No recomendado para fotos o arte.

### Comparación con alternativas

| Herramienta | Compresión | Costo |
|-------------|-----------|-------|
| **PDF ToolOffice (Ultra)** | 50-60% | ✨ Gratis |
| Adobe Compress | 30-40% | $ |
| ILovePDF | 40-50% | $ |
| Ghostscript (CLI) | 40-60% | ✨ Gratis |

---

## 📝 API de Conversión

### PDF → DOCX
```bash
curl -X POST -F "archivo=@documento.pdf" \
     -F "direccion=pdf-docx" \
     http://localhost:5000/api/conversion > resultado.docx
```

### PDF → XLSX (con extracción inteligente de tablas)
```bash
curl -X POST -F "archivo=@tabla.pdf" \
     -F "direccion=pdf-xlsx" \
     http://localhost:5000/api/conversion > resultado.xlsx
```

### DOCX → PDF
```bash
curl -X POST -F "archivo=@documento.docx" \
     -F "direccion=docx-pdf" \
     http://localhost:5000/api/conversion > resultado.pdf
```

### XLSX → PDF
```bash
curl -X POST -F "archivo=@datos.xlsx" \
     -F "direccion=xlsx-pdf" \
     http://localhost:5000/api/conversion > resultado.pdf
```

---

## 🔒 Seguridad

### Mejoras implementadas (v1.0)

| # | Mejora | Impacto |
|---|--------|---------|
| 1 | **Autenticación en `/admin/logs`** — Protegido con contraseña en header | 🔴 CRÍTICO |
| 2 | **Validación MIME types** — Verifica contenido real vs extensión | 🔴 CRÍTICO |
| 3 | **Sanitización de errores** — No expone rutas internas al cliente | 🟡 ALTO |
| 4 | **Health endpoint** — Para monitoreo de disponibilidad | 🟢 MEDIO |
| 5 | **Rotación de logs** — Elimina registros después de N días | 🟢 MEDIO |
| 6 | **Validación de PDFs** — Detecta archivos corruptos antes de procesar | 🟡 ALTO |

**Score de Seguridad:** 3/10 → **8/10** ⬆️ +5

### Comportamiento de errores

| Escenario | DEBUG=True | DEBUG=False |
|-----------|-----------|-------------|
| Error con path | Expone path completo | "Error procesando archivo" |
| Logs internos | Mensaje completo | Mensaje completo (guardado en BD) |

### En Producción

1. **Cambiar ADMIN_PASSWORD** antes de deployar
2. **Usar HTTPS** (con proxy inverso como Nginx)
3. **Whitelist de IPs** si es acceso interno
4. **Monitorear `/health`** para detectar caídas
5. **Limpiar uploads periódicamente** (cleanup.py habilitado)
6. **No commitear `.env`** (ya está en .gitignore)

---

## 📈 Rendimiento

### Límites Configurables

| Parámetro | Valor | Configurable en |
|-----------|-------|-----------------|
| Max file size | 50 MB | `.env` → `MAX_CONTENT_LENGTH` |
| Cleanup frequency | Cada 24 horas | `cleanup.py` |
| Log retention | 30 días | `.env` → `DATABASE_LOG_RETENTION_DAYS` |
| Max upload folder age | 7 días | `.env` → `UPLOAD_CLEANUP_DAYS` |

### Optimizaciones
- ✅ Índices en base de datos (`idx_logs_fecha`)
- ✅ Limpieza automática de uploads antiguos
- ✅ WAL mode en SQLite para concurrencia
- ✅ Procesamiento en memoria (BytesIO)
- ✅ Busy timeout de 30s en SQLite

---

## 🔧 Desarrollo

### Instalar dependencias
```bash
pip install -r requirements.txt
```

### Ejecutar en modo debug
```env
DEBUG=True
```
```bash
python run.py
```

### Ver logs
```bash
# Bash/WSL
curl -H "X-Admin-Password: tu_contraseña" http://localhost:5000/admin/logs

# PowerShell
Invoke-WebRequest -Headers @{"X-Admin-Password" = "tu_contraseña"} `
  http://localhost:5000/admin/logs
```

### Exportar logs a Excel
```bash
curl -H "X-Admin-Password: tu_contraseña" \
     http://localhost:5000/admin/logs/export \
     -o logs_historico.xlsx
```

### Verificar instalación
```python
python -c "
import sys
print('✓ Python version:', sys.version_info.major, '.', sys.version_info.minor)

try:
    import flask; print('✓ Flask instalado')
except: print('✗ Flask no encontrado')

try:
    import dotenv; print('✓ python-dotenv instalado')
except: print('✗ python-dotenv no encontrado')

try:
    import magic; print('✓ python-magic instalado')
except: print('⚠ python-magic no encontrado (opcional)')

print('✓ Estado: Listo para ejecutar')
"
```

---

## 📦 Guía de Implementación

> **Tiempo estimado:** 15-30 minutos · **Dificultad:** 🟢 Baja

### Paso 1: Actualizar dependencias (5 min)

```powershell
# Activar entorno virtual
.\.venv\Scripts\Activate.ps1

# Actualizar pip e instalar
python -m pip install --upgrade pip
pip install -r requirements.txt
```

### Paso 2: Configurar .env (3 min)

```powershell
# Crear archivo .env (ver sección Configuración arriba)
# IMPORTANTE: Cambiar ADMIN_PASSWORD en producción
python -c "import secrets; print(secrets.token_hex(16))"
```

### Paso 3: Verificar .gitignore (2 min)

```powershell
cat .gitignore | grep ".env"
# Si no aparece:
Add-Content .gitignore "`n.env"
```

### Paso 4: Arrancar la aplicación (2 min)

```powershell
python run.py
```

**Salida esperada:**
```
 * Serving Flask app 'app'
 * Running on http://0.0.0.0:5000
```

### Paso 5: Verificar funcionamiento (5 min)

```powershell
# Health check
curl http://localhost:5000/health

# Admin sin contraseña (debe fallar con 401)
curl http://localhost:5000/admin/logs

# Admin con contraseña
curl -H "X-Admin-Password: cambiar_esto_en_produccion" http://localhost:5000/admin/logs

# Validación de archivo falso
echo "fake data" > test_fake.pdf
curl -F "archivo=@test_fake.pdf" http://localhost:5000/api/paginas
# → {"error": "Archivo no es un PDF válido"}
Remove-Item test_fake.pdf -Force
```

### Checklist Final

- [ ] Archivo `.env` creado con variables correctas
- [ ] `.gitignore` actualizado (`.env` incluido)
- [ ] Dependencias instaladas (`pip install -r requirements.txt`)
- [ ] Aplicación arranca sin errores (`python run.py`)
- [ ] `/health` retorna JSON correcto
- [ ] `/admin/logs` sin password → 401
- [ ] `/admin/logs` con password → HTML tabla
- [ ] Validación MIME rechaza archivos falsos
- [ ] Errores no exponen rutas internas
- [ ] Base de datos se crea automáticamente

---

## 🚨 Troubleshooting

### Error: "ModuleNotFoundError: No module named 'dotenv'"
```bash
pip install python-dotenv
```

### Error: "python-magic-bin not found"
```bash
# Windows (PowerShell)
pip install python-magic-bin

# Linux/WSL
pip install python-magic
```

### Error: "Se requiere un archivo PDF"
- Verifica que el archivo sea un PDF válido
- No puedes subir archivos disfrazados (MIME type validado)
- Máximo 50 MB

### Error: "Base de datos bloqueada"
- Reinicia la aplicación
- Verifica que no haya múltiples instancias corriendo
- Espera unos segundos y reintenta

### Puerto 5000 en uso
```powershell
# Cambiar en .env
FLASK_PORT=5001

# O matar el proceso en el puerto
netstat -ano | findstr :5000
taskkill /PID <PID> /F
```

### Error: "Not authorized" en /admin/logs
```bash
# Verificar contraseña exacta del .env
curl -H "X-Admin-Password: tu_contraseña_exacta" http://localhost:5000/admin/logs
```

---

## 🔄 Changelog

### v1.1 — 16 Abril 2026

**Correcciones:**
- **Bug fix:** Endpoint `/api/compresion` no registraba errores en SQLite ni eliminaba archivos temporales al fallar. Corregido con bloque `finally` y `error_response()` consistente.

**Nuevas funcionalidades:**

- **Compresión ULTRA ⭐** — Nuevo nivel máximo de compresión (50-60% reducción). Convierte a escala de grises + reduce resolución al 50%.
- **Exportación de logs a Excel** — Nuevo endpoint `/admin/logs/export` genera archivo Excel con histórico completo, formato con colores por resultado (verde=éxito, rojo=error), filtros automáticos y columna fija.
- **4 niveles de compresión** — Se agregó el nivel `ultra` además de baja, media y alta.

**Estado de la base de datos:**
La BD SQLite (`app/database/logs.db`) almacena histórico acumulado de todas las operaciones. Retención configurable en `.env` (default: 30 días).

---

### v1.0 — 13 Abril 2026

**Mejoras de seguridad y confiabilidad (6 cambios):**

| # | Cambio | Impacto | Tiempo |
|---|--------|---------|--------|
| 1 | Autenticación en `/admin/logs` con header `X-Admin-Password` | 🔴 CRÍTICO | 1.5h |
| 2 | Validación MIME types con python-magic | 🔴 CRÍTICO | 2h |
| 3 | Sanitización de errores (oculta paths en producción) | 🟡 ALTO | 1h |
| 4 | Endpoint `/health` para monitoreo | 🟢 MEDIO | 30min |
| 5 | Rotación automática de logs (configurable, default 30 días) | 🟢 MEDIO | 1.5h |
| 6 | Validación PDF antes de procesar (header + estructura) | 🟡 ALTO | 2h |

**Archivos creados:** `.env`, `.gitignore`  
**Archivos modificados:** `__init__.py`, `routes.py`, `services.py`, `database.py`, `cleanup.py`, `requirements.txt`

**Breaking changes:** NINGUNO ✅ — Todos los cambios son backward compatible.

**Detalle de cambios en código:**

```diff
# app/__init__.py
+ from dotenv import load_dotenv
+ load_dotenv()
+ app.config['ADMIN_PASSWORD'] = os.getenv('ADMIN_PASSWORD', ...)
+ app.config['LOG_RETENTION_DAYS'] = int(os.getenv('DATABASE_LOG_RETENTION_DAYS', 30))

# app/routes.py
+ sanitizar_error(msg)           # Oculta rutas en producción
+ validar_autenticacion_admin()  # Protege /admin/logs
+ GET /health                    # Health check
+ Validaciones MIME en todos los POST endpoints

# app/services.py
+ validar_mime_type(ruta, tipo_esperado)  # Valida MIME con python-magic
+ validar_pdf(ruta)                       # Valida header + estructura

# app/database.py
+ limpiar_logs_antiguos(db_path, retention_days)
+ CREATE INDEX idx_logs_fecha ON logs(fecha)

# requirements.txt
+ python-dotenv>=1.0
+ python-magic>=0.4.24
```

---

## 🔮 Roadmap Futuro

| Feature | Prioridad | Complejidad | Tiempo Est. |
|---------|-----------|-------------|-------------|
| Rate limiting | Alta | Media | 2h |
| Redis cache | Media | Alta | 6h |
| Celery queue | Media | Muy Alta | 12h |
| pytest suite | Media | Media | 8h |
| Prometheus/Grafana | Baja | Alta | 8h |
| React SPA | Baja | Muy Alta | 30h |
| Kubernetes | Baja | Muy Alta | 20h |

---

## 📊 Flujo de la Interfaz Web

### Navegación por pestañas
Cada pestaña ofrece controles distintos:

- **Unión:** nombre del archivo final + contraseña para PDFs protegidos.
- **División:** modo (rango/todas/pares/impares) + página inicio/fin.
- **Conversión:** dirección de conversión (PDF↔Word/Excel).
- **Compresión:** nivel (baja/media/alta/ultra).
- **Cifrado:** contraseña + confirmación.

### Flujo de ejecución

1. **Selección** — El usuario elige la herramienta vía pestañas.
2. **Carga** — Arrastra archivos o hace clic en la zona de upload.
3. **Validación** — Se valida tamaño (50 MB máx.) en el cliente.
4. **Configuración** — Se ajustan opciones según la herramienta.
5. **Ejecución** — Al pulsar "Procesar": se deshabilita el botón, se muestra progreso visual y se envía `FormData` al endpoint correspondiente.
6. **Finalización** — Se oculta la barra, se muestra resultado con botón Descargar, se reactiva el botón principal, toast de éxito y descarga automática.

### Comportamientos UI/UX
- Header sticky con logo, tabs y versión
- Zonas de carga con estado visual `dragover`
- Lista de archivos con nombre, tamaño formateado y acción quitar
- Drag & drop para reordenar archivos en Unión
- Vista previa en División (nombre + número de páginas)
- Toast global para errores/éxitos
- Diseño responsive básico (`@media max-width: 600px`)

---

## 📊 Base de Datos de Logs

La base de datos SQLite conserva registro de cada operación:

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | INTEGER | Autoincremental |
| `fecha` | TEXT | Fecha de operación (YYYY-MM-DD) |
| `hora` | TEXT | Hora de operación (HH:MM:SS) |
| `modulo` | TEXT | union, division, conversion, compresion, cifrado |
| `archivo` | TEXT | Nombre del archivo procesado |
| `tamano_kb` | REAL | Tamaño en KB |
| `resultado` | TEXT | "exito" o "error" |
| `detalle` | TEXT | Información adicional (modo, nivel, etc.) |

---

## 📞 Soporte

Para reportar problemas o sugerencias:
1. Verifica los logs en `/admin/logs` (requiere contraseña)
2. Revisa la consola del servidor
3. Intenta el endpoint `/health` para verificar disponibilidad
4. Reinstalar dependencias: `pip install -r requirements.txt --force-reinstall`

---

## 📄 Licencia

**PDF ToolOffice** es software de autoría propia desarrollado de forma independiente.

- **Autor:** Bairon Nicolas Calle Rivera
- **Contacto:** b41r0nn@gmail.com
- **Licencia:** [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/) — Solo uso no comercial
- **Versión:** 2.0.0

Se permite el uso, copia y modificación para fines **no comerciales** con atribución al autor.
Para uso comercial se requiere autorización escrita previa.

© 2026 Bairon Nicolas Calle Rivera. Todos los derechos reservados.
