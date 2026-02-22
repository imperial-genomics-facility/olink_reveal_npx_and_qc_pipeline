## Image building steps

### Build docker image

Check main README.md for build instructions.

## Usage

### How to use this image for running Jupyter lab instance?

* Run Jupyter lab instance using this example code.
<code><pre>docker run 
  -p 8888:8888 
  -v /YOUR_DATA_DIR:/data 
  igf_olink_r_qc:vX.Y 
  bash -c "cd /data;jupyter lab --no-browser --ip=0.0.0.0 --ServerApp.token=YOUR_TOKEN"</pre></code>
* Open any browser and go to `localhost:8888`

### How to use this image using RStudio

* Run RStudio using this example command
<code><pre>docker run 
 	-e PASSWORD=bioc 
 	-p 8787:8787 
 	igf_olink_r_qc:vX.Y</pre></code>
* Open any browser and go to `localhost:8787`
