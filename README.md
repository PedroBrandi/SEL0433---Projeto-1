# SEL0433 - Assembly 8051 - Projeto Final
### Integrantes: 
* João Henrique Viana de Oliveira - 15462907
* Pedro Brandi Pereira - 15640990

Este projeto consiste em um módulo dosador rotativo acionado por motor DC, desenvolvido para operar em uma linha de produção de uma fábrica de parafusos, conforme descrito na seção inicial do projeto proposto. O sistema foi programado em linguagem Assembly para a família de microcontroladores MCS-51 (8051) e validado no simulador EdSim51.

O objetivo do dosador é girar exatamente 10 voltas para liberar uma quantidade fixa de parafusos, exibindo uma contagem de voltas no display de 7 segmentos acoplado ao simulador utilizado. Além disso, o programa conta com inversão no sentido de movimento do motor, reiniciando a contagem (não cumulativa) exibida no display e apresentando um led dedicado à orientação do giro.

A descrição técnica de cada decisão tomada no código, bem como o detalhamento individual de cada função estão atribuídas no arquivo presente neste repositório (`sel0433_projeto1_final.asm`) em formato de comentário.

## Funcionalidades Apresentadas

* Controle de quantidade de voltas: O programa conta as voltas dadas pelo motor e as exibe em um display de 7 segmentos;
* Controle de sentido de giro: O programa conta com a inversão no sentido de giro do motor mediante o acionamento de uma chave SW, simulando um caso real de travamento no giro do motor;
* Exibição da quantidade de voltas: O programa dispõe de tabelas referentes aos valores decimais para correta exibição no display de 7 segmentos, sendo referenciadas mais de uma vez durante o código; 
* Reset na contagem: Ao inverter o sentido de movimento, a contagem de voltas no motor é reiniciada, de modo a não exibir um resultado cumulativo;
* Feedback visual do sentido de giro: O sentido de giro do motor é referência pela exibição ou não do ponto decimal no display de 7 segmentos.

## Arquitetura implementada
* Duas tabelas distintas utilizadas separadamente para os dois sentidos de rotação requisitados no projeto, com uma delas contendo a presença do ponto decimal no display de 7 segmentos (anti-horário);
* Multiplas funções chamadas dentro da seção MAIN, referenciando: verificação da chave SW (`verifica_botao`), ajuste do timer (`configura_contador`), acionamento dos motores (`aciona_motor`) e correta exibição da contagem do número de voltas no display de 7 segmentos, obedecendo o sentido requisitado (`exibe_contagem`);
* Utilização da flag F0 como variável de estado do sentido do motor;
* Utilização do Timer 1 como contador (modo 2), aproveitando da funcionalidade de Reload.
