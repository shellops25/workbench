import time
import requests
from requests.auth import HTTPBasicAuth
import xml.etree.ElementTree as etree
import argparse
import os 
import sys
import random


QUALYS_API_BASE = "https://qualysapi.qualys.com"
#TARGET_IP = "192.168.1.123"  # Replace with your build machine IP
SCAN_OPTION_TITLE = "MyScanOptions"
REPORT_TEMPLATE_ID = "12345"  # Replace with actual template ID
SCAN_TITLE = f"BuildScan_{int(time.time())}"
REPORT_TITLE = f"BuildReport_{int(time.time())}"

def get_args():
    parser = argparse.ArgumentParser(description="Qualys API Scan Script")
    parser.add_argument("--username", help="Qualys API username")
    parser.add_argument("--password", help="Qualys API password")
    parser.add_argument("--target_ip", help="Target IP address to scan")

    args = parseer.parse_args()

    target_ip = args.target or os.getenv("TARGET_IP"
    username = args.username or os.getenv("QUALYS_USERNAME")    
    password = args.password or os.getenv("QUALYS_PASSWORD")    

    missing = []

    if not target_ip:
        missing.append("target_ip") 
    if not username:    
        missing.append("username")
    if not password:
        missing.append("password")
    if missing:
        print(f"Missing arguments: {', '.join(missing)}")
        sys.exit(1)
    return target_ip, username, password

def launch_scan():
    online_scanner_ids = list_scanners()
    if online_scanner_ids
        random_scanner = random.choice(online_scanner_ids)
        print(f"Using scanner: {random_scanner}")
    else:
        print("No online scanners available.")
        sys.exit(1)
    
    print("Starting Scan")
    data = {
        "action": "launch",
        "scan_title": SCAN_TITLE,
        "ip": TARGET_IP,
        "option_title": SCAN_OPTION_TITLE
    }
    r = requests.post(f"{QUALYS_API_BASE}/api/2.0/fo/scan/", auth=auth, headers=headers, data=data)
    r.raise_for_status()
    
    root = ET.fromstring(r.text)
    response_elem = root.find(".//RESPONSE")
    item_list = response_elem.find("ITEM_LIST")
    scan_ref = None
    if item_list is not None:
        for item in item_list.findall('ITEM'):
            key = item.find('KEY')
            if key is not None and key.text == 'REFERENCE':
                value = item.find('VALUE')
                if value is not None:
                    scan_ref = value.text
                    break

    if scan_ref is None:
        raise ValueError("Scan reference not found in response.")
    print(f"Scan launched: {scan_ref}")
    return scan_ref

def wait_for_scan(scan_ref):
    print("Waiting for scan to finish")
    while True:
        r = requests.get(f"{QUALYS_API_BASE}/api/2.0/fo/scan/?action=list&scan_ref={scan_ref}", auth=auth, headers=headers)
        r.raise_for_status()
        status = r.text.split("<STATE>")[1].split("</STATE>")[0]
        print(f"Scan status: {status}")
        if status == "Running":
            print("Scan is running, notification of completion will be sent from Qualys")
            break
        time.sleep(30)

def list_scanners():
    print("Fetching online scanners")
    r = requests.get(f"{QUALYS_API_BASE}/api/2.0/fo/appliance/?action=list", auth=auth, headers=headers)
    r.raise_for_status()
    root = etree.fromstring(r.text)
    response_elem = root.find(".//RESPONSE")
    item_list = response_elem.find("APPLIANCE_LIST")
    online_scanner_ids = []

    if item_list is not None:
        for item in item_list.findall('APPLIANCE'):
            status = item.findtext('STATUS')
            scanner_id = item.findtext("ID")
            if status == "Online" and scanner_id is not None:
                online_scanner_ids.append(scanner_id)
    print(f"Online scanners ID: {online_scanner_ids}")
    return online_scanner_ids

    
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
    target_ip, username, password = get_args()
    auth = HTTPBasicAuth(username, password)
    headers = {"X-Requested-With: Python XMLHttpRequest"}
    scan_ref = launch_scan()
    wait_for_scan(scan_ref)
    #
    # report fetching is disabled for now
    #launch_report(scan_ref)
    #report_id = get_report_id()
    #download_report(report_id)
