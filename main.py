"""
Extract current 10bis balance
"""
import os
import time

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.firefox.options import Options

# from selenium.webdriver.chrome.options import Options

from prometheus_client import Gauge, CollectorRegistry, push_to_gateway
from money_parser import price_str
from loguru import logger
from retrying import retry


USERNAME = os.environ["USERNAME"]
PASSWORD = os.environ["PASSWORD"]
PROMETHEUS_GATEWAY_ENDPOINT = os.environ.get("PROMETHEUS_GATEWAY_ENDPOINT", None)
PROMETHEUS_JOB_NAME = os.environ.get("PROMETHEUS_JOB_NAME", None)


@retry
def main():
    if PROMETHEUS_GATEWAY_ENDPOINT is not None and PROMETHEUS_JOB_NAME is not None:
        prometheus_registry = CollectorRegistry()
    else:
        prometheus_registry = None

    options = Options()
    options.headless = True
    # chrome_options = Options()
    # chrome_options.add_argument("--headless")

    driver = webdriver.Firefox(options=options)
    # driver = webdriver.Chrome(options=options, chrome_options=chrome_options)
    driver.get("https://www.10bis.co.il/")
    driver.find_element_by_css_selector(
        "button.styled__HeaderUserLink-sc-1l9k7ll-4:nth-child(3)"
    ).click()
    driver.find_element_by_css_selector("#email").send_keys(USERNAME)
    driver.find_element_by_css_selector("#password").send_keys(PASSWORD)
    driver.find_element_by_css_selector(".styled__LongButton-sc-10wc8na-4").click()
    time.sleep(10)
    driver.find_element_by_css_selector(
        ".styled__ActionMenuButton-sc-1snjgai-0"
    ).click()
    time.sleep(10)
    driver.find_element_by_css_selector(
        "div.styled__ActionMenuLinkContainer-sc-1snjgai-14:nth-child(5) > a:nth-child(1)"
    ).click()
    time.sleep(10)
    credit = driver.find_element_by_css_selector(".klnjjw").text
    credit_amount = price_str(credit)
    logger.info(f"Credit amount {credit_amount}")
    credit_gauge = Gauge(
        "tenbis_credit_total",
        "Current Credit left on 10bis",
        registry=prometheus_registry,
    )
    credit_gauge.set(credit_amount)
    print(credit_amount)
    if prometheus_registry is not None:
        push_to_gateway(
            PROMETHEUS_GATEWAY_ENDPOINT,
            job=PROMETHEUS_JOB_NAME,
            registry=prometheus_registry,
        )
        logger.info("Pushed to gateway")
    driver.close()


if __name__ == "__main__":
    main()
