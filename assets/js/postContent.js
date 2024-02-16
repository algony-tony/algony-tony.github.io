window.addEventListener("load", () => {
    moveTOC();
    replaceClassFirstElement('wrapper-header', 'wrapper-header-with-side');
    replaceClassFirstElement('wrapper-content', 'wrapper-content-with-side');
    replaceClassFirstElement('wrapper-footer', 'wrapper-footer-with-side');
});

//将Content内容转移
const moveTOC = () => {
    const toc = document.querySelector('#markdown-toc');
    if (!toc) return;
    const TOCString = toc.innerHTML;
    const contentUl = document.querySelector('#content-side');
    contentUl.insertAdjacentHTML('afterbegin', TOCString);
};

const replaceClassFirstElement = (oldClass, newClass) => {
    const elem = document.getElementsByClassName(oldClass)[0];
    elem.classList.add(newClass);
    elem.classList.remove(oldClass);
};