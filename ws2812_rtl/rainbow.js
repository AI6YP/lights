'use strict';

var pixel = require('./pixel');

var i, scale, range;

// scale = .25; // dim version
scale = 1;

range = 8;

function up () {
    return i * scale / (range - 1);
}

function down () {
    return (range - 1 - i) * scale / (range - 1);
}

// Full rainbow 6 zone dim

for (i = 0; i < 8; i++) { console.log(pixel(scale,  up(),   0)); }
for (i = 0; i < 8; i++) { console.log(pixel(down(), scale,  0)); }
for (i = 0; i < 8; i++) { console.log(pixel(0,      scale,  up())); }
for (i = 0; i < 8; i++) { console.log(pixel(0,      down(), scale)); }
for (i = 0; i < 8; i++) { console.log(pixel(up(),   0,      scale)); }
for (i = 0; i < 8; i++) { console.log(pixel(scale,  0,      down())); }
