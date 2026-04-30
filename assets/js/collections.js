(() => {
  const tagNodes = Array.from(document.querySelectorAll('.archive-tag-badge'));

  if (!tagNodes.length) {
    return;
  }

  const items = tagNodes.map((node) => ({
    node,
    posts: new Set((node.dataset.posts || '').split('|').filter(Boolean))
  }));

  const intersectionSize = (left, right) => {
    let matches = 0;
    left.forEach((value) => {
      if (right.has(value)) {
        matches += 1;
      }
    });
    return matches;
  };

  const resetState = () => {
    items.forEach((item) => {
      item.node.classList.remove('is-active', 'is-related', 'is-dimmed');
      item.node.style.removeProperty('--related-strength');
    });
  };

  const activate = (activeItem) => {
    items.forEach((item) => {
      item.node.classList.remove('is-active', 'is-related', 'is-dimmed');
      item.node.style.removeProperty('--related-strength');

      if (item === activeItem) {
        item.node.classList.add('is-active');
        return;
      }

      const overlap = intersectionSize(activeItem.posts, item.posts);
      if (overlap > 0) {
        item.node.classList.add('is-related');
        item.node.style.setProperty('--related-strength', String(Math.min(overlap, 4)));
      } else {
        item.node.classList.add('is-dimmed');
      }
    });
  };

  items.forEach((item) => {
    item.node.addEventListener('mouseenter', () => activate(item));
    item.node.addEventListener('focus', () => activate(item));
    item.node.addEventListener('mouseleave', resetState);
    item.node.addEventListener('blur', resetState);
  });
})();
