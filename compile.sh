#!/bin/sh
mkdir -p build && cmake --fresh -B build && cmake --build build
