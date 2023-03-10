postgres:
	docker run --name postgres15 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:15.1-alpine

createdb:
	docker exec -it postgres15 createdb --username=root --owner=root simple_bank

sqlc:
	sqlc generate 

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

dropdb:
	docker exec -it postgres15 dropdb simple_bank

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

deletecontainers:
	docker stop $$(docker ps -a -q) && docker container rm $$(docker ps -aq)


.PHONY: postgres createdb dropdb migrateup migratedown deletecontainers sqlc