//  Original Author: SimoN#6253 (Discord) | S_imoN (Forum CFX) //
//  Please Respect My Work //
// Do Not Touch Here If You Don't Know What You Are Doing //

var jobToConfirm = sessionStorage.getItem("JobToConfirm");
var jobToConfirmLabel = sessionStorage.getItem("JobToConfirmLabel");

let config_confirm = $.getJSON('../../config.json',(e)=>{
    var language = '../lang/'+ e.lang + '.json'
    var config_lang = $.getJSON(language, (lang) =>{

        if (jobToConfirm === "unemployed"){
            $('#container').append(`
            <div id="box-texte">${lang['confirmationPhraseUnemployed']}</div>
            <button id="yes" onclick="setJob(jobToConfirm, jobToConfirmLabel);">${lang.YES}</button>
            <button id="no" onclick="cancel();">${lang.NO}</button>
            `);
        }else{
            $('#container').append(`
            <div id="box-texte">${lang['confirmationPhrase']} ${jobToConfirmLabel} ?</div>
            <button id="yes" onclick="setJob(jobToConfirm, jobToConfirmLabel);">${lang.YES}</button>
            <button id="no" onclick="cancel()">${lang.NO}</button>
            `);
        };
    });
});



function setJob(jobName, jobLabel){
    $.post(`https://s_jobcenter/button`, JSON.stringify({jobName:jobName,jobLabel:jobLabel}));
    $('#container').css('display', 'none');
    document.location.href = "../main/index.html";
}

function cancel(){
    $.post(`https://s_jobcenter/closemenu`, JSON.stringify({}));
    $('#container').css('display', 'none');
    document.location.href = "../main/index.html";
};