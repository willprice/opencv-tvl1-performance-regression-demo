# OpenCV optical flow speed comparison

I've found OpenCV's GPU TVL1 implementation to be much slower in v4 than in v2.
This repository serves as an example demonstrating the issue.

## Set up

Ensure you have docker 19.03+ with an NVIDIA card present on your system. Build
the docker images (this handles building the base OpenCV images + the optical
flow demo application)

```console
$ make flow-images
```

Download test media and extract frames:

```console
$ ffmpeg -i "https://github.com/MarkAYoder/esc-media/raw/master/BigBuckBunny_640x360.m4v" -t 00:00:10 -qscale 2 frames/frame_%010d.jpg
```


## Run speed test

Discard the first results as they will include the time spent by the nvidia
driver generating binaries for the current GPU from the PTX files.

```console
$ time docker run \
    --gpus '"device=0"' \
    --rm -it \
    -v $PWD/frames:/input \
    -v $PWD/flow/opencv2:/output \
    -v $PWD/.cache-opencv2:/cache/nv \
    willprice/furnari-flow:opencv2 

...
0.03user 0.02system 0:14.57elapsed 0%CPU (0avgtext+0avgdata 63544maxresident)k
0inputs+0outputs (0major+7956minor)pagefaults 0swaps

$ time docker run \
    --gpus '"device=0"' \
    --rm -it \
    -v $PWD/frames:/input \
    -v $PWD/flow/opencv4:/output \
    -v $PWD/.cache-opencv4:/cache/nv \
    willprice/furnari-flow:opencv4

...
0.04user 0.02system 2:31.88elapsed 0%CPU (0avgtext+0avgdata 63404maxresident)k
0inputs+0outputs (0major+7877minor)pagefaults 0swaps
```
