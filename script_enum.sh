#!/bin/bash

# Cores
verde='\e[32m'
red='\e[33m'
scor='\e[0m'

function banner(){
        echo -e "${verde}SCRIPT DE AUTOMAÇÃO${scor} - ${red}PROJETO SO${scor}"
        echo
        echo -e "${verde}[X] MÉTRICAS QUE SERÃO TESTADAS EM TODOS OS AMBIENTES [X]${scor}"
        echo
        echo -e "${verde}1. TEMPO DE EXECUÇÃO PARA CADA AMBIENTE;${scor}"
        echo -e "${verde}2. QUANTIDADE TOTAL PARA CADA AMBIENTE;${scor}"
        echo -e "${verde}3. VERIFICAÇÃO DE SUBDOMÍNIOS VÁLIDOS PARA CADA AMBIENTE - STATUS CODE = 200;${scor}"
        echo -e "${verde}4. CONSUMO DE RECURSOS DE CPU E MEMÓRIA PARA CADA AMBIENTE.${scor}"
        echo
        echo -e "${red}Rodrigo Padilha - José Ryann${scor}"
        echo
        echo
}

function primeiroambiente(){
        echo -e "[X] ${verde}Iniciando script do primeiro ambiente${scor} [X]"
        echo -e "[X] ${verde}Subfinder em apenas um domínio${scor} [X]"

        read -p "Informe o domínio: " subfinderprimeiro
        echo

        # Primeira métrica: Tempo de execução
        echo -e "${verde}Primeira métrica - TEMPO DE EXECUÇÃO: ${scor}"
        time subfinder -d ${subfinderprimeiro} -silent &> subfinder_1.txt
        echo

        # Segunda métrica: Quantidade total de subdomínios encontrados
        echo -e "${verde}Segunda métrica - QUANTIDADE TOTAL: ${scor}"
        total=$(wc -l < subfinder_1.txt)
        echo "Total de subdomínios encontrados: ${total}"
        echo

        # Terceira métrica: Subdomínios com status code 200
        echo -e "${verde}Terceira métrica - SUBDOMÍNIOS VÁLIDOS (STATUS CODE 200)${scor}"
        httpx -mc 200 -silent < subfinder_1.txt > subf1_200.txt
        totalv=$(wc -l < subf1_200.txt)
        echo "Total de subdomínios válidos: ${totalv}"
        echo

        # Quarta métrica: Consumo de CPU e memória
        echo -e "${verde}Quarta métrica - CONSUMO DE RECURSOS DE CPU E MEMÓRIA:${scor}"
        subfinder -d ${subfinderprimeiro} -silent &>/dev/null &
        pid=$!
        pidstat -r -u -p $pid 1 > pidstat_output_subfinder.txt &

        wait $pid

        cpu_max=$(awk '/%CPU/ {getline; print $8}' pidstat_output_subfinder.txt | sort -nr | head -n1)
        mem_max=$(awk '/%MEM/ {getline; print $10}' pidstat_output_subfinder.txt | sort -nr | head -n1)

        if [[ -n "$cpu_max" ]] && (( $(echo "$cpu_max < 0" | bc -l) )); then
                echo "CPU: Menor que 0%!"
        else
                echo "CPU: ${cpu_max}%"
        fi

        if [[ -z "$mem_max" ]] || [[ "$mem_max" == "0" ]]; then
                echo "MEMÓRIA: Menor que 0%!"
        else
                echo "MEMÓRIA: ${mem_max}%"
        fi
        rm pidstat_output_subfinder.txt
}

