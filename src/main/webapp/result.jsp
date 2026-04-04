<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Conversion Réussie | Document Converter</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    
    <style>
        body {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            min-height: 100vh;
            padding: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .container {
            max-width: 900px;
            margin-top: 40px;
        }
        
        .success-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            border: none;
        }
        
        .success-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .success-body {
            padding: 40px;
        }
        
        .file-info-card {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            border-left: 5px solid #28a745;
            margin: 30px 0;
        }
        
        .action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 40px 0;
        }
        
        .action-card {
            background: white;
            border: 2px solid #e9ecef;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
        }
        
        .action-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            text-decoration: none;
            color: inherit;
        }
        
        .action-card.download {
            border-color: #007bff;
            background: linear-gradient(135deg, rgba(0, 123, 255, 0.05) 0%, rgba(0, 86, 179, 0.05) 100%);
        }
        
        .action-card.preview {
            border-color: #17a2b8;
            background: linear-gradient(135deg, rgba(23, 162, 184, 0.05) 0%, rgba(13, 110, 253, 0.05) 100%);
        }
        
        .action-card.whatsapp {
            border-color: #25D366;
            background: linear-gradient(135deg, rgba(37, 211, 102, 0.05) 0%, rgba(18, 140, 126, 0.05) 100%);
        }
        
        .action-card.telegram {
            border-color: #0088cc;
            background: linear-gradient(135deg, rgba(0, 136, 204, 0.05) 0%, rgba(0, 85, 128, 0.05) 100%);
        }
        
        .action-icon {
            font-size: 3.5rem;
            margin-bottom: 20px;
        }
        
        .action-card.download .action-icon { color: #007bff; }
        .action-card.preview .action-icon { color: #17a2b8; }
        .action-card.whatsapp .action-icon { color: #25D366; }
        .action-card.telegram .action-icon { color: #0088cc; }
        
        .btn-new-conversion {
            background: linear-gradient(135deg, #6f42c1 0%, #4a1d96 100%);
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }
        
        .btn-new-conversion:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(111, 66, 193, 0.3);
            color: white;
        }
        
        .conversion-badge {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 0.9rem;
            margin: 5px;
        }
        
        .badge-success { background: #28a745; color: white; }
        .badge-pdf { background: #dc3545; color: white; }
        .badge-word { background: #0d6efd; color: white; }
        .badge-excel { background: #198754; color: white; }
        .badge-text { background: #6c757d; color: white; }
        
        .modal-content {
            border-radius: 15px;
            border: none;
        }
        
        .file-content-preview {
            max-height: 500px;
            overflow-y: auto;
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            font-family: 'Courier New', monospace;
            font-size: 14px;
            white-space: pre-wrap;
        }
        
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            display: none;
        }
    </style>
</head>
<body>
    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="text-center">
            <div class="spinner-border text-light" style="width: 3rem; height: 3rem;"></div>
            <h4 class="text-white mt-3" id="loadingText">Chargement en cours...</h4>
        </div>
    </div>
    
    <!-- Modal pour l'aperçu -->
    <div class="modal fade" id="previewModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="bi bi-eye me-2"></i>Aperçu du fichier</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="previewContent" class="file-content-preview">
                        Chargement de l'aperçu...
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                    <button type="button" class="btn btn-primary" onclick="downloadFile()">
                        <i class="bi bi-download me-2"></i>Télécharger
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="success-card">
            <!-- En-tête -->
            <div class="success-header">
                <i class="bi bi-check-circle" style="font-size: 5rem; margin-bottom: 20px;"></i>
                <h1 class="mb-3">Conversion Réussie !</h1>
                <p class="lead mb-0">Votre document a été converti avec succès</p>
            </div>
            
            <!-- Corps -->
            <div class="success-body">
                <%
                    // Récupérer les données de la session
                    String convertedFile = (String) session.getAttribute("convertedFile");
                    String outputType = (String) session.getAttribute("outputType");
                    String conversionMessage = (String) session.getAttribute("conversionMessage");
                    String originalFile = (String) session.getAttribute("uploadedFile");
                    String convertedPath = (String) session.getAttribute("convertedPath");
                    
                    // Vérifier si on a un fichier converti
                    if (convertedFile == null || convertedPath == null) {
                        response.sendRedirect("upload.jsp");
                        return;
                    }
                    
                    // Déterminer le badge selon le type
                    String badgeClass = "badge-success";
                    if ("pdf".equals(outputType)) {
                        badgeClass = "badge-pdf";
                    } else if ("word".equals(outputType)) {
                        badgeClass = "badge-word";
                    } else if ("excel".equals(outputType)) {
                        badgeClass = "badge-excel";
                    } else if ("text".equals(outputType)) {
                        badgeClass = "badge-text";
                    }
                %>
                
                <!-- Message de confirmation -->
                <div class="alert alert-success" role="alert">
                    <div class="d-flex align-items-center">
                        <i class="bi bi-check-circle-fill fs-2 me-3"></i>
                        <div>
                            <h4 class="alert-heading mb-2">
                                <%= conversionMessage != null ? conversionMessage : "Conversion terminée avec succès !" %>
                            </h4>
                            <p class="mb-0">Votre fichier est prêt à être téléchargé ou partagé.</p>
                        </div>
                    </div>
                </div>
                
                <!-- Informations sur les fichiers -->
                <div class="file-info-card">
                    <h5 class="mb-4"><i class="bi bi-info-circle me-2"></i>Détails de la conversion</h5>
                    
                    <div class="row">
                        <!-- Fichier original -->
                        <div class="col-md-6 mb-4">
                            <h6 class="text-muted mb-3">
                                <i class="bi bi-file-earmark me-2"></i>Fichier original
                            </h6>
                            <div class="d-flex align-items-center">
                                <%
                                    String originalIcon = "bi-file-earmark";
                                    String originalColor = "text-secondary";
                                    if (originalFile != null) {
                                        if (originalFile.toLowerCase().endsWith(".pdf")) {
                                            originalIcon = "bi-file-earmark-pdf";
                                            originalColor = "text-danger";
                                        } else if (originalFile.toLowerCase().endsWith(".doc") || originalFile.toLowerCase().endsWith(".docx")) {
                                            originalIcon = "bi-file-earmark-word";
                                            originalColor = "text-primary";
                                        } else if (originalFile.toLowerCase().endsWith(".xls") || originalFile.toLowerCase().endsWith(".xlsx")) {
                                            originalIcon = "bi-file-earmark-excel";
                                            originalColor = "text-success";
                                        }
                                    }
                                %>
                                <i class="bi <%= originalIcon %> <%= originalColor %> fs-1 me-3"></i>
                                <div>
                                    <h5 class="mb-1"><%= originalFile != null ? originalFile : "Document source" %></h5>
                                    <span class="badge bg-secondary">ORIGINAL</span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Fichier converti -->
                        <div class="col-md-6 mb-4">
                            <h6 class="text-muted mb-3">
                                <i class="bi bi-file-earmark-check me-2"></i>Fichier converti
                            </h6>
                            <div class="d-flex align-items-center">
                                <%
                                    String convertedIcon = "bi-file-earmark-check";
                                    String convertedColor = "text-success";
                                    if ("pdf".equals(outputType)) {
                                        convertedIcon = "bi-file-earmark-pdf";
                                        convertedColor = "text-danger";
                                    } else if ("word".equals(outputType)) {
                                        convertedIcon = "bi-file-earmark-word";
                                        convertedColor = "text-primary";
                                    } else if ("excel".equals(outputType)) {
                                        convertedIcon = "bi-file-earmark-excel";
                                        convertedColor = "text-success";
                                    } else if ("text".equals(outputType)) {
                                        convertedIcon = "bi-file-earmark-text";
                                        convertedColor = "text-secondary";
                                    }
                                %>
                                <i class="bi <%= convertedIcon %> <%= convertedColor %> fs-1 me-3"></i>
                                <div>
                                    <h5 class="mb-1" id="convertedFileName"><%= convertedFile %></h5>
                                    <span class="conversion-badge <%= badgeClass %>">
                                        <%= outputType != null ? outputType.toUpperCase() : "CONVERTI" %>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Timestamp -->
                    <div class="alert alert-light mt-3">
                        <i class="bi bi-clock-history me-2"></i>
                        Conversion effectuée le <strong><%= new java.util.Date() %></strong>
                    </div>
                </div>
                
                <!-- Actions disponibles -->
                <h4 class="mb-4 text-center">
                    <i class="bi bi-lightning me-2"></i>Que souhaitez-vous faire ?
                </h4>
                
                <div class="action-grid">
                    <!-- Téléchargement -->
                    <a href="javascript:void(0)" class="action-card download" onclick="downloadFile()">
                        <div class="action-icon">
                            <i class="bi bi-download"></i>
                        </div>
                        <h4>Télécharger</h4>
                        <p class="text-muted mb-0">
                            Téléchargez le fichier converti sur votre appareil
                        </p>
                        <div class="mt-3">
                            <span class="badge bg-primary">
                                <i class="bi bi-arrow-down me-1"></i>Format <%= outputType != null ? outputType.toUpperCase() : "" %>
                            </span>
                        </div>
                    </a>
                    
                    <!-- Aperçu -->
                    <a href="javascript:void(0)" class="action-card preview" onclick="showFilePreview()">
                        <div class="action-icon">
                            <i class="bi bi-eye"></i>
                        </div>
                        <h4>Aperçu</h4>
                        <p class="text-muted mb-0">
                            Visualisez le contenu avant de télécharger
                        </p>
                        <div class="mt-3">
                            <span class="badge bg-info">
                                <i class="bi bi-search me-1"></i>Visualisation
                            </span>
                        </div>
                    </a>
                    
                    <!-- WhatsApp -->
                    <a href="javascript:void(0)" class="action-card whatsapp" onclick="shareWhatsApp()">
                        <div class="action-icon">
                            <i class="bi bi-whatsapp"></i>
                        </div>
                        <h4>WhatsApp</h4>
                        <p class="text-muted mb-0">
                            Partagez directement sur WhatsApp
                        </p>
                        <div class="mt-3">
                            <span class="badge bg-success">
                                <i class="bi bi-share me-1"></i>Partage
                            </span>
                        </div>
                    </a>
                    
                    <!-- Telegram -->
                    <a href="javascript:void(0)" class="action-card telegram" onclick="shareTelegram()">
                        <div class="action-icon">
                            <i class="bi bi-telegram"></i>
                        </div>
                        <h4>Telegram</h4>
                        <p class="text-muted mb-0">
                            Envoyez via Telegram
                        </p>
                        <div class="mt-3">
                            <span class="badge bg-primary">
                                <i class="bi bi-send me-1"></i>Envoi
                            </span>
                        </div>
                    </a>
                </div>
                
                <!-- Nouvelle conversion -->
                <div class="text-center mt-5 pt-4 border-top">
                    <h5 class="mb-4">Souhaitez-vous effectuer une autre conversion ?</h5>
                    <a href="upload.jsp" class="btn btn-new-conversion">
                        <i class="bi bi-plus-circle me-2"></i>Nouvelle Conversion
                    </a>
                    <p class="text-muted mt-3">
                        <i class="bi bi-arrow-repeat me-1"></i>
                        Convertissez un autre fichier
                    </p>
                </div>
                
                <!-- Debug info (caché par défaut) -->
                <details class="mt-4">
                    <summary class="text-muted" style="cursor: pointer;">
                        <i class="bi bi-bug me-2"></i>Informations de débogage
                    </summary>
                    <div class="alert alert-secondary mt-2">
                        <p class="mb-1 small">
                            <strong>Fichier converti :</strong> <%= convertedFile %><br>
                            <strong>Chemin :</strong> <%= convertedPath %><br>
                            <strong>Type :</strong> <%= outputType %><br>
                            <strong>Session ID :</strong> <%= session.getId() %>
                        </p>
                    </div>
                </details>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Variables globales
        const convertedFileName = '<%= convertedFile %>';
        const outputType = '<%= outputType %>';
        
        // Fonction pour afficher l'aperçu
        function showFilePreview() {
            console.log("Ouverture de l'aperçu pour : " + convertedFileName);
            
            // Afficher l'overlay de chargement
            showLoading('Préparation de l\'aperçu...');
            
            // Récupérer le contenu du fichier via AJAX
            fetch('preview?file=' + encodeURIComponent(convertedFileName))
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Erreur lors du chargement de l\'aperçu');
                    }
                    return response.text();
                })
                .then(content => {
                    // Afficher le contenu dans le modal
                    document.getElementById('previewContent').innerHTML = content;
                    
                    // Afficher le modal
                    const previewModal = new bootstrap.Modal(document.getElementById('previewModal'));
                    previewModal.show();
                    
                    // Cacher l'overlay
                    hideLoading();
                })
                .catch(error => {
                    console.error('Erreur:', error);
                    hideLoading();
                    
                    // Afficher un message d'erreur
                    document.getElementById('previewContent').innerHTML = 
                        '<div class="alert alert-warning">' +
                        '<i class="bi bi-exclamation-triangle me-2"></i>' +
                        'Impossible de charger l\'aperçu. ' +
                        '<button class="btn btn-sm btn-outline-warning mt-2" onclick="downloadFile()">' +
                        '<i class="bi bi-download me-1"></i>Télécharger directement' +
                        '</button>' +
                        '</div>';
                    
                    const previewModal = new bootstrap.Modal(document.getElementById('previewModal'));
                    previewModal.show();
                });
        }
        
        // Fonction pour télécharger le fichier
        function downloadFile() {
            console.log("Téléchargement de : " + convertedFileName);
            
            // Afficher l'overlay de chargement
            showLoading('Préparation du téléchargement...');
            
            // Créer un lien de téléchargement
            const downloadLink = document.createElement('a');
            downloadLink.href = 'download?file=' + encodeURIComponent(convertedFileName);
            downloadLink.download = convertedFileName;
            downloadLink.style.display = 'none';
            
            // Ajouter au document et cliquer
            document.body.appendChild(downloadLink);
            downloadLink.click();
            document.body.removeChild(downloadLink);
            
            // Cacher l'overlay après un délai
            setTimeout(() => {
                hideLoading();
                
                // Afficher une notification de succès
                showToast('Téléchargement lancé !', 'success');
            }, 1000);
        }
        
        // Fonctions de partage
        function shareWhatsApp() {
            const fileName = convertedFileName;
            const downloadUrl = window.location.origin + 
                               '/DocumentConverter/download?file=' + 
                               encodeURIComponent(fileName);
            const text = '📄 Document converti : ' + fileName + 
                        '\n\n📥 Télécharger : ' + downloadUrl + 
                        '\n\n🔗 Converti avec Document Converter';
            
            const url = 'https://wa.me/?text=' + encodeURIComponent(text);
            window.open(url, '_blank');
            
            showToast('WhatsApp ouvert pour le partage !', 'success');
        }
        
        function shareTelegram() {
            const fileName = convertedFileName;
            const downloadUrl = window.location.origin + 
                               '/DocumentConverter/download?file=' + 
                               encodeURIComponent(fileName);
            const text = '📄 Document converti : ' + fileName + 
                        '\n\n📥 Télécharger : ' + downloadUrl;
            
            const url = 'https://t.me/share/url?url=' + 
                       encodeURIComponent(downloadUrl) + 
                       '&text=' + encodeURIComponent(text);
            window.open(url, '_blank');
            
            showToast('Telegram ouvert pour le partage !', 'info');
        }
        
        // Fonctions utilitaires
        function showLoading(message) {
            document.getElementById('loadingText').textContent = message;
            document.getElementById('loadingOverlay').style.display = 'flex';
        }
        
        function hideLoading() {
            document.getElementById('loadingOverlay').style.display = 'none';
        }
        
        function showToast(message, type = 'info') {
            // Créer le toast
            const toastHTML = `
                <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 1050">
                    <div class="toast align-items-center text-white bg-${type} border-0" role="alert">
                        <div class="d-flex">
                            <div class="toast-body">
                                <i class="bi bi-${type == 'success' ? 'check-circle' : 'info-circle'} me-2"></i>
                                ${message}
                            </div>
                            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                        </div>
                    </div>
                </div>
            `;
            
            // Ajouter au document
            document.body.insertAdjacentHTML('beforeend', toastHTML);
            
            // Afficher le toast
            const toastEl = document.querySelector('.toast');
            const toast = new bootstrap.Toast(toastEl);
            toast.show();
            
            // Supprimer après fermeture
            toastEl.addEventListener('hidden.bs.toast', function() {
                this.parentElement.remove();
            });
        }
        
        // Auto-téléchargement optionnel (désactivé par défaut)
        // setTimeout(() => {
        //     console.log("Auto-téléchargement dans 2 secondes...");
        //     // downloadFile();
        // }, 2000);
        
        // Initialisation
        document.addEventListener('DOMContentLoaded', function() {
            console.log("Page de résultat chargée");
            console.log("Fichier à télécharger : " + convertedFileName);
            console.log("Type de fichier : " + outputType);
            
            // Vérifier si le fichier existe côté serveur
            checkFileAvailability();
        });
        
        // Vérifier la disponibilité du fichier
        function checkFileAvailability() {
            fetch('checkfile?file=' + encodeURIComponent(convertedFileName))
                .then(response => {
                    if (!response.ok) {
                        console.warn("Fichier non trouvé sur le serveur");
                        // Afficher un avertissement discret
                        const debugSection = document.querySelector('details');
                        if (debugSection) {
                            const warning = document.createElement('div');
                            warning.className = 'alert alert-warning mt-2 small';
                            warning.innerHTML = '<i class="bi bi-exclamation-triangle me-2"></i>Le fichier pourrait ne pas être disponible sur le serveur.';
                            debugSection.appendChild(warning);
                        }
                    } else {
                        console.log("Fichier disponible sur le serveur");
                    }
                })
                .catch(error => {
                    console.error("Erreur de vérification :", error);
                });
        }
    </script>
</body>
</html>