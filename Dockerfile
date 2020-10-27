FROM gcr.io/kaggle-images/python:v60

# install the notebook and nbgitpuller packages
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook && \
    pip install --no-cache nbgitpuller

RUN jupyter serverextension enable --py nbgitpuller --sys-prefix

# create user with a home directory
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

WORKDIR ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}

RUN if [ -f "requirements.txt" ] ; \
  then pip install --no-cache -r requirements.txt; \
  fi

USER ${NB_USER}
