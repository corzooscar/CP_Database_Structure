# Sistema de Seguimiento de Estudiantes y Egresados
## Justificación del Modelo de Datos

*Documento de referencia para el equipo de desarrollo — Proyecto Integrador 2026*

---

## Introducción

Este documento explica, entidad por entidad y llave foránea por llave foránea, las decisiones de diseño tomadas para el modelo de datos del sistema. El objetivo es que cualquier miembro del equipo entienda no solo qué campos tiene cada tabla, sino **por qué existen**, qué problema resuelven y qué alternativas se descartaron. Todas las decisiones surgieron de un proceso iterativo de revisión, partiendo de una primera propuesta y refinándola frente a casos de uso reales del sistema.

---

## Catálogos de apoyo

Estas entidades representan listas de valores fijos o semi-fijos que se usan en varias partes del sistema. Se modelan como tablas independientes (en vez de campos de texto libre o restricciones CHECK) por tres razones que se repiten a lo largo del documento: evitar inconsistencias de escritura ("3ro" vs "Tercero" vs "3°"), permitir comparaciones y filtros confiables, y facilitar el mantenimiento cuando la lista cambie (agregar un valor nuevo es una fila, no una migración de esquema).

### `rol_usuario`

Contiene los tres roles del sistema: Super Administrador, Administrador Institucional (Rector) y Estudiante/Egresado. Se modela como tabla —y no como texto en `credenciales`— porque el rol determina lógica de autorización real en el backend (qué endpoints y vistas puede tocar cada usuario). Tenerlo en una tabla permite hacer JOIN limpio en las consultas de permisos y evita depender de strings mágicos repartidos por el código.

| Atributo | Tipo / Regla | Descripción |
|---|---|---|
| id | PK | Identificador único del rol. |
| nombre | Texto | Nombre del rol (Admin, Rector, Estudiante). |

### `tipos_documento`

Catálogo de tipos de documento de identidad válidos en Colombia (CC, TI, PP, CE, RC, PEP). Se separa `abreviatura` de `nombre` porque son usos distintos: la abreviatura para mostrar en formularios compactos, el nombre completo para reportes.

| Atributo | Tipo / Regla | Descripción |
|---|---|---|
| id | PK | Identificador único. |
| abreviatura | Texto (2-3 car.) | Ej: CC, TI, PEP. |
| nombre | Texto | Ej: Cédula de Ciudadanía. |

### `géneros`

Catálogo de géneros. Igual que `tipos_documento`, se prefiere tabla sobre CHECK para permitir cambios sin alterar el esquema y para que `campaña_criterio` pueda filtrar por género con una FK real en lugar de comparar texto libre.

| Atributo | Tipo / Regla | Descripción |
|---|---|---|
| id | PK | Identificador único. |
| nombre | Texto | Nombre del género. |

### `grados`

Catálogo de grados escolares (Transición a 11°). Aunque son solo 11 valores estables, se modela como tabla para garantizar que `perfil_estudiante` y `campaña_criterio` usen exactamente el mismo valor al comparar (evita que un filtro de campaña por "grado 9" no encuentre estudiantes guardados como "9°" o "noveno"). También habilita orden y comparación por rangos si se necesita en el futuro.

| Atributo | Tipo / Regla | Descripción |
|---|---|---|
| id | PK | Identificador único. |
| grado | Texto | Ej: Transición, 1°, 2°, ..., 11°. |

### `localidades`

Representa las zonas administrativas de referencia de Barranquilla (Norte, Sur, Oriente, Occidente, etc.). Es el nivel superior de la jerarquía geográfica: una localidad agrupa varios barrios.

| Atributo | Tipo / Regla | Descripción |
|---|---|---|
| id | PK | Identificador único. |
| nombre | Texto | Nombre de la localidad. |

### `barrios`

Representa los barrios de Barranquilla y su área metropolitana. Es el nivel específico de ubicación usado por personas e instituciones.

🔑 **id_localidad** → `localidades.id`
Cada barrio pertenece a exactamente una localidad, reflejando la jerarquía administrativa real de la ciudad. Gracias a esta relación, ni `personas` ni `instituciones` necesitan guardar la localidad por separado: se obtiene automáticamente haciendo JOIN barrio → localidad. Guardar ambas FKs de forma independiente (como se planteó en una versión inicial) generaría una dependencia transitiva y un riesgo real de inconsistencia — por ejemplo, seleccionar un barrio de la localidad Norte pero, por error, la localidad Sur en un campo separado. Eliminar esa redundancia es aplicar normalización básica.

| Atributo | Tipo / Regla | Descripción |
|---|---|---|
| id | PK | Identificador único. |
| nombre | Texto | Nombre del barrio. |

---

## Identidad, personas e instituciones

### `credenciales`

