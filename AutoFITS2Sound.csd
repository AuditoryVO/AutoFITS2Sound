;FITS2OSC
;Adrián García Riber
;2021
<Cabbage>
form caption("Fits2Spectra2Sound_Normalized") size(650, 425), colour(50, 50, 50), pluginID("Fits2Spectra2Sound_Normalized")
vslider bounds(6, 10, 31, 150), channel("level"), text("Level"), range(0, 1, 0.5, 1, 0.001) 
image bounds(55, 12, 570, 400), channel("bkgrnd"), colour(255, 255, 255), corners(10)

image bounds(36, 12, 600, 400) identchannel("Image") corners(10) file("Init.png")

image bounds(111, 60, 1, 303) identchannel("Timeline") colour(255, 0, 0, 255) outlinethickness(0) 




</Cabbage>
<CsoundSynthesizer>
<CsOptions>
;-n -d -+rtmidi=NULL -M0 -m0d --midi-key-cps=4 --midi-velocity-amp=5
-odac
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
sr = 48000
ksmps =10
nchnls = 2
0dbfs = 1


gks init 0
gkplay init 0
gkTimeline init 111
gki	init 0



instr 1

giosc1 OSCinit 9999 ;x
giosc2 OSCinit 9998 ;y
;giosc3 OSCinit 9997 ;length
giosc4 OSCinit 9996 ;speed
giosc5 OSCinit 9995 ;index
giosc6 OSCinit 9994 ;play/stop

kFader chnget "level"
;kl init 0
;ks init 100
kfrec init 0
kTime init 0
;kcount init 0


;kans OSClisten giosc3, "/length", "f", kl
kans OSClisten giosc5, "/i", "f", gki
kans OSClisten giosc6, "/p", "f", gkplay
kans OSClisten giosc2, "/y", "f", kfrec
kans OSClisten giosc1, "/x", "f", kTime


if gki!=0 then

    printk2 gki
    printk2 kTime
    printk2 kfrec*10000

;------------------------------GEN
    aosc oscil 1, (kfrec*10000), 1

;------------------------------------OUT

    outs aosc*kFader/30, aosc*kFader/30
;    fout "Spectra_rec.wav", 12, (aosc*kFader/30) ;write to soundfile
  
endif

if (gki == 0) && (gkplay == 1) then
    event "i", 3, 0.001, 11.3

endif

endin



instr 2 ;Changing images


kans OSClisten giosc4, "/s", "f", gks

if gks==1 then
	
	Scurve sprintfk "file(%s)", "Spectra.png"
	chnset Scurve, "Image"
	giImage imageload "Spectra.png"

elseif gks==0 then
    Scurve sprintfk "file(%s)", "Init.png"
	chnset Scurve, "Image"	
	imagefree giImage
			
endif
endin




instr 3 ; Timeline


if (gki != 0) then

    idur=11.3
    gkTimeline linseg 111, idur, 575
    Smessage sprintfk "bounds(%d,%d,%d,%d)", gkTimeline, 60, 1, 303
    chnset Smessage, "Timeline"
 

else


	Smessage sprintfk "bounds(%d,%d,%d,%d)", 111, 60, 1, 303
	chnset Smessage, "Timeline"
    gkTimeline = 111
    idur=0

		
	
endif

endin




</CsInstruments>
<CsScore>
f 1 0 1024 10 1
;f 2 0 1024 10 1
;f 3 0 1024 10 1
;f 4 0 1024 10 1
;f 5 0 1024 10 1

i 1 0 3600*24*7
i 2 0 3600*24*7
;i 3 0 3600*24*7
e

</CsScore>
</CsoundSynthesizer>
