resource "aws_ecr_repository" "main" {
  name = "${var.name}"
}

resource "aws_ecr_repository_policy" "foopolicy" {
  repository = "${aws_ecr_repository.main.name}"
  policy = "${var.policy}"
}