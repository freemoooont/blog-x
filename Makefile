build: build-api
build-api:
	docker-compose --log-level=debug build --pull --file=Docker/Dockerfile --tag=${REGISTRY}/kolyan-blog-api:${IMAGE_TAG}
push-api:
	docker-compose push ${REGISTRY}/kolyan-blog-api:${IMAGE_TAG}
push: push-api
deploy:
	ssh -o StrictHostKeyChecking=no -i ${PRODUCTION_KEY} admin@${HOST} -p ${PORT} 'rm -rf site_${BUILD_NUMBER}'
	ssh -o StrictHostKeyChecking=no -i ${PRODUCTION_KEY} admin@${HOST} -p ${PORT} 'mkdir site_${BUILD_NUMBER}'
	scp -o StrictHostKeyChecking=no -P ${PORT} docker-compose.yml admin@${HOST}:site_${BUILD_NUMBER}/docker-compose.yml
	ssh -o StrictHostKeyChecking=no -i ${PRODUCTION_KEY} admin@${HOST} -p ${PORT} 'cd site_${BUILD_NUMBER} && echo "REGISTRY=${REGISTRY}" >> .env'
	ssh -o StrictHostKeyChecking=no -i ${PRODUCTION_KEY} admin@${HOST} -p ${PORT} 'cd site_${BUILD_NUMBER} && echo "IMAGE_TAG=${IMAGE_TAG}" >> .env'
	ssh -o StrictHostKeyChecking=no -i ${PRODUCTION_KEY} admin@${HOST} -p ${PORT} 'cd site_${BUILD_NUMBER} && echo "API_DB_PASSWORD=${API_DB_PASSWORD}" >> .env'
	ssh -o StrictHostKeyChecking=no -i ${PRODUCTION_KEY} admin@${HOST} -p ${PORT} 'cd site_${BUILD_NUMBER} && sudo docker-compose pull'
	ssh -o StrictHostKeyChecking=no -i ${PRODUCTION_KEY} admin@${HOST} -p ${PORT} 'cd site_${BUILD_NUMBER} && sudo docker-compose up -d'
	ssh -o StrictHostKeyChecking=no -i ${PRODUCTION_KEY} admin@${HOST} -p ${PORT} 'rm -f site'
	ssh -o StrictHostKeyChecking=no -i ${PRODUCTION_KEY} admin@${HOST} -p ${PORT} 'ln -sr site_${BUILD_NUMBER} site'