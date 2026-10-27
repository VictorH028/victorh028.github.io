---
title: Atajos de teclado 
date: 2026-10-27 
---


ATAJOS DE TECLADO - OPENBOX (rc.xml)
=====================================

Leyenda:
  W = tecla Windows / Super
  A = Alt
  C = Ctrl
  S = Shift
  KP = teclado numerico

-------------------------------------------------------------------------------
ESCRITORIOS
-------------------------------------------------------------------------------
  W-1 ... W-5              Ir al escritorio 1-5
  S-W-1 ... S-W-5          Enviar ventana al escritorio 1-5
  W-S-Left                 Enviar ventana al escritorio anterior
  W-S-Right                Enviar ventana al escritorio siguiente

-------------------------------------------------------------------------------
CAMBIO DE VENTANAS
-------------------------------------------------------------------------------
  A-Tab                    Siguiente ventana (mismo escritorio)
  W-Tab                    Siguiente ventana (todos los escritorios)

-------------------------------------------------------------------------------
MOSAICO / SNAP
-------------------------------------------------------------------------------
  W-Left                   Mitad izquierda (49%)
  W-Right                  Mitad derecha (49%)
  W-Up                     Maximizar completo
  W-Down                   Restaurar y centrar (60% x 80%)
  W-h                      Esquina superior izquierda
  W-k                      Esquina superior derecha
  W-j                      Esquina inferior izquierda
  W-l                      Esquina inferior derecha
  A-z                      Columna izquierda (32%)
  A-x                      Columna central (32%)
  A-c                      Columna derecha (32%)

-------------------------------------------------------------------------------
MOSAICO NUMERICO (TECLADO NUMERICO)
-------------------------------------------------------------------------------
  W-KP_7                   Arriba izquierda
  W-KP_8                   Mitad superior
  W-KP_9                   Arriba derecha
  W-KP_4                   Mitad izquierda
  W-KP_5                   Maximizar
  W-KP_6                   Mitad derecha
  W-KP_1                   Abajo izquierda
  W-KP_2                   Mitad inferior
  W-KP_3                   Abajo derecha

-------------------------------------------------------------------------------
MOVER Y REDIMENSIONAR
-------------------------------------------------------------------------------
  W-A-Up                   Mover ventana 20 px hacia arriba
  W-A-Down                 Mover ventana 20 px hacia abajo
  W-A-Left                 Mover ventana 20 px a la izquierda
  W-A-Right                Mover ventana 20 px a la derecha
  C-A-Left                 Redimensionar 20 px a la izquierda
  C-A-Right                Redimensionar 20 px a la derecha
  C-A-Up                   Redimensionar 20 px arriba
  C-A-Down                 Redimensionar 20 px abajo
  A-m                      Modo mover
  A-r                      Modo redimensionar

-------------------------------------------------------------------------------
LANZAR APLICACIONES
-------------------------------------------------------------------------------
  W-e                      geany
  W-f                      thunar
  W-t                      xfce4-terminal
  W-Return                 xfce4-terminal
  W-w                      netsurf-gtk3
  W-p                      rofi launcher
  A-F1                     rofi launcher
  W-m                      rofi mpd
  W-x                      rofi powermenu
  W-b                      rofi battery
  W-n                      rofi network
  W-v                      tasks
  C-A-v                    vim (terminal)
  C-A-r                    ranger (terminal)
  C-A-h                    htop (terminal)
  C-A-n                    nano (terminal)

-------------------------------------------------------------------------------
OPENBOX / GESTION DE VENTANAS
-------------------------------------------------------------------------------
  C-S-Escape               Salir de Openbox
  C-S-BackSpace            Reiniciar Openbox
  C-S-R                    Reconfigurar (recargar rc.xml)
  W-c                      Cerrar ventana
  W-q                      Cerrar ventana
  A-F5                     Minimizar
  A-F6                     Alternar maximizar
  A-F7                     Alternar decoraciones
  W-d                      Mostrar/ocultar escritorio
  W-space                  Menu raiz
  A-space                  Menu de ventana

-------------------------------------------------------------------------------
DESHABILITADOS (COMENTADOS EN EL XML)
-------------------------------------------------------------------------------
  Multimedia:
    XF86AudioRaiseVolume   volume-up
    XF86AudioLowerVolume   volume-down
    XF86AudioMute          amixer set Master toggle
    XF86AudioStop          mpc stop
    XF86AudioPlay          mpc toggle
    XF86AudioPrev          mpc prev
    XF86AudioNext          mpc next
  Brillo:
    XF86MonBrightnessUp    backlight-up
    XF86MonBrightnessDown  backlight-down
  Capturas:
    Print                  Captura de pantalla completa
    A-Print                Captura con retardo de 5 s
    C-Print                Captura de ventana activa
