FROM bioconductor/bioconductor_docker:3.21
LABEL version=0.3

# -------------- System deps ---------------------------------------------------
RUN apt-get update && \
    apt-get install --no-install-recommends --fix-missing -y \
        python3 python3-venv python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# --- Python venv + Jupyter FIRST (IRkernel::installspec needs jupyter on PATH) -
RUN python3 -m venv /opt/venv
ENV PATH=/opt/venv/bin:$PATH
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir jupyterlab nbconvert

# -- R packages (installed to system library, not user home) --------------------
RUN R -e '\
    pkgs <- c("OlinkAnalyze","dplyr","ggplot2","stringr","arrow", \
              "tidyverse","ggrepel","umap","pheatmap","patchwork", \
              "scales","ggpubr","IRkernel"); \
    install.packages(pkgs, repos="https://cloud.r-project.org/", \
                     lib="/usr/local/lib/R/site-library"); \
    '

# -- Register the IR kernel system-wide (jupyter is now on PATH) ----------------
RUN R -e 'IRkernel::installspec(user = FALSE, prefix = "/usr/local")'

# -- Verify the IR kernel is discoverable by Jupyter ----------------------------
RUN jupyter kernelspec list

# -- Singularity-friendly environment -------------------------------------------
#  • Singularity mounts $HOME read-only and runs as the calling user.
#  • Many tools (R, Jupyter, matplotlib…) try to write caches/configs to $HOME.
#  • We redirect everything to /tmp, which Singularity keeps writable.
ENV HOME=/tmp \
    XDG_CACHE_HOME=/tmp/.cache \
    XDG_CONFIG_HOME=/tmp/.config \
    XDG_DATA_HOME=/tmp/.local/share \
    JUPYTER_DATA_DIR=/usr/local/share/jupyter \
    JUPYTER_CONFIG_DIR=/tmp/.jupyter \
    JUPYTER_RUNTIME_DIR=/tmp/.jupyter/runtime \
    R_LIBS_USER=/tmp/R_libs \
    R_ENVIRON_USER="" \
    R_PROFILE_USER="" \
    PIP_CACHE_DIR=/tmp/.cache/pip

# -- Make sure key directories exist and are world-writable ---------------------
RUN mkdir -p /tmp/.cache /tmp/.config /tmp/.local/share \
             /tmp/.jupyter/runtime /tmp/R_libs && \
    chmod -R 777 /tmp/.cache /tmp/.config /tmp/.local /tmp/.jupyter /tmp/R_libs

# -- Don't lock to a specific user — Singularity uses the host UID --------------
# (deliberately no USER instruction here)
WORKDIR /work