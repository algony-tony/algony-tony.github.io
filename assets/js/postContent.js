const ACTIVE_CLASS = 'is-active';

const moveTOC = () => {
    const toc = document.querySelector('#markdown-toc');
    const contentUl = document.querySelector('#content-side');
    if (!toc || !contentUl) return [];

    contentUl.innerHTML = '';
    for (const item of toc.children) {
        contentUl.appendChild(item.cloneNode(true));
    }

    return Array.from(contentUl.querySelectorAll('a[href^="#"]'));
};

const syncActiveTOCLink = (links) => {
    if (!links.length || !('IntersectionObserver' in window)) return;

    const sections = links
        .map((link) => {
            const id = decodeURIComponent(link.getAttribute('href').slice(1));
            const target = document.getElementById(id);
            return target ? { link, target } : null;
        })
        .filter(Boolean);

    if (!sections.length) return;

    let activeId = sections[0].target.id;

    const updateActiveState = () => {
        for (const { link } of sections) {
            const isActive = decodeURIComponent(link.getAttribute('href').slice(1)) === activeId;
            link.classList.toggle(ACTIVE_CLASS, isActive);
            link.parentElement?.classList.toggle(ACTIVE_CLASS, isActive);
        }
    };

    const observer = new IntersectionObserver(
        (entries) => {
            const visibleEntries = entries
                .filter((entry) => entry.isIntersecting)
                .sort((a, b) => a.boundingClientRect.top - b.boundingClientRect.top);

            if (visibleEntries.length > 0) {
                activeId = visibleEntries[0].target.id;
                updateActiveState();
            }
        },
        {
            rootMargin: '-15% 0px -70% 0px',
            threshold: [0, 1]
        }
    );

    for (const { target } of sections) {
        observer.observe(target);
    }

    updateActiveState();
};

const initPostTOC = () => {
    const links = moveTOC();
    syncActiveTOCLink(links);
};

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initPostTOC);
} else {
    initPostTOC();
}
