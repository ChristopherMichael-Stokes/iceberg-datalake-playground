.PHONY: start, stop, shell, clean, environment, deepclean

.DEFAULT_GOAL := start
UV_INSTALLED := $(shell command -v uv)


ifneq ($(UV_INSTALLED),)
.venv:
	echo "uv is installed, using uv to create venv"
	uv venv --python=python3.9 $@ # make venv with same name as target

 
.venv/bin/python: requirements.txt .venv
	uv pip install --upgrade pip
	uv pip install -r $< # install packages from first argument
	touch .venv/bin/python # necessary to update the file timestamp so we only run this target once

else

.venv:
	echo "uv is not installed, using system python"
	python3.9 -m venv $@ 


.venv/bin/python: requirements.txt .venv
	.venv/bin/python -m pip install --upgrade pip
	.venv/bin/python -m pip install -r $< 
	touch .venv/bin/python
endif


environment: .venv/bin/python


logs/docker-compose.log:
	# make log directory if not exists
	mkdir -p logs
	docker-compose up -d
	# pipe docker compose logs to file
	docker-compose logs -f > logs/docker-compose.log 2>&1 &


start: logs/docker-compose.log environment
	sleep 5
	@echo "Docker compose started"


stop: 
	docker-compose down
	rm -rf logs/


shell: logs/docker-compose.log 
	docker compose exec -it spark-iceberg bash


clean: stop
	find warehouse -not -name ".gitkeep" -not -iname "*.py" \
		-not -iname "*.java" \
		-not -iname "*.scala" \
		-not -iname "*.ipynb" \
		-delete
	find data/ -not -name '.gitkeep' -delete
	rm -rf .venv
	rm -rf .mypy_cache


deepclean: clean
	# delete all docker images from the docker compose
	docker-compose down --rmi all

