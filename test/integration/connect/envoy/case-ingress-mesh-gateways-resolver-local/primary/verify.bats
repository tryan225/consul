#!/usr/bin/env bats

load helpers

@test "gateway-primary proxy admin is up on :19002" {
  retry_default curl -f -s localhost:19002/stats -o /dev/null
}

@test "ingress-primary proxy admin is up on :20000" {
  retry_default curl -f -s localhost:20000/stats -o /dev/null
}

@test "ingress should have healthy endpoints for s2" {
  assert_upstream_has_endpoints_in_status 127.0.0.1:20000 s2.default.secondary HEALTHY 1
}

@test "gateway-primary should have healthy endpoints for secondary" {
   assert_upstream_has_endpoints_in_status 127.0.0.1:19002 secondary HEALTHY 1
}

@test "gateway-secondary should have healthy endpoints for s2" {
   assert_upstream_has_endpoints_in_status consul-secondary:19003 s2 HEALTHY 1
}

@test "ingress should be able to connect to s2" {
  run retry_default curl -s -f -d hello localhost:9999
  [ "$status" -eq 0 ]
  [ "$output" = "hello" ]
}

@test "ingress made 1 connection" {
  assert_envoy_metric_at_least 127.0.0.1:20000 "cluster.s2.default.secondary.*cx_total" 1
}

@test "gateway-primary is used for the upstream connection" {
  assert_envoy_metric_at_least 127.0.0.1:19002 "cluster.secondary.*cx_total" 1
}
