#! /bin/sh

cp WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz_backup.jar WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz.jar
jar xvf WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz.jar
cp custom.dict WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz/dict/

# add custom dictionary file into *.jar file
jar -uf WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz.jar WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz/dict/custom.dict 
mv WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz.jar ../lib

rm -rf WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz/ META-INF/