Contiene exclusivamente la información necesaria para el inicio de sesión. Se diseñó deliberadamente "ciega" del resto del sistema —no sabe si pertenece a una persona o a una institución— para mantener una separación estricta de responsabilidades: la autenticación es un concepto distinto de la identidad de negocio (quién es la persona) o del perfil académico (su relación con un colegio).

🔑 **id_rol** → `rol_usuario.id`
Define qué tipo de usuario es esta credencial y, por lo tanto, qué permisos y vistas le corresponden en el sistema.

| Atributo | Tipo / Regla | Descripción |
|---|---|---|
| id | PK | Identificador único. |
| username | Texto único | Usuario para iniciar sesión. |
| contraseña | Texto (hash) | Nunca se almacena en texto plano. |

> **Nota de diseño importante:** en una primera versión del modelo, `personas` y `perfil_estudiante` tenían una llave hacia `credenciales`, y a la vez `perfil_estudiante` era referenciado desde `personas` — esto generaba un ciclo de dependencias (`personas → perfil_estudiante → credenciales → ...` de vuelta). La solución adoptada fue invertir el sentido: es `perfil_estudiante` quien apunta hacia `personas`, `instituciones` y `credenciales`, nunca al revés. Así el flujo de dependencias queda en una sola dirección y se elimina el ciclo por completo.

### `personas`

Contiene los datos biográficos de un individuo: quién es, independientemente de su relación con una institución educativa. Se separa deliberadamente de `perfil_estudiante` porque son dos conceptos distintos con distinto ciclo de vida: los datos personales (nombre, documento, fecha de nacimiento) no cambian aunque la persona pase de estudiante a egresado, mientras que su estado académico sí lo hace.

🔑 **id_genero** → `géneros.id`
Asocia a la persona con su género, tomado del catálogo para evitar inconsistencias de escritura y permitir filtros confiables (usado también en `campaña_criterio`).

🔑 **id_tipo_documento** → `tipos_documento.id`
Indica qué tipo de documento de identidad tiene la persona (CC, TI, PP, CE, RC, PEP), necesario porque estudiantes menores de edad suelen tener Tarjeta de Identidad y no Cédula.

🔑 **id_barrio** → `barrios.id`
Ubicación de residencia de la persona. No incluye `id_localidad` de forma independiente, por la misma razón explicada en `barrios`: la localidad se deriva vía barrio, evitando duplicidad y posible inconsistencia.

| Atributo | Tipo / Regla | Descripción |
|---|---|---|
| id | PK | Identificador único. |
| nombres | Texto | Nombres de la persona. |
| apellidos | Texto | Apellidos de la persona. |
| fecha_nacimiento | Fecha | Usada para calcular edad (filtros de campañas). |
| email | Texto | Correo de contacto. |
| telefono | Texto | Teléfono de contacto. |
| documento | Texto único | Número de documento de identidad. |
| direccion | Texto | Dirección de residencia. |

### `contactos_personales`

Registra contactos adicionales de una persona (familiar, acudiente, conocido), útil especialmente para estudiantes menores de edad donde se requiere un contacto de emergencia o acudiente responsable.

🔑 **id_persona** → `personas.id`
Identifica a qué persona pertenece este contacto adicional. Una persona puede tener varios contactos registrados (relación uno a muchos).

| Atributo | Tipo / Regla | Descripción |
|---|---|---|
| id | PK | Identificador único. |
| nombres | Texto | Nombres del contacto. |
| apellidos | Texto | Apellidos del contacto. |
| telefono | Texto | Teléfono del contacto. |
| parentesco | Texto | Relación con la persona (padre, madre, tío, etc.). |

### `instituciones`

Contiene la información de los colegios participantes en la plataforma. Es la entidad institucional equivalente a `personas`, pero para instituciones.

🔑 **id_barrio** → `barrios.id`
Ubicación del colegio, con el mismo criterio de normalización aplicado a `personas`: no se guarda localidad por separado, se deriva vía barrio.

🔑 **id_credencial** → `credenciales.id`
Permite que la institución tenga un usuario de acceso asociado directamente (por ejemplo, para el login del rector como representante de la institución), sin depender de una tabla intermedia.

| Atributo | Tipo / Regla | Descripción |
|---|---|---|
| id | PK | Identificador único. |
| nombre_institucion | Texto | Nombre del colegio. |
| director | Texto | Nombre del director(a). |
| direccion | Texto | Dirección física del colegio. |
| rector | Texto | Nombre del rector. |
| codigo_dane | Texto único | Código oficial DANE de la institución educativa. |

### `perfil_estudiante`

Representa la relación específica entre una persona y una institución educativa: no quién es la persona, sino su vínculo académico (en qué colegio está, en qué grado, si está activo o egresado). Esta separación permite, en el futuro, soportar historial de instituciones por persona sin rediseñar el modelo, aunque en la versión actual del MVP cada persona pertenece a un único colegio de forma permanente.

