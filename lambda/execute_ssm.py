import boto3
import json
import time
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

def lambda_handler(event, context):
    ssm = boto3.client("ssm")

    # Get command and optional arguments from the event payload
    base_command = event.get("command", "uptime")  # Default command: "uptime"
    arg1 = event.get("arg1", "")  # Default empty if not provided
    arg2 = event.get("arg2", "")  # Default empty if not provided

    # Construct the full command
    command_to_run = base_command
    if arg1:
        command_to_run += f" {arg1}"
    if arg2:
        command_to_run += f" {arg2}"

    instance_id = "i-0f6051fe2fbebc7c7"  # Replace with your EC2 Instance ID

    logger.info(f"Executing command: {command_to_run} on instance {instance_id}")

    try:
        # Send command to EC2 instance
        response = ssm.send_command(
            InstanceIds=[instance_id],
            DocumentName="AWS-RunShellScript",
            Parameters={"commands": [command_to_run]}  # Ensures the command is properly formatted
        )

        command_id = response["Command"]["CommandId"]
        logger.info(f"Command sent successfully. Command ID: {command_id}")

        # Wait for command to be registered (handle "InvocationDoesNotExist" error)
        time.sleep(2)  # Initial short wait before first check

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

            time.sleep(2)  # Wait before retrying

        # Return command output
        return {
            "CommandId": command_id,
            "Status": output["Status"],
            "StandardOutput": output.get("StandardOutputContent", "").strip(),
            "StandardError": output.get("StandardErrorContent", "").strip()
        }

    except Exception as e:
        logger.error(f"Error executing command: {str(e)}")
        return {
            "error": str(e)
        }
