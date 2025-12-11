document.addEventListener('DOMContentLoaded', function () {

function highlightElementFromHash() {
  // Získáme fragment z URL (např. "#myId")
  const hash = window.location.hash.substring(1); // odstraníme '#'
  if (!hash) return;

  // Předpokládáme, že máme webovou komponentu s tagem 'pb-view'
  const webComponent = document.querySelector('pb-view');
  if (!webComponent || !webComponent.shadowRoot) return;

  // Nejprve odstraníme předchozí zvýraznění (pokud existuje)
  const previouslyFound = webComponent.shadowRoot.querySelector('.found');
  if (previouslyFound) {
    previouslyFound.classList.remove('found');
  }

  // Najdeme prvek s odpovídajícím id uvnitř shadow rootu
  const targetElement = webComponent.shadowRoot.getElementById(hash);
  if (targetElement) {
    // Přidáme CSS třídu 'found' pro zvýraznění
    targetElement.classList.add('found');
    targetElement.scrollIntoView({ behavior: 'smooth' });
  }
}

// Spustíme po načtení stránky a při změně hash v URL
window.addEventListener('load', highlightElementFromHash);
window.addEventListener('hashchange', highlightElementFromHash);
});
