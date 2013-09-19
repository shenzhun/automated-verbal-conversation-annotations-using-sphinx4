verbal-conversation-recognition-using-sphinx4
=======================================================

Use Python and the open source Sphinx-4 speech-recognition package to capture letters and numbers from spoken conversations.


Installing Sphinx-4
--------------------
How to Build and Run Sphinx4 http://cmusphinx.sourceforge.net/wiki/sphinx4:howtobuildand_run_sphinx4

Custom dictionary
--------------------
In the Sphinx-4 directory tree, there is a directory called bld/models/edu/cmu/sphinx/model/acoustic/WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz/dict/. 
This directory contains the alpha.dict and digit.dict dictionary files. we'll need to build our dictionary files from the cmudict.0.6d file in the same directory.
Change to the bld/models/edu/cmu/sphinx/model/acoustic/WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz/dict/ directory and issue these commands to build the desired dictionary file:
<pre><code>
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

</code></pre>

Configuration of project
------------------------
Sphinx-4 provides many configuration options to meet almost any need in the field of speech recognition. 

Annotation4conv.java
<pre><code>
/*
 * Author: shen zhun
 * Date: 6/8/2013
 */

package sphinx4.conversation.annotation;

import edu.cmu.sphinx.frontend.util.Microphone;
import edu.cmu.sphinx.recognizer.Recognizer;
import edu.cmu.sphinx.result.Result;
import edu.cmu.sphinx.util.props.ConfigurationManager;

/**
 * A simple Sphinx4see demo showing a simple speech application built using Sphinx-4. This application uses the Sphinx-4
 * endpointer, which automatically segments incoming audio into utterances and silences.
 */
public class Annotation4conv {

    public static void main(String[] args) {
        ConfigurationManager cm;

        if (args.length > 0) {
            cm = new ConfigurationManager(args[0]);
        } else {
            cm = new ConfigurationManager(Annotation4conv.class.getResource("annotation4conv.config.xml"));
        }
        
        // allocate the recognizer
	System.out.println("Loading...");
        Recognizer recognizer = (Recognizer) cm.lookup("recognizer");
        recognizer.allocate();

        // start the microphone or exit if the programm if this is not possible
        Microphone microphone = (Microphone) cm.lookup("microphone");
        if (!microphone.startRecording()) {
            System.out.println("Cannot start microphone.");
            recognizer.deallocate();
            System.exit(1);
        }
        
        System.out.println("Listening for letters and numbers");
        // loop the recognition until the programm exits.
        while (true) {
            System.out.println("Start speaking. Press Ctrl-C to quit.\n");

            Result result = recognizer.recognize();

            if (result != null) {
                String resultText = result.getBestFinalResultNoFiller();

                System.out.println("You said: " + resultText + '\n');

            } else {
                System.out.println("I can't hear what you said.\n");
            }
        }
    }
}
</code></pre>

annotation4conv.config.xml

<pre><code>
<?xml version="1.0" encoding="UTF-8"?>


