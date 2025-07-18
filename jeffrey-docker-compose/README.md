# Jeffrey Docker Compose Setup

This Docker Compose configuration provides a lightweight alternative to the Kubernetes deployment, offering the same functionality with easier local development and testing.

## Architecture

The setup includes 4 services:

1. **jeffrey-console** - Main web interface for viewing profiling data
2. **jeffrey-testapp-client** - Load testing client that generates requests
3. **jeffrey-testapp-direct-server** - High-performance server (efficient.mode=true)
4. **jeffrey-testapp-dom-server** - Standard server (efficient.mode=false)

## Quick Start

1. Navigate to the docker-compose directory:
   ```bash
   cd jeffrey-docker-compose
   ```

2. Start all services:
   ```bash
   docker-compose up -d
   ```

3. Access the Jeffrey Console:
   ```bash
   open http://localhost:8080
   ```

4. Check service status:
   ```bash
   docker-compose ps
   ```

5. View logs:
   ```bash
   # All services
   docker-compose logs -f
   
   # Specific service
   docker-compose logs -f jeffrey-console
   ```

## Service Details

### Jeffrey Console
- **URL**: http://localhost:8080
- **Purpose**: Web interface for viewing profiling data
- **Data**: Stores SQLite database and recordings in shared volume

### Jeffrey Testapp Client
- **Purpose**: Generates load against both server instances
- **Target URLs**: 
  - http://jeffrey-testapp-direct-server:8080
  - http://jeffrey-testapp-dom-server:8080

### Jeffrey Testapp Servers
- **Direct Server**: High-performance mode (efficient.mode=true)
- **DOM Server**: Standard mode (efficient.mode=false)
- **Both**: Write profiling data to shared volume

## Configuration

### Directory Structure
```
jeffrey-docker-compose/
├── docker-compose.yml          # Main Docker Compose configuration
├── config/                     # Service configurations
│   ├── console/
│   │   └── application.properties
│   ├── client/
│   │   └── application.properties
│   ├── server-direct/
│   │   └── application.properties
│   └── server-dom/
│       └── application.properties
├── scripts/
│   └── init-jeffrey-env.sh     # Environment initialization script
└── README.md                   # This file
```

### Volume Mapping
- **jeffrey-data**: Shared volume mounted at `/tmp/jeffrey` in all containers
- **Config files**: Mounted read-only from local `config/` directory

### Health Checks
All services include health checks using Spring Boot actuator endpoints:
- **Endpoint**: `/actuator/health`
- **Interval**: 30s
- **Timeout**: 10s
- **Retries**: 3

## Management Commands

### Start Services
```bash
# Start all services
docker-compose up -d

# Start specific service
docker-compose up -d jeffrey-console
```

### Stop Services
```bash
# Stop all services
docker-compose down

# Stop specific service
docker-compose stop jeffrey-console
```

### Restart Services
```bash
# Restart all services
docker-compose restart

# Restart specific service
docker-compose restart jeffrey-console
```

### View Logs
```bash
# Follow all logs
docker-compose logs -f

# Follow specific service logs
docker-compose logs -f jeffrey-console

# View recent logs
docker-compose logs --tail=50 jeffrey-console
```

### Service Status
```bash
# Check service status
docker-compose ps

# Check service health
docker-compose exec jeffrey-console curl -f http://localhost:8080/actuator/health
```

## Troubleshooting

### Common Issues

1. **Port 8080 already in use**
   - Change the port mapping in docker-compose.yml: `"8081:8080"`

2. **Services fail to start**
   - Check logs: `docker-compose logs <service-name>`
   - Verify health checks: `docker-compose ps`

3. **Client can't connect to servers**
   - Ensure all services are healthy: `docker-compose ps`
   - Check network connectivity: `docker-compose exec jeffrey-testapp-client ping jeffrey-testapp-direct-server`

4. **No profiling data visible**
   - Verify shared volume is mounted correctly
   - Check if services are generating profile data: `docker-compose exec jeffrey-console ls -la /tmp/jeffrey/`

### Debugging

1. **Access container shell**:
   ```bash
   docker-compose exec jeffrey-console bash
   ```

2. **Check shared volume contents**:
   ```bash
   docker-compose exec jeffrey-console find /tmp/jeffrey -type f -name "*.jfr"
   ```

3. **View service configuration**:
   ```bash
   docker-compose exec jeffrey-console cat /app/config/application.properties
   ```

## Development

### Modifying Configuration
1. Edit files in the `config/` directory
2. Restart the affected service: `docker-compose restart <service-name>`

### Updating Images
1. Pull latest images: `docker-compose pull`
2. Restart services: `docker-compose up -d`

### Clearing Data
1. Stop all services: `docker-compose down`
2. Remove volume: `docker volume rm jeffrey-docker-compose_jeffrey-data`
3. Restart: `docker-compose up -d`

## Comparison with Kubernetes

| Feature | Kubernetes | Docker Compose |
|---------|------------|----------------|
| Complexity | High | Low |
| Resource Usage | High | Low |
| Startup Time | Slower | Faster |
| Networking | Complex | Simple |
| Persistence | PV/PVC | Named Volume |
| Service Discovery | DNS | DNS |
| Health Checks | Probes | Health Checks |
| Configuration | ConfigMaps | Volume Mounts |

## Next Steps

1. **Monitor Performance**: Use Jeffrey Console to view profiling data
2. **Adjust Load**: Modify client configuration to change load patterns
3. **Compare Modes**: Observe differences between direct and DOM server modes
4. **Scale Services**: Add replicas using Docker Compose scale functionality