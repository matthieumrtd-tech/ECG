# Montaigne ECG — espace de révision

Site statique gratuit (HTML/CSS/JS), sans abonnement ni backend. Les flashcards et tâches sont sauvegardées dans le navigateur (`localStorage`).

## Lancer en local
Ouvrir `index.html` dans un navigateur. Pour éviter les limites du mode fichier, lancer un serveur local :
`python3 -m http.server 8000` puis ouvrir `http://localhost:8000`.

## Publier gratuitement avec GitHub Pages
1. Créer/ouvrir un dépôt GitHub.
2. Déposer le contenu de ce dossier à la racine du dépôt.
3. Dans Settings → Pages, choisir Deploy from a branch, branche `main`, dossier `/root`.
4. GitHub fournit une adresse `https://<pseudo>.github.io/<repo>/`.

## Limites actuelles
- Version initiale : cours/annales sont des espaces d'accueil, pas une banque de contenu préremplie.
- Données enregistrées localement sur chaque appareil; elles ne se synchronisent pas automatiquement entre appareils.
- Aucun compte utilisateur ni partage collectif pour le moment.
