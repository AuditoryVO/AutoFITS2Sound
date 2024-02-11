;FITS2OSC
;Adrián García Riber
;2021-FreqFactor review Jan. 2024
<Cabbage>
form caption("Fits2Spectra2Sound_Normalized") size(650, 450), colour(50, 50, 50), pluginID("Fits2Spectra2Sound_Normalized")
hslider bounds(388, 416, 230, 29), channel("level"), text("Level"), range(0, 1, 0.5, 1, 0.001) 
image bounds(55, 12, 570, 400), channel("bkgrnd"), colour(255, 255, 255), corners(10)

image bounds(36, 12, 600, 400) identchannel("Image") corners(10) file("Init.png")

image bounds(111, 60, 1, 303) identchannel("Timeline") colour(255, 0, 0, 255) outlinethickness(0) 

hslider bounds(64, 416, 278, 29) channel("FreqFact"), text("Frequency factor"), range(0, 0.5, 0.15, 1, 0.001) 

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
sr = 48000
ksmps = 7.1642
nchnls = 2
0dbfs = 1

gks init 0
gkplay init 0
gkTimeline init 111
gki	init 0
gkfrec init 0
gkTime init 0
gkfFact int 0.5 
gkcount init 0


instr 1

giosc1 OSCinit 9999 ;x
giosc2 OSCinit 9998 ;y
giosc4 OSCinit 9996 ;activation
giosc5 OSCinit 9995 ;index
giosc6 OSCinit 9994 ;play/stop

kFader chnget "level"
gkfFact chnget "FreqFact"

kans OSClisten giosc5, "/i", "f", gki
kans OSClisten giosc6, "/p", "f", gkplay
kans OSClisten giosc2, "/y", "f", gkfrec
kans OSClisten giosc1, "/x", "f", gkTime

if gki!=0 then
    aosc oscil 1, (gkfrec*10000*gkfFact), 1
    outs aosc*kFader/30, aosc*kFader/30
;printk2 gkfrec*10000*gkfFact
;printk2 gki
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

if (gki != 0) && (gkplay == 1) then
    gkcount = gkcount + 1
        if (gkcount == 205) then
            ;idur=11.3
            gkTimeline=gkTimeline + 1
            Smessage sprintfk "bounds(%d,%d,%d,%d)", gkTimeline+15, 60, 1, 303
            chnset Smessage, "Timeline"
            gkcount = 0
        endif
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
i 1 0 3600*24*7
i 2 0 3600*24*7
i 3 0 3600*24*7
e

</CsScore>
</CsoundSynthesizer>
