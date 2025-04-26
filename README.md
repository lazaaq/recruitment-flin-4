# FLIN WordPress AWS Hosting Infrastructure

## Overview
This project outlines a scalable WordPress hosting setup using AWS services:
- **EC2** for hosting the WordPress server.
- **RDS** (MySQL) for WordPress database backend.
- **S3** for storing static assets like images and theme files.
- **CloudFront** for speeding up content delivery through caching and CDN.

---

## Benefits
- **Scalability**: EC2 instances can be auto-scaled based on traffic.
- **Reliability**: RDS handles backups, replication, and recovery automatically.
- **Performance**: CloudFront + S3 reduces latency and speeds up content delivery globally.
- **Cost-Optimization**: Use smaller instances and serverless storage for efficiency.

---

## Architecture Diagram
![diagram](https://github.com/user-attachments/assets/78c493f6-3d4e-4604-81f3-68048c5d2429)
