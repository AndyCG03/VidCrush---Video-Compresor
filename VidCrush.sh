#!/bin/bash
# ============================================================
#  VIDCRUSH PRO — Compresor Inteligente de Video + GIF
#  Versión 3.0 — Modo "Carpeta Mágica"
# ============================================================

# ── Detectar colores (igual que antes) ──
if [ -t 1 ] && [ -n "$TERM" ] && [ "$TERM" != "dumb" ] && command -v tput >/dev/null 2>&1; then
    RED=$(tput setaf 1); GREEN=$(tput setaf 2); YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4); PURPLE=$(tput setaf 5); CYAN=$(tput setaf 6)
    WHITE=$(tput setaf 7); BOLD=$(tput bold); NC=$(tput sgr0)
else
    RED=''; GREEN=''; YELLOW=''; BLUE=''; PURPLE=''; CYAN=''; WHITE=''; BOLD=''; NC=''
fi

# ── Configuración ──
CONFIG_FILE="$HOME/.vidcrush.conf"
OUTPUT_DIR="VIDEOS_COMPRIMIDOS"
LOGS_DIR="LOGS_VIDCRUSH"
PRESET="slow"
CRF=35
MAX_WIDTH=1280
FPS=24
AUDIO_BITRATE=64
GIF_WIDTH=480
GIF_FPS=10
GIF_MAX_SECONDS=30
LOG_FILE="$LOGS_DIR/vidcrush_$(date +%Y%m%d_%H%M%S).log"
TOTAL_SAVED=0
TOTAL_FILES=0

# ── Funciones de color ──
info()    { printf "${CYAN}[INFO]${NC}  %s\n" "$1"; }
ok()      { printf "${GREEN}[OK]${NC}    %s\n" "$1"; }
warn()    { printf "${YELLOW}[WARN]${NC}  %s\n" "$1"; }
error()   { printf "${RED}[ERROR]${NC} %s\n" "$1"; }
step()    { printf "${BLUE}[>>>]${NC}  %s\n" "$1"; }
header()  { printf "${BOLD}${WHITE}%s${NC}\n" "$1"; }

# ── Logging ──
log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

# ── Utilidades ──
format_size() {
    local size=$1
    if [[ -z "$size" || "$size" -lt 1024 ]]; then echo "${size}B"
    elif [[ "$size" -lt 1048576 ]]; then echo "$(( (size + 512) / 1024 ))KB"
    else echo "$(( (size + 524288) / 1048576 ))MB"; fi
}

get_file_size() {
    local file=$1
    if [[ -f "$file" ]]; then
        if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "mingw"* || "$OSTYPE" == "cygwin"* ]]; then
            stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || wc -c < "$file" 2>/dev/null
        else
            stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null
        fi
    else echo 0; fi
}

# ── Verificar FFmpeg ──
check_dependencies() {
    if ! command -v ffmpeg &>/dev/null || ! command -v ffprobe &>/dev/null; then
        printf "${RED}[ERROR]${NC} FFmpeg no está instalado\n"
        printf "${YELLOW}Descarga: https://www.gyan.dev/ffmpeg/builds/${NC}\n"
        exit 1
    fi
}

# ── Crear carpetas ──
setup_directories() {
    mkdir -p "$OUTPUT_DIR" && ok "📁 $OUTPUT_DIR/"
    mkdir -p "$LOGS_DIR" && ok "📁 $LOGS_DIR/"
}

# ── Escáner de videos ──
VIDEO_EXTENSIONS=("mp4" "avi" "mkv" "mov" "webm" "flv" "wmv" "m4v" "mpg" "mpeg" "3gp" "mts" "m2ts")

find_videos_in_folder() {
    local folder="$1"
    local videos=()
    
    for ext in "${VIDEO_EXTENSIONS[@]}"; do
        while IFS= read -r -d '' file; do
            videos+=("$file")
        done < <(find "$folder" -maxdepth 1 -type f -iname "*.${ext}" -print0 2>/dev/null)
    done
    
    printf '%s\n' "${videos[@]}"
}

