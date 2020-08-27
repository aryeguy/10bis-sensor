import os

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.firefox.options import Options

import time

USERNAME = os.environ['USERNAME']
PASSWORD = os.environ['PASSWORD']
options = Options()
options.headless = True

driver = webdriver.Firefox(options=options)
driver.get("https://www.10bis.co.il/")
driver.find_element_by_css_selector("button.styled__HeaderUserLink-sc-1l9k7ll-4:nth-child(3)").click()
driver.find_element_by_css_selector("#email").send_keys(USERNAME)
driver.find_element_by_css_selector("#password").send_keys(PASSWORD)
driver.find_element_by_css_selector(".styled__LongButton-sc-10wc8na-4").click()
time.sleep(10)
driver.find_element_by_css_selector(".styled__ActionMenuButton-sc-1snjgai-0").click()
time.sleep(10)
driver.find_element_by_css_selector("div.styled__ActionMenuLinkContainer-sc-1snjgai-14:nth-child(5) > a:nth-child(1)").click()
time.sleep(10)
credit = driver.find_element_by_css_selector(".klnjjw").text
# TODO clean currency from text
print(credit)
driver.close()
