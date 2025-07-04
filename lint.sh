dart format . --set-exit-if-changed && flutter analyze && cd sample/android && ./gradlew ktlintFormat && cd ../.. && cd android && ./gradlew ktlintFormat

# Before use it, in the first time, you must guarantee some running permissions:
# chmod +x lint.sh
#
# After that, you just need to run:
# ./lint.sh