string(ASCII 27 Esc)
set(ColourReset "${Esc}[m")
set(Blue        "${Esc}[34m")
set(Yellow      "${Esc}[33m")
set(Green       "${Esc}[32m")

function(message_blue msg)
    message(STATUS "${Blue}${msg}${ColourReset}")
endfunction(message_blue)

function(message_yellow msg)
    message(STATUS "${Yellow}${msg}${ColourReset}")
endfunction(message_yellow)