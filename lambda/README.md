Powershell:

aws lambda invoke --function-name test-ec2 --payload '{\"command\":\"ls\", \"arg1\":\"-la\"}' response.txt --cli-binary-format raw-in-base64-out

aws lambda invoke --function-name test-ec2 --payload '{\"command\":\"ls\", \"arg1\":\"-lh\", \"arg2\":\"/home\"}' response.txt --cli-binary-format raw-in-base64-out

{
  "command": "uptime",
  "arg1": "",
  "arg2": "",
  "instance_id": "i-0f6051fe2fbebc7c7"
}




