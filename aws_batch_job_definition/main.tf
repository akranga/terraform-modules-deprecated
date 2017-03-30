data "aws_caller_identity" "current" { }

data "template_file" "cli_input" {
  template = "${file("${path.module}/cli-input.json")}"

  vars {
    name         = "${var.name}"
    vcpus        = "${var.vcpus}"
    memory       = "${var.memory}"
    role_arn     = "${var.role_arn}"
    command      = "${jsonencode(compact(split(" ", "${var.command}")))}"
    parameters   = "${jsonencode("${var.parameters}")}"
    docker_image = "${var.docker_image}"
  }
}


resource "null_resource" "batch" {
  triggers {
    cli_input_json = "${data.template_file.cli_input.rendered}"
  }

  provisioner "local-exec" {
    command = <<THEEND

mkdir -p ${path.cwd}/.terraform/${var.name}-aws_batch_job_definition

cat <<EOF > ${path.cwd}/.terraform/${var.name}-aws_batch_job_definition/cli-input-part1.json
${data.template_file.cli_input.rendered}
EOF

cat <<EOF | jq  -c -M '. | to_entries | {containerProperties: {environment: [. [] | {name: .key, value: .value}]}}' > ${path.cwd}/.terraform/${var.name}-aws_batch_job_definition/cli-input-part2.json
${jsonencode("${var.environment}")}
EOF

jq -c -M -s '.[0] * .[1]' \
  ${path.cwd}/.terraform/${var.name}-aws_batch_job_definition/cli-input-part1.json \
  ${path.cwd}/.terraform/${var.name}-aws_batch_job_definition/cli-input-part2.json \
  > ${path.cwd}/.terraform/${var.name}-aws_batch_job_definition/cli-input.json

echo "Create starting creation of job definition with:"
cat ${path.cwd}/.terraform/${var.name}-aws_batch_job_definition/cli-input.json

aws batch register-job-definition \
  --region us-east-1 \
  --cli-input-json file://${path.cwd}/.terraform/${var.name}-aws_batch_job_definition/cli-input.json \
    > ${path.cwd}/.terraform/${var.name}-aws_batch_job_definition/response.json

echo "Job definition creation response:"
cat ${path.cwd}/.terraform/${var.name}-aws_batch_job_definition/response.json

jq -M -r '.jobDefinitionArn' > ${path.cwd}/.terraform/${var.name}-aws_batch_job_definition/arn.txt

sleep 10

THEEND
  }


  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "fail"
    command    = <<THEEND

revisions=$(aws batch describe-job-definitions \
  --region ${var.region} \
  --job-definition-name ${var.name} \
  --status ACTIVE \
  | jq -r '.jobDefinitions[] | .revision')
for rev in $revisions; do
  echo "deregistering job definition: $rev"
  aws batch deregister-job-definition \
    --region ${var.region} \
    --job-definition ${var.name}:$rev || true
done

rm -rf ${path.cwd}/.terraform/${var.name}-aws_batch_job_definition

sleep 10

THEEND
  }
}
