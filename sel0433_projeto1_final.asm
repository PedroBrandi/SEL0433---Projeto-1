; Joao Henrique Viana de Oliveira - 15462907
; Pedro Brandi Pereira - 15640990
org 0000h
ajmp main

; Tabelas de lookup da saida para
; cada numero em um display, com
; e sem ponto
org 0400h
display_sem_ponto:
	db 0C0h
	db 0F9h
	db 0A4h
	db 0B0h
	db 099h
	db 092h
	db 082h
	db 0F8h
	db 080h
	db 090h

org 040bh
display_com_ponto:
	db 040h
	db 079h
	db 024h
	db 030h
	db 019h
	db 012h
	db 002h
	db 078h
	db 000h
	db 010h

org 0033h
main:
	; Configura inicialmente o
	; contador de rotacoes
	acall configura_contador

	loop:
	; Chama subrotinas para verificar
	; o estado do botao, depois
	; definir a direcao do motor
	; com base neste estado, e entao
	; verificar e exibir a quantidade
	; de rotacoes (limitado a 10).
	acall verifica_botao
	acall aciona_motor
	acall exibe_contagem

	; Retorna para o inicio do
	; programa para continuar a
	; verificacao
	ajmp loop

; Configura o timer 1 como contador
; de rotacoes. Define G e C/T para
; o timer 1, para habilitar o
; disparo por hardware e o modo de
; contador de eventos. Define o
; modo como 2, para utilizar
; somente o TL1 na contagem.
; Finalmente, inicializa o TL1 e
; TH1 com 256 - 10 = 0xF6 e
; habilita o timer definindo TR1
; para 1.
; Nao foi necessario utilizar
; interrupcoes, dado que no modo 2
; a contagem reinicia para o valor
; em TH1.
configura_contador:
	mov tmod, #01100000b
	mov tl1, #0f6h
	mov th1, #0f6h
	setb tr1
	ret

; Verifica o estado do botao de
; direcao, e armazena em F0
verifica_botao:
	; Caso o botao 0 esteja
	; pressionado, P2.0 estara em 0,
	; portanto pula para
	; define_direcao_2, que armazena
	; 1 em F0. Caso contrario,
	; continua para define_direcao_1,
	; que armazena 0 em F0.
	jnb p2.0, define_direcao_2

	; Armazena 0 em F0 e retorna da
	; subrotina. Caso haja mudanca
	; de direcao, reinicia a
	; contagem.
	define_direcao_1:
	jnb f0, pula_direcao
	mov tl1, #0f6h
	clr f0
	ret

	; Armazena 1 em F0 e retorna da
	; subrotina. Caso haja mudanca
	; de direcao, reinicia a
	; contagem.
	define_direcao_2:
	jb f0, pula_direcao
	mov tl1, #0f6h
	setb f0

	; Caso nao haja mudanca de
	; direcao, nao faz nenhuma
	; mudanca
	pula_direcao:
	ret

; Define a direcao do motor com
; base em F0
aciona_motor:
	; Verifica o estado de F0. Caso
	; F0 seja 1, pula para
	; motor_direcao_2, que define o
	; sentido de rotacao anti-horario
	; no motor. Caso F0 seja 0,
	; continua para motor_direcao_1,
	; que define o sentido horario de
	; rotacao no motor.
	jb f0, motor_direcao_2

	; Define 0b01 nos LSBs de P3, que
	; define o sentido horario de
	; rotacao no motor.
	motor_direcao_1:
	setb p3.0
	clr p3.1
	ret

	; Define 0b10 nos LSBs de P3, que
	; define o sentido anti-horario
	; de rotacao no motor.
	motor_direcao_2:
	clr p3.0
	setb p3.1
	ret

; Verifica, limita e exibe a
; contagem de rotacoes do motor em
; um display de 7 segmentos.
exibe_contagem:
	; Move a contagem atual para o
	; acumulador, e subtrai 0xF6
	; para obter o valor correto
	; e exibe no display.
	mov a, tl1
	subb a, #0f6h

	jb f0, exibe_ponto

	; Caso F0 = 0, utiliza a tabela
	; de digitos sem o ponto
	nao_exibe_ponto:
	mov dptr, #display_sem_ponto
	ajmp exibe_display

	; Caso F0 = 1, utiliza a tabela
	; de digitos com o ponto
	exibe_ponto:
	mov dptr, #display_com_ponto

	; Utiliza a tabela de lookup
	; de numeros para exibir a
	; contagem no display.
	exibe_display:
	movc a, @a+dptr
	mov p1, a

	ret
