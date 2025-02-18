variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
}

variable "encryption" {
  description = "Enable server-side encryption"
  type        = bool
}

variable "logging" {
  description = "Logging configuration"
  type = object({
    target_bucket = string
    target_prefix = string
  })
  default = null
}

variable "block_public_acls" {
  description = "Block public ACLs"
  type        = bool
}

variable "block_public_policy" {
  description = "Block public bucket policies"
  type        = bool
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs"
  type        = bool
}

variable "restrict_public_buckets" {
  description = "Restrict public bucket policies"
  type        = bool
}