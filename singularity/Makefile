IMAGE=debian.singularity

.PHONY: bootstrap

all: bootstrap

${IMAGE}:
	sudo singularity create -s 10000 ${IMAGE}

create: ${IMAGE}
	true

bootstrap: create
	sudo singularity bootstrap ${IMAGE} bootstrap

shell: ${IMAGE}
	singularity exec ${IMAGE} bash

write: ${IMAGE}
	sudo singularity exec -w ${IMAGE} bash

