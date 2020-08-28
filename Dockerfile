FROM python:3.8.5-buster

# Chrome browser to run the tests
#RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub -o /tmp/google.pub \
    #&& cat /tmp/google.pub | apt-key add -; rm /tmp/google.pub \
    #&& echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google.list \
    #&& mkdir -p /usr/share/desktop-directories \
    #&& apt-get -y update && apt-get install -y google-chrome-stable
# Disable the SUID sandbox so that chrome can launch without being in a privileged container
#RUN dpkg-divert --add --rename --divert /opt/google/chrome/google-chrome.real /opt/google/chrome/google-chrome \
    #&& echo "#!/bin/bash\nexec /opt/google/chrome/google-chrome.real --no-sandbox --disable-setuid-sandbox \"\$@\"" > /opt/google/chrome/google-chrome \
    #&& chmod 755 /opt/google/chrome/google-chrome


# Install dependencies
#RUN apt-get update && apt-get install -y --no-install-recommends \
  #fontconfig fontconfig-config fonts-dejavu-core gconf-service gconf-service-backend gconf2-common \
  #libasn1-8-heimdal libasound2 libasound2-data libatk1.0-0 libatk1.0-data libavahi-client3 libavahi-common-data \
  #libavahi-common3 libcairo2 libcups2 libdatrie1 libdbus-1-3 libdbus-glib-1-2 libexpat1 libfontconfig1 \
  #libfreetype6 libgconf-2-4 libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-common libgmp10 libgnome-keyring-common \
  #libgnome-keyring0 libgraphite2-3 libgssapi-krb5-2 libgssapi3-heimdal libgtk2.0-0 \
  #libgtk2.0-common libharfbuzz0b libhcrypto4-heimdal libheimbase1-heimdal libheimntlm0-heimdal  \
  #libhx509-5-heimdal libjbig0 libjpeg-turbo8 libjpeg8 libk5crypto3 libkeyutils1 \
  #libkrb5-26-heimdal libkrb5-3 libkrb5support0 libldap-2.4-2 libnspr4 libnss3 \
  #libp11-kit0 libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libpixman-1-0 libroken18-heimdal \
  #libsasl2-2 libsasl2-modules-db libsqlite3-0 libtasn1-6 libthai-data libthai0 libtiff5 libwind0-heimdal libx11-6 \
  #libx11-data libxau6 libxcb-render0 libxcb-shm0 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxdmcp6 \
  #libxext6 libxfixes3 libxi6 libxinerama1 libxml2 libxrandr2 libxrender1 libxss1 libxtst6 shared-mime-info ucf \
  #x11-common xdg-utils

RUN apt update && apt-get install chromium-browser -y
 
# Chrome Driver
RUN mkdir -p /opt/selenium \
    && curl http://chromedriver.storage.googleapis.com/2.45/chromedriver_linux64.zip -o /opt/selenium/chromedriver_linux64.zip \
    && cd /opt/selenium; unzip /opt/selenium/chromedriver_linux64.zip; rm -rf chromedriver_linux64.zip; ln -fs /opt/selenium/chromedriver /usr/local/bin/chromedriver;

RUN pip3 install poetry
ADD poetry.lock .
ADD pyproject.toml .
ADD main.py .

RUN poetry config virtualenvs.create false
RUN poetry install
CMD python main.py
# TODO poetry
# TODO

