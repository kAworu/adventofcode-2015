#!/usr/bin/awk -f

/[A-Z][a-z]+ would (gain|lose) [0-9]+ happiness units by sitting next to [A-Z][a-z]+\./ {
	subject = $1;
	happy   = ($3 == "gain");
	units   = int($4) * (happy ? 1 : -1);
	next_to = $11;
	sub(/\.$/, "", next_to);
	happiness[subject, next_to] += units;
	happiness[next_to, subject] += units;
	people[subject] = people[next_to] = 1;
}

END {
	for (person in people) {
		happiness["Myself", person] = happiness[person, "Myself"] = 0;
		npeople++;
	}
	people["Myself"] = 1;
	npeople++;

	print happiest(people, npeople);
}

function happiest(standing, nstanding, first, previous, change,
	      person, p, next_standing, c, max_change) {
	if (nstanding == 0)
		return change + happiness[first, previous];

	for (person in standing) {
		delete next_standing;
		for (p in standing) {
			if (p != person)
				next_standing[p] = 1;
		}
		if (!first) {
			# unlike TSP we don't have to try every permutations,
			# we can start with any person. We could optimize
			# further though, because
			#     <- A <-> B <-> C <-> D ->
			# will yield the same result as
			#     <- A <-> D <-> C <-> B ->
			return happiest(next_standing, nstanding - 1, person, person);
		}
		c = happiest(next_standing, nstanding - 1, first, person, change + happiness[previous, person]);
		max_change = (c > max_change ? c : max_change);
	}
	return max_change;
}