🔑 **id_persona** → `personas.id`
Vincula el perfil académico con la identidad de la persona. Este es el punto donde se resolvió la dependencia circular original: en vez de que `personas` apuntara hacia `perfil_estudiante` (y este de vuelta hacia `credenciales`), se invirtió el sentido para que sea `perfil_estudiante` quien reúna las tres referencias (persona, institución, credencial). De esta forma el flujo de dependencias queda unidireccional: `personas ← perfil_estudiante → instituciones / credenciales`, sin ciclos.

🔑 **id_institucion** → `instituciones.id`
Indica a qué colegio pertenece el estudiante.

🔑 **id_credencial** → `credenciales.id`
Asocia el perfil con sus datos de inicio de sesión como estudiante/egresado.

🔑 **id_grado** → `grados.id`
Grado que cursa actualmente (o cursó, si es egresado), tomado del catálogo para garantizar comparación confiable con los filtros de `campaña_criterio`.

| Atributo | Tipo / Regla | Descripción |
|---|---|---|
| id | PK | Identificador único del perfil. |
| estado | CHECK | Activo, Inactivo o Egresado. |
| fecha_ingreso | Fecha | Fecha en que ingresó a la institución. |
| fecha_egreso | Fecha, nullable | Fecha de egreso; nulo si aún está activo. |

---

## Campañas de actualización

Este bloque de entidades resuelve el núcleo funcional del MVP: permitir que Super Administradores y Rectores creen campañas de actualización dirigidas a poblaciones específicas, definidas mediante filtros (no listas fijas de personas), y llevar registro de quién participó y quién actualizó su información.

### `campañas`

Almacena la información general de cada campaña, ya sea creada internamente por un rol del sistema o en representación de una entidad externa (alcaldía, empresa privada).

🔑 **id_credencial_creador** → `credenciales.id` (nullable)
Registra qué usuario del sistema (Super Admin o Rector) creó la campaña, para efectos de auditoría interna. Es nullable porque el campo `creador` (texto libre) puede referirse a una entidad externa sin credencial en el sistema (ej. Alcaldía de Barranquilla, empresa privada); en ese caso esta FK queda vacía, pero el nombre del creador externo igual queda registrado en el campo de texto.

| Atributo | Tipo / Regla | Descripción |
|---|---|---|
| id | PK | Identificador único. |
| titulo | Texto | Título de la campaña. |
| tipo | CHECK | Educativa, Deportiva o Cultural. |
| descripcion | Texto | Detalle de la campaña. |
| creador | Texto | Nombre del creador externo (alcaldía, empresa) si aplica. |
| publico | Texto descriptivo | Descripción libre de a quién va dirigida (solo referencial, no usada para lógica de filtrado). |
| alcance | CHECK | Institucional (creada por Rector) o Global (creada por Super Admin). |
| fecha_inicio | Fecha | Inicio de vigencia de la campaña. |
| fecha_fin | Fecha | Fin de vigencia de la campaña. |
| estado | Texto/CHECK | Estado de la campaña (activa, cerrada, etc.). |

### `campaña_criterio_institucion`

Define explícitamente a qué instituciones aplica una campaña, cuando el alcance es Institucional (un Rector creándola para su propio colegio) o cuando un Super Administrador elige un grupo selecto de instituciones en vez de todas. A diferencia de los criterios de persona (grado, género, edad), aquí sí tiene sentido una lista explícita, porque elegir instituciones es una selección finita y manual que el administrador hace directamente en el formulario, no un cálculo dinámico.

🔑 **id_campaña** → `campañas.id`
Campaña a la que pertenece este criterio de institución.

🔑 **id_institucion** → `instituciones.id`
Institución específica incluida en el alcance de la campaña.

| Atributo | Tipo / Regla | Descripción |
|---|---|---|
| id | PK | Identificador único. |

### `campaña_criterio`

Contiene los filtros dinámicos que determinan qué personas son elegibles para una campaña (edad, género, grado, estado académico). **Esta es la pieza de diseño más importante del modelo**: en versiones iniciales se planteó guardar explícitamente qué personas o instituciones estaban destinadas a cada campaña (una fila por persona). Se descartó ese enfoque porque el direccionamiento real depende de reglas definidas en un formulario (por edad, ubicación, institución, grado, género), no de una lista fija — guardar personas una por una habría significado recalcular y reinsertar filas cada vez que un estudiante cambiara de edad o de estado, además de no reflejar la intención real del administrador al crear la campaña. En su lugar, se guardan las reglas, y la elegibilidad de cada persona se calcula en tiempo real con una consulta cuando esta revisa su panel.

