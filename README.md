verbal-conversation-recognition-using-sphinx4
=======================================================

Use Python and the open source Sphinx-4 speech-recognition package to capture letters and numbers from spoken conversations.


Installing Sphinx-4
--------------------
How to Build and Run Sphinx4 http://cmusphinx.sourceforge.net/wiki/sphinx4:howtobuildand_run_sphinx4

Custom dictionary
--------------------
The first step in creating the pseudo word-spotting setup is to build the desired dictionary file. In the Sphinx-4 directory tree, there is a directory called bld/models/edu/cmu/sphinx/model/acoustic/WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz/dict/. This directory contains the alpha.dict and digit.dict dictionary files. At first glance, it appears that combining these two dictionary files will produce the desired file. This is not the case, however, as we'll need to build our dictionary files from the cmudict.0.6d file in the same directory.
Change to the bld/models/edu/cmu/sphinx/model/acoustic/WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz/dict/ directory and issue these commands to build the desired dictionary file:
