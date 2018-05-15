# Yet Another Set of Dockerfiles

## Designed for Composability

* base image
* proxy/dns cache
* log/metric forwarder
* TBD

### Base Image

##### debian + monit

Debian is awesome. [Monit](https://mmonit.com/monit/) provides such flexible and lightweight monitoring and error recovery that I deem it valuable enough to have in every container. It's like having automatic error response playbooks at the container level.

### Proxy/DNS Cache

##### dnsmasq + tinyproxy

In my experience, caching dns appropriately can reduce confusing throttling or errors from your dns provider. Specifically, dns in previous versions of kubernetes would fall over under ordinary network use because none of the containers in pods were caching any dns. I have also seen aws dns responses hang for a distressing about of time. The number of dns requests triggered by third party libraries is not always clear or under your control, so cache that nonsense.

By pairing the DNS cache (dnsmasq) with a proxy (tinyproxy), we can compose a proxy container with a service container and redirect traffic by the standard action of setting the environment variables `http_proxy` and `https_proxy`. Respecting these variables is expected, and anything that does not respect them should make you sad. The benefits of adding dns caching through a standard action instead of a custom action--like installing dnsmasq via the Dockerfile for your container--should be recognised:

* no change to service Dockerfile
* decide at deploy time if you need dns caching for a service
* service continues to work standalone
* proxy/dns cache works standalone, can be paired with any service (would not recommend using one proxy for multiple service containers w/o diligent study)

### Log/Metric Forwarder

##### fluentbit + savelog

Wrestling with docker logs via stdout or syslog is no fun. Everyone wants to write to disk and have N log/metric streams; lets do that. [Fluentbit](https://fluentbit.io/) is a stripped-down, all-C version of the fluentd collector. Fluentbit (`td-agent-bit` binary) runs a simple set of pipelines built of: inputs, parsers, filters, and outputs. A simple log-to-elasticseach with log rotation can be accomplished with fluentbit + monit triggering savelog on a mounted volume that is shared between the logger and the service.

### TBD

TBD. More to come.

