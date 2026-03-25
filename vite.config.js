import { defineConfig } from 'vite';

export default defineConfig({
    build: {
        outDir: 'adminmenu/js/dist',
        lib: {
            entry: 'adminmenu/js/src/formbuilder.js',
            name: 'BbfFormbuilder',
            fileName: 'bbf-formbuilder',
            formats: ['iife'],
        },
        rollupOptions: {
            output: {
                assetFileNames: 'bbf-formbuilder.[ext]',
            },
        },
    },
});
