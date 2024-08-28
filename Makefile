run-server:
	bin/server

test:
	bundle exec rspec ${TEST}

console:
	rails c

bundle-install:
	bundle intall

bundle-update:
	bundle update ${GEM}