# ── Banner ÉPICO ──
show_banner() {
    clear_screen
    printf "\n${BOLD}${CYAN}"
    printf '╔══════════════════════════════════════════════════════════╗\n'
    printf '║                                                          ║\n'
    printf '║     ██╗   ██╗██╗██████╗  ██████╗██████╗ ██╗   ██╗███████╗\n'
    printf '║     ██║   ██║██║██╔══██╗██╔════╝██╔══██╗██║   ██║██╔════╝\n'
    printf '║     ██║   ██║██║██║  ██║██║     ██████╔╝██║   ██║███████╗\n'
    printf '║     ╚██╗ ██╔╝██║██║  ██║██║     ██╔══██╗██║   ██║╚════██║\n'
    printf '║      ╚████╔╝ ██║██████╔╝╚██████╗██║  ██║╚██████╔╝███████║\n'
    printf '║       ╚═══╝  ╚═╝╚═════╝  ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝\n'
    printf '║                                                          ║\n'
    printf '║           🎬  COMPRESOR PROFESIONAL DE VIDEO             ║\n'
    printf '║                    Versión 3.0 — PRO                     ║\n'
    printf '╚══════════════════════════════════════════════════════════╝\n'
    printf "${NC}\n"
}

clear_screen() {
    command -v clear &>/dev/null && clear || printf "\033[2J\033[H"
}

# ── MENÚ PRINCIPAL (MODO CARPETA MÁGICA) ──
show_main_menu() {
    show_banner
    printf "${BOLD}${WHITE}═══════════════════════════════════════════════════════════${NC}\n"
    printf "${BOLD}⚡  MODO CARPETA MÁGICA — Arrastra tu carpeta y procesamos TODO${NC}\n"
    printf "${BOLD}${WHITE}═══════════════════════════════════════════════════════════${NC}\n\n"
    
    printf "  ${GREEN}1)${NC}  📁  PROCESAR CARPETA COMPLETA (recomendado)\n"
    printf "  ${GREEN}2)${NC}  🎬  Comprimir un solo video\n"
    printf "  ${GREEN}3)${NC}  🎞️   Convertir a GIF\n"
    printf "  ${GREEN}4)${NC}  🔄  Ambos formatos\n"
    printf "  ${GREEN}5)${NC}  ⚙️   Configuración avanzada\n"
    printf "  ${GREEN}6)${NC}  📊  Estadísticas\n"
    printf "  ${GREEN}7)${NC}  📋  Ver logs\n"
    printf "  ${GREEN}8)${NC}  ℹ️   Ayuda\n"
    printf "  ${RED}9)${NC}  🚪  Salir\n\n"
    
    printf "  ${BOLD}➤ Selecciona una opción [1-9]: ${NC}"
    read -r opt
    
    case $opt in
        1) magic_folder_mode ;;
        2) process_single_video "comprimir" ;;
        3) process_single_video "gif" ;;
        4) process_single_video "ambos" ;;
        5) advanced_config_menu ;;
        6) show_stats ;;
        7) show_logs ;;
        8) show_help ;;
        9) printf "\n${GREEN}¡Hasta luego! 🎬${NC}\n"; exit 0 ;;
        *) warn "Opción inválida"; sleep 1; show_main_menu ;;
    esac
}

