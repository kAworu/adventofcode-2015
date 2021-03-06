#!/usr/bin/awk -f

/[A-Za-z]+: capacity -?[0-9]+, durability -?[0-9]+, flavor -?[0-9]+, texture -?[0-9]+, calories [0-9]+/ {
	ingredient = $1;
	sub(/:$/, "", ingredient);
	capacity[ingredient]   = int($3);
	durability[ingredient] = int($5);
	flavor[ingredient]     = int($7);
	texture[ingredient]    = int($9);
	ingredients[NR] = ingredient;
}

END {
	print best_score(100, ingredients, NR);
}

function best_score(teaspoons, ingredients, ningredients, c, d, f, t,
		    i, ingredient, next_ingredients, ci, di, fi, ti, s, best) {
	if (ningredients == 0) {
		if (c <= 0 || d <= 0 || f <= 0 || t <= 0)
			return 0;
		else
			return c * d * f * t;
	}

	ingredient = ingredients[ningredients];
	delete next_ingredients;
	for (i = 1; i < ningredients; i++)
		next_ingredients[i] = ingredients[i];

	ci = capacity[ingredient];
	di = durability[ingredient];
	fi = flavor[ingredient];
	ti = texture[ingredient];

	# if we're the last ingredient, just take all the teaspoons left.
	for (i = (ningredients == 1 ? teaspoons : 0); i <= teaspoons; i++) {
		s = best_score(teaspoons - i,
		    next_ingredients, ningredients - 1,
		    c + ci * i, d + di * i, f + fi * i, t + ti * i);
		best = (s > best ? s : best);
	}

	return best;
}
