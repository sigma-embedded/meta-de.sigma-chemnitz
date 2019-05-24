python elito_enhance_decodeuri() {
    import elito
    elito.enhance_decodeuri()
}

addhandler elito_enhance_decodeuri
elito_enhance_decodeuri[eventmask] = "bb.event.ConfigParsed"