# ── MODO CARPETA MÁGICA (NUEVO) ──
magic_folder_mode() {
    show_banner
    printf "${BOLD}${CYAN}═══════════════════════════════════════════════════════════${NC}\n"
    printf "${BOLD}✨  MODO CARPETA MÁGICA - PROCESAMIENTO INTELIGENTE${NC}\n"
    printf "${BOLD}${CYAN}═══════════════════════════════════════════════════════════${NC}\n\n"
    
    printf "  Arrastra tu carpeta con videos aquí:\n"
    printf "  ${BOLD}➤ ${NC}"
    read -r FOLDER_PATH
    
    # Limpiar comillas y backslashes
    FOLDER_PATH=$(echo "$FOLDER_PATH" | sed -e "s/^'//" -e "s/'$//" -e 's/^"//' -e 's/"$//' -e 's/\\/\//g')
    
    if [[ ! -d "$FOLDER_PATH" ]]; then
        error "❌ Carpeta no encontrada: $FOLDER_PATH"
        printf "\nPresiona Enter para continuar..."
        read -r
        show_main_menu
        return
    fi
    
    # Entrar a la carpeta
    cd "$FOLDER_PATH" || return
    
    # Escanear videos
    local videos=()
    while IFS= read -r file; do
        videos+=("$file")
    done < <(find_videos_in_folder ".")
    
    local total=${#videos[@]}
    
    if [[ $total -eq 0 ]]; then
        error "❌ No se encontraron videos en la carpeta"
        cd - >/dev/null || return
        printf "\nPresiona Enter para continuar..."
        read -r
        show_main_menu
        return
    fi
    
    # Mostrar resumen
    printf "\n${BOLD}📊  CARPETA SELECCIONADA:${NC} $(basename "$FOLDER_PATH")\n"
    printf "${BOLD}🎬  VIDEOS ENCONTRADOS:${NC} $total\n"
    printf "${BOLD}📁  DESTINO:${NC} ./$OUTPUT_DIR/\n\n"
    
    printf "  ${YELLOW}¿Qué quieres hacer con estos $total videos?${NC}\n\n"
    printf "  ${GREEN}1)${NC}  Comprimir todos\n"
    printf "  ${GREEN}2)${NC}  Convertir todos a GIF\n"
    printf "  ${GREEN}3)${NC}  Ambos formatos\n"
    printf "  ${RED}4)${NC}  Cancelar\n\n"
    printf "  ${BOLD}➤ Opción: ${NC}"
    read -r sub_opt
    
    case $sub_opt in
        1) mode="comprimir" ;;
        2) mode="gif" ;;
        3) mode="ambos" ;;
        4) cd - >/dev/null || return; show_main_menu; return ;;
        *) warn "Opción inválida"; cd - >/dev/null || return; sleep 1; magic_folder_mode; return ;;
    esac
    
    # Configurar directorios en la carpeta destino
    OUTPUT_DIR_BACKUP="$OUTPUT_DIR"
    LOGS_DIR_BACKUP="$LOGS_DIR"
    
    OUTPUT_DIR="./$OUTPUT_DIR_BACKUP"
    LOGS_DIR="./$LOGS_DIR_BACKUP"
    LOG_FILE="$LOGS_DIR/vidcrush_$(date +%Y%m%d_%H%M%S).log"
    
    setup_directories
    log "=== MODO CARPETA MÁGICA: $(basename "$FOLDER_PATH") | $total videos | Modo: $mode ==="
    
    printf "\n${BOLD}${GREEN}⚡  INICIANDO PROCESAMIENTO...${NC}\n\n"
    
    local count=0
    TOTAL_SAVED=0
    
    for video in "${videos[@]}"; do
        ((count++))
        printf "${BOLD}${CYAN}[$count/$total]${NC} 🎬  $(basename "$video")\n"
        printf "${CYAN}────────────────────────────────────────────${NC}\n"
        
        case $mode in
            "comprimir") compress_video "$video" ;;
            "gif") convert_to_gif "$video" ;;
            "ambos") 
                compress_video "$video"
                printf "\n"
                convert_to_gif "$video"
                ;;
        esac
        
        printf "\n"
    done
    
    # Resumen final
    printf "${BOLD}${GREEN}═══════════════════════════════════════════════════════════${NC}\n"
    printf "${BOLD}🎉  ¡PROCESAMIENTO COMPLETADO!${NC}\n"
    printf "${GREEN}───────────────────────────────────────────────────────────────${NC}\n"
    printf "  📁 Carpeta:     %s\n" "$(basename "$FOLDER_PATH")"
    printf "  🎬 Videos:      %d\n" $total
    printf "  📂 Guardado en: %s/\n" "$OUTPUT_DIR"
    printf "  📋 Log:         %s\n" "$LOG_FILE"
    printf "${GREEN}───────────────────────────────────────────────────────────────${NC}\n"
    
    # Restaurar rutas originales
    OUTPUT_DIR="$OUTPUT_DIR_BACKUP"
    LOGS_DIR="$LOGS_DIR_BACKUP"
    cd - >/dev/null || return
    
    printf "\n${BOLD}Presiona Enter para volver al menú...${NC}"
    read -r
    show_main_menu
}

# ── Procesar un solo video ──
process_single_video() {
    local mode=$1
    show_banner
    
    printf "${BOLD}🎬  ARCHIVO DE ENTRADA${NC}\n"
    printf "──────────────────────────────────────────\n\n"
    printf "  Arrastra el video aquí: "
    read -r INPUT
    
    INPUT=$(echo "$INPUT" | sed -e "s/^'//" -e "s/'$//" -e 's/^"//' -e 's/"$//' -e 's/\\/\//g')
    
    if [[ ! -f "$INPUT" ]]; then
        error "Archivo no encontrado: $INPUT"
        printf "\nPresiona Enter..."
        read -r
        show_main_menu
        return
    fi
    
    setup_directories
    
    case $mode in
        "comprimir") compress_video "$INPUT" ;;
        "gif") convert_to_gif "$INPUT" ;;
        "ambos") 
            compress_video "$INPUT"
            printf "\n"
            convert_to_gif "$INPUT"
            ;;
    esac
    
    printf "\nPresiona Enter..."
    read -r
    show_main_menu
}

