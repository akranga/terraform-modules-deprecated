data "aws_caller_identity" "current" { }

data "template_file" "cli_input" {
  template = "${file("${path.module}/cli-input.json")}"

  vars {
    name        = "${var.name}"
    order       = "${var.order}"
    priority    = "${var.priority}"
    compute_env = "${var.compute_env}"
  }
}

resource "null_resource" "batch" {
  triggers {
    cli_input_json = "${data.template_file.cli_input.rendered}"
  }

  provisioner "local-exec" {
    command = <<THEEND

for i in $(seq 1 60); do
  _status=$(aws batch describe-compute-environments \
    --region "${var.region}" \
    --compute-environments "${var.compute_env}" \
    | jq -r '.computeEnvironments[].status')
  echo "Waiting for compute environment "${var.compute_env}": $_status"
  test "$_status" = "VALID" && break
  sleep 10
done

mkdir -p ${path.cwd}/.terraform/${var.name}-aws_batch_queue
cat <<EOF > ${path.cwd}/.terraform/${var.name}-aws_batch_queue/cli-input.json
${data.template_file.cli_input.rendered}
EOF

_status=$(aws batch describe-job-queues \
    --region ${var.region} \
    --job-queues="${var.name}" \
    | jq -r '.jobQueues[].status')

if [ -z "$_status" ]; then
  aws batch create-job-queue \
    --region ${var.region} \
    --cli-input-json file://${path.cwd}/.terraform/${var.name}-aws_batch_queue/cli-input.json
else
  aws batch update-job-queue \
    --region ${var.region} \
    --cli-input-json file://${path.cwd}/.terraform/${var.name}-aws_batch_queue/cli-input.json
fi

for i in $(seq 1 60); do
  _status=$(aws batch describe-job-queues \
    --region ${var.region} \
    --job-queues="${var.name}" \
    | jq -r '.jobQueues[].status')
  echo "Waiting for queue "${var.name}": $_status"
  test "$_status" = "VALID" && break
  sleep 10
done

THEEND
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "fail"
    command    = <<THEEND

aws batch update-job-queue \
  --region ${var.region} \
  --job-queue ${var.name} \
  --state DISABLED || true

sleep 10

aws batch delete-job-queue \
  --region ${var.region} \
  --job-queue ${var.name} || true

sleep 10

for i in $(seq 1 60); do
  _status=$(aws batch describe-job-queues \
    --region ${var.region} \
    --job-queues="${var.name}" \
    | jq -r '.jobQueues[].status')
  echo "Waiting for "${var.name}": $_status"
  test -z "$_status" && break
  if test "$_status" = "INVALID"; then
    echo "Something went wrong with ${var.name} deletion"
    exit 1
  fi
  sleep 10
done

THEEND
  }
}
