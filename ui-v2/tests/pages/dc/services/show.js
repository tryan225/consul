export default function(
  visitable,
  clickable,
  attribute,
  collection,
  text,
  intentions,
  filter,
  tabs
) {
  return {
    visit: visitable('/:dc/services/:service'),
    externalSource: attribute('data-test-external-source', '[data-test-external-source]', {
      scope: '.external-source',
    }),
    dashboardAnchor: {
      href: attribute('href', '[data-test-dashboard-anchor]'),
    },
    tabs: tabs('tab', ['instances', 'intentions', 'routing', 'tags']),
    filter: filter,

    // TODO: These need to somehow move to subpages
    instances: collection('.consul-service-instance-list > ul > li:not(:first-child)', {
      address: text('a ul .address'),
    }),
    intentions: intentions(),
  };
}
