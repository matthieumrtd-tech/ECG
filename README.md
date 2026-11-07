# Montaigne ECG

Application personnelle de révisions ECG publiée sur GitHub Pages et reliée au projet Supabase Montaigne ECG.

## Fonctions disponibles

- Compte email/mot de passe Supabase, persistance locale, sauvegarde distante, fusion atomique par identifiant, suppressions tombstone et mises à jour temps réel. Le schéma avec RLS propriétaire a été appliqué au projet.
- Dashboard, matières, planning, statistiques, répétition espacée inspirée de SM-2, création/modification/suppression de flashcards.
- Chapitres et sous-chapitres, cours et fiches éditables.
- Import de documents TXT, Markdown, CSV simple, PDF et DOCX. PDF.js/Mammoth s’exécutent côté navigateur et sont chargés depuis un CDN gratuit lors de l’import.
- Génération de cartes candidates uniquement depuis des blocs Q/R ou des lignes de définitions, avec aperçu avant ajout. Aucun contenu de cours n’est inventé.
- PWA : manifeste, service worker de cache, icônes et métadonnées iOS.

## Import et données

Les cours sont extraits dans le navigateur puis enregistrés dans la sauvegarde Supabase lorsque le compte est connecté. L’import PDF/DOCX nécessite une connexion internet pour télécharger le lecteur open source. Une image de cours scannée sans couche texte ne peut pas être transcrite automatiquement. Les documents sont limités à 20 Mo et 200 000 caractères extraits.

## Limites restantes

- Répétition espacée : variante de SM-2, pas FSRS.
- Les cartes sont encore principalement en texte ; l’insertion d’images, la mise en forme riche et les tableaux dédiés restent à compléter.
- Le partage de données en temps réel a été vérifié côté synchronisation du compte et ligne cloud ; un second appareil n’a pas encore été connecté pour un test de bout en bout.
