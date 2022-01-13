
//Random color
function getColor() {
    var randomColor = Math.floor(Math.random() * 16777215).toString(16);
    return randomColor
}

function genColors(){
    var colors = []
    for(var i = 10; i < 99; i ++){
      var color = getColor()
      colors[i] = color
    }
    return colors
}

//This function code needs to modified so that it works with Your cat code.
function headColor(color,code) {
    $('.cat__head, .cat__chest').css('background', '#' + color)  //This changes the color of the cat
    $('#headcode').html('code: '+code) //This updates text of the badge next to the slider
    $('#dnabody').html(code) //This updates the body color part of the DNA that is displayed below the cat
}

function mouthBodyTailColor(color,code) {
    $('.cat__mouth-contour, .cat__mouth-left, .cat__mouth-right,.cat__paw-left_inner, .cat__paw-left, .cat__paw-right_inner, .cat__paw-right, .cat__tail').css('background', '#' + color)  //This changes the color of the cat
    $('#mouthcode').html('code: '+code) //This updates text of the badge next to the slider
    $('#dnamouth').html(code) //This updates the body color part of the DNA that is displayed below the cat
}

function eyeColor(color,code) {
    $('.pupil-left, .pupil-right').css('background', '#' + color)  //This changes the color of the cat
    $('#eyecode').html('code: '+code) //This updates text of the badge next to the slider
    $('#dnaeyes').html(code) //This updates the body color part of the DNA that is displayed below the cat
}

function earColor(color,code) {
    $('.cat__ear--left, .cat__ear--right').css('background', '#' + color)  //This changes the color of the cat
    $('#earcode').html('code: '+code) //This updates text of the badge next to the slider
    $('#dnaears').html(code) //This updates the body color part of the DNA that is displayed below the cat
}

//###################################################
//Functions below will be used later on in the project
//###################################################
function eyeVariation(num) {
    // Note: num is coming in as Text and NOT and int
    $('#dnashape').html(num)
    switch (num) {
        case "1":
            normalEyes()
            $('#eyeShapeCode').html('Basic')
            break
        case "2":
            normalEyes()
            $('#eyeShapeCode').html('Chill')
            chillEyes()
            break
        case "3":
                normalEyes()
                $('#eyeShapeCode').html('Lucky Right')
                luckyRightEye()
                break
        case "4":
                normalEyes()
                $('#eyeShapeCode').html('Lucky Left')
                luckyLeftEye()
                break
        default:
            console.log("Not 1 or 2")

    }
}

function decorationVariation(num) {
    $('#dnadecoration').html(num)
    switch (num) {
        case 1:
            $('#decorationName').html('Basic')
            normaldecoration()
            break
    }
}

function normalEyes() {
    console.log($('#eyecolor').val())
    $('.pupil-right').css('background', '#' + colors[$('#eyecolor').val()])
    $('.pupil-left').css('background', '#' + colors[$('#eyecolor').val()])
    $('.cat__eye').find('span').css('border', 'none')
}

function chillEyes() {
    $('.cat__eye').find('span').css('border-top', '15px solid')
}

function luckyRightEye() {
    $('.pupil-right').css('background', '#' + getColor())
}

function luckyLeftEye() {
    $('.pupil-left').css('background', '#' + getColor())
}

async function normaldecoration() {
    //Remove all style from other decorations
    //In this way we can also use normalDecoration() to reset the decoration style
    $('.cat__head-dots').css({ "transform": "rotate(0deg)", "height": "48px", "width": "14px", "top": "1px", "border-radius": "0 0 50% 50%" })
    $('.cat__head-dots_first').css({ "transform": "rotate(0deg)", "height": "35px", "width": "14px", "top": "1px", "border-radius": "50% 0 50% 50%" })
    $('.cat__head-dots_second').css({ "transform": "rotate(0deg)", "height": "35px", "width": "14px", "top": "1px", "border-radius": "0 50% 50% 50%" })
}
