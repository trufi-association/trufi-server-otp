# OpenTripPlanner Server

A Docker-based [OpenTripPlanner](https://www.opentripplanner.org/) (OTP) server for public transit routing. Part of the [Trufi Association](https://www.trufi-association.org/) transit stack.

## Prerequisites

- [Docker](https://www.docker.com/) and Docker Compose
- A **GTFS file** (`.zip`) with your transit data
- A **PBF file** (OpenStreetMap extract) for your area

### Getting Data Files

- **GTFS**: Create with [trufi-gtfs-builder](https://github.com/trufi-association/trufi-gtfs-builder) or download from transit agencies
- **PBF**: Download from [Geofabrik](https://download.geofabrik.de/)

## Quick Start

### 1. Run the setup script

```bash
./init.sh --gtfs /path/to/gtfs.zip --pbf /path/to/region.osm.pbf
```

Options:
- `--gtfs <path>` - Path to GTFS file (`.zip`)
- `--pbf <path>` - Path to OSM PBF file (`.osm.pbf`)
- `--version <ver>` - OTP version (default: 2.8.1)

### 2. Start the server

```bash
docker-compose up
```

The first run builds the routing graph from your data (this takes a few minutes). Subsequent runs load the cached graph.

### 3. Access the API

- **API**: http://localhost:8080/otp/
- **GraphiQL**: http://localhost:8080/graphiql (OTP 2.x only)

## Available OTP Versions

| Version | Java | Notes |
|---------|------|-------|
| 2.8.1   | 21   | Latest stable (recommended) |
| 2.7.0   | 21   | |
| 2.4.0   | 21   | |
| 2.2.0   | 21   | |
| 2.0.0   | 11   | |
| 1.5.0   | 11   | Legacy, REST API only |

## Configuration

### Memory

Default memory is 2GB. For larger datasets, set in `.env`:

```bash
JAVA_MAX_MEMORY=-Xmx8G
```

### OTP Version

Set in `.env` (created by `init.sh`):

```bash
otpversion=2.8.1
```

## Project Structure

```
trufi-server-otp/
├── Dockerfiles/           # OTP version configurations
│   ├── 1.5.0/
│   ├── 2.0.0/
│   ├── 2.2.0/
│   ├── 2.4.0/
│   ├── 2.7.0/
│   └── 2.8.1/
├── data/                  # Your data files (gitignored)
│   ├── *.gtfs.zip        # GTFS file
│   ├── *.osm.pbf         # PBF file
│   └── graph.obj         # Generated graph (cached)
├── docker-compose.yml
├── init.sh               # Setup script
├── trufi-proxy.json      # trufi-server integration
└── .env                  # Configuration
```

## trufi-server Integration

This service integrates with [trufi-server](https://github.com/trufi-association/trufi-server). The `trufi-proxy.json` file provides the configuration needed for automatic service discovery.

## Common Operations

### Rebuild Graph

After updating GTFS data:

```bash
rm data/graph.obj
docker-compose up
```

### View Logs

```bash
docker-compose logs -f
```

### Stop Server

```bash
docker-compose down
```

## API Endpoints (OTP 2.x)

| Endpoint | Description |
|----------|-------------|
| `/otp/` | API root |
| `/graphiql` | GraphQL IDE |
| `/otp/gtfs/v1` | GTFS GraphQL API |
| `/otp/routers/default/index/graphql` | Legacy GraphQL API |

## Troubleshooting

### Out of Memory

Increase `JAVA_MAX_MEMORY` in `.env`. Large cities may need 4-8GB.

### Graph Build Fails

- Validate GTFS with [GTFS Validator](https://gtfs-validator.mobilitydata.org/)
- Ensure PBF file covers GTFS stop locations

### Container Won't Start

Check logs: `docker-compose logs -f`

## Links

- [OpenTripPlanner Documentation](https://docs.opentripplanner.org/)
- [Trufi Association](https://www.trufi-association.org/)
- [trufi-server](https://github.com/trufi-association/trufi-server)
- [trufi-gtfs-builder](https://github.com/trufi-association/trufi-gtfs-builder)
