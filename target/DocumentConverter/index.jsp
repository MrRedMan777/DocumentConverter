<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DocConvert Pro | Conversion Intelligente</title>
    
    <!-- CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        .conversion-step {
            padding: 2rem;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
            height: 100%;
        }
        
        .conversion-step:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.1);
        }
        
        .step-number {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            margin-bottom: 1rem;
        }
        
        .feature-list li {
            padding: 0.5rem 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .feature-list li:last-child {
            border-bottom: none;
        }
        
        .cta-button {
            padding: 1rem 2.5rem;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }
        
        .cta-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
            color: white;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-glass">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="bi bi-magic brand-icon"></i>
                DocConvert Pro
            </a>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="index.jsp">
                            <i class="bi bi-house"></i> Accueil
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="upload.jsp">
                            <i class="bi bi-upload"></i> Convertir
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-primary-glow btn-glow ms-3" href="upload.jsp">
                            <i class="bi bi-lightning"></i> Commencer
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="hero-title mb-4">
                        Transformez vos documents
                        <span class="d-block text-gradient">en un clic</span>
                    </h1>
                    <p class="hero-subtitle mb-4">
                        L'ING. CADET Clive Tod D. porte une solution complète pour convertir vos fichiers PDF, Word et Excel.
                        Rapide, sécurisé et d'une simplicité élégante.
                    </p>
                    <a href="upload.jsp" class="cta-button">
                        <i class="bi bi-upload"></i> Commencer la conversion
                    </a>
                </div>
                <div class="col-lg-6">
                    <div class="glass-card p-4">
                        <img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png" 
                             alt="Conversion" class="img-fluid">
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Conversion Steps -->
    <section class="py-5">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="display-5 fw-bold text-white mb-3">
                    Conversion en 3 étapes simples
                </h2>
                <p class="text-muted">Notre processus intuitif vous guide de A à Z</p>
            </div>
            
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="conversion-step fade-in">
                        <div class="step-number">1</div>
                        <h4 class="text-white mb-3">Upload</h4>
                        <p class="text-muted">
                            Téléchargez votre document PDF, Word ou Excel.
                            Supporte tous les formats courants.
                        </p>
                        <div class="mt-3">
                            <span class="badge-glow me-2">PDF</span>
                            <span class="badge-glow me-2">DOC</span>
                            <span class="badge-glow">XLS</span>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <div class="conversion-step fade-in" style="animation-delay: 0.2s">
                        <div class="step-number">2</div>
                        <h4 class="text-white mb-3">Convertir</h4>
                        <p class="text-muted">
                            Choisissez le format de sortie et lancez la conversion.
                            Notre technologie s'occupe de tout.
                        </p>
                        <div class="mt-3">
                            <span class="badge-glow me-2">Word</span>
                            <span class="badge-glow me-2">PDF</span>
                            <span class="badge-glow">Excel</span>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <div class="conversion-step fade-in" style="animation-delay: 0.4s">
                        <div class="step-number">3</div>
                        <h4 class="text-white mb-3">Télécharger</h4>
                        <p class="text-muted">
                            Récupérez votre fichier converti.
                            Partagez-le ou téléchargez-le instantanément.
                        </p>
                        <div class="mt-3">
                            <span class="badge-glow me-2">
                                <i class="bi bi-download"></i>
                            </span>
                            <span class="badge-glow me-2">
                                <i class="bi bi-whatsapp"></i>
                            </span>
                            <span class="badge-glow">
                                <i class="bi bi-telegram"></i>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features -->
    <section class="py-5 bg-dark">
        <div class="container">
            <div class="row">
                <div class="col-lg-6 mb-4">
                    <div class="glass-card p-4">
                        <h3 class="text-white mb-4">
                            <i class="bi bi-lightning text-warning me-2"></i>
                            Fonctionnalités principales
                        </h3>
                        <ul class="feature-list list-unstyled">
                            <li class="text-white">
                                <i class="bi bi-check-circle-fill text-success me-2"></i>
                                Conversion PDF → Word
                            </li>
                            <li class="text-white">
                                <i class="bi bi-check-circle-fill text-success me-2"></i>
                                Conversion Word → PDF
                            </li>
                            <li class="text-white">
                                <i class="bi bi-check-circle-fill text-success me-2"></i>
                                Conversion PDF → Excel
                            </li>
                            <li class="text-white">
                                <i class="bi bi-check-circle-fill text-success me-2"></i>
                                Support multi-formats
                            </li>
                            <li class="text-white">
                                <i class="bi bi-check-circle-fill text-success me-2"></i>
                                Partage instantané
                            </li>
                        </ul>
                    </div>
                </div>
                
                <div class="col-lg-6">
                    <div class="glass-card p-4">
                        <h3 class="text-white mb-4">
                            <i class="bi bi-shield-check text-primary me-2"></i>
                            Sécurité garantie
                        </h3>
                        <p class="text-muted">
                            Vos fichiers sont traités de manière sécurisée :
                        </p>
                        <div class="row mt-3">
                            <div class="col-6 mb-3">
                                <div class="text-center">
                                    <i class="bi bi-lock display-4 text-success"></i>
                                    <p class="text-white mt-2 mb-0">Chiffrement SSL</p>
                                </div>
                            </div>
                            <div class="col-6 mb-3">
                                <div class="text-center">
                                    <i class="bi bi-clock display-4 text-warning"></i>
                                    <p class="text-white mt-2 mb-0">Suppression auto</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA -->
    <section class="py-5">
        <div class="container text-center">
            <div class="glass-card p-5">
                <h2 class="display-6 fw-bold text-white mb-4">
                    Prêt à transformer vos documents ?
                </h2>
                <p class="text-muted mb-4 fs-5">
                    Essayez gratuitement notre service de conversion.
                </p>
                <a href="upload.jsp" class="cta-button btn-lg">
                    <i class="bi bi-magic"></i> Commencer maintenant
                </a>
            </div>
        </div>
    </section>

    <!-- JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Animation au scroll
        document.addEventListener('DOMContentLoaded', function() {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('fade-in');
                    }
                });
            });
            
            document.querySelectorAll('.fade-in').forEach(el => {
                observer.observe(el);
            });
        });
    </script>
</body>
</html>