<config>

    <property name="logLevel" value="WARNING"/>

    <property name="absoluteBeamWidth"  value="-1"/>
    <property name="relativeBeamWidth"  value="1E-80"/>
    <property name="wordInsertionProbability" value="0.1"/>
    <property name="languageWeight"     value="8"/>

    <property name="frontend" value="epFrontEnd"/>
    <property name="recognizer" value="recognizer"/>

    <component name="recognizer" type="edu.cmu.sphinx.recognizer.Recognizer">
        <property name="decoder" value="decoder"/>
        <propertylist name="monitors">
            <item>accuracyTracker </item>
            <item>speedTracker </item>
            <item>memoryTracker </item>
        </propertylist>
   </component>

    <component name="decoder" type="edu.cmu.sphinx.decoder.Decoder">
        <property name="searchManager" value="searchManager"/>
    </component>

    <component name="searchManager" 
        type="edu.cmu.sphinx.decoder.search.SimpleBreadthFirstSearchManager">
        <property name="logMath" value="logMath"/>
        <property name="linguist" value="flatLinguist"/>
        <property name="pruner" value="trivialPruner"/>
        <property name="scorer" value="threadedScorer"/>
        <property name="activeListFactory" value="activeList"/>
    </component>

    <component name="activeList" 
             type="edu.cmu.sphinx.decoder.search.PartitionActiveListFactory">
        <property name="logMath" value="logMath"/>
        <property name="absoluteBeamWidth" value="${absoluteBeamWidth}"/>
        <property name="relativeBeamWidth" value="${relativeBeamWidth}"/>
    </component>

    <component name="trivialPruner" 
                type="edu.cmu.sphinx.decoder.pruner.SimplePruner"/>

    <component name="threadedScorer" 
                type="edu.cmu.sphinx.decoder.scorer.ThreadedAcousticScorer">
        <property name="frontend" value="${frontend}"/>
    </component>

    <component name="flatLinguist"
                type="edu.cmu.sphinx.linguist.flat.FlatLinguist">
        <property name="logMath" value="logMath"/>
        <property name="grammar" value="jsgfGrammar"/>
        <property name="acousticModel" value="wsj"/>
        <property name="wordInsertionProbability"
                value="${wordInsertionProbability}"/>
        <property name="languageWeight" value="${languageWeight}"/>
        <property name="unitManager" value="unitManager"/>
    </component>

    <component name="jsgfGrammar" type="edu.cmu.sphinx.jsgf.JSGFGrammar">
        <property name="dictionary" value="dictionary"/>
        <property name="grammarLocation" 
             value="resource:/sphinx4/conversation/annotation/"/>
        <property name="grammarName" value="annotation4conv"/>
        <property name="logMath" value="logMath"/>
        <property name="addSilenceWords" value="true"/>
    </component>

    <component name="dictionary" 
        type="edu.cmu.sphinx.linguist.dictionary.FastDictionary">
        <property name="dictionaryPath"
                  value="resource:/WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz/dict/alnum.dict"/>
        <property name="fillerPath" 
                  value="resource:/WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz/noisedict"/>
        <property name="unitManager" value="unitManager"/>
    </component>

    <component name="wsj"
               type="edu.cmu.sphinx.linguist.acoustic.tiedstate.TiedStateAcousticModel">
        <property name="loader" value="wsjLoader"/>
        <property name="unitManager" value="unitManager"/>
    </component>

    <component name="wsjLoader" type="edu.cmu.sphinx.linguist.acoustic.tiedstate.Sphinx3Loader">
        <property name="logMath" value="logMath"/>
        <property name="unitManager" value="unitManager"/>
        <property name="location" value="resource:/WSJ_8gau_13dCep_16k_40mel_130Hz_6800Hz"/>
    </component>

    <component name="unitManager" 
        type="edu.cmu.sphinx.linguist.acoustic.UnitManager"/>

    <component name="epFrontEnd" type="edu.cmu.sphinx.frontend.FrontEnd">
        <propertylist name="pipeline">
            <item>microphone </item>
            <item>dataBlocker </item>
            <item>speechClassifier </item>
            <item>speechMarker </item>
            <item>nonSpeechDataFilter </item>
            <item>preemphasizer </item>
            <item>windower </item>
            <item>fft </item>
            <item>melFilterBank </item>
            <item>dct </item>
            <item>batchCMN </item>
            <item>featureExtraction </item>
        </propertylist>
    </component>


    <component name="microphone"
               type="edu.cmu.sphinx.frontend.util.Microphone">
        <property name="closeBetweenUtterances" value="false"/>
    </component>

    <component name="audioFileDataSource" type="edu.cmu.sphinx.frontend.util.AudioFileDataSource"/>

    <component name="dataBlocker" type="edu.cmu.sphinx.frontend.DataBlocker"/>

    <component name="speechClassifier" type="edu.cmu.sphinx.frontend.endpoint.SpeechClassifier"/>

    <component name="nonSpeechDataFilter" 
               type="edu.cmu.sphinx.frontend.endpoint.NonSpeechDataFilter"/>

    <component name="speechMarker" type="edu.cmu.sphinx.frontend.endpoint.SpeechMarker" />
        
    <component name="preemphasizer"
               type="edu.cmu.sphinx.frontend.filter.Preemphasizer"/>

    <component name="windower" 
               type="edu.cmu.sphinx.frontend.window.RaisedCosineWindower">
    </component>

    <component name="fft" 
            type="edu.cmu.sphinx.frontend.transform.DiscreteFourierTransform">
    </component>

    <component name="melFilterBank" 
        type="edu.cmu.sphinx.frontend.frequencywarp.MelFrequencyFilterBank">
    </component>

    <component name="dct" 
            type="edu.cmu.sphinx.frontend.transform.DiscreteCosineTransform"/>

    <component name="batchCMN" 
               type="edu.cmu.sphinx.frontend.feature.BatchCMN"/>

    <component name="featureExtraction" 
               type="edu.cmu.sphinx.frontend.feature.DeltasFeatureExtractor"/>

    <component name="accuracyTracker" 
                type="edu.cmu.sphinx.instrumentation.BestPathAccuracyTracker">
        <property name="recognizer" value="${recognizer}"/>
        <property name="showAlignedResults" value="false"/>
        <property name="showRawResults" value="false"/>
    </component>

    <component name="memoryTracker" 
                type="edu.cmu.sphinx.instrumentation.MemoryTracker">
        <property name="recognizer" value="${recognizer}"/>
        <property name="showSummary" value="false"/>
        <property name="showDetails" value="false"/>
    </component>

    <component name="speedTracker" 
                type="edu.cmu.sphinx.instrumentation.SpeedTracker">
        <property name="recognizer" value="${recognizer}"/>
        <property name="frontend" value="${frontend}"/>
        <property name="showSummary" value="true"/>
        <property name="showDetails" value="false"/>
    </component>

    <component name="logMath" type="edu.cmu.sphinx.util.LogMath">
        <property name="logBase" value="1.0001"/>
        <property name="useAddTable" value="true"/>
    </component>

</config>

</code></pre>


