#! /usr/bin/env python
import os,sys,logging
log = logging.getLogger("test_upload")
try:
    import requests 
except ImportError:
    os.system("pip install --user requests")
    import requests
from requests.packages import urllib3
urllib3.disable_warnings()

def main():
    logging.basicConfig(level=logging.INFO)
    host,filename = sys.argv[1:3]
    log.info("Logging into %s", host)
    data = {
        'txtUserId': 'factory',
        'txtPassword':'d2ece905ba9be022df1bf42d1f9a38d303fac300',
        'btnLogin': 'Login',
    }
    response = requests.post( 
        'https://%(host)s/hydra/view/login?redirect=/hydra/view/system'%locals(),
        data=data,
        verify=False, 
        allow_redirects=False, 
    )
    if response.ok:
        log.info("Uploading firmware %s", filename)
        data = {
            'submit':'Upload',
        }
        files = {
            'update_file': open(filename,'rb'),
        }
        response = requests.post(
            'https://%(host)s/hydra/control/system_control'%locals(),
            cookies=response.cookies, 
            data=data,
            files=files, 
            verify=False, 
        )
        if not response.ok:
            log.error("Not-okay response from upload: %s", response.status_code)
            return 1
        else:
            log.info("Completed upload")
            content = response.content
            print content
            for line in content.splitlines():
                if 'action_status' in line:
                    print line
            return 0
    else:
        log.error("Not-okay response from login")
        return 1

if __name__ == "__main__":
    sys.exit(main())
