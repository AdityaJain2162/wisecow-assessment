import http.client
import time
from urllib.parse import urlparse
import logging

# Configure logging
logging.basicConfig(filename='application_status.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')

def check_application_status(url, check_interval=60):
    parsed_url = urlparse(url)
    host = parsed_url.netloc
    path = parsed_url.path or "/"

    while True:
        try:
            conn = http.client.HTTPSConnection(host)
            conn.request("GET", path)
            response = conn.getresponse()
            status_code = response.status

            if status_code == 200:
                logging.info(f"The application at {url} is UP. Status code: {status_code}")
            else:
                logging.warning(f"The application at {url} is DOWN. Status code: {status_code}")

        except Exception as e:
            logging.error(f"The application at {url} is DOWN. An error occurred: {e}")

        time.sleep(check_interval)

if __name__ == "__main__":
    url = "https://www.google.co.in/"
    check_interval = 3
    check_application_status(url, check_interval)
