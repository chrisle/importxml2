all:
	smoosh js/build.json

autotest:
	kicker -e "jasmine-node js/spec/gdoc_helper_spec.js"
