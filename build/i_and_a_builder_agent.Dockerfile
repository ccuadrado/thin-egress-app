FROM ubuntu

RUN apt-get update && \
    apt-get -y install curl python3 python3-pip git vim tree zip jq && \
    pip3 install -U pip && \
    pip3 install awscli boto3 requests pytest

RUN apt-get clean && apt-get install -y apt-transport-https gnupg2 && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl

# Rebuild instructions:
#   apptag="i_and_a_builder_agent"
#   docker build -f i_and_a_builder_agent.Dockerfile -t "$apptag" .
#   registry="docker-registry.asf.alaska.edu:5000"
#   appjustbuilt=$(docker images -q "$apptag")
#   docker tag ${appjustbuilt} ${registry}/${apptag}
#   docker push ${registry}/${apptag}

CMD ["tail", "-f", "/dev/null"]

