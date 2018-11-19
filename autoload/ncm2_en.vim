if get(s:, 'loaded', 0)
    finish
endif
let s:loaded = 1

let g:ncm2_en#proc = yarp#py3({
    \ 'module': 'ncm2_en',
    \ 'on_load': { -> ncm2#set_ready(g:ncm2_en#source)}
    \ })

let g:ncm2_en#source = extend(get(g:, 'ncm2_en#source', {}), {
            \ 'name': 'en',
            \ 'ready': 0,
            \ 'priority': 5,
            \ 'mark': 'en',
            \ 'scope': ['tex', 'plaintex'],
            \ 'on_complete': 'ncm2_en#on_complete',
            \ 'on_warmup': 'ncm2_en#on_warmup',
            \ }, 'keep')

func! ncm2_en#init()
    call ncm2#register_source(g:ncm2_en#source)
endfunc

func! ncm2_en#on_warmup(ctx)
    call g:ncm2_en#proc.jobstart()
    call g:ncm2_en#proc.try_notify('on_warmup')
endfunc

func! ncm2_en#on_complete(ctx)
    call g:ncm2_en#proc.try_notify('on_complete', a:ctx)
endfunc

