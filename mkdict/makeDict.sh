#! /bin/sh

cp WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz_backup.jar WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz.jar
jar xvf WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz.jar
cd WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz/dict/

grep -e '^[A-Z][ (]' cmudict.0.6d > alnum.dict
grep -P '^(ZERO|ONE|TWO|THREE|FOUR|FIVE|SIX|SEVEN|EIGHT|NINE)[ (]' cmudict.0.6d >> alnum.dict
cd ../..
# add custom dictionary file into *.jar file
jar -uf WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz.jar WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz/dict/alnum.dict 
mv WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz.jar ../lib

rm -rf WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz/ META-INF/
