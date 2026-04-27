CREATE TABLE IF NOT EXISTS mcp (
    "key" VARCHAR(250) NOT NULL PRIMARY KEY,
    "value" JSONB NOT NULL,
    "tenant_id" VARCHAR(150) GENERATED ALWAYS AS (value ->> 'tenantId') STORED,
    "id" VARCHAR(250) NOT NULL GENERATED ALWAYS AS (value ->> 'id') STORED,
    "description" TEXT GENERATED ALWAYS AS (value ->> 'description') STORED,
    "instructions" TEXT GENERATED ALWAYS AS (value ->> 'instructions') STORED,
    "server_type" VARCHAR(50) GENERATED ALWAYS AS (value ->> 'serverType') STORED,
    "auth_type" VARCHAR(50) GENERATED ALWAYS AS (value ->> 'authType') STORED,
    "enabled" BOOLEAN GENERATED ALWAYS AS (CAST(value ->> 'enabled' AS BOOLEAN)) STORED,
    "is_default" BOOLEAN GENERATED ALWAYS AS (CAST(value ->> 'isDefault' AS BOOLEAN)) STORED,
    "deleted" BOOLEAN NOT NULL GENERATED ALWAYS AS (CAST(value ->> 'deleted' AS BOOLEAN)) STORED,
    "fulltext" TSVECTOR GENERATED ALWAYS AS (
        FULLTEXT_INDEX(CAST(value ->> 'id' AS VARCHAR))
    ) STORED,
    "created" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS mcp__deleted_tenant ON mcp ("deleted", "tenant_id");
CREATE INDEX IF NOT EXISTS mcp__id_deleted_tenant ON mcp ("id", "deleted", "tenant_id");
CREATE INDEX IF NOT EXISTS mcp__enabled_deleted_tenant ON mcp ("enabled", "deleted", "tenant_id");
CREATE INDEX IF NOT EXISTS mcp__fulltext ON mcp USING GIN (fulltext);

CREATE OR REPLACE TRIGGER mcp_updated BEFORE UPDATE
    ON mcp FOR EACH ROW EXECUTE PROCEDURE
    UPDATE_UPDATED_DATETIME();

CREATE TABLE IF NOT EXISTS mcp_session (
    "key"        VARCHAR(250) NOT NULL PRIMARY KEY,
    "value"      JSONB NOT NULL,
    "tenant_id"  VARCHAR(150) GENERATED ALWAYS AS (value ->> 'tenantId') STORED,
    "server_id"  VARCHAR(150) GENERATED ALWAYS AS (value ->> 'serverId') STORED,
    "session_id" VARCHAR(150) NOT NULL GENERATED ALWAYS AS (value ->> 'sessionId') STORED,
    "sse_node"   VARCHAR(250) GENERATED ALWAYS AS (value ->> 'sseNode') STORED,
    "user_id"    VARCHAR(150) GENERATED ALWAYS AS (value ->> 'userId') STORED,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS mcp_session__tenant_server ON mcp_session ("tenant_id", "server_id");
CREATE INDEX IF NOT EXISTS mcp_session__session ON mcp_session ("tenant_id", "session_id");
CREATE INDEX IF NOT EXISTS mcp_session__sse_node ON mcp_session ("sse_node");
CREATE INDEX IF NOT EXISTS mcp_session__created_at ON mcp_session ("created_at");
