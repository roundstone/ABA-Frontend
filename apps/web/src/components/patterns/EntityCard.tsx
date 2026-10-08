import React from 'react';

export function EntityCard({ type, entity }: any) {
  return <div>{type}: {entity?.name}</div>;
}
