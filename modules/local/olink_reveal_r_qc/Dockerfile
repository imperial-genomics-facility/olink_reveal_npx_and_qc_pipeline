FROM bioconductor/bioconductor_docker:3.21
RUN apt-get update && \
    R -e 'install.packages("IRkernel", repos="https://cloud.r-project.org/"); IRkernel::installspec();' && \
    R -e 'install.packages("OlinkAnalyze", repos="https://cloud.r-project.org/");' && \
    R -e 'install.packages("dplyr", repos="https://cloud.r-project.org/");' && \
    R -e 'install.packages("ggplot2", repos="https://cloud.r-project.org/");' && \
    R -e 'install.packages("stringr", repos="https://cloud.r-project.org/");' && \
    R -e 'install.packages("ggpubr", repos="https://cloud.r-project.org/");'
RUN python3 -m pip install --upgrade pip setuptools wheel && \
    pip3 install --no-cache-dir jupyterlab setuptools rpy2 scanpy openpyxl altair
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
RUN R -e 'IRkernel::installspec(user = FALSE)'
USER rstudio
WORKDIR /home/rstudio/work
EXPOSE 8888
