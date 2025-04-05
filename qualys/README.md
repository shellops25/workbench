# Qualys Adhoc Scan Runner

Call Qualys API with existing Qualys credentials, specify a target IP to launch standard scan

Supports ```--username foo --password xxx --target 192.168.0.1``` arguments.   Instead of CLI args, env vars can be set:

```
# Linux
$ export QUALYS_USERNAME="foo"
$ export QUALYS_PASSWORD="xxx"
$ export TARGET_IP="192.168.0.1"

# Windows
> set QUALYS_USERNAME=foo
> set QUALYS_PASSWORD=xxxx
> set TARGET_IP=192.168.0.1
```

```

# qualys_scan_report.py users requests module which requires %REQUESTS_CA_BUNDLE% to contain valid intermediate certs
# Windows
> set REQUESTS_CA_BUNDLE=C:\temp\cert.pem
# Linux - existing keystore might be included in your distro
$ echo $SSL_CERT_FILE
SSL_CERT_FILE=/etc/pki/...
#
#
# qualys_scan_report_urllib3.py uses urllib3 which supports the windows keystore
#
# example usage
> python qualys_scan_report_urllib3.py --target 192.168.0.1 --username my-q-acct
Starting Scan
Scan launched: scan/123456.1234
Waiting for scan to start
Scan status: Queued
Scan status: Queued
Scan status: Queued
Scan status: Queued
Scan status: Queued
Scan status: Running
Scan is running, notification of completion will be sent from Qualys
```