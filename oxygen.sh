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

# ...
clear
echo; echo
cat banner.txt
echo

# Função para separar visualmente as seções do script
function separator() {
  echo "--------------------------------------------------------"
}

separator
yellow_message "Bem-vindo ao Script de Coleta de Dados Telnet"
separator

# Coleta de dados
read -p "Insira o nome do arquivo de entrada: " input
read -p "Insira o nome do arquivo de saída: " output
read -p "Insira o endereço IP para o Telnet: " ip
read -p "Insira o nome de usuário Telnet: " user
read -s -p "Insira a senha Telnet: " pass
echo

separator
yellow_message "Verificação de Padrão"
separator

# Usar grep para verificar as linhas
if grep -q -E '^[0-9]+/[0-9]+/[0-9]+$' "$input"; then
  green_message "As linhas no arquivo $input correspondem ao padrão X/Y/Z."
  echo "Provavelmente o arquivo possui apenas IDs de ONTs e ONUs."
  echo "Para prosseguir, o arquivo precisa conter comandos para as OLTs."
  
  # Perguntar ao usuário se ele deseja executar o script "vortex"
  read -p "Deseja executar o vortex e converter as IDs para comandos do Telnet? (Y/n) " response
  if [ "$response" = "Y" ] || [ "$response" = "y" ]; then
    cp $input .vortex.tmp
    sed -E 's/([0-9]+)\/([0-9]+)\/([0-9]+)/show optic_module slot \1 pon \2 onu \3/; t; d' .vortex.tmp > $input
  else
    yellow_message "Você escolheu não executar o vortex."
    echo "Prosseguindo com a lista informada..."
  fi
  
else
  red_message "Nenhuma linha no arquivo $input corresponde ao padrão X/Y/Z."
fi

separator
yellow_message "Execução do Script Telnet"
separator

sleep 1

# Executa o oxygen para coletar os dados das ONUs e ONTs informadas em input
expect oxygen.expect $ip $user $pass $input | tee $output

separator
yellow_message "Limpeza de Arquivos Temporários"
separator

# Limpeza dos arquivos temporários:
if [ -e .output.bak ]; then
  # output temporário do oxygen
  rm .output.bak
fi
if [ -e .vortex.tmp ]; then
  # output temporário do vortex
  rm .vortex.tmp
fi

# echo para corrigir bug a atual linha causado pelo expect 
echo

separator
yellow_message "Formatação do Arquivo de Saída"
separator

# Deseja formatar o arquivo de saída
read -p "Deseja extrair apenas 'RECV POWER' dos resultados Telnet? (Y/n) " response
if [ "$response" = "Y" ] || [ "$response" = "y" ]; then
  # Formatador
  cp $output .output.bak # backup para debug
  sed -n '/cd onu/,/exit/p' .output.bak | sed '/\(cd onu\|exit\)/d' > $output

  separator
  yellow_message "Extração de Dados"
  separator

  # Extratores de dados: (com variante para teste e debug)
  grep -E 'RECV POWER   :|onu is in unactive!|\[ ERR ' $output # apenas exibição
  grep -E 'RECV POWER   :|onu is in unactive!|\[ ERR ' $output > RP_$input # grava a extração
  # sed -n '/RECV POWER   :/p;/onu is in unactive!/p;/\[ ERR /p' arquivo.txt
else
  yellow_message "Você escolheu não filtrar o arquivo."
fi