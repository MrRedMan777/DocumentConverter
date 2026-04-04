<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Conversion de Documents</title>
    
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
            max-width: 800px;
            margin-top: 30px;
        }
        
        .card {
            background: white;
            border-radius: 15px;
            border: none;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 20px;
        }
        
        .step-indicator {
            display: flex;
            justify-content: center;
            margin-bottom: 30px;
            gap: 40px;
        }
        
        .step {
            text-align: center;
            position: relative;
        }
        
        .step-circle {
            width: 40px;
            height: 40px;
            background: #e9ecef;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin: 0 auto 10px;
            border: 3px solid transparent;
        }
        
        .step.active .step-circle {
            background: #667eea;
            color: white;
            border-color: #764ba2;
        }
        
        .step.completed .step-circle {
            background: #28a745;
            color: white;
            border-color: #218838;
        }
        
        .upload-area {
            border: 3px dashed #667eea;
            border-radius: 10px;
            padding: 40px 20px;
            text-align: center;
            background: #f8f9fa;
            cursor: pointer;
            margin: 20px 0;
            transition: all 0.3s ease;
        }
        
        .upload-area:hover {
            background: #e9ecef;
            border-color: #764ba2;
        }
        
        .file-preview {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin: 20px 0;
            border-left: 4px solid #667eea;
        }
        
        .conversion-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }
        
        .conversion-card {
            border: 2px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
        }
        
        .conversion-card:hover {
            border-color: #667eea;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.1);
        }
        
        .conversion-card.selected {
            border-color: #667eea;
            background: rgba(102, 126, 234, 0.05);
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .format-icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
        
        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 30px;
            border-radius: 50px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .alert-custom {
            border-radius: 10px;
            border: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Indicateur d'étapes -->
        <div class="step-indicator">
            <div class="step <%= (request.getParameter("step") == null || "upload".equals(request.getParameter("step"))) ? "active" : "completed" %>" id="step1">
                <div class="step-circle">1</div>
                <div>Upload</div>
            </div>
            <div class="step <%= "conversion".equals(request.getParameter("step")) ? "active" : "" %>" id="step2">
                <div class="step-circle">2</div>
                <div>Conversion</div>
            </div>
            <div class="step" id="step3">
                <div class="step-circle">3</div>
                <div>Résultat</div>
            </div>
        </div>
        
        <!-- Carte principale -->
        <div class="card">
            <div class="card-header text-center">
                <h3 class="mb-0"><i class="bi bi-file-earmark-arrow-up me-2"></i>Convertisseur de Documents</h3>
            </div>
            
            <div class="card-body p-4">
                <!-- Affichage des erreurs -->
                <% 
                    String error = (String) request.getAttribute("error");
                    if (error != null) { 
                %>
                    <div class="alert alert-danger alert-custom alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle me-2"></i>
                        <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                
                <!-- ÉTAPE 1: UPLOAD (visible par défaut) -->
                <div id="uploadSection" <%= "conversion".equals(request.getParameter("step")) ? "style='display:none;'" : "" %>>
                    <h4 class="mb-3 text-center">📁 Téléchargez votre fichier</h4>
                    
                    <form id="uploadForm" action="upload" method="post" enctype="multipart/form-data">
                        <div class="upload-area" onclick="document.getElementById('fileInput').click()">
                            <i class="bi bi-cloud-arrow-up" style="font-size: 3rem; color: #667eea;"></i>
                            <h5 class="mt-3">Glissez-déposez votre fichier ici</h5>
                            <p class="text-muted">ou cliquez pour sélectionner</p>
                            <p class="text-muted small mt-2">
                                Formats supportés : PDF, DOC, DOCX, XLS, XLSX, TXT<br>
                                Taille maximum : 10MB
                            </p>
                            <input type="file" name="file" id="fileInput" class="d-none" 
                                   accept=".pdf,.doc,.docx,.xls,.xlsx,.txt" required>
                        </div>
                        
                        <!-- Aperçu du fichier -->
                        <div id="filePreview" class="file-preview d-none">
                            <div class="d-flex align-items-center">
                                <i id="fileIcon" class="bi bi-file-earmark-pdf fs-1 me-3"></i>
                                <div>
                                    <h5 id="fileName" class="mb-1"></h5>
                                    <p id="fileSize" class="text-muted mb-0"></p>
                                    <p id="fileType" class="text-muted small"></p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="text-center mt-4">
                            <button type="submit" class="btn btn-primary-custom" id="uploadBtn" disabled>
                                <i class="bi bi-arrow-right me-2"></i>Continuer vers la conversion
                            </button>
                        </div>
                    </form>
                </div>
                
                <!-- ÉTAPE 2: CONVERSION (visible seulement après upload) -->
                <% 
                    String step = request.getParameter("step");
                    String uploadedFile = (String) session.getAttribute("uploadedFile");
                    String fileType = (String) session.getAttribute("fileType");
                    
                    if ("conversion".equals(step) && uploadedFile != null) {
                %>
                    <div id="conversionSection">
                        <h4 class="mb-3 text-center">🔄 Choisissez la conversion</h4>
                        
                        <!-- Info fichier uploadé -->
                        <div class="file-preview">
                            <div class="d-flex align-items-center">
                                <% 
                                    String iconClass = "bi-file-earmark-pdf";
                                    String iconColor = "text-danger";
                                    if ("word".equals(fileType)) {
                                        iconClass = "bi-file-earmark-word";
                                        iconColor = "text-primary";
                                    } else if ("excel".equals(fileType)) {
                                        iconClass = "bi-file-earmark-excel";
                                        iconColor = "text-success";
                                    } else if ("text".equals(fileType)) {
                                        iconClass = "bi-file-earmark-text";
                                        iconColor = "text-secondary";
                                    }
                                %>
                                <i class="bi <%= iconClass %> <%= iconColor %> fs-1 me-3"></i>
                                <div>
                                    <h5 class="mb-1"><%= uploadedFile %></h5>
                                    <p class="text-muted mb-0">Prêt pour conversion</p>
                                    <span class="badge bg-primary mt-1">
                                        <%= fileType != null ? fileType.toUpperCase() : "FICHIER" %>
                                    </span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Options de conversion -->
                        <h5 class="mt-4 mb-3">Sélectionnez le format de sortie :</h5>
                        
                        <form id="conversionForm" action="convert" method="post">
                            <div class="conversion-options" id="conversionOptions">
                                <% 
                                    // Générer les options selon le type de fichier
                                    if ("pdf".equals(fileType)) {
                                %>
                                    <!-- PDF → Word -->
                                    <div class="conversion-card" onclick="selectConversion('pdfToWord')">
                                        <div class="format-icon text-danger">
                                            <i class="bi bi-file-earmark-pdf"></i>
                                        </div>
                                        <div class="mb-2">
                                            <i class="bi bi-arrow-right"></i>
                                        </div>
                                        <div class="format-icon text-primary">
                                            <i class="bi bi-file-earmark-word"></i>
                                        </div>
                                        <h6 class="mt-2">PDF vers Word</h6>
                                        <p class="text-muted small mb-0">.docx</p>
                                        <input type="radio" name="conversionType" value="pdfToWord" class="d-none" checked>
                                    </div>
                                    
                                    <!-- PDF → Excel -->
                                    <div class="conversion-card" onclick="selectConversion('pdfToExcel')">
                                        <div class="format-icon text-danger">
                                            <i class="bi bi-file-earmark-pdf"></i>
                                        </div>
                                        <div class="mb-2">
                                            <i class="bi bi-arrow-right"></i>
                                        </div>
                                        <div class="format-icon text-success">
                                            <i class="bi bi-file-earmark-excel"></i>
                                        </div>
                                        <h6 class="mt-2">PDF vers Excel</h6>
                                        <p class="text-muted small mb-0">.xlsx</p>
                                        <input type="radio" name="conversionType" value="pdfToExcel" class="d-none">
                                    </div>
                                    
                                    <!-- PDF → Texte -->
                                    <div class="conversion-card" onclick="selectConversion('pdfToText')">
                                        <div class="format-icon text-danger">
                                            <i class="bi bi-file-earmark-pdf"></i>
                                        </div>
                                        <div class="mb-2">
                                            <i class="bi bi-arrow-right"></i>
                                        </div>
                                        <div class="format-icon text-secondary">
                                            <i class="bi bi-file-earmark-text"></i>
                                        </div>
                                        <h6 class="mt-2">PDF vers Texte</h6>
                                        <p class="text-muted small mb-0">.txt</p>
                                        <input type="radio" name="conversionType" value="pdfToText" class="d-none">
                                    </div>
                                    
                                <% } else if ("word".equals(fileType)) { %>
                                    
                                    <!-- Word → PDF -->
                                    <div class="conversion-card" onclick="selectConversion('wordToPdf')">
                                        <div class="format-icon text-primary">
                                            <i class="bi bi-file-earmark-word"></i>
                                        </div>
                                        <div class="mb-2">
                                            <i class="bi bi-arrow-right"></i>
                                        </div>
                                        <div class="format-icon text-danger">
                                            <i class="bi bi-file-earmark-pdf"></i>
                                        </div>
                                        <h6 class="mt-2">Word vers PDF</h6>
                                        <p class="text-muted small mb-0">.pdf</p>
                                        <input type="radio" name="conversionType" value="wordToPdf" class="d-none" checked>
                                    </div>
                                    
                                    <!-- Word → Texte -->
                                    <div class="conversion-card" onclick="selectConversion('wordToText')">
                                        <div class="format-icon text-primary">
                                            <i class="bi bi-file-earmark-word"></i>
                                        </div>
                                        <div class="mb-2">
                                            <i class="bi bi-arrow-right"></i>
                                        </div>
                                        <div class="format-icon text-secondary">
                                            <i class="bi bi-file-earmark-text"></i>
                                        </div>
                                        <h6 class="mt-2">Word vers Texte</h6>
                                        <p class="text-muted small mb-0">.txt</p>
                                        <input type="radio" name="conversionType" value="wordToText" class="d-none">
                                    </div>
                                    
                                <% } else if ("excel".equals(fileType)) { %>
                                    
                                    <!-- Excel → PDF -->
                                    <div class="conversion-card" onclick="selectConversion('excelToPdf')">
                                        <div class="format-icon text-success">
                                            <i class="bi bi-file-earmark-excel"></i>
                                        </div>
                                        <div class="mb-2">
                                            <i class="bi bi-arrow-right"></i>
                                        </div>
                                        <div class="format-icon text-danger">
                                            <i class="bi bi-file-earmark-pdf"></i>
                                        </div>
                                        <h6 class="mt-2">Excel vers PDF</h6>
                                        <p class="text-muted small mb-0">.pdf</p>
                                        <input type="radio" name="conversionType" value="excelToPdf" class="d-none" checked>
                                    </div>
                                    
                                    <!-- Excel → Texte -->
                                    <div class="conversion-card" onclick="selectConversion('excelToText')">
                                        <div class="format-icon text-success">
                                            <i class="bi bi-file-earmark-excel"></i>
                                        </div>
                                        <div class="mb-2">
                                            <i class="bi bi-arrow-right"></i>
                                        </div>
                                        <div class="format-icon text-secondary">
                                            <i class="bi bi-file-earmark-text"></i>
                                        </div>
                                        <h6 class="mt-2">Excel vers Texte</h6>
                                        <p class="text-muted small mb-0">.txt</p>
                                        <input type="radio" name="conversionType" value="excelToText" class="d-none">
                                    </div>
                                    
                                <% } else if ("text".equals(fileType)) { %>
                                    
                                    <!-- Texte → PDF -->
                                    <div class="conversion-card" onclick="selectConversion('textToPdf')">
                                        <div class="format-icon text-secondary">
                                            <i class="bi bi-file-earmark-text"></i>
                                        </div>
                                        <div class="mb-2">
                                            <i class="bi bi-arrow-right"></i>
                                        </div>
                                        <div class="format-icon text-danger">
                                            <i class="bi bi-file-earmark-pdf"></i>
                                        </div>
                                        <h6 class="mt-2">Texte vers PDF</h6>
                                        <p class="text-muted small mb-0">.pdf</p>
                                        <input type="radio" name="conversionType" value="textToPdf" class="d-none" checked>
                                    </div>
                                    
                                    <!-- Texte → Word -->
                                    <div class="conversion-card" onclick="selectConversion('textToWord')">
                                        <div class="format-icon text-secondary">
                                            <i class="bi bi-file-earmark-text"></i>
                                        </div>
                                        <div class="mb-2">
                                            <i class="bi bi-arrow-right"></i>
                                        </div>
                                        <div class="format-icon text-primary">
                                            <i class="bi bi-file-earmark-word"></i>
                                        </div>
                                        <h6 class="mt-2">Texte vers Word</h6>
                                        <p class="text-muted small mb-0">.docx</p>
                                        <input type="radio" name="conversionType" value="textToWord" class="d-none">
                                    </div>
                                    
                                <% } else { %>
                                    <div class="alert alert-warning">
                                        <i class="bi bi-exclamation-triangle me-2"></i>
                                        Type de fichier non supporté pour la conversion.
                                    </div>
                                <% } %>
                            </div>
                            
                            <div class="d-flex justify-content-between mt-4">
                                <a href="upload.jsp" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-2"></i>Retour
                                </a>
                                <button type="submit" class="btn btn-primary-custom">
                                    <i class="bi bi-magic me-2"></i>Convertir maintenant
                                </button>
                            </div>
                        </form>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Gestion de l'upload
        document.addEventListener('DOMContentLoaded', function() {
            // Gestion du fichier sélectionné
            document.getElementById('fileInput').addEventListener('change', function(e) {
                const file = e.target.files[0];
                if (file) {
                    handleFileSelection(file);
                }
            });
            
            // Gestion du drag & drop
            const dropArea = document.querySelector('.upload-area');
            ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
                dropArea.addEventListener(eventName, preventDefaults, false);
            });
            
            dropArea.addEventListener('drop', handleDrop);
            
            // Gestion de la sélection des conversions
            setupConversionCards();
        });
        
        function preventDefaults(e) {
            e.preventDefault();
            e.stopPropagation();
        }
        
        function handleDrop(e) {
            const dt = e.dataTransfer;
            const files = dt.files;
            if (files.length > 0) {
                handleFileSelection(files[0]);
            }
        }
        
        function handleFileSelection(file) {
            // Validation
            if (!validateFile(file)) {
                return;
            }
            
            // Afficher l'aperçu
            showFilePreview(file);
            
            // Activer le bouton
            document.getElementById('uploadBtn').disabled = false;
        }
        
        function validateFile(file) {
            // Vérifier la taille
            if (file.size > 10 * 1024 * 1024) {
                alert('Erreur : Fichier trop volumineux (max 10MB)');
                return false;
            }
            
            // Vérifier l'extension
            const validExtensions = ['.pdf', '.doc', '.docx', '.xls', '.xlsx', '.txt'];
            const fileName = file.name.toLowerCase();
            const isValid = validExtensions.some(ext => fileName.endsWith(ext));
            
            if (!isValid) {
                alert('Erreur : Format non supporté');
                return false;
            }
            
            return true;
        }
        
        function showFilePreview(file) {
            const preview = document.getElementById('filePreview');
            const fileName = document.getElementById('fileName');
            const fileSize = document.getElementById('fileSize');
            const fileType = document.getElementById('fileType');
            const fileIcon = document.getElementById('fileIcon');
            
            // Informations
            fileName.textContent = file.name;
            fileSize.textContent = formatBytes(file.size);
            
            // Déterminer le type
            const fileTypeName = getFileType(file.name);
            fileType.textContent = fileTypeName.toUpperCase();
            
            // Icône selon le type
            if (fileTypeName === 'pdf') {
                fileIcon.className = 'bi bi-file-earmark-pdf fs-1 me-3 text-danger';
            } else if (fileTypeName === 'word') {
                fileIcon.className = 'bi bi-file-earmark-word fs-1 me-3 text-primary';
            } else if (fileTypeName === 'excel') {
                fileIcon.className = 'bi bi-file-earmark-excel fs-1 me-3 text-success';
            } else {
                fileIcon.className = 'bi bi-file-earmark-text fs-1 me-3 text-secondary';
            }
            
            // Afficher l'aperçu
            preview.classList.remove('d-none');
        }
        
        function getFileType(fileName) {
            const lowerName = fileName.toLowerCase();
            if (lowerName.endsWith('.pdf')) return 'pdf';
            if (lowerName.endsWith('.doc') || lowerName.endsWith('.docx')) return 'word';
            if (lowerName.endsWith('.xls') || lowerName.endsWith('.xlsx')) return 'excel';
            if (lowerName.endsWith('.txt')) return 'text';
            return 'other';
        }
        
        function formatBytes(bytes, decimals = 2) {
            if (bytes === 0) return '0 Bytes';
            const k = 1024;
            const dm = decimals < 0 ? 0 : decimals;
            const sizes = ['Bytes', 'KB', 'MB', 'GB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
        }
        
        function setupConversionCards() {
            // Gestion de la sélection des cartes de conversion
            const cards = document.querySelectorAll('.conversion-card');
            cards.forEach(card => {
                card.addEventListener('click', function() {
                    // Désélectionner toutes les cartes
                    cards.forEach(c => c.classList.remove('selected'));
                    
                    // Sélectionner cette carte
                    this.classList.add('selected');
                    
                    // Cocher le radio button correspondant
                    const radio = this.querySelector('input[type="radio"]');
                    if (radio) {
                        radio.checked = true;
                    }
                });
            });
            
            // Sélectionner la première carte par défaut
            if (cards.length > 0) {
                cards[0].classList.add('selected');
                const firstRadio = cards[0].querySelector('input[type="radio"]');
                if (firstRadio) {
                    firstRadio.checked = true;
                }
            }
        }
        
        function selectConversion(type) {
            // Cette fonction est appelée par onclick dans les cartes
            const cards = document.querySelectorAll('.conversion-card');
            cards.forEach(card => {
                card.classList.remove('selected');
                const radio = card.querySelector('input[type="radio"]');
                if (radio && radio.value === type) {
                    card.classList.add('selected');
                    radio.checked = true;
                }
            });
        }
    </script>
</body>
</html>