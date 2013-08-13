#! /bin/sh

grep -e '^[A-Z][ (]' cmudict.0.6d > alnum.dict
grep -P '^(ZERO|ONE|TWO|THREE|FOUR|FIVE|SIX|SEVEN|EIGHT|NINE)[ (]' cmudict.0.6d >> alnum.dict
