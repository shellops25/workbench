import time
import requests
from requests.auth import HTTPBasicAuth
import smtplib
from email.message import EmailMessage
import mimetypes
import os
import json

QUALYS_API_BASE = "https://qualysapi.qualys.com"
QUALYS_USERNAME = "your_username"
QUALYS_PASSWORD = "your_password"
TARGET_IP = "192.168.1.123"  # Replace with your build machine IP
SCAN_OPTION_TITLE = "MyScanOptions"
REPORT_TEMPLATE_ID = "12345"  # Replace with actual template ID
SCAN_TITLE = f"BuildScan_{int(time.time())}"
REPORT_TITLE = f"BuildReport_{int(time.time())}"
REPORT_PATH = "qualys_build_report.pdf"

SMTP_SERVER = "smtp.example.com"
SMTP_PORT = 465
SENDER_EMAIL = "sender@example.com"
SENDER_PASSWORD = "yourpassword"
RECIPIENT_EMAIL = "recipient@example.com"

# Teams webhook
# https://learn.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook?tabs=newteams%2Cdotnet
TEAMS_WEBHOOK_URL = "https://outlook.office.com/webhook/..."


auth = HTTPBasicAuth(QUALYS_USERNAME, QUALYS_PASSWORD)
headers = {"X-Requested-With": "Python"}


def launch_scan():
    print("Launching scan...")
    data = {
        "action": "launch",
        "scan_title": SCAN_TITLE,
        "ip": TARGET_IP,
        "option_title": SCAN_OPTION_TITLE
    }
    r = requests.post(f"{QUALYS_API_BASE}/api/2.0/fo/scan/", auth=auth, headers=headers, data=data)
    r.raise_for_status()
    scan_ref = r.text.split("<REFERENCE>")[1].split("</REFERENCE>")[0]
    print(f"Scan launched: {scan_ref}")
    return scan_ref


def wait_for_scan(scan_ref):
    print("Waiting for scan to finish...")
    while True:
        r = requests.get(f"{QUALYS_API_BASE}/api/2.0/fo/scan/?action=list&scan_ref={scan_ref}", auth=auth, headers=headers)
        r.raise_for_status()
        status = r.text.split("<STATUS>")[1].split("</STATUS>")[0]
        print(f"Scan status: {status}")
        if status == "Finished":
            break
        time.sleep(30)


def launch_report(scan_ref):
    print("Launching report...")
    data = {
        "action": "launch",
        "report_type": "Scan",
        "report_title": REPORT_TITLE,
        "output_format": "pdf",
        "template_id": REPORT_TEMPLATE_ID,
        "scan_ref": scan_ref
    }
    r = requests.post(f"{QUALYS_API_BASE}/api/2.0/fo/report/", auth=auth, headers=headers, data=data)
    r.raise_for_status()
    print("Report launched.")


def get_report_id():
    print("Waiting for report generation...")
    report_id = None
    while not report_id:
        r = requests.get(f"{QUALYS_API_BASE}/api/2.0/fo/report/?action=list&report_title={REPORT_TITLE}", auth=auth, headers=headers)
        r.raise_for_status()
        if "<ID>" in r.text and "<STATUS>Finished</STATUS>" in r.text:
            report_id = r.text.split("<ID>")[1].split("</ID>")[0]
        else:
            print("Report not ready yet...")
            time.sleep(30)
    print(f"Report ready: ID {report_id}")
    return report_id


def download_report(report_id, save_path):
    print("Downloading report...")
    r = requests.get(f"{QUALYS_API_BASE}/api/2.0/fo/report/?action=fetch&id={report_id}", auth=auth, headers=headers)
    r.raise_for_status()
    with open(save_path, "wb") as f:
        f.write(r.content)
    print(f"Report downloaded: {save_path}")


def send_email_with_report(smtp_server, smtp_port, sender_email, sender_password, recipient_email, report_path):
    print("Sending report via email...")
    msg = EmailMessage()
    msg['Subject'] = 'Qualys Build Report'
    msg['From'] = sender_email
    msg['To'] = recipient_email
    msg.set_content("Attached is the latest Qualys scan report for your build.")

    with open(report_path, 'rb') as f:
        file_data = f.read()
        maintype, subtype = mimetypes.guess_type(report_path)[0].split('/')
        msg.add_attachment(file_data, maintype=maintype, subtype=subtype, filename=os.path.basename(report_path))

    with smtplib.SMTP_SSL(smtp_server, smtp_port) as smtp:
        smtp.login(sender_email, sender_password)
        smtp.send_message(msg)
    print("Email sent successfully.")


def send_teams_notification(webhook_url, report_path):
    print("Sending notification to Microsoft Teams...")
    report_name = os.path.basename(report_path)
    with open(report_path, "rb") as file:
        file_size_kb = round(len(file.read()) / 1024, 2)

    message = {
        "@type": "MessageCard",
        "@context": "http://schema.org/extensions",
        "summary": "Qualys Build Report",
        "themeColor": "0076D7",
        "title": "✅ Qualys Scan Completed",
        "text": f"Scan complete. A PDF report (`{report_name}`, {file_size_kb} KB) has been generated and emailed.",
        "sections": [],
        "potentialAction": []
    }

    r = requests.post(webhook_url, data=json.dumps(message), headers={"Content-Type": "application/json"})
    r.raise_for_status()
    print("Teams notification sent.")


if __name__ == "__main__":
    scan_ref = launch_scan()
    wait_for_scan(scan_ref)
    launch_report(scan_ref)
    report_id = get_report_id()
    download_report(report_id, REPORT_PATH)

    send_email_with_report(
        smtp_server=SMTP_SERVER,
        smtp_port=SMTP_PORT,
        sender_email=SENDER_EMAIL,
        sender_password=SENDER_PASSWORD,
        recipient_email=RECIPIENT_EMAIL,
        report_path=REPORT_PATH
    )

    send_teams_notification(
        webhook_url=TEAMS_WEBHOOK_URL,
        report_path=REPORT_PATH
    )
