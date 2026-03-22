-- V4: Explicit cleanup of default/public schema for appointment service
-- These tables belong to other domains (IAM/Corp) and should not exist in the scheduling database's shared public schema if they were accidentally created there.

DROP TABLE IF EXISTS public.usuarios CASCADE;

DROP TABLE IF EXISTS public.rol CASCADE;

DROP TABLE IF EXISTS public.permiso CASCADE;

DROP TABLE IF EXISTS public.usuario_rol CASCADE;

DROP TABLE IF EXISTS public.asignacion_usuario_rol CASCADE;

DROP TABLE IF EXISTS public.asignacion_rol_permiso CASCADE;

DROP TABLE IF EXISTS public.asignacion_menu_permiso CASCADE;

DROP TABLE IF EXISTS public.menu CASCADE;

DROP TABLE IF EXISTS public.organizacion CASCADE;

DROP TABLE IF EXISTS public.evento_auditoria CASCADE;
-- Assuming this is also extraneous