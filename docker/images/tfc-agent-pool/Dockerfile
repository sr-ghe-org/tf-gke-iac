FROM hashicorp/tfc-agent:1.15
RUN mkdir -p /home/tfc-agent/.tfc-agent
ADD --chown=tfc-agent:tfc-agent hooks /home/tfc-agent/.tfc-agent/hooks
RUN chmod -R 755 /home/tfc-agent/.tfc-agent/hooks
USER root
RUN apt-get update -y && apt-get install sudo
RUN sudo apt-get update -y && sudo apt-get install apt-transport-https ca-certificates gnupg curl -y
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && sudo apt-get update -y && sudo apt-get install google-cloud-sdk -y
RUN sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin kubectl -y
USER tfc-agent