# ── Comprimir video ──
compress_video() {
    local input=$1
    local basename=$(basename "$input")
    local name_no_ext="${basename%.*}"
    local output="${OUTPUT_DIR}/${name_no_ext}_comprimido.mp4"
    
    step "Comprimiendo: $basename"
    
    local orig_size=$(get_file_size "$input")
    local duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input" 2>/dev/null)
    duration=${duration%.*}
    
    info "📊  Original: $(format_size $orig_size) | Duración: ${duration}s"
    
    ffmpeg -i "$input" \
        -vcodec libx264 \
        -crf $CRF \
        -preset $PRESET \
        -vf "scale='min($MAX_WIDTH,iw)':-2,fps=$FPS" \
        -acodec aac \
        -b:a ${AUDIO_BITRATE}k \
        -ac 1 \
        -movflags +faststart \
        -y "$output" \
        2>&1 | while IFS= read -r line; do
            if [[ "$line" =~ frame=.*fps=.* ]]; then
                printf "\r  ${CYAN}Procesando:${NC} %s    " "$(echo "$line" | grep -o 'time=.*bitrate' | cut -d= -f2 | cut -d' ' -f1)"
            fi
        done
    
    if [[ -f "$output" ]]; then
        local new_size=$(get_file_size "$output")
        local saved=$((orig_size - new_size))
        local percent=$(( (orig_size - new_size) * 100 / orig_size ))
        TOTAL_SAVED=$((TOTAL_SAVED + saved))
        
        printf "\n\n"
        ok "✅  Guardado: $(basename "$output")"
        ok "     Tamaño: $(format_size $orig_size) → $(format_size $new_size) (${percent}% menos)"
        
        log "COMPRIMIDO: $basename | ${percent}% ahorrado | $(format_size $saved)"
    else
        error "Falló compresión: $basename"
        log "ERROR: $basename"
    fi
}

# ── Convertir a GIF ──
convert_to_gif() {
    local input=$1
    local basename=$(basename "$input")
    local name_no_ext="${basename%.*}"
    local output="${OUTPUT_DIR}/${name_no_ext}.gif"
    local palette="/tmp/palette_$$.png"
    
    step "Generando GIF: $basename"
    
    local duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input" 2>/dev/null)
    duration=${duration%.*}
    
    local trim=""
    if [[ "$duration" -gt "$GIF_MAX_SECONDS" ]]; then
        warn "  Recortando a ${GIF_MAX_SECONDS}s"
        trim="-t $GIF_MAX_SECONDS"
    fi
    
    printf "  ${CYAN}🎨  Generando paleta...${NC}"
    ffmpeg -i "$input" $trim \
        -vf "fps=$GIF_FPS,scale=$GIF_WIDTH:-2:flags=lanczos,palettegen=stats_mode=diff" \
        -y "$palette" 2>/dev/null
    printf " ${GREEN}✓${NC}\n"
    
    printf "  ${CYAN}✨  Creando GIF...${NC}"
    ffmpeg -i "$input" -i "$palette" $trim \
        -lavfi "fps=$GIF_FPS,scale=$GIF_WIDTH:-2:flags=lanczos[x];[x][1:v]paletteuse=dither=floyd_steinberg" \
        -y "$output" 2>/dev/null
    printf " ${GREEN}✓${NC}\n"
    
    rm -f "$palette"
    
    if [[ -f "$output" ]]; then
        local gif_size=$(get_file_size "$output")
        printf "\n"
        ok "✅  GIF: $(basename "$output") ($(format_size $gif_size))"
        log "GIF: $basename | $(format_size $gif_size)"
        
        if ((gif_size > 15000000)); then
            warn "  💡 Tip: GIF grande, prueba con ancho 320px o FPS 6"
        fi
    else
        error "Falló GIF: $basename"
    fi
}

