# 🎬 VIDCRUSH - Compresor de Video Profesional

<p align="center">
  <img src="https://img.shields.io/badge/version-2.3-blue.svg" alt="Version 2.3">
  <img src="https://img.shields.io/badge/plataforma-Git%20Bash%20(Windows)%20%7C%20Linux%20%7C%20MacOS-lightgrey.svg" alt="Plataforma">
  <img src="https://img.shields.io/badge/ffmpeg-obligatorio-green.svg" alt="FFmpeg">
</p>

<p align="center">
  <b>VIDCRUSH</b> comprime videos y crea GIFs optimizados usando FFmpeg.<br/>
  <strong>⚠️ OBLIGATORIO: Usar GIT BASH en Windows (CMD/PowerShell NO funcionan)</strong>
</p>

---

## ⚠️ REQUISITO #1: GIT BASH (Windows)

**VIDCRUSH está escrito en Bash**. Windows NO entiende Bash por sí mismo.

### ✅ Descargar Git Bash
1. Ve a: **https://git-scm.com/downloads**
2. Descarga e instala (opciones por defecto)
3. Busca **"Git Bash"** en el menú inicio

### ✅ Ejecutar VIDCRUSH
```bash
# Abre Git Bash, NO CMD, NO PowerShell
cd /c/Users/tu_usuario/Desktop/carpeta_del_script
bash VidCrush.sh
```

**❌ CMD/PowerShell:** Error de sintaxis  
**✅ Git Bash:** Funciona perfecto

---

## 📦 REQUISITO #2: FFMPEG

**Windows (Git Bash):**
1. Descarga de: https://www.gyan.dev/ffmpeg/builds/ (archivo .zip)
2. Extrae en `C:\ffmpeg\bin\ffmpeg.exe`
3. Agrega `C:\ffmpeg\bin` a tu PATH (Variables de entorno)
4. Verifica en Git Bash: `ffmpeg -version`

**Linux:** `sudo apt install ffmpeg`  
**MacOS:** `brew install ffmpeg`

---

## 🚀 CÓMO USAR VIDCRUSH

### 1. Abrir Git Bash
Inicio → Escribe "Git Bash" → Enter

### 2. Ir a la carpeta del script
```bash
cd /c/Users/tu_usuario/Desktop/carpeta_donde_esta_el_script
```

### 3. Ejecutar
```bash
bash VidCrush.sh              # Modo interactivo (recomendado)
# O
bash VidCrush.sh video.mp4    # Comprimir directo
```

---

## 📁 ESTRUCTURA AUTOMÁTICA

```
📂 Tu carpeta/
├── 📂 comprimidos/     # Videos y GIFs procesados
└── 📂 Logs/           # Historial de compresiones
```

---

## 🎯 MENÚ PRINCIPAL (EN GIT BASH)

1. **Comprimir un video**
2. **Comprimir TODOS los videos de la carpeta** ← Útil
3. **Convertir a GIF**
4. **Ambos formatos**
5. **Configuración avanzada**
6. **Estadísticas**
7. **Ver logs**
8. **Ayuda**
9. **Salir**

---

## ⚙️ CONFIGURACIÓN POR DEFECTO

| Parámetro | Valor |
|-----------|-------|
| CRF | 35 |
| Ancho máx | 720p |
| FPS | 24 |
| Audio | 64k |
| GIF ancho | 480px |
| GIF FPS | 10 |
| GIF duración | 30s |

---

## 💡 TIPS RÁPIDOS

- **Máxima compresión:** CRF 45, FPS 15, Audio 32k
- **Mejor calidad:** CRF 18, Preset slow
- **WhatsApp/Redes:** CRF 32, 720p
- **GIF pequeño:** Ancho 320px, FPS 6

---

## 🔥 EJEMPLO PRÁCTICO (PASO A PASO)

```bash
# 1. Abre Git Bash
# 2. Navega a la carpeta
cd /c/Users/tu_usuario/Desktop/mis_videos

# 3. Ejecuta VIDCRUSH
bash /c/Users/tu_usuario/Desktop/VidCrush.sh

# 4. En el menú, elige opción 2 (comprimir todos)
# 5. Espera a que termine
# 6. Revisa carpeta /comprimidos
# 7. Revisa logs en /Logs
```

---

## ❓ SOLUCIÓN DE PROBLEMAS

**"No se reconoce el comando"**  
→ Estás en CMD. Abre Git Bash.

**"ffmpeg no encontrado"**  
→ Instala FFmpeg o usa método portable.

**"Permiso denegado"**  
→ En Git Bash funciona sin chmod. Usa `bash script.sh`

---

**¿Dudas?** Opción 8 en el menú. 🎬