function segundoambiente(){
        echo -e "[X] ${verde}Iniciando script do segundo ambiente${scor} [X]"
        echo -e "[X] ${verde}Subfinder em apenas uma lista de domínios${scor} [X]"

        read -p "Informe a lista de domínios: " subfindersegundo
        echo

        # Primeira métrica: Tempo de execução
        echo -e "${verde}Primeira métrica - TEMPO DE EXECUÇÃO: ${scor}"
        time subfinder -dL ${subfindersegundo} -silent &> subfinder_2.txt
        echo

        # Segunda métrica: Quantidade total de subdomínios encontrados
        echo -e "${verde}Segunda métrica - QUANTIDADE TOTAL: ${scor}"
        total=$(wc -l < subfinder_2.txt)
        echo "Total de subdomínios encontrados: ${total}"
        echo

        # Terceira métrica: Subdomínios com status code 200
        echo -e "${verde}Terceira métrica - SUBDOMÍNIOS VÁLIDOS (STATUS CODE 200)${scor}"
        httpx -mc 200 -silent < subfinder_2.txt > subf2_200.txt
        totalv=$(subf2_200.txt < wc -l)
        echo -e "Total de subdomínios válidos: ${totalv}"
        echo

        # Quarta métrica: Consumo de CPU e memória
        echo -e "${verde}Quarta métrica - CONSUMO DE RECURSOS DE CPU E MEMÓRIA:${scor}"
        subfinder -dL ${subfindersegundo} -silent &>/dev/null &
        pid=$!
        pidstat -r -u -p $pid 1 > pidstat_output_subfinder_lista.txt &

        wait $pid

        cpu_max=$(awk '/%CPU/ {getline; print $8}' pidstat_output_subfinder_lista.txt | sort -nr | head -n1)
        mem_max=$(awk '/%MEM/ {getline; print $10}' pidstat_output_subfinder_lista.txt | sort -nr | head -n1)

        if [[ -n "$cpu_max" ]] && (( $(echo "$cpu_max < 0" | bc -l) )); then
                echo "CPU: Menor que 0%!"
        else
                echo "CPU: ${cpu_max}%"
        fi

        if [[ -z "$mem_max" ]] || [[ "$mem_max" == "0" ]]; then
                echo "MEMÓRIA: Menor que 0%!"
        else
                echo "MEMÓRIA: ${mem_max}%"
        fi
        rm pidstat_output_subfinder_lista.txt
}

function terceiroambiente(){
        echo -e "[X] ${verde}Iniciando script do terceiro ambiente${scor} [X]"
        echo -e "[X] ${verde}Assetfinder em apenas um domínio${scor} [X]"

        read -p "Informe o domínio: " assetfinderprimeiro
        echo

        # Primeira métrica: Tempo de execução
        echo -e "${verde}Primeira métrica - TEMPO DE EXECUÇÃO: ${scor}"
        time assetfinder -subs-only ${assetfinderprimeiro} > assetfinder_1.txt
        echo

        # Segunda métrica: Quantidade total de subdomínios encontrados
        echo -e "${verde}Segunda métrica - QUANTIDADE TOTAL: ${scor}"
        total=$(wc -l < assetfinder_1.txt)
        echo "Total de subdomínios encontrados: ${total}"
        echo

        # Terceira métrica: Subdomínios com status code 200
        echo -e "${verde}Terceira métrica - SUBDOMÍNIOS VÁLIDOS (STATUS CODE 200)${scor}"
        httpx -mc 200 -silent < assetfinder_1.txt > asset1_200.txt
        totalv=$(wc -l < asset1_200.txt)
        echo -e "Total de subdomínios válidos: ${totalv}"
        echo

        # Quarta métrica: Consumo de CPU e memória
        echo -e "${verde}Quarta métrica - CONSUMO DE RECURSOS DE CPU E MEMÓRIA:${scor}"
        assetfinder -subs-only ${assetfinderprimeiro} &>/dev/null &
        pid=$!
        pidstat -r -u -p $pid 1 > pidstat_output_assetfinder.txt &

        wait $pid

        cpu_max=$(awk '/%CPU/ {getline; print $8}' pidstat_output_assetfinder.txt | sort -nr | head -n1)
        mem_max=$(awk '/%MEM/ {getline; print $10}' pidstat_output_assetfinder.txt | sort -nr | head -n1)

        if [[ -n "$cpu_max" ]] && (( $(echo "$cpu_max < 0" | bc -l) )); then
                echo "CPU: Menor que 0%!"
        else
                echo "CPU: ${cpu_max}%"
        fi

        if [[ -z "$mem_max" ]] || [[ "$mem_max" == "0" ]]; then
                echo "MEMÓRIA: Menor que 0%!"
        else
                echo "MEMÓRIA: ${mem_max}%"
        fi
        rm pidstat_output_assetfinder.txt
}

