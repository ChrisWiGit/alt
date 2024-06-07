if not exist Help\nul mkdir Help
del Help\*.chm
del Help\*.hhc
del Help\*.hhk
del Help\*.hhp
del Help\*.htm*
del Help\*.gif
del Help\*.log
Source\DIPasDoc.exe -p -v3 -ddirectives.txt -OHtmlHelp -ccustom.txt -T"DelphiTools 2 Hilfe" -EHelp -ISource -Lde Source\*.pas
pause