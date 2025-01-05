Here's a basic `README.md` file for the project based on the files provided:

---

# Big Data Ecosystem Project

## Overview

This project demonstrates a typical Big Data Ecosystem using Docker Compose, which sets up and connects several services, including Elasticsearch, Kibana, Logstash, and MySQL. The data from a MySQL database (`Chinook`) is ingested into Elasticsearch using Logstash, making it searchable and visualizable through Kibana. 

The project uses Docker containers for all services, ensuring easy and reproducible deployment. 

## Services Overview

The `docker-compose.yml` file defines the following services:

1. **Elasticsearch (es01)**:
   - Stores the data from MySQL.
   - Provides a search engine to index and query data.
   - Configured with SSL for secure communication.

2. **Kibana**:
   - Provides a web interface for visualizing the data stored in Elasticsearch.
   - Securely connects to Elasticsearch via SSL.

3. **Logstash (logstash01)**:
   - Ingests data from the MySQL database (`Chinook`), processes the data, and loads it into Elasticsearch.
   - Configured with JDBC input to fetch data from MySQL tables and filter them.
   
4. **MySQL (mysql-db)**:
   - A relational database containing the `Chinook` schema for storing data such as Artists, Albums, Employees, etc.
   - Data is queried by Logstash and transferred into Elasticsearch for indexing.

5. **Setup (certificates)**:
   - Initializes certificates for Elasticsearch and Kibana to enable secure SSL communication.
   
## File Structure

- **docker-compose.yml**: Defines the services and configuration for Elasticsearch, Kibana, Logstash, MySQL, and setup.
- **logstash/logstash.conf**: Contains the configuration for Logstash pipelines to ingest data from MySQL and push it to Elasticsearch.
- **data/init.sql**: SQL script to set the MySQL root password and configure authentication settings.
- **.env**: Stores environment variables like passwords, cluster settings, and memory limits.

## Requirements

- Docker
- Docker Compose

## Getting Started

### 1. Clone the repository

```bash
git clone <repo_url>
cd <project_directory>
```

### 2. Set up the environment

Create a `.env` file based on the `example.env` and provide the necessary credentials and settings:

```bash
cp .env.example .env
```

Update the `.env` file with appropriate values for:

- `ELASTIC_PASSWORD`
- `KIBANA_PASSWORD`
- `CLUSTER_NAME`
- `LICENSE`
- `ES_PORT`
- `KIBANA_PORT`
- `MYSQL_ROOT_PASSWORD`

### 3. Start the project

Run the following command to start all the services:

```bash
docker-compose up -d
```

This will:

- Build and start the Elasticsearch, Kibana, Logstash, and MySQL containers.
- Set up secure connections using SSL certificates.
- Import data from MySQL into Elasticsearch through Logstash.

### 4. Access the services

- **Elasticsearch**: Access at `https://localhost:9200`
- **Kibana**: Access at `http://localhost:5601`
  
Use the environment variables `ELASTIC_PASSWORD` and `KIBANA_PASSWORD` to log in.

### 5. Verify the setup

You can check the logs for each container to ensure everything is running smoothly:

```bash
docker-compose logs -f
```

You can also verify the data ingestion from MySQL to Elasticsearch using Kibana's Discover tab or by querying Elasticsearch directly.

### 6. Stop the services

To stop the services, run:

```bash
docker-compose down
```

This will stop and remove the containers. Data in volumes is persistent, so it will remain even after the containers are stopped.

## Configuration Details

- **Logstash Pipeline**: The Logstash pipeline is configured to fetch data from the MySQL `Chinook` database and insert it into Elasticsearch. Each table (`Artist`, `Album`, `Employee`, `Customer`, `Invoice`, `InvoiceLine`) has its own query and processing rules.
- **MySQL Setup**: The `init.sql` script initializes MySQL with the required user and password settings for Logstash to connect.

### Example MySQL JDBC Input Configuration

```bash
input {
  jdbc {
    jdbc_connection_string => "jdbc:mysql://mysql-db:3306/Chinook"
    jdbc_user => "root"
    jdbc_password => "rootpassword"
    jdbc_driver_library => "/usr/share/logstash-core/lib/jars/mysql-connector-j-9.1.0.jar"
    jdbc_driver_class => "com.mysql.cj.jdbc.Driver"
    statement => "SELECT * FROM Artist"
    type => "artist"
  }
}
```

### Logstash Output to Elasticsearch

```bash
output {
  if [type] == "artist" {
    elasticsearch {
      hosts => ["https://es01:9200"]
      index => "artist"
      document_id => '%{artistid}'
      user => "elastic"
      password => "elastic123"
      ssl => true
      ssl_certificate_verification => true
      cacert => "/usr/share/logstash/certs/ca/ca.crt"
    }
  }
}
```

## Troubleshooting

- If the containers are not starting properly, check the logs for errors:

```bash
docker-compose logs <container_name>
```

- Ensure that the `.env` file is correctly configured with the necessary environment variables.
- Verify that the MySQL database is properly initialized with the `Chinook` schema using the `init.sql` script.

## Contributing

Feel free to submit issues or pull requests for improvements. If you'd like to contribute, please fork the repository and create a pull request with a description of the changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

This `README.md` provides an overview of the project setup, environment, services, and the steps to get started. If you need any further customization or additions to this file, feel free to let me know!
