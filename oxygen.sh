#!/bin/bash

# Função para exibir mensagens em verde
function green_message() {
  echo -e "\e[32m$1\e[0m"
}

# Função para exibir mensagens em amarelo
function yellow_message() {
  echo -e "\e[33m$1\e[0m"
}

# Função para exibir mensagens em vermelho
function red_message() {
  echo -e "\e[31m$1\e[0m"
}

# Função para separar visualmente as seções do script
function separator() {
  echo "--------------------------------------------------------"
}

# Função para coletar os dados de entrada
function coletar_dados() {
  read -p "Insira o nome do arquivo de entrada: " input
  read -p "Insira o nome do arquivo de saída: " output
  read -p "Insira o endereço IP para o Telnet: " ip
  read -p "Insira o nome de usuário Telnet: " user
  read -s -p "Insira a senha Telnet: " pass
  echo
}

# Função para verificar se o arquivo de entrada existe
function verificar_arquivo_entrada() {
  if [ ! -f "$input" ]; then
    red_message "O arquivo de entrada '$input' não existe."
    exit 1
  fi
}

# Função para verificar se o arquivo de saída já existe
function verificar_arquivo_saida() {
  if [ -f "$output" ]; then
    read -p "O arquivo de saída '$output' já existe. Deseja sobrescrevê-lo? (Y/n) " response
    if [ "$response" != "Y" ] && [ "$response" != "y" ]; then
      yellow_message "Operação cancelada pelo usuário."
      exit 0
    fi
  fi
}

# Função para verificar se o endereço IP é válido
function verificar_endereco_ip() {
  if ! [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    red_message "O endereço IP '$ip' é inválido."
    exit 1
  fi
}

# Função para verificar se o nome de usuário Telnet foi fornecido
function verificar_nome_usuario() {
  if [ -z "$user" ]; then
    red_message "O nome de usuário Telnet não foi fornecido."
    exit 1
  fi
}

# Função para verificar se a senha Telnet foi fornecida
function verificar_senha() {
  if [ -z "$pass" ]; then
    red_message "A senha Telnet não foi fornecida."
    exit 1
  fi
}

# Função para verificar se o arquivo de entrada contém IDs de ONTs e ONUs
function verificar_arquivo_entrada_ont_onu() {
  if grep -q -E '^[0-9]+/[0-9]+/[0-9]+$' "$input"; then
    green_message "As linhas no arquivo $input correspondem ao padrão X/Y/Z."
    echo "Provavelmente o arquivo possui apenas IDs de ONTs e ONUs."
    echo "Para prosseguir, o arquivo precisa conter comandos para as OLTs."
    
    # Perguntar ao usuário se ele deseja executar o script "vortex"
    read -p "Deseja executar o vortex e converter as IDs para comandos do Telnet? (Y/n) " response
    if [ "$response" = "Y" ] || [ "$response" = "y" ]; then
      cp "$input" .vortex.tmp
      sed -E 's/([0-9]+)\/([0-9]+)\/([0-9]+)/show optic_module slot \1 pon \2 onu \3/; t; d' .vortex.tmp > "$input"
    else
      yellow_message "Você escolheu não executar o vortex."
      echo "Prosseguindo com a lista informada..."
    fi
    
  else
    red_message "Nenhuma linha no arquivo $input corresponde ao padrão X/Y/Z."
  fi
}

# Função para executar o script Telnet
function executar_script_telnet() {
  separator
  yellow_message "Execução do Script Telnet"
  separator
  sleep 1
  expect oxygen.expect "$ip" "$user" "$pass" "$input" | tee "$output"
}

# Função para limpar arquivos temporários
function limpar_arquivos_temporarios() {
  separator
  yellow_message "Limpeza de Arquivos Temporários"
  separator
  if [ -e .output.bak ]; then
    # output temporário do oxygen
    rm .output.bak
  fi
  if [ -e .vortex.tmp ]; then
    # output temporário do vortex
    rm .vortex.tmp
  fi
}

# Função para formatar o arquivo de saída
function formatar_arquivo_saida() {
  separator
  yellow_message "Formatação do Arquivo de Saída"
  separator
  read -p "Deseja extrair apenas 'RECV POWER' dos resultados Telnet? (Y/n) " response
  if [ "$response" = "Y" ] || [ "$response" = "y" ]; then
    # Formatador
    cp "$output" .output.bak # backup para debug
    sed -n '/cd onu/,/exit/p' .output.bak | sed '/\(cd onu\|exit\)/d' > "$output"

    separator
    yellow_message "Extração de Dados"
    separator

    # Extratores de dados: (com variante para teste e debug)
    grep -E 'RECV POWER   :|onu is in unactive!|\[ ERR ' "$output" # apenas exibição
    grep -E 'RECV POWER   :|onu is in unactive!|\[ ERR ' "$output" > "RP_$input" # grava a extração
  else
    yellow_message "Você escolheu não filtrar o arquivo."
  fi
}

# Função para exibir uma mensagem de finalização
function exibir_mensagem_finalizacao() {
  separator
  green_message "Script finalizado."
  separator
}

# Limpa a tela
clear

# Exibe o banner
echo
cat banner.txt
echo

# Exibe uma mensagem de boas-vindas
separator
yellow_message "Bem-vindo ao Script de Coleta de Dados Telnet"
separator

# Coleta de dados
coletar_dados

# Verificações
verificar_arquivo_entrada
verificar_arquivo_saida
verificar_endereco_ip
verificar_nome_usuario
verificar_senha
verificar_arquivo_entrada_ont_onu

# Execução do script Telnet
executar_script_telnet

# Limpeza dos arquivos temporários
limpar_arquivos_temporarios

# Formatação do arquivo de saída
formatar_arquivo_saida

# Exibe uma mensagem de finalização
exibir_mensagem_finalizacao