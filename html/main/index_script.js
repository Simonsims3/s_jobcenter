// Original Author: SimoN#6253 (Discord) | S_imoN (Forum CFX) //
// Please Respect My Work //
// Do Not Touch Here If You Don't Know What You Are Doing //

window.addEventListener('message', function(e){
    var lua = e.data;
    if(lua.type === 'openMenu'){
        $('body').css('display', 'flex');
        ressourceName = lua.ressourceName
    } else if(lua.type === 'closeMenu'){
        $('body').css('display', 'none');
    };
})

document.addEventListener('keydown', (e) => {
    if(e.key === 'Escape'){
        $.post('https://'+ ressourceName +'/closemenu', JSON.stringify({}));
        $('body').css('display', 'none');
    };
});

let config = $.getJSON('../../config.json',(e)=>{
    e.jobs.forEach(job => {
        $('.container').append(`
        <div class="job">
        <img class="imgdiv" src=${job.imagepath}>
        <div class="textdiv"><h2>${job.jobLabel}</h2>${job.description}</div>
        <button class="buttonapply" onclick='confirm("${job.jobName}", "${job.jobLabel}")'>➤</button>
        </div>`);
    });
});

function confirm(job, jobLabel){
    document.location.href = "../confirm/confirm.html";
    sessionStorage.setItem("JobToConfirm", job);
    sessionStorage.setItem("JobToConfirmLabel", jobLabel);
    sessionStorage.setItem("ressourceName", ressourceName);
}