> Una campaña puede tener varias filas en esta tabla (por ejemplo, una fila por cada grado seleccionado en el formulario), donde los criterios dentro de una misma fila se combinan con **AND**, y las distintas filas de una misma campaña se combinan con **OR** entre sí. La generación de esas combinaciones (producto cartesiano de grados y géneros elegidos) es responsabilidad del backend/frontend al momento de guardar la campaña, no de la base de datos.

🔑 **id_campaña** → `campañas.id`
Campaña a la que pertenece este conjunto de criterios.

🔑 **id_genero** → `géneros.id` (nullable)
Filtra por género específico; nulo significa que el criterio no distingue por género.

🔑 **id_grado** → `grados.id` (nullable)
Filtra por grado específico; nulo significa que no se distingue por grado. Usa el mismo catálogo que `perfil_estudiante.id_grado` para garantizar que la comparación en la consulta de elegibilidad sea exacta y confiable.

| Atributo | Tipo / Regla | Descripción |
|---|---|---|
| id | PK | Identificador único. |
| edad_min | Numérico, nullable | Edad mínima requerida. |
| edad_max | Numérico, nullable | Edad máxima permitida. |
| estado_perfil | CHECK, nullable | Activo o Egresado; nulo si aplica a ambos. |

### `inscripciones_campaña`

Registra el evento real de inscripción de una persona a una campaña. A diferencia de `campaña_criterio` (que define quién PUEDE participar), esta tabla registra quién REALMENTE se inscribió. La regla de negocio acordada es que solo puede inscribirse quien ya cumple los criterios de elegibilidad de la campaña — es decir, esta tabla nunca se llena sin que antes se haya validado contra `campaña_criterio`.

🔑 **id_campaña** → `campañas.id`
Campaña a la que se inscribió el usuario.

🔑 **id_credencial** → `credenciales.id`
Usuario (estudiante/egresado) que se inscribió.

| Atributo | Tipo / Regla | Descripción |
|---|---|---|
| id | PK | Identificador único. |
| fecha_inscripcion | Fecha/Timestamp | Momento en que se realizó la inscripción. |

### `actualizaciones`

Esta entidad responde directamente al objetivo central del MVP planteado en el documento de requerimientos: registrar la fecha de la última actualización de información de cada usuario, para medir la vigencia de los datos. Permite responder preguntas clave del sistema: ¿quién actualizó durante una campaña específica?, ¿cuándo fue la última actualización de una persona?, ¿qué porcentaje de estudiantes respondió a una campaña?, ¿quiénes siguen pendientes? Esta última pregunta se resuelve comparando, para cada persona elegible según `campaña_criterio`, si existe o no un registro correspondiente en esta tabla.

🔑 **id_persona** → `personas.id`
Persona que realizó la actualización de su información.

🔑 **id_campaña** → `campañas.id`
Campaña en cuyo marco se realizó la actualización, necesaria para poder medir la tasa de respuesta por campaña.

| Atributo | Tipo / Regla | Descripción |
|---|---|---|
| id | PK | Identificador único. |
| fecha_actualizacion | Fecha/Timestamp | Momento exacto de la actualización. |

---

## Decisiones de diseño clave — resumen

Para referencia rápida del equipo, estas son las decisiones más importantes tomadas durante el diseño y por qué:

- **Normalización de ubicación**: `localidad` y `barrio` están en jerarquía (barrio → localidad), y `personas`/`instituciones` solo guardan `id_barrio`, evitando dependencias transitivas e inconsistencias.
- **Catálogos sobre texto libre**: `tipos_documento`, `géneros` y `grados` existen como tablas —no como CHECK ni texto libre— para permitir comparaciones confiables entre `perfil_estudiante` y `campaña_criterio`, y facilitar cambios futuros sin migrar el esquema.
- **Sin ciclos de dependencia**: `perfil_estudiante` concentra las referencias hacia `personas`, `instituciones` y `credenciales`; ninguna de esas tres le apunta de vuelta. Esto reemplazó un diseño inicial donde `personas` y `credenciales` se referenciaban mutuamente.
- **Campañas dirigidas por criterios, no por listas de personas**: `campaña_criterio` guarda reglas (edad, género, grado, estado), no una fila por persona destinataria. La elegibilidad se calcula en el momento con una consulta, evitando datos duplicados o desincronizados frente a cambios en el estudiante.
- **Separación de institución explícita vs. criterio dinámico de persona**: `campaña_criterio_institucion` sí guarda una lista explícita porque elegir instituciones es una selección finita y manual, mientras que los criterios de persona son reglas evaluables, no una selección directa.
- **Trazabilidad de creador de campaña sin perder flexibilidad**: `campañas.creador` (texto libre) permite registrar entidades externas (alcaldía, empresas), mientras que `id_credencial_creador` (nullable) mantiene la auditoría interna cuando quien crea la campaña es un usuario del propio sistema.
