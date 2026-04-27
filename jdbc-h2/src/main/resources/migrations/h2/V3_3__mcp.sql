CREATE TABLE IF NOT EXISTS mcp (
    "key" VARCHAR(250) NOT NULL PRIMARY KEY,
    "value" TEXT NOT NULL,
    "tenant_id" VARCHAR(150) GENERATED ALWAYS AS (JQ_STRING("value", '.tenantId')),
    "id" VARCHAR(250) NOT NULL GENERATED ALWAYS AS (JQ_STRING("value", '.id')),
    "description" TEXT GENERATED ALWAYS AS (JQ_STRING("value", '.description')),
    "instructions" TEXT GENERATED ALWAYS AS (JQ_STRING("value", '.instructions')),
    "server_type" VARCHAR(50) GENERATED ALWAYS AS (JQ_STRING("value", '.serverType')),
    "auth_type" VARCHAR(50) GENERATED ALWAYS AS (JQ_STRING("value", '.authType')),
    "enabled" BOOLEAN GENERATED ALWAYS AS (JQ_BOOLEAN("value", '.enabled')),
    "is_default" BOOLEAN GENERATED ALWAYS AS (JQ_BOOLEAN("value", '.isDefault')),
    "deleted" BOOLEAN NOT NULL GENERATED ALWAYS AS (JQ_BOOLEAN("value", '.deleted')),
    "fulltext" TEXT NOT NULL GENERATED ALWAYS AS (JQ_STRING("value", '.id')),
    "created" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS mcp__deleted_tenant ON mcp ("deleted", "tenant_id");
CREATE INDEX IF NOT EXISTS mcp__id_deleted_tenant ON mcp ("id", "deleted", "tenant_id");
CREATE INDEX IF NOT EXISTS mcp__enabled_deleted_tenant ON mcp ("enabled", "deleted", "tenant_id");

CREATE TABLE IF NOT EXISTS mcp_session (
    "key"        VARCHAR(250) NOT NULL PRIMARY KEY,
    "value"      TEXT NOT NULL,
    "tenant_id"  VARCHAR(150) GENERATED ALWAYS AS (JQ_STRING("value", '.tenantId')),
    "server_id"  VARCHAR(150) GENERATED ALWAYS AS (JQ_STRING("value", '.serverId')),
    "session_id" VARCHAR(150) NOT NULL GENERATED ALWAYS AS (JQ_STRING("value", '.sessionId')),
    "sse_node"   VARCHAR(250) GENERATED ALWAYS AS (JQ_STRING("value", '.sseNode')),
    "user_id"    VARCHAR(150) GENERATED ALWAYS AS (JQ_STRING("value", '.userId')),
    "created_at" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS mcp_session__tenant_server ON mcp_session ("tenant_id", "server_id");
CREATE INDEX IF NOT EXISTS mcp_session__session ON mcp_session ("tenant_id", "session_id");
CREATE INDEX IF NOT EXISTS mcp_session__sse_node ON mcp_session ("sse_node");
CREATE INDEX IF NOT EXISTS mcp_session__created_at ON mcp_session ("created_at");
