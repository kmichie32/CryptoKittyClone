
var colors = Object.values(allColors())

var defaultDNA = {
    "headcolor" : 10,
    "mouthColor" : 13,
    "eyesColor" : 96,
    "earsColor" : 16,
    //Cattributes
    "eyesShape" : 1,
    "decorationPattern" : 1,
    "decorationMidcolor" : 13,
    "decorationSidescolor" : 13,
    "animation" :  1,
    "lastNum" :  1
    }

// when page load
$( document ).ready(function() {
  $('#dnabody').html(defaultDNA.headColor);
  $('#dnamouth').html(defaultDNA.mouthColor);
  $('#dnaeyes').html(defaultDNA.eyesColor);
  $('#dnaears').html(defaultDNA.earsColor);
    
  $('#dnashape').html(defaultDNA.eyesShape)
  $('#dnadecoration').html(defaultDNA.decorationPattern)
  $('#dnadecorationMid').html(defaultDNA.decorationMidcolor)
  $('#dnadecorationSides').html(defaultDNA.decorationSidescolor)
  $('#dnaanimation').html(defaultDNA.animation)
  $('#dnaspecial').html(defaultDNA.lastNum)

  renderCat(defaultDNA)
});

function getDna(){
    var dna = ''
    dna += $('#dnabody').html()
    dna += $('#dnamouth').html()
    dna += $('#dnaeyes').html()
    dna += $('#dnaears').html()
    dna += $('#dnashape').html()
    dna += $('#dnadecoration').html()
    dna += $('#dnadecorationMid').html()
    dna += $('#dnadecorationSides').html()
    dna += $('#dnaanimation').html()
    dna += $('#dnaspecial').html()

    return parseInt(dna)
}

function renderCat(dna){
    // Head Color Initiated
    headColor(colors[dna.headcolor],dna.headcolor)
    $('#bodycolor').val(dna.headcolor)

    // Mouth/Body/Tail Initiated
    mouthBodyTailColor(colors[dna.mouthColor],dna.mouthColor)
    $('#mouthBodyTailcolor').val(dna.mouthColor)

    // Eyes Initiated
    eyeColor(colors[dna.eyesColor],dna.eyesColor)
    $('#eyecolor').val(dna.eyesColor)

    // Ear Initiated
    earColor(colors[dna.earsColor],dna.earsColor)
    $('#earcolor').val(dna.earsColor)

    // Ear Initiated
    eyeVariation(dna.eyesShape+'')
    $('#eyeShape').val(dna.eyesShape)

    // Decoration Shape Initiated
    decorationVariation(dna.decorationPattern+'')
    $('#decorationShape').val(dna.decorationPattern)

    // Middle Decoration Color Initiated
    midDecorColor(colors[dna.decorationMidcolor],dna.decorationMidcolor)
    $('#decorationMidColor').val(dna.decorationMidcolor)

    outsideDecorColor(colors[dna.decorationSidescolor],dna.decorationSidescolor)
    $('#decorationOutsideColor').val(dna.decorationSidescolor)

    animationVariation(dna.animation)
    $('#animation').val(dna.animation)
}

// Changing cat colors
$('#bodycolor').change(()=>{
    var colorVal = $('#bodycolor').val()
    headColor(colors[colorVal],colorVal)
})

// Changing cat Mouth/Legs/Tail colors
$('#mouthBodyTailcolor').change(()=>{
  var mouthColorVal = $('#mouthBodyTailcolor').val()
  mouthBodyTailColor(colors[mouthColorVal],mouthColorVal)
})

// Changing cat Eye colors
$('#eyecolor').change(()=>{
  var eyeColorVal = $('#eyecolor').val()
  eyeColor(colors[eyeColorVal],eyeColorVal)
})

// Changing cat Eye colors
$('#earcolor').change(()=>{
  var earColorVal = $('#earcolor').val()
  earColor(colors[earColorVal],earColorVal)
})

// Changing cat Eye colors
$('#eyeShape').change(()=>{
  var shape = $('#eyeShape').val()
  eyeVariation(shape)
})

// Changing cat Eye colors
$('#decorationShape').change(()=>{
  var shape = $('#decorationShape').val()
  decorationVariation(shape)
})

$('#decorationMidColor').change(()=>{
  var midDecorColorVal = $('#decorationMidColor').val()
  midDecorColor(colors[midDecorColorVal],midDecorColorVal)
})

$('#decorationOutsideColor').change(()=>{
  var outsideDecorColorVal = $('#decorationOutsideColor').val()
  outsideDecorColor(colors[outsideDecorColorVal],outsideDecorColorVal)
})

$('#animation').change(()=>{
  var animationVal = parseInt($('#animation').val())
  animationVariation(animationVal)
})