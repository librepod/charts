# PostgreSQL: The World's Most Advanced Open Source Relational Database

![Version: 0.1.2](https://img.shields.io/badge/Version-0.1.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Installs a PostgreSQL

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| configs.DBHOST | string | `"postgres-db"` |  |
| configs.DBNAME | string | `"postgres"` |  |
| configs.DBPORT | string | `"5432"` |  |
| configs.DBUSER | string | `"postgres"` |  |
| configs.PGPASSWORD | string | `""` |  |
| configs.POSTGRES_HOST_AUTH_METHOD | string | `"trust"` |  |
| configs.POSTGRES_PASSWORD | string | `""` |  |
| configs.POSTGRES_USER | string | `"postgres"` |  |
| configs.RESTORE_URL | string | `""` |  |
| configs.TZ | string | `"Europe/Moscow"` |  |
| configs.existingSecret | string | `""` | Set this to the name of a secret to load environment variables from. If defined, values in the secret will override values in configs |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"postgres"` |  |
| image.tag | string | `"10-alpine"` |  |
| storage.accessModes | string | `"ReadWriteOnce"` |  |
| storage.class | string | `"nfs-client"` |  |
| storage.dataSize | string | `"1Gi"` |  |