function quartoambiente(){
        echo -e "[X] ${verde}Iniciando script do quarto ambiente${scor} [X]"
        echo -e "[X] ${verde}Assetfinder em apenas uma lista de domínios${scor} [X]"

        read -p "Informe a lista de domínios: " assetfindersegundo
        echo

        # Primeira métrica: Tempo de execução
        echo -e "${verde}Primeira métrica - TEMPO DE EXECUÇÃO: ${scor}"
        time cat ${assetfindersegundo} | xargs -n1 assetfinder -subs-only > assetfinder_2.txt
        echo

        # Segunda métrica: Quantidade total de subdomínios encontrados
        echo -e "${verde}Segunda métrica - QUANTIDADE TOTAL: ${scor}"
        total=$(wc -l < assetfinder_2.txt)
        echo "Total de subdomínios encontrados: ${total}"
        echo

        # Terceira métrica: Subdomínios com status code 200
        echo -e "${verde}Terceira métrica - SUBDOMÍNIOS VÁLIDOS (STATUS CODE 200)${scor}"
        httpx -mc 200 -silent < assetfinder_2.txt > asset2_200.txt
        totalv=$(wc -l < asset2_200.txt)
        echo -e "Total de subdomínios válidos: ${totalv}"
        echo

        # Quarta métrica: Consumo de CPU e memória
        echo -e "${verde}Quarta métrica - CONSUMO DE RECURSOS DE CPU E MEMÓRIA:${scor}"
        cat ${assetfindersegundo} | xargs -n1 assetfinder -subs-only &>/dev/null &
        pid=$!
        pidstat -r -u -p $pid 1 > pidstat_output_assetfinder_lista.txt &

        wait $pid

        cpu_max=$(awk '/%CPU/ {getline; print $8}' pidstat_output_assetfinder_lista.txt | sort -nr | head -n1)
        mem_max=$(awk '/%MEM/ {getline; print $10}' pidstat_output_assetfinder_lista.txt | sort -nr | head -n1)

        if [[ -n "$cpu_max" ]] && (( $(echo "$cpu_max < 0" | bc -l) )); then
                echo "CPU: Menor que 0%!"
        else
                echo "CPU: ${cpu_max}%"
        fi

        if [[ -z "$mem_max" ]] || [[ "$mem_max" == "0" ]]; then
                echo "MEMÓRIA: Menor que 0%!"
        else
                echo "MEMÓRIA: ${mem_max}%"
        fi

        rm pidstat_output_assetfinder_lista.txt

}

function menu(){
        #while true; do
        #       clear
                banner
                echo -e "[1] Primeiro ambiente: Subfinder em um domínio"
                echo -e "[2] Segundo ambiente: Subfinder em uma lista de domínios"
                echo -e "[3] Terceiro ambiente: Assetfinder em um domínio"
                echo -e "[4] Quarto ambiente: Assetfinder em uma lista de domínios"
                echo -e "[5] Sair"
                read -p "Escolha uma opção acima: " op
                echo
                case $op in
                        1) primeiroambiente ;;
                        2) segundoambiente ;;
                        3) terceiroambiente ;;
                        4) quartoambiente ;;
                        5) echo -e "${red}Saindo...${scor}" ; exit 0 ;;
                        *) echo -e "${red}Opção inválida!${scor}"
                esac
        #done
}


menu
