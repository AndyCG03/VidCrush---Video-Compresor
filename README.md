# 🎬 VIDCRUSH PRO - Compresor de Video Profesional

<p align="center">
<<<<<<< HEAD
  <img src="https://img.shields.io/badge/version-3.0--PRO-blue.svg" alt="Version 3.0 PRO">
=======
  <img src="https://img.shields.io/badge/version-3.0-blue.svg" alt="Version 3.0">
>>>>>>> a0fb73753c1a03ee1e939abcee9048ceb1319ae3
  <img src="https://img.shields.io/badge/plataforma-Git%20Bash%20(Windows)%20%7C%20Linux%20%7C%20MacOS-lightgrey.svg" alt="Plataforma">
  <img src="https://img.shields.io/badge/ffmpeg-obligatorio-green.svg" alt="FFmpeg">
  <img src="https://img.shields.io/badge/modo-CARPETA%20MÁGICA-brightgreen.svg" alt="Modo Carpeta Mágica">
</p>

  <b>VIDCRUSH PRO</b> comprime videos y crea GIFs optimizados usando FFmpeg.<br/>

</p>

---

## ⚠️ REQUISITO #1: GIT BASH (Windows)

**VIDCRUSH está escrito en Bash**. Windows NO entiende Bash por sí mismo.

### ✅ Descargar Git Bash
1. Ve a: **https://git-scm.com/downloads**
2. Descarga e instala (opciones por defecto)
3. Busca **"Git Bash"** en el menú inicio

### ✅ Ejecutar VIDCRUSH PRO
```bash
# Abre Git Bash, NO CMD, NO PowerShell
cd /c/Users/tu_usuario/Desktop/
bash vidcrush_pro.sh
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

## 🚀 NUEVO: MODO CARPETA MÁGICA ✨

**La forma más rápida de procesar videos. Arrastra y listo.**

```bash
# 1. Abre Git Bash
# 2. Ejecuta VIDCRUSH PRO
bash vidcrush_pro.sh

# 3. Opción 1 → "PROCESAR CARPETA COMPLETA"
# 4. Arrastra tu carpeta con videos a la terminal
# 5. Elige: Comprimir, GIF o Ambos
# 6. ¡LISTO! 🍿
```

**VIDCRUSH PRO crea automáticamente dentro de TU carpeta:**
```
📂 TU CARPETA (con tus videos)
├── 📁 VIDEOS_COMPRIMIDOS/     # Todos los videos procesados
└── 📁 LOGS_VIDCRUSH/          # Historial de compresiones
```

---

## 🎯 MENÚ PRINCIPAL

```
╔══════════════════════════════════════════════════════════╗
║              🎬  VIDCRUSH PRO 3.0                       ║
║              Compresor de Video Profesional             ║
╚══════════════════════════════════════════════════════════╝

  ✨ MODO CARPETA MÁGICA — Arrastra tu carpeta y procesamos TODO

  1)  📁  PROCESAR CARPETA COMPLETA (recomendado)
  2)  🎬  Comprimir un solo video
  3)  🎞️  Convertir a GIF
  4)  🔄  Ambos formatos
  5)  ⚙️   Configuración avanzada
  6)  📊  Estadísticas
  7)  📋  Ver logs
  8)  ℹ️   Ayuda
  9)  🚪  Salir
