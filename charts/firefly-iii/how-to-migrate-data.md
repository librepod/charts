## How to migrate Firefly data via Postgres pg_dump

Based on this article: https://www.adyxax.org/blog/2020/06/25/dump-and-restore-a-postgresql-database-on-kubernetes/

1. Make sure that your old Firefly instance and a new one use same Postgres credentials (POSTGRESS_USER, POSTGRESS_PASSWORD)
2. Drop into the old Postgres container:
```sh
kubectl -n database exec -ti postgres-postgresql-0 -- /bin/sh
```
3. Execute pg_dump:
```sh
pg_dump --host postgres-postgresql --verbose --no-owner -U firefly -d firefly > /tmp/firefly.sql
```

4. Copy the dump from old postgres container to your host:
```sh
kubectl -n database cp postgres-postgresql-0:/tmp/firefly.sql ./firefly.sql
```

5. Stop Firefly deployment by changing `replicas` to 0
6. Copy the dump to the new postgres container:
```sh
kubectl -n default cp firefly.sql firefly-iii-postgres-cbbdc97db-frr7p:/tmp/firefly.sql
```
7. Drop into the new Postgres container like you did in #2.
8. Restore the dump with psql:
```sh
psql -U firefly -f /tmp/firefly.sql
```
