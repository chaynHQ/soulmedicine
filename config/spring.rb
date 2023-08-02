# frozen_string_literal: true

Spring.watch(
  '.env',
  '.env.local',
  '.env.test',
  '.ruby-version',
  '.rbenv-vars',
  'tmp/restart.txt',
  'tmp/caching-dev.txt'
)
