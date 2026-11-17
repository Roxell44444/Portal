# Configuración de servicios reales

## Supabase
1. Crea un proyecto Supabase.
2. Ejecuta `supabase/migrations/0001_initial.sql` en SQL Editor.
3. Copia Project URL y la clave publicable/anon desde Project Settings → API.
4. En GitHub → Settings → Secrets and variables → Actions crea `SUPABASE_URL` y `SUPABASE_ANON_KEY`.
5. Ejecuta Actions → Build PORTAL Android → Run workflow y descarga el artefacto APK.

No uses la clave `service_role` en el cliente ni en la compilación.

## Mapas globales
El prototipo utiliza teselas de OpenStreetMap con atribución visible y caché persistente nativa de flutter_map 8.3.2, y Nominatim para búsquedas manuales iniciadas por el usuario. El cliente serializa las consultas, limita cada dispositivo a una petición por segundo y conserva resultados repetidos en memoria. Esto no controla el límite agregado de todo PORTAL: Nominatim público admite como máximo una petición por segundo por aplicación y solo uso moderado. No es una API ilimitada ni infraestructura de producción global. Antes de abrir el servicio al público, PORTAL deberá cambiar a un proveedor con cuota apropiada o desplegar geocodificación y teselas propias. No se permite autocompletar con Nominatim público, scraping ni descargas masivas. Los lugares conservan identidad OSM estable (tipo e ID), URL de fuente y licencia ODbL.

## Android
La compilación genera el proyecto Android con Flutter en GitHub Actions. El permiso de ubicación en primer plano debe estar declarado en AndroidManifest. La ubicación solo se solicita cuando la persona toca el botón correspondiente.

## Alcance implementado en este primer corte
- Registro, login, recuperación de contraseña y cierre de sesión mediante Supabase Auth.
- Perfil básico.
- Feed de texto y creación de publicaciones.
- Mapa mundial, búsqueda de lugares, localización voluntaria y guardado de lugares en la cuenta.
- Vision, personajes IA, mensajería completa, reacciones, comentarios y misiones siguen pendientes de desarrollo y pruebas.
