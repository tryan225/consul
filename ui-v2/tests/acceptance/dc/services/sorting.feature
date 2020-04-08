@setupApplicationTest
Feature: dc / services / sorting
  Scenario:
    Given 1 datacenter model with the value "dc-1"
    And 6 service models from yaml
    ---
    - Name: Service A
      Kind: consul
    - Name: Service B
      Kind: consul
    - Name: Service C
      Kind: consul
    - Name: Service D
      Kind: consul
    - Name: Service E
      Kind: consul
    - Name: Service F
      Kind: consul
    ---
    When I visit the services page for yaml
    ---
      dc: dc-1
    ---
    When I click selected on the sort
    When I click options.1.button on the sort
    Then I see name on the services vertically like yaml
    ---
    - Service F
    - Service E
    - Service D
    - Service C
    - Service B
    - Service A
    ---
    When I click selected on the sort
    When I click options.0.button on the sort
    Then I see name on the services vertically like yaml
    ---
    - Service A
    - Service B
    - Service C
    - Service D
    - Service E
    - Service F
    ---
