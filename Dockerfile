#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

FROM grafana/grafana:5.3.2

USER root

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y python3-pip procps
RUN pip3 install j2cli

USER grafana

RUN mkdir -p /var/lib/grafana/pulsar
RUN mkdir -p /var/lib/grafana/pulsar_provisioning
RUN mkdir -p /var/lib/grafana/pulsar_provisioning/dashboards
RUN mkdir -p /var/lib/grafana/pulsar_provisioning/datasources
COPY conf/grafana.ini /etc/grafana/grafana.ini
COPY conf/provisioning/dashboards.yml /var/lib/grafana/pulsar_provisioning/dashboards/pulsar.yml
COPY conf/provisioning/datasources.yml /var/lib/grafana/pulsar_provisioning/datasources/pulsar.yml
COPY dashboards/* /var/lib/grafana/pulsar_provisioning/dashboards/
COPY entrypoint.sh /pulsar_grafana_entrypoint.sh

EXPOSE 3000

ENV PULSAR_PROMETHEUS_URL http://localhost:9090
ENV GF_PATHS_PROVISIONING /var/lib/grafana/pulsar_provisioning

ENTRYPOINT ["/pulsar_grafana_entrypoint.sh"]