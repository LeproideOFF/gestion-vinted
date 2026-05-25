# 🛍️ Gestion Vinted Pro - P2P Serverless

Une solution ultra-premium, 100% privée et sans serveur, pour gérer votre inventaire Vinted comme un professionnel. Développé intégralement par **leprodie**.

---

## 🌟 Le Concept
Cette application a été conçue pour les "Power Users" de Vinted qui souhaitent une gestion totale de leurs stocks et de leur rentabilité, sans dépendre d'un cloud ou d'un serveur tiers. Toutes vos données restent sur vos appareils.

## 🚀 Fonctionnalités Majeures

### 💎 Interface & Expérience (UX)
*   **Design Liquid Glass :** Une esthétique moderne en verre dépoli avec des effets de flou en temps réel.
*   **Mode Sombre Intégral :** Adaptation automatique au système pour une utilisation confortable jour et nuit.
*   **Gestes de Glissement (Swipes) :** Modifiez ou supprimez vos articles d'un simple geste sur mobile.
*   **Barre de Navigation Flottante :** Navigation fluide entre l'inventaire, les stats et la synchro.
*   **Animations Fluides :** Transitions et retours visuels soignés pour une sensation "Premium".

### 📊 Business & Finance
*   **Calculateur de Profit Avancé :** Distinction précise entre coûts d'achat (prix, frais port, frais Vinted, emballage) et prix de revente.
*   **Tableau de Bord Dynamique :** Visualisez votre bénéfice net total, votre ROI moyen et vos ventes potentielles.
*   **Objectifs de Ventes :** Suivez votre progression mensuelle avec une barre de complétion interactive.
*   **Statistiques de Rotation :** Analysez le pourcentage de votre stock vendu pour optimiser vos achats.
*   **Export CSV (Desktop) :** Exportez tout votre inventaire en un clic pour votre comptabilité.

### 🔍 Logistique & Scan
*   **Recherche avec Scan QR :** Trouvez un article instantanément dans votre stock en scannant son code.
*   **Génération de QR Codes :** Générez des étiquettes uniques pour chaque article à imprimer et coller sur vos bacs de rangement.
*   **Gestion des Emplacements :** Notez précisément où se trouve chaque article (ex: Bac A, Étagère 2).
*   **Scan de Code-Barres :** Intégration pour scanner les codes-barres existants.
*   **Suivi de Colis :** Enregistrez vos numéros de suivi directement dans la fiche article.

### 🔄 Synchronisation Magique P2P
*   **Transfert Sans Serveur :** Synchronisez vos iPhones, iPads et Macs entre eux via le réseau local.
*   **Partage d'Images :** Transfert automatique des photos haute résolution lors de la synchro.
*   **Appairage par Code PIN :** Connexion sécurisée entre appareils avec une animation radar stylisée.
*   **Résolution de Conflits :** Fusion intelligente des données basée sur l'horodatage le plus récent.

### 🤖 Assistants Intégrés
*   **IA de Description :** Générateur automatique de textes d'annonces propres et optimisés.
*   **IA d'Estimation :** Aide à la fixation du prix de vente basée sur les caractéristiques de l'objet.
*   **Générateur de Mots-Clés :** Création automatique de hashtags pour booster vos ventes.

---

## 🛠 Stack Technique
*   **Framework :** Flutter (Multiplateforme iOS / macOS / Android / Windows)
*   **Base de données :** Isar (NoSQL local ultra-performant)
*   **Gestion d'état :** Riverpod
*   **UI/Animations :** flutter_animate, Google Fonts (Poppins)
*   **Connectivité :** mDNS (nsd), Sockets TCP, mobile_scanner
*   **Stockage :** Gestion permanente des fichiers locaux via Path Provider

---

## 💻 Installation (Développeur)

1.  **Prérequis :** Flutter SDK, Xcode (pour iOS/macOS), CocoaPods.
2.  **Cloner le dépôt.**
3.  **Installer les dépendances :**
    ```bash
    flutter pub get
    ```
4.  **Générer le code Isar/Riverpod :**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
5.  **Lancer l'application :**
    ```bash
    flutter run
    ```

---

*Développé avec passion par **leprodie**.*
