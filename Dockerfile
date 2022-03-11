FROM ubuntu

RUN apt-get update && \
    # Install prerequisites
    apt-get install sudo git vim -y && \
    DEBIAN_FRONTEND=noninteractive TZ=US/Arizona apt-get install tzdata -y && \
    # Install fat
    git clone https://github.com/attify/firmware-analysis-toolkit.git /root/firmware-analysis-toolkit && \
    cd /root/firmware-analysis-toolkit && \
    /root/firmware-analysis-toolkit/setup.sh
