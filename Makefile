all: flow-images

flow-images: flow-opencv2 flow-opencv4

.PHONY: flow-opencv2
flow-opencv2: opencv2-image
	$(MAKE) -C opencv2/src build

.PHONY: flow-opencv4
flow-opencv4: opencv4-image
	$(MAKE) -C opencv2/src build

.PHONY: base-images
base-images: opencv2-image opencv4-image

.PHONY: opencv2-image
opencv2-image:
	$(MAKE) -C opencv2/docker build

.PHONY: opencv4-image
opencv4-image:
	$(MAKE) -C opencv4/docker build
