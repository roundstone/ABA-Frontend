import { ApiError } from '@/lib/api';
import { NetworkNodeData } from './types';
import { mockNetworkUsers } from './mocks';

const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

function pruneLevels(node: NetworkNodeData, currentLevel: number, maxLevels: number): NetworkNodeData {
  if (currentLevel >= maxLevels || !node.children) {
    return { ...node, children: [] };
  }
  
  return {
    ...node,
    children: node.children.map(child => pruneLevels(child, currentLevel + 1, maxLevels))
  };
}

export async function getNetworkTree(rootId: string = 'ABA-492', maxLevels: number = 999) {
  await delay(600);
  
  const rootNode = mockNetworkUsers[rootId];
  if (!rootNode) {
    throw new ApiError(404, 'User not found in network', 'NOT_FOUND');
  }

  // Deep clone to avoid mutating the mock structure, then prune levels
  const tree = JSON.parse(JSON.stringify(rootNode));
  const prunedTree = pruneLevels(tree, 0, maxLevels);

  return { data: prunedTree };
}
