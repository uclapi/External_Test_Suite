FROM docker.io/selenium/standalone-firefox:latest

COPY requirements.txt /home/seluser/requirements.txt

RUN sudo apt-get update && sudo apt-get install cron -y

COPY oauth-cron /etc/cron.d/oauth-cron

RUN cd /home/seluser && sudo apt-get install python3-pip -y && pip3 install -r requirements.txt && chmod 0644 /etc/cron.d/oauth-cron && crontab /etc/cron.d/oauth-cron && sudo rm -rf /var/lib/apt/lists/*

COPY oauthtest.py /home/seluser/main.py

CMD /opt/bin/start-xvfb.sh & /opt/bin/start-selenium-standalone.sh & echo "CACHET_TOKEN=$CACHET_TOKEN" > /home/seluser/.env & echo "CLIENT_ID=$CLIENT_ID" >> /home/seluser/.env & echo "PASSWORD=$PASSWORD" >> /home/seluser/.env & echo "CLIENT_SECRET=$CLIENT_SECRET" >> /home/seluser/.env & echo "TOKEN=$TOKEN" >> /home/seluser/.env & sleep 5 && sudo cron -f

