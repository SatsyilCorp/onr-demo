# Downstream Analytics & Decision-Support Project

This is an example downstream repository demonstrating how an enterprise application, analytics service, or infrastructure team integrates seamlessly with the **Enterprise Golden Pipeline**.

---

## 1. Project Structure

```
downstream-project/
├── .github/
│   └── workflows/
│       └── pipeline.yml          # Imports central Enterprise Golden Pipeline
├── src/                          # Application source code & FastAPI endpoints
│   ├── analytics/                # Statistical forecasting & budget execution
│   ├── mlops/                    # Model drift detection (KS-test / PSI)
│   ├── dataops/                  # Schema drift validator
│   └── main.py                   # Microservice entrypoint
├── tests/                        # Automated unit, MLOps & DataOps test suites
├── infra/                        # OpenTofu IaC modules (VPC, KMS, S3, GPU cluster)
├── databricks/                   # Databricks Asset Bundle (databricks.yml)
├── Dockerfile                    # Multi-stage hardened container (non-root USER 10001)
├── pyproject.toml                # Dependencies & build definitions
└── README.md                     # Project documentation
```

---

## 2. CI/CD Integration

All security scanning (SAST, SCA, Secrets, IaC, Container), SBOM generation, Cosign signing, FinOps cost estimation, and Zero-Downtime deployment are managed centrally by the imported Golden Pipeline defined in `.github/workflows/pipeline.yml`.

To deploy:
- Push to `development` or `feature/*` $\rightarrow$ Deploys to **`dev`**
- Merge to `main` $\rightarrow$ Full scans & deploys to **`test`** (staging)
- Create tag `v*.*.*` $\rightarrow$ Builds, signs, and packages release (**no deploy**)
- Trigger `workflow_dispatch` with release tag $\rightarrow$ Promotes to **`prod`** with dual-control approval