# ── Configuración avanzada (simplificada) ──
advanced_config_menu() {
    while true; do
        show_banner
        printf "${BOLD}${CYAN}════════════════════════════════════════════${NC}\n"
        printf "${BOLD}⚙️  CONFIGURACIÓN${NC}\n"
        printf "${BOLD}${CYAN}════════════════════════════════════════════${NC}\n\n"
        
        printf "  ${YELLOW}VIDEO${NC}\n"
        printf "  1)  CRF ................. [${BOLD}${CRF}${NC}] (18-51)\n"
        printf "  2)  Ancho máximo ........ [${BOLD}${MAX_WIDTH}px${NC}]\n"
        printf "  3)  FPS ................. [${BOLD}${FPS}${NC}]\n"
        printf "  4)  Audio ............... [${BOLD}${AUDIO_BITRATE}k${NC}]\n"
        printf "  5)  Preset .............. [${BOLD}${PRESET}${NC}]\n\n"
        printf "  ${YELLOW}GIF${NC}\n"
        printf "  6)  Ancho ............... [${BOLD}${GIF_WIDTH}px${NC}]\n"
        printf "  7)  FPS ................. [${BOLD}${GIF_FPS}${NC}]\n"
        printf "  8)  Duración máxima ..... [${BOLD}${GIF_MAX_SECONDS}s${NC}]\n\n"
        printf "  9)  Guardar configuración\n"
        printf "  0)  Volver\n\n"
        printf "  ${BOLD}➤ Opción: ${NC}"
        
        read -r adv_opt
        case $adv_opt in
            1) read -p "  CRF (18-51): " new_crf; [[ "$new_crf" =~ ^[0-9]+$ && $new_crf -ge 18 && $new_crf -le 51 ]] && CRF=$new_crf ;;
            2) read -p "  Ancho máximo: " new_w; [[ "$new_w" =~ ^[0-9]+$ && $new_w -ge 320 ]] && MAX_WIDTH=$new_w ;;
            3) read -p "  FPS (10-60): " new_f; [[ "$new_f" =~ ^[0-9]+$ && $new_f -ge 10 && $new_f -le 60 ]] && FPS=$new_f ;;
            4) read -p "  Audio kbps (32-256): " new_a; [[ "$new_a" =~ ^[0-9]+$ && $new_a -ge 32 && $new_a -le 256 ]] && AUDIO_BITRATE=$new_a ;;
            5) read -p "  Preset: " new_p; [[ -n "$new_p" ]] && PRESET=$new_p ;;
            6) read -p "  Ancho GIF (160-1200): " new_gw; [[ "$new_gw" =~ ^[0-9]+$ && $new_gw -ge 160 ]] && GIF_WIDTH=$new_gw ;;
            7) read -p "  FPS GIF (4-24): " new_gf; [[ "$new_gf" =~ ^[0-9]+$ && $new_gf -ge 4 && $new_gf -le 24 ]] && GIF_FPS=$new_gf ;;
            8) read -p "  Duración máx GIF (5-60): " new_gs; [[ "$new_gs" =~ ^[0-9]+$ && $new_gs -ge 5 && $new_gs -le 60 ]] && GIF_MAX_SECONDS=$new_gs ;;
            9) save_config ;;
            0) break ;;
        esac
        sleep 1
    done
    show_main_menu
}

# ── Guardar configuración ──
save_config() {
    cat > "$CONFIG_FILE" << EOF
CRF=$CRF
MAX_WIDTH=$MAX_WIDTH
FPS=$FPS
AUDIO_BITRATE=$AUDIO_BITRATE
GIF_WIDTH=$GIF_WIDTH
GIF_FPS=$GIF_FPS
GIF_MAX_SECONDS=$GIF_MAX_SECONDS
PRESET="$PRESET"
OUTPUT_DIR="$OUTPUT_DIR"
LOGS_DIR="$LOGS_DIR"
EOF
    ok "Configuración guardada"
}

