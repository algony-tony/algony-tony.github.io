
 (function() {
    moveTOC() //将Content内容转移
    replaceClassFirstElement('wrapper-header','wrapper-header-with-side')
    replaceClassFirstElement('wrapper-content','wrapper-content-with-side')
    replaceClassFirstElement('wrapper-footer','wrapper-footer-with-side')
}());

//将Content内容转移
function moveTOC() {
    if (document.querySelector('#markdown-toc') !== null) {
        var TOCString = document.querySelector('#markdown-toc').innerHTML
        var contentUl = document.querySelector('#content-side')
        contentUl.insertAdjacentHTML('afterbegin', TOCString) //插入字符串
    }
}

function replaceClassFirstElement(oldClass, newClass) {
    var elem = document.getElementsByClassName(oldClass)[0];
    elem.classList.add(newClass);
    elem.classList.remove(oldClass);
}
