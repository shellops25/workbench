import time
import urllib3
import urllib3.util import make_headers
import xml.etree.ElementTree as etree
import argparse
import os 
import sys
import random


QUALYS_API_BASE = "https://qualysapi.qualys.com"
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
    http = urllib3.PoolManager()
    response = http.request("POST", f"{QUALYS_API_BASE}/api/2.0/fo/scan/", fields=data, headers=headers)
    if response.status >= 400:
        raise HTTPError(f"Error launching scan: {response.status} {response.data}")
    root = ET.fromstring(resposne.data.decode('utf-8'))
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
        http = urllib3.PoolManager()
        response = http.request("GET", f"{QUALYS_API_BASE}/api/2.0/fo/scan/?action=list&scan_ref={scan_ref}", headers=headers)
        if response.status >= 400:
            raise HTTPError(f"Error fetching scan status: {response.status} {response.data}")
        status = response.data.decode('uft-8').split("<STATE>")[1].split("</STATE>")[0]
        print(f"Scan status: {status}")
        if status == "Running":
            print("Scan is running, notification of completion will be sent from Qualys")
            break
        time.sleep(30)

def list_scanners():
    print("Fetching online scanners")
    http = urllib3.PoolManager()
    response = http.request("GET", f"{QUALYS_API_BASE}/api/2.0/fo/appliance/?action=list", headers=headers)
    if response.status >= 400:
        raise HTTPError(f"Error fetching scanners: {response.status} {response.data}")
    root = ET.fromstring(response.data.decode('utf-8'))
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