# ── Cargar configuración ──
load_config() {
    [[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE" && info "Configuración cargada"
}

# ── Mostrar logs ──
show_logs() {
    show_banner
    printf "${BOLD}${CYAN}════════════════════════════════════════════${NC}\n"
    printf "${BOLD}📋  LOGS DISPONIBLES${NC}\n"
    printf "${BOLD}${CYAN}════════════════════════════════════════════${NC}\n\n"
    
    if [[ -d "$LOGS_DIR" ]] && ls "$LOGS_DIR"/*.log 2>/dev/null; then
        local count=1; local logs=()
        while IFS= read -r logfile; do
            logs+=("$logfile")
            printf "  ${GREEN}%d)${NC} %s\n" $count "$(basename "$logfile")"
            ((count++))
        done < <(ls -t "$LOGS_DIR"/*.log 2>/dev/null)
        
        printf "\n  ${BOLD}➤ Ver log [1-$((count-1))] o 0 para volver: ${NC}"
        read -r log_opt
        
        [[ "$log_opt" == "0" ]] && { show_main_menu; return; }
        if [[ "$log_opt" =~ ^[0-9]+$ ]] && ((log_opt >= 1 && log_opt < count)); then
            clear_screen
            cat "${logs[$((log_opt-1))]}"
            printf "\n\n${BOLD}Presiona Enter...${NC}"; read -r
        fi
    else
        printf "  ⚠️  No hay logs en $LOGS_DIR/\n"
        printf "\n${BOLD}Presiona Enter...${NC}"; read -r
    fi
    show_main_menu
}

# ── Estadísticas ──
show_stats() {
    show_banner
    printf "${BOLD}${CYAN}════════════════════════════════════════════${NC}\n"
    printf "${BOLD}📊  ESTADÍSTICAS${NC}\n"
    printf "${BOLD}${CYAN}════════════════════════════════════════════${NC}\n\n"
    
    if [[ -d "$OUTPUT_DIR" ]]; then
        local total=$(find "$OUTPUT_DIR" -type f \( -name "*.mp4" -o -name "*.gif" \) 2>/dev/null | wc -l)
        local size=0
        while IFS= read -r f; do s=$(get_file_size "$f"); size=$((size + s)); done < <(find "$OUTPUT_DIR" -type f 2>/dev/null)
        printf "  📁 $OUTPUT_DIR/\n"
        printf "  🎬 Archivos: $total\n"
        printf "  💾 Espacio:  $(format_size $size)\n\n"
        ls -lh "$OUTPUT_DIR" 2>/dev/null | tail -5 | while read -r l; do printf "    %s\n" "$l"; done
    else
        printf "  ⚠️  No hay archivos procesados\n"
    fi
    
    printf "\n${BOLD}Presiona Enter...${NC}"; read -r
    show_main_menu
}

# ── Ayuda ──
show_help() {
    show_banner
    printf "${BOLD}${CYAN}════════════════════════════════════════════${NC}\n"
    printf "${BOLD}📚  AYUDA RÁPIDA${NC}\n"
    printf "${BOLD}${CYAN}════════════════════════════════════════════${NC}\n\n"
    
    printf "${BOLD}✨ MODO CARPETA MÁGICA (NUEVO):${NC}\n"
    printf "  • Opción 1: Arrastra cualquier carpeta con videos\n"
    printf "  • Procesa TODOS los videos automáticamente\n"
    printf "  • Crea carpetas organizadas dentro de la carpeta\n\n"
    
    printf "${BOLD}🎯 USO RÁPIDO:${NC}\n"
    printf "  1. Abre Git Bash\n"
    printf "  2. Navega a la carpeta del script\n"
    printf "  3. Ejecuta: bash vidcrush_pro.sh\n"
    printf "  4. Opción 1 → Arrastra tu carpeta de videos\n"
    printf "  5. Listo, a esperar 🍿\n\n"
    
    printf "${BOLD}💡 TIPS:${NC}\n"
    printf "  • Máxima compresión: CRF 45, FPS 15, Audio 32k\n"
    printf "  • Mejor calidad: CRF 18, Preset slow\n"
    printf "  • GIF pequeño: Ancho 320px, FPS 6\n\n"
    
    printf "${BOLD}Presiona Enter...${NC}"; read -r
    show_main_menu
}

# ── Inicio ──
init() {
    check_dependencies
    load_config
    setup_directories
    
    if [[ $# -gt 0 ]]; then
        INPUT="$1"; MODE="${2:-comprimir}"
        [[ ! -f "$INPUT" ]] && error "Archivo no encontrado" && exit 1
        case "$MODE" in
            comprimir|video) compress_video "$INPUT" ;;
            gif|GIF) convert_to_gif "$INPUT" ;;
            ambos|both) compress_video "$INPUT"; printf "\n"; convert_to_gif "$INPUT" ;;
            *) error "Modo inválido" ;;
        esac
        exit 0
    fi
    
    show_main_menu
}

init "$@"