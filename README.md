![License](https://img.shields.io/badge/license-MIT-green)
![Delphi](https://img.shields.io/badge/Delphi-RAD%20Studio-red)
![Build](https://img.shields.io/badge/build-stable-brightgreen)
![Status](https://img.shields.io/badge/status-active-blue)

# AssetForge 🔨

> Deterministic asset hashing for cache-safe production deployments.

AssetForge is a lightweight, open-source build tool written in Delphi that provides content-based asset versioning for modern web deployments.

It ensures browsers always receive the correct asset version while allowing aggressive HTTP caching.

---

## ✨ Why AssetForge?

Browser caching issues are one of the most common production problems.
AssetForge solves this by:

- 🔐 Generating SHA-256 content hashes
- 🏷 Renaming assets with deterministic version identifiers
- 🔁 Updating HTML references automatically
- ⚡ Supporting incremental builds
- 📦 Keeping source files untouched
- 📄 Generating a manifest.json for traceability
- 🚀 Example

## 🚀 Example

Input

```
<script src="assets/app.js"></script>
<link rel="stylesheet" href="assets/style.css">
```


```
<script src="assets/app.3f2c9ab4a1bc.js"></script>
<link rel="stylesheet" href="assets/style.a91e44dd82fa.css">
```

Safe to cache forever.

---

📦 Features
- SHA-256 hashing
- Incremental build detection
- Manifest generation
- Clean dist/ output directory
- CLI-friendly
- CI/CD ready

---

🔧 Installation


Clone the repository:


```
git clone https://github.com/yourname/AssetForge.git
```

Build using Delphi (RAD Studio).

---

🖥 Usage

```
assetforge build --src ./src --dist ./dist --prod
```

options

```
--src     Source directory
--dist    Output directory
--prod    Enable hashing mode
--dev     Disable hashing (development mode)
```

---

🤝 Contributing

Contributions are welcome.


If you find a bug or have an improvement idea:


- Open an issue
- Submit a pull request

---


📄 License
MIT License — free for commercial and private use.
