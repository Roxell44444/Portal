# Configuración de servicios reales

## Supabase
1. Crea un proyecto Supabase.
2. Ejecuta `supabase/migrations/0001_initial.sql` en SQL Editor.
3. Copia Project URL y la clave publicable/anon desde Project Settings → API.
4. En GitHub → Settings → Secrets and variables → Actions crea `SUPABASE_URL` y `SUPABASE_ANON_KEY`.
5. Ejecuta Actions → Build PORTAL Android → Run workflow y descarga el artefacto APK.

No uses la clave `service_role` en el cliente ni en la compilación.

## Mapas globales
El prototipo utiliza teselas de OpenStreetMap con atribución y Nominatim para buscar lugares. Nominatim público tiene límites y política de uso; no es una API ilimitada para una aplicación mundial con muchos usuarios. Antes de escalar, se deberá usar un proveedor con cuota adecuada o infraestructura propia. No se permite scraping masivo ni usar el servicio público para descargas masivas.

## Android
La compilación genera el proyecto Android con Flutter en GitHub Actions. El permiso de ubicación en primer plano debe estar declarado en AndroidManifest. La ubicación solo se solicita cuando la persona toca el botón correspondiente.

## Alcance implementado en este primer corte
- Registro, login, recuperación de contraseña y cierre de sesión mediante Supabase Auth.
- Perfil básico.
- Feed de texto y creación de publicaciones.
- Mapa mundial, búsqueda de lugares, localización voluntaria y guardado de lugares en la cuenta.
- Vision, personajes IA, mensajería completa, reacciones, comentarios y misiones siguen pendientes de desarrollo y pruebas.
