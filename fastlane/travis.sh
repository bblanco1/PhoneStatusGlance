#!/bin/sh

bundle exec pod repo update
bundle exec fastlane test
exit $?
