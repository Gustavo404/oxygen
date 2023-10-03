# Oxygen

[![AWK 1.3.4](https://img.shields.io/badge/AWK-1.3.4-red)](https://packages.debian.org/stable/awk) 
[![ShellScript Bash](https://img.shields.io/badge/ShellScript-Bash-blue)](https://www.gnu.org/software/bash/)
[![ShellScript expect](https://img.shields.io/badge/ShellScript-Expect-brown)](https://wiki.debian.org/Expect)
[![Licença](https://img.shields.io/badge/Licen%C3%A7a-GPL%202.0-yellow)](https://github.com/gustavo404/Oxygen/blob/main/LICENSE)
[![Youtube](https://img.shields.io/badge/Youtube-Gustavo404-red.svg)](https://youtube.com/gustavo404)

## Visão geral

Um controlador de telnet em expect, que se conecta com a OLT e executa uma lista de comandos informados no telnet. Além disso, o Oxygen é responsável por elevar o privilégio ou mudar de shell, se necessário. Embora pareça simples, esse script possui a enorme responsabilidade de executar esses procedimentos sem sobrecarregar ou travar a OLT. O Oxygen também solicita os dados de login, garantindo a segurança dessas informações. 

## **Código `oxygen.sh` (Bash)**

O arquivo **`oxygen.sh`** é um script em Bash que controla uma conexão Telnet e a execução de comandos em um dispositivo de rede, como uma OLT. A seguir, estão detalhadas as principais funcionalidades e processos deste código:

## **Uso**

O **`oxygen.sh`** é um script que permite a conexão Telnet e a execução de comandos em dispositivos de rede, como OLTs. Abaixo estão os passos para utilizar o código:

1. **Execução do Script**:
    
    Execute o script **`oxygen.sh`** a partir do terminal:
    
    ```bash
    bash oxygen.sh
    ```
    
2. **Coleta de Dados**:
    
    O script irá solicitar informações essenciais:
    
    - Nome do arquivo de entrada.
    - Nome do arquivo de saída. (este input será removido)
    - Endereço IP para a conexão Telnet.
    - Nome de usuário Telnet.
    - Senha Telnet (será ocultada durante a digitação).
3. **Verificação de Entradas**:
    
    O script verifica a existência do arquivo de entrada especificado, se o arquivo de saída já existe e valida o endereço IP, nome de usuário e senha fornecidos.
    
4. **Processamento de Dados de Entrada**:
    
    O script verifica se o arquivo de entrada contém IDs de ONTs e ONUs. Caso contrário, ele oferece a opção de converter esses IDs em comandos do Telnet.
    
5. **Execução do Script Telnet**:
    
    O script inicia a execução do script Telnet, interagindo com o dispositivo de rede e executando os comandos especificados no arquivo de entrada.
    
6. **Formatação do Arquivo de Saída**:
    
    Após a conclusão da execução do Telnet, o script oferece a opção de extrair informações específicas do arquivo de saída e formatá-lo de acordo com a escolha.
    
7. **Finalização do Script**:
    
    O script exibirá uma mensagem de conclusão e encerrará a execução.
    

### **Funções de Exibição de Mensagens**

- **`green_message()`**: Exibe mensagens em verde.
- **`yellow_message()`**: Exibe mensagens em amarelo.
- **`red_message()`**: Exibe mensagens em vermelho.

### **Funções para Manipulação de Arquivos**

- **`coletar_dados()`**: Coleta dados de entrada do usuário, como nome de arquivo de entrada, nome de arquivo de saída, endereço IP Telnet, nome de usuário e senha Telnet.
- **`verificar_arquivo_entrada()`**: Verifica se o arquivo de entrada especificado existe.
- **`verificar_arquivo_saida()`**: Verifica se o arquivo de saída especificado já existe e pede ao usuário para confirmar a sobrescrita, se aplicável.
- **`verificar_endereco_ip()`**: Verifica se o endereço IP especificado é válido.
- **`verificar_nome_usuario()`**: Verifica se o nome de usuário Telnet foi fornecido.
- **`verificar_senha()`**: Verifica se a senha Telnet foi fornecida.
- **`verificar_arquivo_entrada_ont_onu()`**: Verifica se o arquivo de entrada contém IDs de ONTs e ONUs e oferece a opção de executar um processo chamado "vortex" para convertê-los em comandos Telnet.

### **Função para Execução do Script Telnet**

- **`executar_script_telnet()`**: Inicia a execução do script Telnet com base nas informações coletadas, utilizando o comando **`expect`** para interagir com o dispositivo de rede.

### **Função para Limpar Arquivos Temporários**

- **`limpar_arquivos_temporarios()`**: Remove arquivos temporários criados durante o processo.

### **Função para Formatar o Arquivo de Saída**

- **`formatar_arquivo_saida()`**: Permite ao usuário escolher se deseja extrair informações específicas do arquivo de saída do Telnet, como dados de potência de recepção, e formata o arquivo de saída de acordo com a escolha.

### **Mensagem de Finalização**

- **`exibir_mensagem_finalizacao()`**: Exibe uma mensagem de conclusão do script.

## **Código `oxygen.expect` (Expect)**

O arquivo **`oxygen.expect`** é um script Expect que automatiza a conexão Telnet e a execução de comandos em um dispositivo de rede. A seguir, estão detalhadas as principais funcionalidades e processos deste código:

## **Uso**

O **`oxygen.expect`** é um script Expect que automatiza a conexão Telnet e a execução de comandos em dispositivos de rede. Siga as etapas abaixo para utilizá-lo:

1. **Execução do Script**:
    
    Execute o script **`oxygen.expect`** a partir do terminal, fornecendo os argumentos necessários na seguinte ordem:
    
    - Endereço IP do dispositivo de rede.
    - Nome de usuário Telnet.
    - Senha Telnet.
    - Nome do arquivo contendo os comandos a serem executados.
    
    Exemplo de uso:
    
    ```bash
    bash oxygen.expect 10.10.100.0 usuario senha comandos.txt
    ```
    
2. **Processamento Automático**:
    
    O script Expect automatiza a conexão Telnet, autenticação e execução dos comandos especificados no arquivo fornecido.
    
3. **Mensagens de Conclusão**:
    
    O script exibirá mensagens de sucesso durante a execução e uma mensagem de conclusão ao finalizar com sucesso.
    

### **Funções para Exibição de Mensagens Coloridas**

- **`print_error()`**: Exibe mensagens de erro em vermelho.
- **`print_success()`**: Exibe mensagens de sucesso em verde.
- **`print_info()`**: Exibe mensagens informativas em cores padrão.

### **Configuração Inicial**

- O script configura cores para mensagens e define funções para mensagens coloridas.

### **Processo Telnet**

- O script inicia uma sessão Telnet para o dispositivo de rede especificado.
- Autentica o usuário fornecendo nome de usuário e senha.
- Executa uma série de comandos Telnet fornecidos em um arquivo, com pausas opcionais entre eles.
- O script exibe mensagens de sucesso e erro durante o processo.

### **Mensagem de Conclusão**

- O script exibe uma mensagem de conclusão quando a execução do script Telnet é bem-sucedida.
