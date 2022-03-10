# Salesforce DX Project: LWC Integration Demo

Esse projeto tem por objetivo demonstrar como os componentes LWC se comunicam entre si através de propriedades públicas, eventos no DOM e mensagens via "Lightning Message Channel".

## Componentes

Foram criados 5 componentes com diferentes níveis de relacionamento para contemplar todos os cenários:

### Componente cardSelector

Esse componente é o mais alto na hieraquia de relecionamento, então vamos chamá-lo de componente "Pai". Assim que que a tela interage com esse componente, o método `renderedCallback` é invocado, ele por sua vez invoca o método `getData` que faz uma requisição ao servidor por meio da classe `CardSelectorController` para buscar os cartões que serão exibidos na tela para seleção.

Ao selecionar um cartão na lista, a propriedade `selectedData` é preechida com os dados do cartão selecionado. Além disso esses dados são publicados no canal de comunicação `(Lightning Message Channel)` que criamos com o nome `TransacionalDataChannel`.

Quando a propriedade `selectedData` está preenchida, o componente `cardSelectorDetail` que aqui chamaremos de "filho" é exibido e recebe esse dado na sua propriedade pública `externalData`.

#### Classe CardSelectorController

O método `fetchData` que é invocado pelo LWC, faz uma query no próprio Salesforce para buscar alguns campos do objeto `Case` e em seguida utiliza esses campos como parâmetro para invocar uma API externa por meio da classe `CardListService` que irá retornar a lista de cartões.

## Autorizar URL para callout:
- Setup->Security->Remote site settings-> New Remote Site

## Exemplo de requisição HTTP GET:
- RestIntegration.getInstance().executeCallout(
    'GET',
    'https://7d3ff44a-0b94-4fbf-b70e-9d7a0d667eec.mock.pstmn.io',
    '/meios-pagamentos/v1/cartoes',
    null,
    null
);

## Referências:
- https://trailhead.salesforce.com/pt-BR/content/learn/superbadges/superbadge_integration