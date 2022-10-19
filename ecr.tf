resource "aws_ecr_repository" "main" {
  name                 = var.repo_name
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 10 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}

#============ image build ==================
resource "null_resource" "deploy_image" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "bash deploy_image.sh;"
  }

  depends_on = [aws_ecr_repository.main]
}
