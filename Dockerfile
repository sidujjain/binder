FROM jupyter/scipy-notebook:hub-1.4.2

# Install remaining required packages
RUN pip install torch==1.13.0 torchvision==0.14.0 torchaudio==0.13.0 --extra-index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache jupyteranalytics
RUN pip install --no-cache ipython-sql==0.4.0
RUN pip install --no-cache jovian==0.2.41
RUN pip install --no-cache jupyter_contrib_nbextensions
RUN jupyter serverextension enable --py jupyteranalytics --sys-prefix
RUN jupyter contrib nbextension install --sys-prefix
RUN jupyter nbextension enable codefolding/main
RUN jupyter nbextension enable collapsible_headings/main
RUN jupyter nbextension enable spellchecker/main

RUN pip install jupyter-console jupyter-vscode-proxy

USER root

RUN apt-get update && apt-get install -y g++ libzmq3-dev nodejs npm curl
RUN npm install -g --unsafe-perm ijavascript
RUN ijsinstall --install=global
RUN jupyter console --kernel javascript
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create user with a home directory
ARG NB_USER=jovyan
ARG NB_USER_GROUP=users
ARG NB_UID=1000

ENV USER ${NB_USER}
ENV NB_USER ${NB_USER}
ENV NB_USER_GROUP ${NB_USER_GROUP}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

WORKDIR ${HOME}/work
RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}

RUN pip install nbgitpuller

COPY --chown=${NB_USER}:${NB_USER_GROUP} images/binder/settings.json ${HOME}/.local/share/code-server/User/
COPY --chown=${NB_USER}:${NB_USER_GROUP} images/binder/jupyter_notebook_config.py ${HOME}/.jupyter/

RUN code-server --install-extension ms-python.python
RUN code-server --install-extension ms-toolsai.jupyter
RUN code-server --install-extension jovian.jobot

ENV GOOGLE_ANALYTICS_TRACKING_ID=UA-118636311-5
RUN pip install jovian==0.2.47
