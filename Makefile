setup:
	mkdir -p data/grafana-data
	mkdir -p data/prometheus-data
	mkdir -p data/loki-data
	mkdir -p data/n8n-data
	sudo chown -R 472 data/grafana-data
	sudo chown -R 65534 data/prometheus-data
	sudo chown -R 10001 data/loki-data
	sudo chown -R 1000 data/n8n-data
	docker network create monitoring > /dev/null 2>&1

serve-master:
	docker compose -f master/docker-compose.yaml --env-file master/.env --project-directory . up -d

down-master:
	docker compose -f master/docker-compose.yaml --env-file master/.env --project-directory . down

serve-node:
	docker compose -f node/docker-compose.yaml --env-file node/.env --project-directory . up -d

down-node:
	docker compose -f node/docker-compose.yaml --env-file node/.env --project-directory . down

allow-domain-cert:
	sudo setfacl -m u:472:rx /etc/letsencrypt/live
	sudo setfacl -m u:472:rx /etc/letsencrypt/archive

	@read -p "Enter domain: " domain; \
	sudo setfacl -m u:472:r /etc/letsencrypt/live/$$domain/*; \
	sudo setfacl -m u:472:r /etc/letsencrypt/archive/$$domain/*


	