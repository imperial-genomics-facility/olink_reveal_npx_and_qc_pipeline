FROM bioconductor/bioconductor_docker:3.21
RUN apt-get update && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
RUN R -e 'install.packages("OlinkAnalyze", repos="https://cloud.r-project.org/");' && \
    R -e 'install.packages("dplyr", repos="https://cloud.r-project.org/");' && \
    R -e 'install.packages("ggplot2", repos="https://cloud.r-project.org/");' && \
    R -e 'install.packages("stringr", repos="https://cloud.r-project.org/");' && \
    R -e 'install.packages("arrow", repos="https://cloud.r-project.org/");' && \
    R -e 'install.packages("tidyverse", repos="https://cloud.r-project.org/");' && \
    R -e 'install.packages("ggrepel", repos="https://cloud.r-project.org/");' && \
    R -e 'install.packages("umap", repos="https://cloud.r-project.org/");' && \
    R -e 'install.packages("pheatmap", repos="https://cloud.r-project.org/");' && \
    R -e 'install.packages("patchwork", repos="https://cloud.r-project.org/");' && \
    R -e 'install.packages("scales", repos="https://cloud.r-project.org/");' && \
    R -e 'install.packages("ggpubr", repos="https://cloud.r-project.org/");'
RUN apt-get install --no-install-recommends --fix-missing -y python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
ENV USERNAME=rstudio
RUN python3 -m venv /venv
ENV PATH=/venv/bin:$PATH
RUN python3 -m pip install --upgrade pip && \
    pip3 install --no-cache-dir jupyterlab
RUN R -e 'install.packages("IRkernel", repos="https://cloud.r-project.org/"); IRkernel::installspec();' && \
    R -e 'IRkernel::installspec(user = FALSE)'
USER rstudio
WORKDIR /home/rstudio/work
EXPOSE 8888
