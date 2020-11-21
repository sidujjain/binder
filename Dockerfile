FROM jupyter/scipy-notebook:45bfe5a474fa

# Install remaining required packages
RUN pip install --no-cache jovian==0.2.24 && \
    pip install --no-cache jupyteranalytics && \
    pip install --no-cache torch==1.7.0+cpu torchvision==0.8.1+cpu torchaudio==0.7.0 -f https://download.pytorch.org/whl/torch_stable.html

RUN jupyter serverextension enable --py jupyteranalytics --sys-prefix

# Create user with a home directory
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

WORKDIR ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}

# Install packages from requirements.txt, if present
RUN if [ -f "requirements.txt" ] ; \
  then pip install --no-cache -r requirements.txt; \
  fi

RUN rm Dockerfile
USER ${NB_USER}