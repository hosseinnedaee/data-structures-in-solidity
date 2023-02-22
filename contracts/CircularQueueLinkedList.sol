// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract CircularQueueLinkedList {

    event Dequeue(uint256 value);

    struct Node {
        uint256 data;
        bytes32 next;
    }

    mapping(bytes32 => Node) public nodes;

    bytes32 public front;
    bytes32 public rear;
    
    function enqueue(uint256 x) external {
        Node memory node;
        node.data = x;

        if(front == rear && front == bytes32(0)) {
            bytes32 key = keccak256(abi.encodePacked("first"));
            node.next = key; // points to the first node which is itself (circular)

            front = rear = key;

            nodes[rear] = node;
        } else {
            bytes32 key = keccak256(abi.encodePacked(rear, block.timestamp));
            node.next = front; // point to the first node (circular)

            nodes[key] = node;

            Node storage oldLastNode = nodes[rear];
            oldLastNode.next = key; // point to the next node

            rear = key;
        }
    }

    function dequeue() external {
        require(front != bytes32(0) && rear != bytes32(0), "Queue is empty");

        if(front == rear) {
            Node memory node = nodes[front];
            emit Dequeue(node.data);

            delete nodes[front];

            front = rear = bytes32(0);
        } else {
            Node memory node = nodes[front];
            emit Dequeue(node.data);
            delete nodes[front];
            
            front = node.next;

            nodes[rear].next = front;
        }
    }

    function display() external view returns (uint256[] memory) {
        if(front == rear && front == bytes32(0)) {
            return new uint256[](0);
        }

        // First we need to know array length
        uint256 arrLength = 0;
        bytes32 p = front;
        do {
            arrLength++;
            p = nodes[p].next;
        } while(p != front);

        uint256[] memory ret = new uint256[](arrLength);

        p = front;
        uint256 counter = 0;
        do {
            ret[counter] = nodes[p].data;
            counter++;
            p = nodes[p].next;
        } while(p != front);

        return ret;
    }

    function peek() external view returns (uint256) {
        require(front != bytes32(0) && rear != bytes32(0) ,"Queue is empty");

        return nodes[front].data;
    }
}