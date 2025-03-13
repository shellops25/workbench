import boto3
import json
import time
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

def lambda_handler(event, context):
    ssm = boto3.client("ssm")

    # Get the command from the event payload, default to "uptime"
    command_to_run = event.get("command", "uptime")
    instance_id = "i-0f6051fe2fbebc7c7"  # Replace with your EC2 Instance ID

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

        # Wait for the command to be registered (handle "InvocationDoesNotExist" error)
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
