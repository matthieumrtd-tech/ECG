(() => {
  const equations = [
    ['Σₖ₌₀ⁿqᵏ=(1−qⁿ⁺¹)/(1−q)', '\\displaystyle\\sum_{k=0}^{n}q^k=\\frac{1-q^{n+1}}{1-q}'],
    ['Σₖ₌₀ⁿuₖ=(n+1)(u₀+uₙ)/2', '\\displaystyle\\sum_{k=0}^{n}u_k=\\frac{(n+1)(u_0+u_n)}{2}'],
    ['Σuₖ=u₀(1−qⁿ⁺¹)/(1−q)', '\\displaystyle\\sum_{k=0}^{n}u_k=u_0\\frac{1-q^{n+1}}{1-q}'],
    ['Σₖ₌₀∞qᵏ=1/(1−q)', '\\displaystyle\\sum_{k=0}^{\\infty}q^k=\\frac{1}{1-q}'],
    ['Σ₀¹⁰uₖ=−33', '\\displaystyle\\sum_{k=0}^{10}u_k=-33'],
    ['Σ₁ⁿuₖ=10(1−(1/2)ⁿ)', '\\displaystyle\\sum_{k=1}^{n}u_k=10\\left(1-\\left(\\frac12\\right)^n\\right)'],
    ['S=1+q+…+qⁿ', 'S=\\displaystyle\\sum_{k=0}^{n}q^k'],
    ['(n+1)(u₀+uₙ)/2', '\\frac{(n+1)(u_0+u_n)}{2}'],
    ['(1−qⁿ⁺¹)/(1−q)', '\\frac{1-q^{n+1}}{1-q}'],
    ['(1−(1/2)ⁿ)', '\\left(1-\\left(\\frac12\\right)^n\\right)'],
    ['ℓ=b/(1−a)', '\\ell=\\frac{b}{1-a}'],
    ['b/(1−a)', '\\frac{b}{1-a}'],
    ['Σₖ₌₀ⁿqᵏ', '\\displaystyle\\sum_{k=0}^{n}q^k'],
    ['Σₖ₌₀ⁿuₖ', '\\displaystyle\\sum_{k=0}^{n}u_k'],
    ['Σₖ₌₀∞qᵏ', '\\displaystyle\\sum_{k=0}^{\\infty}q^k'],
    ['Σ₀ⁿuₖ', '\\displaystyle\\sum_{k=0}^{n}u_k'],
    ['Σ₁ⁿuₖ', '\\displaystyle\\sum_{k=1}^{n}u_k'],
    ['Σqⁿ', '\\displaystyle\\sum_{n=0}^{\\infty}q^n'],
    ['uₙ₊₁/uₙ', '\\frac{u_{n+1}}{u_n}'],
    ['1/(1−q)', '\\frac{1}{1-q}'],
    ['p/100', '\\frac{p}{100}'],
    ['uₙ₊₁=uₙ+r', 'u_{n+1}=u_n+r'],
    ['uₙ=u₀+nr', 'u_n=u_0+nr'],
    ['uₙ=u₁+(n−1)r', 'u_n=u_1+(n-1)r'],
    ['uₙ₊₁=q uₙ', 'u_{n+1}=qu_n'],
    ['uₙ=u₀qⁿ', 'u_n=u_0q^n'],
    ['uₙ=u₁qⁿ⁻¹', 'u_n=u_1q^{n-1}'],
    ['uₙ₊₁=a uₙ+b', 'u_{n+1}=au_n+b'],
    ['ℓ=b/(1−a)', '\\ell=\\frac{b}{1-a}'],
    ['ℓ=aℓ+b', '\\ell=a\\ell+b'],
    ['vₙ=uₙ−ℓ', 'v_n=u_n-\\ell'],
    ['vₙ₊₁=a vₙ', 'v_{n+1}=av_n'],
    ['uₙ=ℓ+(u₀−ℓ)aⁿ', 'u_n=\\ell+(u_0-\\ell)a^n'],
    ['uₙ=ℓ+(u₁−ℓ)aⁿ⁻¹', 'u_n=\\ell+(u_1-\\ell)a^{n-1}'],
    ['uₙ₊₁=uₙ+b', 'u_{n+1}=u_n+b'],
    ['uₙ=u₀+nb', 'u_n=u_0+nb'],
    ['uₙ₊₁−uₙ=d(q−1)qⁿ', 'u_{n+1}-u_n=d(q-1)q^n'],
    ['Cₙ=C₀(1+t)ⁿ', 'C_n=C_0(1+t)^n'],
    ['q=1−p/100', 'q=1-\\frac{p}{100}'],
    ['q=1+t', 'q=1+t'],
    ['qⁿ→+∞', 'q^n\\to +\\infty'],
    ['qⁿ→0', 'q^n\\to 0'],
    ['uₙ₊₁−uₙ', 'u_{n+1}-u_n'],
    ['|q|<1', '|q|<1'],
    ['q≠1', 'q\\ne 1'],
    ['u₀=100', 'u_0=100'],
    ['u₀=20', 'u_0=20']
  ].sort((a,b) => b[0].length - a[0].length);

  const pending = new Set();
  const escapeHTML = (s) => String(s).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
  function formatText(source) {
    const pending = [];
    let text = String(source);
    for (const [plain, tex] of equations) {
      if (!text.includes(plain)) continue;
      const marker = '@@MATH_' + pending.length + '@@';
      text = text.split(plain).join(marker);
      pending.push([marker, tex]);
    }
    text = escapeHTML(text).replace(/\n/g, '<br>');
    for (const [marker, tex] of pending) text = text.replaceAll(marker, '\\( ' + tex + ' \\)');
    return text;
  }

  function typeset() {
    const root = document.querySelector('#content');
    if (!root) return;
    const targets = [];
    root.querySelectorAll('.flashcard h2.math-expression').forEach(heading => {
      const flashcard = heading.closest('.flashcard');
      if (!flashcard) return;
      flashcard.classList.add('math-card');
      if (heading.dataset.mathSource === undefined) {
        heading.dataset.mathSource = heading.textContent;
        heading.classList.add('math-expression');
        heading.innerHTML = formatText(heading.dataset.mathSource);
        targets.push(heading);
      }
    });
    root.querySelectorAll('.course-item').forEach(item => {
      if (!item.querySelector('.muted')?.textContent.includes('Mathématiques appliquées')) return;
      const pre = item.querySelector('pre');
      if (!pre) return;
      const content = document.createElement('div');
      content.className = 'math-notes';
      content.dataset.mathSource = pre.textContent;
      content.innerHTML = formatText(content.dataset.mathSource);
      pre.replaceWith(content);
      targets.push(content);
    });
    targets.forEach(node => pending.add(node));
    if (!window.MathJax?.typesetPromise || !pending.size) return;
    const ready = pending.size ? [...pending] : [];
    pending.clear();
    window.MathJax.startup.promise.then(() => window.MathJax.typesetPromise(ready.filter(node => node.isConnected))).catch(() => {});
  }

  const root = document.querySelector('#content');
  if (root) new MutationObserver(typeset).observe(root, {childList:true,subtree:true});
  document.addEventListener('mathjax-ready', typeset);
  document.addEventListener('DOMContentLoaded', typeset, {once:true});
  setInterval(typeset, 500);
  typeset();
})();
