import random
import pyttsx3
import speech_recognition as sr
import time
from subprocess import Popen

from bit import PrivateKeyTestnet



##wallet primary (btc)
key = PrivateKeyTestnet('redacted')
##wallet secondary (btc)
key2 = PrivateKeyTestnet('redacted')


# idlemovie = 'media/idle_screen.mp4'
# welcomemovie = 'media/welcome_screen_loop.mp4'
# eye1movie = 'media/eyes_open.mp4'
# eye2movie = 'media/eyes_close.mp4'
# fortune1movie = 'media/fortune_1.mp4'
# fortune2movie = 'media/fortune_2.mp4'

## "sudo vlc " + idlemovie +" --no-video-title --loop --fullscreen" 



# omxp = Popen(['omxplayer',idlemovie])

##play idle sequence

maindelay = 5  #delay for main loop

r = sr.Recognizer()


def getSpeech():
    text = "human"
    with sr.Microphone() as source:
        print("Say something!")
        audio = r.listen(source)

    try:
        # for testing purposes, we're just using the default API key
        # to use another API key, use `r.recognize_google(audio, key="GOOGLE_SPEECH_RECOGNITION_API_KEY")`
        # instead of `r.recognize_google(audio)`
        text = r.recognize_google(audio)
        print("Google Speech Recognition thinks you said " + text)
    except sr.UnknownValueError:
        print("Google Speech Recognition could not understand audio")
    except sr.RequestError as e:
        print("Could not request results from Google Speech Recognition service; {0}".format(e))
    
    return text

def speak(sentence):
    eng = pyttsx3.init()
    eng.setProperty('rate', 130) 
    eng.say(sentence)
    eng.runAndWait()
    print(sentence)
    eng.stop() 

# name = input('what is your name?')
# n1 = len(name)

# name = getname()
count = 1

## keyphrase is i like coffee

while (1) :
    count -=1

    ##detect user with distance/motion

    ##led flash


    ## play opening sequence
    # omxp = Popen(['omxplayer', eye1movie])
    
    speak("please speak your passphrase")
    name = getSpeech()
    name = name.lower()
    if "coffee" not in name:
        word_list = name.split()
        name = word_list[-1]
        speak("sorry, please try again...")
        continue
    
    speak("greetings, Muntaser")


    speak("how can i help you today?")
    name = getSpeech()
    name = name.lower()
    if "send" in name:
        outstring = "sent with voicewallet"
        txid = key2.send([('mkNdHY2qjNqrTG4vqvzYo7kfhqpq22jDeh',0.000001,'btc')],message=outstring)
        print(txid)
        speak("transaction complete.")
        continue

    if "balance" in name:
        # outstring = "sent with voicewallet"
        bal = key2.get_balance('usd')


        speak("the balance in your bitcoin wallet is " + str(bal) + " dollars")
        continue

    
    
    speak("sorry, Muntaser i did not understand this command ... ")



    time.sleep(maindelay)

    if count == -4:
        break



