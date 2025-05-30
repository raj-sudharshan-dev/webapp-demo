variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-west-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "webapp-demo"
}

variable "estimated_cpu" {
  description = "CPU units for ECS task (256, 512, 1024, 2048, 4096)"
  type        = string
  default     = "512"
  
  validation {
    condition     = contains(["256", "512", "1024", "2048", "4096"], var.estimated_cpu)
    error_message = "CPU must be one of: 256, 512, 1024, 2048, 4096."
  }
}

variable "estimated_memory" {
  description = "Memory for ECS task in MB"
  type        = string
  default     = "1024"
  
  validation {
    condition = can(tonumber(var.estimated_memory)) && tonumber(var.estimated_memory) >= 512
    error_message = "Memory must be a number >= 512."
  }
}

variable "desired_capacity" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
  
  validation {
    condition     = var.desired_capacity >= 1 && var.desired_capacity <= 10
    error_message = "Desired capacity must be between 1 and 10."
  }
}

variable "health_check_path" {
  description = "Health check endpoint path"
  type        = string
  default     = "/health"
}

variable "port" {
  description = "Application port"
  type        = number
  default     = 3000
  
  validation {
    condition     = var.port > 0 && var.port < 65536
    error_message = "Port must be between 1 and 65535."
  }
}