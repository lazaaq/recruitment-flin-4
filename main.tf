provider "aws" {
  region = "ap-southeast-1"  # Singapore region
}

# 1. Create Security Group
resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress_sg"
  description = "Allow HTTP, HTTPS, and SSH"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["your-ip-address/32"]  # Only allow your IP for SSH
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Create EC2 Instance
resource "aws_instance" "wordpress" {
  ami           = "ami-0c55b159cbfafe1f0" # Ubuntu 20.04 (Change if needed)
  instance_type = "t2.micro"
  key_name      = "your-ssh-key-name"
  security_groups = [aws_security_group.wordpress_sg.name]

  tags = {
    Name = "WordPressServer"
  }
}

# 3. Create RDS Database
resource "aws_db_instance" "wordpress_db" {
  allocated_storage    = 20
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  name                 = "wordpressdb"
  username             = "admin"
  password             = "yourpassword"
  skip_final_snapshot  = true
  publicly_accessible  = false
}

# 4. Create S3 Bucket
resource "aws_s3_bucket" "wordpress_assets" {
  bucket = "flin-wordpress-assets"
  acl    = "public-read"

  website {
    index_document = "index.html"
  }
}

# 5. Create CloudFront Distribution
resource "aws_cloudfront_distribution" "wordpress_cdn" {
  origin {
    domain_name = aws_s3_bucket.wordpress_assets.bucket_regional_domain_name
    origin_id   = "S3-wordpress-assets"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-wordpress-assets"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
