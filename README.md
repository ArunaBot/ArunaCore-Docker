
# ArunaCore Docker Image

The official ArunaCore Docker image repository.

Source code for the ArunaCore project can be found at https://github.com/ArunaBot/ArunaCore

---


ArunaCore is an open-source websocket server for intercommunication between applications, distributed as a Docker image in two variants:

| Tag       | Base image        | Description                         |
|-----------|-------------------|-----------------------------------|
| `latest`  | `node:jod-slim`   | Standard version based on Debian  |
| `alpine`  | `node:jod-alpine` | Lightweight version based on Alpine Linux |

---

## How to use

### Run the standard (slim) version

```sh
docker run -p 3000:3000 lobometalurgico/arunacore:latest
```

### Run the Alpine version (smaller image)

```sh
docker run -p 3000:3000 lobometalurgico/arunacore:alpine
```

---

## Version tags

You can also pull specific ArunaCore versions:

```sh
docker pull lobometalurgico/arunacore:1.0.0-BETA.3
docker pull lobometalurgico/arunacore:1.0.0-BETA.3-alpine
```

---

## Port Configuration

The ArunaCore Docker container **always listens on port 3000 internally**. This port is fixed and cannot be changed via environment variables inside the container.

To expose ArunaCore on a different port on your host machine, use Docker's port mapping feature. For example, to expose the service on port 8080 externally, run:

```bash
docker run -p 8080:3000 lobometalurgico/arunacore
```

In this example, the container still listens on port 3000 internally, but the host forwards traffic from port 8080 to the container's port 3000.

**Note:** The healthcheck endpoint also uses port 3000 internally and expects the service to be available there.

---

## Environment Variables

You can configure ArunaCore using environment variables by prefixing the configuration keys with `ARUNACORE_` and capitalizing them. For nested properties, use underscores (`_`). For example, to override `port`, set `ARUNACORE_PORT`.

| Configuration Key               | Environment Variable                   | Description                                                                                   | Default           |
|-------------------------------|--------------------------------------|-----------------------------------------------------------------------------------------------|-------------------|
| `id`                          | `ARUNACORE_ID`                       | Service identifier                                                                            | `arunacore`       |
| `debug`                       | `ARUNACORE_DEBUG`                    | Enable debug mode                                                                             | `false`           |
| `port`                        | `ARUNACORE_PORT`                     | Service listening port (ignored inside container, always 3000)                                                                        | `3000`            |
| `autoLogEnd`                  | `ARUNACORE_AUTOLOGEND`               | Enable automatic logging on process end                                                      | `true`            |
| `masterkey`                   | `ARUNACORE_MASTERKEY`                | Master key for privileged operations. **If set to `changeme` (default), it will be ignored, disabling all functions that require it and showing a warning.** | `changeme` (ignored) |
| `requireAuth`                 | `ARUNACORE_REQUIREAUTH`              | Require authentication                                                                       | `false`           |
| `logger.coloredBackground`    | `ARUNACORE_LOGGER_COLOREDBACKGROUND`| Enable colored background in logger output                                                   | `false`           |
| `logger.allLineColored`       | `ARUNACORE_LOGGER_ALLLINECOLORED`   | Enable coloring of entire log lines                                                          | `true`            |

---

### Usage Examples

Run with custom port and debug enabled (note: `ARUNACORE_PORT` will be ignored inside the container, the port should be mapped with Docker):

```bash
docker run -p 8080:3000 -e ARUNACORE_DEBUG=true lobometalurgico/arunacore
```

Run with master key set (remember to use a strong key!):

```bash
docker run -e ARUNACORE_MASTERKEY=yourStrongMasterKey lobometalurgico/arunacore
```

Disable authentication:

```bash
docker run -e ARUNACORE_REQUIREAUTH=false lobometalurgico/arunacore
```

---

## Support and bugs

Report issues on GitHub:  
https://github.com/ArunaBot/ArunaCore/issues

---

## License

GPL-3.0

---

**Maintained by LoboMetalurgico**  
Contact: lobometalurgico@allonsve.com
