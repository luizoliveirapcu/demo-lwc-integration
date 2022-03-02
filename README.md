# Salesforce DX Project: LWC Integration Demo

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