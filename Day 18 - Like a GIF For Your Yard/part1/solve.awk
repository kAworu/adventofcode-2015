#!/usr/bin/awk -f

BEGIN {
	# split the input into one field per character.
	FS = "";
	STEPS = 100;
}

{
	for (i = 1; i <= NF; i++)
		grid[i, NR] = ($i == "#");
}

END {
	# do animation steps by batch of two, because we use two arrays to
	# ping-pong the light states.
	for (i = 2; i <= STEPS; i += 2) {
		animate(grid, grid0, NR);
		animate(grid0, grid, NR);
	}

	if (STEPS % 2 == 0) {
		nlit = sum(grid);
	} else {
		# the number of steps is odd, we're off-by-one animation run.
		animate(grid, grid0, NR);
		nlit = sum(grid0);
	}
	print nlit;
}

function animate(from, to, len,    x, y, n) {
	for (x = 1; x <= len; x++) {
		for (y = 1; y <= len; y++) {
			n = from[x - 1, y - 1] + \
			    from[x    , y - 1] + \
			    from[x + 1, y - 1] + \
			    from[x + 1, y    ] + \
			    from[x + 1, y + 1] + \
			    from[x    , y + 1] + \
			    from[x - 1, y + 1] + \
			    from[x - 1, y    ];
			to[x, y] = (n == 3 || n == 2 && from[x, y]);
		}
	}
}

function sum(from,    i, n) {
	for (i in from)
		n += from[i];
	return n;
}
