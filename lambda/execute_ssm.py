import boto3
import json
import time
import logging
import sys

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s", force=True)
logger = logging.getLogger()

def lambda_handler(event, context):
    ssm = boto3.client("ssm")

    # Get command and optional arguments from the event payload
    base_command = event.get("command", "uptime")
    arg1 = event.get("arg1", "")
    arg2 = event.get("arg2", "")
    instance_id = event.get("instance_id", "i-0f6051fe2fbebc7c7")

    # Construct the full command
    command_to_run = base_command
    if arg1:
        command_to_run += f" {arg1}"
    if arg2:
        command_to_run += f" {arg2}"

    logger.info(f"Executing command: {command_to_run} on instance {instance_id}")

    try:
        # Send command to EC2 instance
        response = ssm.send_command(
            InstanceIds=[instance_id],
            DocumentName="AWS-RunShellScript",
            Parameters={"commands": [command_to_run]}
        )

        command_id = response["Command"]["CommandId"]
        logger.info(f"Command sent successfully. Command ID: {command_id}")

        # Flush logs to CloudWatch immediately
        sys.stdout.flush()
        sys.stderr.flush()

        # Wait for the command to be registered (handle "InvocationDoesNotExist" error)
        time.sleep(2)

        # Retry up to 10 times (2-second intervals) for command execution
        for _ in range(10):
            try:
                output = ssm.get_command_invocation(
                    CommandId=command_id,
                    InstanceId=instance_id
                )

                if output["Status"] in ["Success", "Failed", "Cancelled", "TimedOut"]:
                    break  # Stop checking once execution completes

                logger.info(f"Waiting for command {command_id} to complete... Status: {output['Status']}")

            except ssm.exceptions.InvocationDoesNotExist:
                logger.info(f"Waiting for SSM command {command_id} to register... Retrying in 2s")

            time.sleep(2)

        # Log the command output
        logger.info(f"Final Status: {output['Status']}")
        logger.info(f"Standard Output: {output.get('StandardOutputContent', '').strip()}")
        logger.info(f"Standard Error: {output.get('StandardErrorContent', '').strip()}")

        # Force log flush again before returning
        sys.stdout.flush()
        sys.stderr.flush()

        return {
            "CommandId": command_id,
            "Status": output["Status"],
            "StandardOutput": output.get("StandardOutputContent", "").strip(),
            "StandardError": output.get("StandardErrorContent", "").strip()
        }

    except Exception as e:
        logger.error(f"Error executing command: {str(e)}")
        sys.stdout.flush()
        sys.stderr.flush()
        return {"error": str(e)}
