#!/bin/sh

# If a pull request, only ever test
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  bundle exec fastlane test
  exit $?
fi

# Betafast
if [[ "$TRAVIS_BRANCH" == "betafast" ]] || [[ "$TRAVIS_BRANCH" = */betafast ]]; then
  bundle exec fastlane betafast
  exit $?
fi

# Beta deploy
if [[ "$TRAVIS_BRANCH" == "beta" ]] || [[ "$TRAVIS_BRANCH" = */beta ]]; then
  bundle exec fastlane beta
  exit $?
fi

# Release for review
if [[ "$TRAVIS_BRANCH" == "release" ]] || [[ "$TRAVIS_BRANCH" = */deploy ]]; then
  bundle exec fastlane deploy
  exit $?
fi

# Default, just run the tests
bundle exec fastlane test
exit $?