```

---

## ⚙️ CONFIGURACIÓN POR DEFECTO

| Parámetro | Valor | Función |
|-----------|-------|---------|
| **CRF** | 35 | Calidad (menor = mejor, 18-51) |
| **Ancho máx** | 720p | Escala automática |
| **FPS** | 24 | Fotogramas por segundo |
| **Audio** | 64k | Bitrate de audio |
| **GIF ancho** | 480px | Resolución del GIF |
| **GIF FPS** | 10 | Fluidez del GIF |
| **GIF duración** | 30s | Máximo por video |

*Todo es configurable en la opción 5*

---

## 💡 TIPS RÁPIDOS

| Para... | Configuración recomendada |
|---------|--------------------------|
| **📦 Máxima compresión** | CRF 45, FPS 15, Audio 32k |
| **🎨 Mejor calidad** | CRF 18, Preset slow |
| **📱 WhatsApp/Redes** | CRF 32, 720p |
| **🐌 GIF pequeño** | Ancho 320px, FPS 6 |
| **⚡ Más rápido** | Preset ultrafast |

---

## 🔥 EJEMPLOS PRÁCTICOS

### 📁 Caso 1: Procesar carpeta completa (MODO MÁGICO)
```bash
bash vidcrush_pro.sh
> Opción 1
> Arrastras: "C:/Users/tu/Desktop/vacaciones"
> Opción 1 (comprimir todos)
> ✅ Todos tus videos comprimidos en /vacaciones/VIDEOS_COMPRIMIDOS
```

### 🎬 Caso 2: Un solo video
```bash
bash vidcrush_pro.sh video.mp4
# Genera: video_comprimido.mp4 en /VIDEOS_COMPRIMIDOS
```

### 🎞️ Caso 3: Solo GIF
```bash
bash vidcrush_pro.sh video.mp4 gif
# Genera: video.gif en /VIDEOS_COMPRIMIDOS
```

### 🔄 Caso 4: Ambos formatos
```bash
bash vidcrush_pro.sh video.mp4 ambos
# Genera: video_comprimido.mp4 + video.gif
```

---

## 📁 ESTRUCTURA COMPLETA

```
📁 TU CARPETA DE VIDEOS/
├── 🎬 video1.mp4
├── 🎬 video2.avi
├── 🎬 video3.mkv
│
├── 📁 VIDEOS_COMPRIMIDOS/     # Creado automáticamente
│   ├── video1_comprimido.mp4
│   ├── video2_comprimido.mp4
│   ├── video3_comprimido.mp4
│   └── video1.gif
│
└── 📁 LOGS_VIDCRUSH/          # Historial completo
    └── vidcrush_20250212_153045.log
```

---

## ❓ SOLUCIÓN DE PROBLEMAS

| Problema | Solución |
|----------|----------|
| **"No se reconoce el comando"** | ❌ Estás en CMD/PowerShell → ✅ Abre Git Bash |
| **"ffmpeg no encontrado"** | Instala FFmpeg o usa método portable en la misma carpeta |
| **"Permiso denegado"** | Usa `bash vidcrush_pro.sh` (no necesitas chmod) |
| **No encuentra videos** | ¿Los videos están en la carpeta que arrastraste? |
| **El GIF es muy grande** | Reduce ancho a 320px y FPS a 6 |

---

## 🚀 MÉTODO PORTÁTIL (SIN INSTALAR FFMPEG)

**¿No quieres instalar FFmpeg en todo el sistema?**

1. Descarga ffmpeg: https://www.gyan.dev/ffmpeg/builds/
2. Extrae la carpeta `ffmpeg` en **la misma carpeta que vidcrush_pro.sh**
3. Estructura:
   ```
   📁 Tu carpeta/
   ├── vidcrush_pro.sh
   └── 📁 ffmpeg/
       └── 📁 bin/
           ├── ffmpeg.exe
           └── ffprobe.exe
   ```
4. ✅ Funciona sin instalar nada

---

## 📊 ESTADÍSTICAS

VIDCRUSH PRO te muestra:
- ✅ Cuántos videos procesaste
- ✅ Cuánto espacio ahorraste
- ✅ Tiempo de procesamiento
- ✅ Logs detallados por sesión
- ✅ Últimos archivos generados

---

## 🎯 RESUMEN: 3 FORMAS DE USARLO

| # | Modo | Comando | ¿Cuándo usarlo? |
|---|------|---------|-----------------|
| 1 | **MODO MÁGICO** 🪄 | `bash vidcrush_pro.sh` → Opción 1 | **Tienes una carpeta con muchos videos** |
| 2 | **Interactivo** ⌨️ | `bash vidcrush_pro.sh` → Opciones 2-4 | Quieres elegir qué hacer |
| 3 | **Directo** ⚡ | `bash vidcrush_pro.sh video.mp4 [modo]` | Procesamiento rápido desde terminal |

---

## 📝 NOTAS IMPORTANTES

✅ **100% local** - Tus archivos nunca salen de tu PC  
✅ **Sin marcas de agua** - Videos originales, solo comprimidos  
✅ **Gratuito** - Código abierto  
✅ **Configurable** - Ajusta calidad, tamaño, FPS, etc.  
✅ **Logs automáticos** - Siempre sabrás qué pasó  

---

**¿Dudas?** Ejecuta el script y elige opción 8 (Ayuda)  
**¿Mejoras?** Siéntete libre de modificar el script

---

<p align="center">
  <b>🎬 VIDCRUSH PRO 3.0 — Haz que tus videos pesen menos, sin perder calidad</b><br/>
</p>

