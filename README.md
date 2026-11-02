# Tableau

Cloud Agent workspace for Tableau integrations at Hertz.

## Tableau QUAL MCP connection

This repository configures the official [Tableau MCP server](https://github.com/tableau/tableau-mcp) for the **QUAL** site:

| Setting | Value |
| --- | --- |
| Server (`SERVER`) | `https://tableau-qual.hertz.com` |
| MCP config | [`.cursor/mcp.json`](.cursor/mcp.json) |

Tableau Server uses a **Personal Access Token (PAT)**. Create one in Tableau (My Account → Personal Access Tokens) with access to the QUAL site and published data sources you need.

### Secrets (required)

Add these as **environment secrets** (or local `.env` from [`.env.example`](.env.example)). Use the exact variable names — the Tableau MCP server reads them from the process environment:

| Secret | Required | Description |
| --- | --- | --- |
| `PAT_NAME` | Yes | PAT token name |
| `PAT_VALUE` | Yes | PAT secret value |
| `SITE_NAME` | If multi-site | Tableau site content URL; leave empty for the default site |

Do not commit tokens or put them in `mcp.json`.

### Enable MCP in Cursor

1. Merge or check out a branch that includes `.cursor/mcp.json`.
2. Add the secrets above to your Cloud Agent environment or Cursor MCP settings.
3. Reload MCP / start a new agent turn. Complete any OAuth or PAT prompt if shown.
4. Ask the agent to list data sources or query a published data source on QUAL.

### Verify connectivity

From a machine that can reach internal Hertz DNS:

```bash
export PAT_NAME=your_token_name
export PAT_VALUE=your_token_secret
# export SITE_NAME=your_site   # if needed
bash scripts/verify-tableau-qual-connection.sh
```

**Note:** Cloud Agent VMs may not resolve `tableau-qual.hertz.com` without corporate VPN or private network access. MCP calls will fail until the agent runtime can reach that host.

## Cloud Agent bootstrap

- [`.cursor/environment.json`](.cursor/environment.json) — install hook
- [`.cursor/install.sh`](.cursor/install.sh) — idempotent bootstrap
- [`scripts/smoke-test.sh`](scripts/smoke-test.sh) — checkout and bootstrap health check
