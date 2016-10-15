#!/bin/sh

# If a pull request, only ever test
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  bundle exec fastlane test
  exit $?
fi

# Beta deploy
if [[ "$TRAVIS_BRANCH" == "beta" ]]; then
  bundle exec fastlane getmatch && bundle exec fastlane beta
  exit $?
fi

# Release for review
if [[ "$TRAVIS_BRANCH" == "release" ]]; then
  bundle exec fastlane getmatch && bundle exec fastlane deploy
  exit $?
fi

# Default, just run the tests
bundle exec fastlane test
exit $?
