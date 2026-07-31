# Doutor-IE Livros

Aplicativo desenvolvido em Flutter para gestão de livros e índices. O projeto é responsivo e foi construído pensando na adaptação fluida para dispositivos móveis (Android/iOS), desktop e navegadores web.

Este README documenta as principais decisões arquiteturais e técnicas aplicadas durante o desenvolvimento.

## Decisões Técnicas

Busquei manter a aplicação modular, testável e adaptável a novos fluxos. O foco principal foi garantir que as regras de negócio ficassem isoladas, para que mudanças na API, no layout ou na plataforma não gerassem refatorações massivas.

| Decisão | Motivo |
| --- | --- |
| **Flutter + Dart** | Reduz a duplicação de código e permite compartilhar o mesmo comportamento de regras de negócio em Android, iOS e Web. |
| **Clean Architecture** | Separação estrita entre `domain`, `infra` e `ui` em cada módulo (feature). Protege as regras de negócio de detalhes como Flutter, rotas, requisições HTTP e da própria API. |
| **Padrão MVVM** | Facilita a escalabilidade. Widgets ficam focados apenas na composição visual e interações, enquanto os ViewModels gerenciam o estado e a lógica de apresentação. |
| **ChangeNotifier** | Utilizado para gerenciar estados reativos, como carregamento, sucesso e erro, de forma simples e eficiente. |
| **Dio + Interceptors** | Padroniza a comunicação HTTP. Facilita injeção de tokens (Authentication), timeouts e a normalização das falhas da API para o projeto. |
| **Go Router** | Usado por baixo do AppNavigator para centralizar o roteamento, garantindo rotas testáveis e navegação via URL (Web). |
| **Widgets Genéricos** | Uso de `AppShell`, `ResponsiveContent`, estados vazios e de erro reaproveitáveis na pasta `core/widgets`, garantindo consistência visual e DRY (Don't Repeat Yourself). |

## Arquitetura: Clean Architecture + MVVM

O projeto foi dividido para que as dependências sempre apontem para dentro: a UI conhece a camada de Domain; a Infra implementa os contratos definidos no Domain; mas o **Domain não conhece nada de fora** (nem Flutter, nem Dio, nem JSON).

- **Domain:** A camada mais estável. Contém os modelos imutáveis (como `Book` e `BookIndex`) e os contratos (Interfaces) dos repositórios.
- **Infra:** Implementa as chamadas à API, fazendo o meio de campo. Recebe o JSON externo, trata exceções com o Dio, e converte os dados para as entidades do Domain.
- **UI (View + ViewModel):** A View (tela) apenas escuta as mudanças de estado. O ViewModel processa as ações, se comunica com os repositórios e altera o estado da tela (`loading`, `success`, `error`).

## Aplicação do SOLID

Tentei seguir os princípios do SOLID não apenas como regras fixas, mas para manter as fronteiras da arquitetura limpas:

- **S (Responsabilidade Única):** Uma tela apenas desenha (View); um ViewModel apenas controla estado (MVVM); um repositório da API só faz chamadas HTTP (Infra).
- **O (Aberto/Fechado):** A criação de novas telas reutiliza os componentes visuais do `core` (`AppShell`, `ErrorState`), focando em extensão através de composição ao invés de modificações diretas no que já funciona.
- **L (Substituição de Liskov):** As ViewModels recebem Interfaces (Contratos do Domain). O projeto pode facilmente substituir a implementação real por versões de testes unitários, sem alterar a lógica da ViewModel.
- **I (Segregação de Interfaces):** Os contratos (`Repositories`) expõem apenas os métodos estritamente necessários para os casos de uso de cada feature.
- **D (Inversão de Dependência):** Telas e ViewModels não dependem de implementações concretas (como Dio). Eles dependem de abstrações (`BooksRepository`, `AuthRepository`) injetadas via injeção de dependências (`IoD`).

## Executando o Projeto

Você deve configurar a API local criando o arquivo `.env` na raiz do projeto contendo: `API_BASE_URL=http://18.231.37.245:8080/api/v1`

**Rodando no Emulador / Dispositivo físico ou Web (Chrome):**
```bash
flutter run -d chrome --dart-define-from-file=.env
```

**Compilando para Android:**

```bash
flutter build apk --release --split-per-abi --dart-define-from-file=.env
```
