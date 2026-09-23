# API Observability & Load Testing

Instrument a Spring Boot API with Actuator/Micrometer, load-test it with k6, then find and fix one real performance bottleneck with before/after numbers to prove it.

## Problem

APIs are routinely shipped without any way to see what they're actually doing under load ; no metrics, no percentile latency, no load test ever run against them. When traffic grows, teams find out about N+1 queries or missing indexes in production instead of before it. This repo demonstrates the workflow for catching that kind of issue before it ships: instrument first, measure under load, fix the bottleneck the data points to, then prove the fix with a re-run.

## Approach

1. Stand up a small domain with an obvious N+1-prone relationship (Order → List<OrderItem>), backed by Postgres and versioned with Liquibase.
2. Expose Actuator health/metrics and a Prometheus-format scrape endpoint via Micrometer ; before writing any load test, so there's something to observe.
3. Seed a realistic data volume (thousands of rows) ; bottlenecks like a missing index or an N+1 query are invisible against a handful of rows.
4. Write a k6 script that drives concurrent virtual users against the target endpoint for a fixed duration, and capture a baseline (p95 latency, throughput).
5. Use the metrics/SQL logging to confirm a real bottleneck, fix it, and re-run the identical k6 script.
6. Document the before/after numbers here rather than claiming an improvement without evidence.

## What I built

- [ ] Spring Boot API (Order → OrderItem) backed by Postgres, schema/seed data managed with Liquibase
- [ ] Spring Boot Actuator + micrometer-registry-prometheus, exposing /actuator/health, /actuator/metrics, /actuator/prometheus
- [ ] Seed data migration inserting a realistic row volume for the target endpoint
- [ ] k6 load test script(s) under k6/
- [ ] Baseline ("before") load test results captured under docs/
- [ ] One identified and fixed bottleneck (N+1 query and/or missing index)
- [ ] "After" load test results captured under docs/, re-run with the identical k6 script
- [ ] (Optional) Grafana dashboard via Docker, if added

## Key decisions & tradeoffs

- *Postgres, not H2* ; an in-memory DB would mask exactly the kind of bottleneck (missing index, real query planner behavior) this repo exists to catch.
- *k6 over JMeter* ; script-as-code (.js) checks into git cleanly and gives simpler, more repeatable before/after runs than a GUI-driven JMeter plan.
- *Grafana treated as optional* ; Actuator's own /actuator/metrics JSON plus a documented before/after table is enough to prove observability; Grafana is only added if a visual dashboard screenshot is worth the extra infra.
- (Add the specific bottleneck decision here once found ; e.g. "chose to fix the N+1 via a JOIN FETCH over batch fetching because _".)

## How to run it

````bash
# clone
git clone https://github.com/SanaShahSyeda/api-observability-and-load-testing
cd observability-and-load-testing
````
# start Postgres (and Grafana, if included)
````bash
docker-compose up -d
````
# run the app
mvn spring-boot:run


Actuator endpoints (once running):
- http://localhost:8080/actuator/health
- http://localhost:8080/actuator/metrics
- http://localhost:8080/actuator/prometheus

Run the load test (requires [k6](https://k6.io/) installed separately):

bash
k6 run k6/load-test.js


Include any required env vars / secrets setup (never commit real secrets; use .env.example).

## Tests

- Integration tests against a real Postgres (Testcontainers), not H2; matching the rest of the portfolio.
- The real "test" for this repo is the load test's before/after numbers, not a unit test suite:

| | Before | After |
|---|---|---|
| p95 latency | TBD | TBD |
| Throughput (RPS) | TBD | TBD |
| Bottleneck fixed | ; | TBD (e.g. N+1 query / missing index) |

Raw k6 output saved under docs/load-test-before.txt and docs/load-test-after.txt.

````bash
mvn test
````

## Tech stack

- Language/framework: Java 21, Spring Boot, Spring Data JPA, Spring Boot Actuator, Micrometer
- Database: PostgreSQL, Liquibase (schema/seed migrations)
- Infra/tooling: k6 (load testing), Docker Compose, Grafana (optional)