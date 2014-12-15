'use strict';

// Converts R,G,B into a signle HEX word

function scale (c) {
    var tmp;
    tmp = c; //  % 1;
    // Gamma correction
    tmp = Math.pow(tmp, (1 / 0.45));
    // scaling
    tmp = 255 * tmp;
    tmp = Math.round(tmp);
    // convert to HEX string
    tmp = tmp.toString(16);
    return ('000000' + tmp).slice(-2);
}

module.exports = function (r, g, b) {
    return scale(g) + scale(r) + scale(b);
};
