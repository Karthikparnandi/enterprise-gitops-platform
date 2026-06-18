# Enterprise DevSecOps & GitOps Infrastructure Platform

![CI Workflow Status](https://github.com/Karthikparnandi/enterprise-gitops-platform/actions/workflows/ci.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Enabled-blue?logo=docker)](https://www.docker.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-Declarative-blue?logo=kubernetes)](https://kubernetes.io/)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-purple?logo=terraform)](https://www.terraform.io/)

A production-ready, highly available GitOps microservices ecosystem featuring infrastructure automation, integrated container security gates, and self-healing orchestration blueprints. This repository acts as the single source of truth for both application code and multi-tier cloud infrastructure dependencies.

---

## 🗺️ System Architecture

```mermaid
graph TD
    subgraph Client Space
        User([Internet User]) -->|Port 8080| FE
    end

    subgraph AWS Cloud Infrastructure [VPC: 10.0.0.0/16]
        subgraph Public Subnet [10.0.1.0/24]
            subgraph Target EC2 Node [t2.micro]
                subgraph Docker Isolated Network
                    FE[Frontend Container: Nginx] -->|Internal Routing| BE[Backend API Container: Flask]
                    BE -->|Internal Routing| DB[(Database Container: PostgreSQL 16)]
                end
            end
        end
        
        subgraph Security Firewall [Ingress Rules]
            SG22[Port 22: Admin SSH]
            SG8080[Port 8080: Web UI]
            SG5000[Port 5000: API Node]
        end
    end

    User --> SG8080
    Admin([DevOps Admin]) --> SG22