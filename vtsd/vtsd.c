/*
 * virtual touchscreen input server
 *
 * Copyright 2009 Embedded Alley Solutions, Inc.
 *
 * Matt Porter <mporter@embeddedalley.com>
 */

#include <sys/types.h>
#include <linux/input.h>
#include <linux/uinput.h>
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h> 

#define UINPUT_DEV	"/dev/uinput"

int init_touchscreen_uinput(int fd, struct uinput_user_dev *uinp)
{
	int i;

	memset(uinp, 0, sizeof(*uinp));

	strncpy(uinp->name, "Virtual Touchscreen", UINPUT_MAX_NAME_SIZE);
	uinp->id.bustype = BUS_VIRTUAL;
	uinp->id.version = 1;

	uinp->absmax[ABS_X] = 639;
	uinp->absmax[ABS_Y] = 479;
	uinp->absmax[ABS_PRESSURE] = 99;
	uinp->absmin[ABS_X] = 0;
	uinp->absmin[ABS_Y] = 0;
	uinp->absmin[ABS_PRESSURE] = 0;
	uinp->absfuzz[ABS_X] = 0;
	uinp->absfuzz[ABS_Y] = 0;
	uinp->absfuzz[ABS_PRESSURE] = 0;
	uinp->absflat[ABS_X] = 0;
	uinp->absflat[ABS_Y] = 0;
	uinp->absflat[ABS_PRESSURE] = 0;

	ioctl(fd, UI_SET_EVBIT, EV_KEY);
	ioctl(fd, UI_SET_EVBIT, EV_ABS);

	ioctl(fd, UI_SET_KEYBIT, BTN_TOUCH);

	ioctl(fd, UI_SET_ABSBIT, ABS_X);
	ioctl(fd, UI_SET_ABSBIT, ABS_Y);
	ioctl(fd, UI_SET_ABSBIT, ABS_PRESSURE);

	write(fd, uinp, sizeof(*uinp));

	if (ioctl(fd, UI_DEV_CREATE)) {
		perror("Unable to create uinput touchscreen device");
		return -1;
	}

	return 0;
}

int main(int argc, char *argv[]) {
	int ret = 0;
	int tfd = 0;
	struct uinput_user_dev tuinput;

	if (argc > 1) {
		fprintf(stderr, "Usage: %s\n", argv[0]);
		ret = -EINVAL;
		goto out;
	}

	tfd = open(UINPUT_DEV, O_RDWR);

	if (tfd < 0) {
		fprintf(stderr, "Error opening %s\n", UINPUT_DEV);
		ret = -EINVAL;
		goto out;
	}

	if (init_touchscreen_uinput(tfd, &tuinput) < 0) {
		ret = -EINVAL;
		goto out;
	}

	while (1) {
		sleep(100000);
	}

out:
	ioctl(tfd, UI_DEV_DESTROY, &tuinput);

	close(tfd);

	return ret;
}
