CREATE TABLE IF NOT EXISTS `mcp` (
    `key` VARCHAR(250) NOT NULL PRIMARY KEY,
    `value` JSON NOT NULL,
    `tenant_id` VARCHAR(150) GENERATED ALWAYS AS (value ->> '$.tenantId') STORED,
    `id` VARCHAR(250) GENERATED ALWAYS AS (value ->> '$.id') STORED NOT NULL,
    `description` TEXT GENERATED ALWAYS AS (value ->> '$.description') STORED,
    `instructions` TEXT GENERATED ALWAYS AS (value ->> '$.instructions') STORED,
    `server_type` VARCHAR(50) GENERATED ALWAYS AS (value ->> '$.serverType') STORED,
    `auth_type` VARCHAR(50) GENERATED ALWAYS AS (value ->> '$.authType') STORED,
    `enabled` BOOL GENERATED ALWAYS AS (value ->> '$.enabled' = 'true') STORED,
    `is_default` BOOL GENERATED ALWAYS AS (value ->> '$.isDefault' = 'true') STORED,
    `deleted` BOOL GENERATED ALWAYS AS (value ->> '$.deleted' = 'true') STORED NOT NULL,
    `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX ix_deleted_tenant (deleted, tenant_id),
    INDEX ix_id_deleted_tenant (id, deleted, tenant_id),
    INDEX ix_enabled_deleted_tenant (enabled, deleted, tenant_id),
    FULLTEXT ix_fulltext (id)
) ENGINE INNODB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `mcp_session` (
    `key`        VARCHAR(250) NOT NULL PRIMARY KEY,
    `value`      JSON NOT NULL,
    `tenant_id`  VARCHAR(150) GENERATED ALWAYS AS (value ->> '$.tenantId') STORED,
    `server_id`  VARCHAR(150) GENERATED ALWAYS AS (value ->> '$.serverId') STORED,
    `session_id` VARCHAR(150) GENERATED ALWAYS AS (value ->> '$.sessionId') STORED NOT NULL,
    `sse_node`   VARCHAR(250) GENERATED ALWAYS AS (value ->> '$.sseNode') STORED,
    `user_id`    VARCHAR(150) GENERATED ALWAYS AS (value ->> '$.userId') STORED,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX ix_tenant_server (tenant_id, server_id),
    INDEX ix_session (tenant_id, session_id),
    INDEX ix_sse_node (sse_node),
    INDEX ix_mcp_session__created_at (created_at)
) ENGINE INNODB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
