---
layout: "docs"
page_title: "Connect - Ingress Gateways"
sidebar_current: "docs-connect-ingressgateways"
description: |-
  An Ingress Gateway enables ingress traffic from services outside the Consul service mesh to services inside the Consul service mesh. This section details how to use Envoy and describes how you can plug in a gateway of your choice.
---

-> **1.8.0+:**  This feature is available in Consul versions 1.8.0 and newer.

# Ingress Gateways

## Prerequisites

Each mesh gateway needs three things:

1. A local Consul agent to manage its configuration.
2. General network connectivity to all services within its local Consul datacenter.
3. General network connectivity to all mesh gateways within remote Consul datacenters.

Mesh gateways also require that your Consul datacenters are configured correctly:

- You'll need to use Consul version 1.6.0.
- Consul [Connect](/docs/agent/options.html#connect) must be enabled in both datacenters.
- Each of your [datacenters](/docs/agent/options.html#datacenter) must have a unique name.
- Your datacenters must be [WAN joined](https://learn.hashicorp.com/consul/security-networking/datacenters).
- The [primary datacenter](/docs/agent/options.html#primary_datacenter) must be set to the same value in both datacenters. This specifies which datacenter is the authority for Connect certificates and is required for services in all datacenters to establish mutual TLS with each other.
- [gRPC](/docs/agent/options.html#grpc_port) must be enabled.
- If you want to [enable gateways globally](/docs/connect/mesh_gateway.html#enabling-gateways-globally) you must enable [centralized configuration](/docs/agent/options.html#enable_central_service_config).

Currently, Envoy is the only proxy with mesh gateway capabilities in Consul.

- Mesh gateway proxies receive their configuration through Consul, which
automatically generates it based on the proxy's registration. Currently Consul
can only translate mesh gateway registration information into Envoy
configuration, therefore the proxies acting as mesh gateways must be Envoy.

- Sidecar proxies that send traffic to an upstream service through a gateway
need to know the location of that gateway. They discover the gateway based on
their sidecar proxy registrations. Consul can only translate the gateway
registration information into Envoy configuration, so any sidecars that send
upstream traffic through a gateway must be Envoy.

Sidecar proxies that don't send upstream traffic through a gateway aren't
affected when you deploy gateways. If you are using Consul's built-in proxy as a
Connect sidecar it will continue to work for intra-datacenter traffic and will
receive incoming traffic even if that traffic has passed through a gateway.

## Mesh Gateway Configuration

Mesh gateways are defined very similarly to other typical services. The one exception is that a mesh gateway
service definition may contain a `Proxy.Config` entry just like a Connect proxy service to define opaque
configuration parameters useful for the actual proxy software.

