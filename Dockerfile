#   Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements.  See the NOTICE file distributed with
#   this work for additional information regarding copyright ownership.
#   The ASF licenses this file to You under the Apache License, Version 2.0
#   (the "License"); you may not use this file except in compliance with
#   the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

FROM laocoon667/jena-fuseki-docker:latest

LABEL maintainer="steffen.roertgen@gwdg.de"

# Fuseki config
ENV ASSEMBLER $FUSEKI_BASE/configuration/assembler.ttl
COPY assembler.ttl $ASSEMBLER

# load vocab from git
RUN git clone https://github.com/openeduhub/oeh-metadata-vocabs.git --branch triple-store /tmp/vocabs

# load curriculums data with wget

RUN mkdir -p /tmp/curricula \
  && wget https://raw.githubusercontent.com/sroertgen/oeh-framework-bayern/master/data/curriculum_bayern.ttl -O /tmp/curricula/curriculum_bayern.ttl

RUN cat /tmp/vocabs/*.ttl > /tmp/vocabs.ttl

RUN for f in /tmp/vocabs/*.ttl ; do FILENAME=`basename ${f%%.*}`; echo ${FILENAME}; echo ${f}; $TDB2TDBLOADER --graph=http://w3id.org/openeduhub/vocabs/${FILENAME}/# ${f}; done

RUN $TDB2TDBLOADER --graph=http://w3id.org/openeduhub/vocabs/# /tmp/vocabs.ttl

# Load curriculum data
RUN $TDB2TDBLOADER --graph=http://w3id.org/openeduhub/curricula/curriculum_bayern/# /tmp/curricula/curriculum_bayern.ttl

RUN $TEXTINDEXER \
  && $TDB2TDBSTATS --graph urn:x-arq:UnionGraph > /tmp/stats.opt \
  && mv /tmp/stats.opt /fuseki-base/databases/tdb2/

USER root

RUN rm -r /tmp/*

WORKDIR /jena-fuseki
EXPOSE 3030
USER 9008
