# OTP Server

A Docker-based [OpenTripPlanner](https://www.opentripplanner.org/) (OTP) server for public transit routing. This project provides a simple way to run OTP with your own GTFS and PBF data files.

Based on [Trufi's OTP Server](https://github.com/trufi-association/trufi-server-otp).

## Prerequisites

- [Docker](https://www.docker.com/) and Docker Compose
- A **GTFS file** with your transit data (see [trufi-gtfs-builder](https://github.com/trufi-association/trufi-gtfs-builder))
- A **PBF file** (OpenStreetMap extract) for your area:
  - Download from [Geofabrik](https://download.geofabrik.de/)
  - Use [BoundingBox](https://boundingbox.klokantech.com/) to define your area

## Quick Start

1. **Add your data files:**
   ```
   data/
   ├── gtfs/           # Place GTFS files here (agency.txt, routes.txt, etc.)
   └── your-area.osm.pbf
   ```

2. **Set OTP version** in `.env`:
   ```bash
   otpversion=2.8.1
   ```

3. **Run the server:**
   ```bash
   docker-compose up
   ```

The first run will build the routing graph from your data (this takes a few minutes). Subsequent runs will load the cached graph and start faster.

## Project Structure

```
├── Dockerfiles/           # OTP version configurations
│   ├── 1.5.0/
│   ├── 2.0.0/
│   ├── 2.2.0/
│   ├── 2.4.0/
│   ├── 2.7.0/
│   └── 2.8.1/            # Latest (recommended)
├── data/
│   ├── gtfs/             # Your GTFS files
│   ├── *.osm.pbf         # Your PBF file
│   ├── otp-config.json   # OTP configuration (GraphQL, etc.)
│   ├── router-config.json # Routing defaults
│   └── graph.obj         # Generated routing graph (cached)
├── docker-compose.yml
├── .env                   # OTP version selector
└── nginx.conf            # Optional reverse proxy config
```

## Configuration

### OTP Version

Set the version in `.env`:

```bash
otpversion=2.8.1
```

**Available versions:** `1.5.0`, `2.0.0`, `2.2.0`, `2.4.0`, `2.7.0`, `2.8.1`

> Note: Version 1.5.0 uses Java 11, versions 2.2.0+ use Java 21.

### Memory

By default, OTP uses 2GB of RAM. For larger datasets, increase memory by uncommenting in `docker-compose.yml`:

```yaml
environment:
  - JAVA_MAX_MEMORY=-Xmx8G
```

### GraphQL API

The GraphQL API is configured in `data/otp-config.json`. By default, the Legacy GraphQL API (compatible with Digitransit) is enabled:

```json
{
    "otpFeatures": {
        "SandboxAPILegacyGraphQLApi": true
    }
}
```

**API Endpoints (OTP 2.x):**
- GraphiQL UI: `http://localhost:8080/graphiql`
- GTFS GraphQL: `http://localhost:8080/otp/gtfs/v1`
- Legacy GraphQL: `http://localhost:8080/otp/routers/default/index/graphql`

> Note: OTP 1.5.0 only supports REST API, not GraphQL.

## Usage

### API Endpoint

Once running, the OTP API is available at:

```
http://localhost:8080/otp/
```

### Rebuilding the Graph

To rebuild the routing graph (e.g., after updating GTFS data):

```bash
rm data/graph.obj
docker-compose up
```

### Running in Background

```bash
docker-compose up -d
```

### Viewing Logs

```bash
docker-compose logs -f
```

### Stopping

```bash
docker-compose down
```

## Nginx Integration

The included `nginx.conf` snippet can be used to proxy OTP behind Nginx:

```nginx
location /otp {
    proxy_pass http://otp:8080/otp/routers/default;
}
```

## Troubleshooting

### Out of Memory Errors

Increase `JAVA_MAX_MEMORY` in `docker-compose.yml`. Large cities may need 4-8GB.

### Graph Build Fails

- Ensure GTFS files are valid (check with [GTFS Validator](https://gtfs-validator.mobilitydata.org/))
- Ensure PBF file covers the area of your GTFS stops

### Container Won't Start

Check logs with `docker-compose logs -f` to see the error.

## Links

- [OpenTripPlanner Documentation](https://docs.opentripplanner.org/)
- [Trufi Association](https://www.trufi-association.org/)
- [trufi-gtfs-builder](https://github.com/trufi-association/trufi-gtfs-builder)
