function abbrNum(number, decPlaces) {
    // 2 decimal places => 100, 3 => 1000, etc
    decPlaces = Math.pow(10,decPlaces);
    var value = parseInt(number);

    // Enumerate number abbreviations
    var abbrev = [
        qsTr("k") + Retranslate.onLocaleOrLanguageChanged, 
        qsTr("m") + Retranslate.onLocaleOrLanguageChanged, 
        qsTr("b") + Retranslate.onLocaleOrLanguageChanged, 
        qsTr("t") + Retranslate.onLocaleOrLanguageChanged
    ];

    // Go through the array backwards, so we do the largest first
    for (var i=abbrev.length-1; i>=0; i--) {

        // Convert array index to "1000", "1000000", etc
        var size = Math.pow(10,(i+1)*3);

        // If the number is bigger or equal do the abbreviation
        if(size <= value) {
             // Here, we multiply by decPlaces, round, and then divide by decPlaces.
             // This gives us nice rounding to a particular decimal place.
             value = Math.round(value*decPlaces/size)/decPlaces;

             // Handle special case where we round up to the next abbreviation
             if((value == 1000) && (i < abbrev.length - 1)) {
                 value = 1;
                 i++;
             }

             // Add the letter for the abbreviation
             value += abbrev[i];

             // We are done... stop
             break;
        }
    }
    return value;
};