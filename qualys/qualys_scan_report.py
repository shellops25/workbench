import time
import requests
from requests.auth import HTTPBasicAuth

QUALYS_API_BASE = "https://qualysapi.qualys.com"
QUALYS_USERNAME = "your_username"
QUALYS_PASSWORD = "your_password"
TARGET_IP = "192.168.1.123"  # Replace with your build machine IP
SCAN_OPTION_TITLE = "MyScanOptions"
REPORT_TEMPLATE_ID = "12345"  # Replace with actual template ID
SCAN_TITLE = f"BuildScan_{int(time.time())}"
REPORT_TITLE = f"BuildReport_{int(time.time())}"

auth = HTTPBasicAuth(QUALYS_USERNAME, QUALYS_PASSWORD)
headers = {"X-Requested-With": "Python"}

def launch_scan():
    print("Starting Scan")
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
    print("Waiting for scan to finish")
    while True:
        r = requests.get(f"{QUALYS_API_BASE}/api/2.0/fo/scan/?action=list&scan_ref={scan_ref}", auth=auth, headers=headers)
        r.raise_for_status()
        status = r.text.split("<STATUS>")[1].split("</STATUS>")[0]
        print(f"Scan status: {status}")
        if status == "Finished":
            break
        time.sleep(30)

def launch_report(scan_ref):
    print("Fetching report")
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
    print("Waiting for report generation")
    report_id = None
    while not report_id:
        r = requests.get(f"{QUALYS_API_BASE}/api/2.0/fo/report/?action=list&report_title={REPORT_TITLE}", auth=auth, headers=headers)
        r.raise_for_status()
        if "<ID>" in r.text and "<STATUS>Finished</STATUS>" in r.text:
            report_id = r.text.split("<ID>")[1].split("</ID>")[0]
        else:
            print("Report not ready yet")
            time.sleep(30)
    print(f"Report ready: ID {report_id}")
    return report_id

def download_report(report_id):
    print("Downloading report")
    r = requests.get(f"{QUALYS_API_BASE}/api/2.0/fo/report/?action=fetch&id={report_id}", auth=auth, headers=headers)
    r.raise_for_status()
    with open("qualys_build_report.pdf", "wb") as f:
        f.write(r.content)
    print("Report downloaded: qualys_build_report.pdf")

if __name__ == "__main__":
    scan_ref = launch_scan()
    wait_for_scan(scan_ref)
    launch_report(scan_ref)
    report_id = get_report_id()
    download_report(report_id)
