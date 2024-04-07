# Iceberg & spark playpen

Based on the official quickstart - https://iceberg.apache.org/spark-quickstart/

Use this project as a means to freely experiment and build your understanding of working with data lakes.

## Setup

Iceberg is a datalake table format solution.  The three parts to a data lake are 1. object storage, 2. object / table metadata, and 3. execution environment.

Here we use Iceberg for 2. as it provides ACID like guarantees to our data (unlike other lake solutions like HIVE), is efficient, and has good support and documentation.

The object storage would usually be s3 if we are working in AWS, so we use an s3 emulator here called minio.

And for the preferred execution environment we have a local spark cluster which can query the data lake, pull / push files and run compuations.  As this is a data lake the data storage and compute is separate so spark is running in it's own container (with a filesystem volume here at `warehouse/`) and the actual lake data is in the minio container with a volume at `data/`.  

## Commands

Start the environment.

This also creates a python venv `.venv` that can be used for your code completion (but not for executing code !!) in your ide.  Note that this requires you to have python3.9 installation (install with `$ brew install python@3.9`) and optionally the [uv](https://astral.sh/blog/uv) package for faster pip (`$ brew install uv`)

```sh
make
```

Stop the environment

```sh
make stop
```

Get a bash shell in the spark environment

- As an example you can then get start an interactive pyspark session with `pyspark`

- Run pyspark python scripts with `spark-submit /home/iceberg/warehouse/<script_name>.py`

    - You can either create these scripts with a text editor in the shell (vim 😁) or with just your current ide as this path is a volume mapping to the relative `warehouse/` directory.

```sh
make shell
```

If you want to reset the state of the project and remove any local data.

```sh
make clean
```

If you want to go one step further and also delete all docker images used by this project, i.e. you are low on storage space and will not need the project anymore.

```sh
make deepclean
```

## Services

A jupyter service is started by default with the start command, so when that's up you can connect to it at http://localhost:8888/tree.  This is where I recommend spending most of the time to do development and experimentation.

The minio object management console UI is running on http://localhost:9001/browser (username: `admin`, password: `password`) - think of this just like the s3 console in AWS.

The spark [web ui](https://spark.apache.org/docs/latest/web-ui.html) is up on http://localhost:4042/ - this is really useful for monitoring you spark code / jobs and ensuring they are executing as expected.
