# Oxygen
Um controlador de telnet em expect, que se conecta com a OLT e executa uma lista de comandos informados no telnet. Além disso, o Oxygen é responsável por elevar o privilégio ou mudar de shell, se necessário. Embora pareça simples, esse script possui a enorme responsabilidade de executar esses procedimentos sem sobrecarregar ou travar a OLT. O Oxygen também solicita os dados de login, garantindo a segurança dessas informações. 
<br><br>





# Dependências
1. Ambiente Unix/Linux com Bash.
2. A presença do script Expect chamado "oxygen.expect" (fornecido aqui) para a interação Telnet.
<br>

# Instalação (Exemplo usando Git):

1. Instale o pacote Git em sua máquina local(se já não o possuir):

  ```bash
   apt install git
  ```

2. Clone este repositório Git em sua máquina local:

  ```bash
   git clone https://github.com/seu-usuario/seu-repositorio.git
  ```
<br>

# Uso
Os
Navegue até o diretório onde o script está localizado:

  ```bash
  cd seu-repositorio
  ```

Execute o script Bash da seguinte maneira:

  ```bash
  ./codigo1.sh
  ```
Siga as instruções interativas para inserir informações de entrada, como nome do arquivo de entrada, nome do arquivo de saída, endereço IP para Telnet, nome de usuário Telnet e senha Telnet.

O script executará a coleta de dados Telnet e, opcionalmente, formatará o arquivo de saída de acordo com sua escolha.
<br><br>








# Documentação: Código 1 - Script de Gerência de Fluxo de Dados

Este script Bash é projetado para coletar dados de uma OLT (Optical Line Terminal) por meio de Telnet e realizar a formatação dos resultados. A documentação a seguir detalha suas principais características e funcionalidades.

## Introdução
O objetivo principal deste script é facilitar a interação com a OLT por meio de Telnet, coletando informações e formatando-as de acordo com as necessidades do usuário.

## Funções de Mensagens Coloridas
O script começa definindo funções para exibir mensagens coloridas no terminal, melhorando a experiência do usuário durante a execução do script. As funções são:
- `green_message`: Exibe mensagens em verde.
- `yellow_message`: Exibe mensagens em amarelo.
- `red_message`: Exibe mensagens em vermelho.

## Coleta de Dados de Entrada
O script limpa a tela, exibe um banner e coleta informações de entrada do usuário, incluindo o nome do arquivo de entrada, nome do arquivo de saída, endereço IP para Telnet, nome de usuário Telnet e senha Telnet.

## Verificação de Padrão no Arquivo de Entrada
O script usa a ferramenta `grep` para verificar se as linhas no arquivo de entrada correspondem a um padrão específico (X/Y/Z). Se as linhas corresponderem a esse padrão, ele assume que o arquivo contém IDs de ONTs e ONUs. Caso contrário, exibe uma mensagem de erro.

## Execução do Script Telnet com Expect
Se o arquivo de entrada for considerado válido, o script utiliza o Expect para executar o script Oxygen (não fornecido neste código-fonte) para coletar dados Telnet das ONUs e ONTs informadas no arquivo de entrada. Os resultados são redirecionados para o arquivo de saída especificado.

## Limpeza de Arquivos Temporários
O script realiza a limpeza de arquivos temporários, se necessário, removendo `.output.bak` e `.vortex.tmp` se existirem.

## Formatação do Arquivo de Saída (Opcional)
O script pergunta ao usuário se ele deseja extrair apenas a informação "RECV POWER" dos resultados Telnet. Se o usuário optar por fazê-lo, o script formata o arquivo de saída, removendo informações desnecessárias e mantendo apenas os dados relevantes. Os resultados são então exibidos e também salvos em um arquivo com o prefixo "RP_" seguido pelo nome do arquivo de entrada.

## Conclusão
Este script simplifica a coleta de dados Telnet e a formatação de resultados, permitindo que o usuário interaja com uma OLT de maneira eficiente e personalizável. Certifique-se de fornecer o script Oxygen para uso completo do sistema.

# Documentação: Código 2 - Script para Coleta de Dados via Telnet

Este script em Expect é projetado para automatizar a interação Telnet com um dispositivo de rede, permitindo a execução de comandos Telnet e a coleta de resultados. A documentação a seguir detalha suas principais características e funcionalidades.

## Configuração das Cores e Funções de Mensagens Coloridas
O script começa definindo variáveis de cores para exibir mensagens coloridas no terminal. Em seguida, são definidas três funções para exibir mensagens coloridas:
- `print_error`: Exibe mensagens em vermelho.
- `print_success`: Exibe mensagens em verde.
- `print_info`: Exibe mensagens em cores padrão.

## Verificação de Argumentos
O script verifica se o número correto de argumentos foi fornecido ao ser executado. Ele espera receber quatro argumentos: o endereço IP do host, o nome de usuário, a senha e o nome do arquivo de comandos. Se o número de argumentos for incorreto, exibe uma mensagem de erro e encerra a execução.

## Inicialização e Autenticação Telnet
O script inicia uma sessão Telnet com o host especificado e realiza a autenticação fornecendo o nome de usuário e senha. Ele espera os prompts "Login:" e "Password:" e responde apropriadamente.

## Elevação de privilégio
Quando logado, o script aguarda uma shell efetua ma elevação de privilégio 

## Execução de Comandos Telnet
Após a autenticação, o script executa comandos Telnet armazenados em um arquivo especificado. Ele lê os comandos do arquivo e os envia para o host Telnet. Após cada comando, o script aguarda o prompt "#", indicando que o comando foi concluído com sucesso.

## Pausas entre Comandos
O script inclui a opção de adicionar uma pausa de 0,2 segundos entre a execução de cada comando Telnet. Essa pausa pode ser personalizada conforme necessário.

## Conclusão
Após a execução de todos os comandos Telnet, o script fecha a sessão Telnet e exibe uma mensagem de conclusão em verde, indicando que a execução do script Telnet foi concluída com sucesso.

Este script é útil para automatizar tarefas de configuração e coleta de dados em dispositivos de rede usando Telnet, tornando o processo mais eficiente e automatizado.
