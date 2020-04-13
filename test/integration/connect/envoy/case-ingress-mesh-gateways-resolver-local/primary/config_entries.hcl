enable_central_service_config = true

config_entries {
  bootstrap {
    kind = "ingress-gateway"
    name = "ingress-gateway"

    listeners = [
      {
        protocol = "tcp"
        port = 9999
        services = [
          {
            name = "s2"
          }
        ]
      }
    ]
  }

  bootstrap {
    kind = "proxy-defaults"
    name = "global"
    mesh_gateway {
      mode = "local"
    }
  }

  bootstrap {
    kind = "service-resolver"
    name = "s2"
    redirect {
      service = "s2"
      datacenter = "secondary"
    }
  }
}
