// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract CircularQueueArrays {

    event Dequeue(uint256 value);

    uint8 constant public N = 5; // The length of the queue

    uint256[N] public queue;

    uint8 public front = N; // Set the initial value equal to N means does not point to anything
    uint8 public rear = N; // Set the initial value equal to N means does not point to anything

    function enqueue(uint256 x) external {
        require((rear + 1) % N != front, "Queue is full");

        if(rear == N && front == N) {
            rear = front = 0;
            queue[rear] = x;
        } else {
            rear = (rear + 1) % N;
            queue[rear] = x;
        }
    }

    function dequeue() external {
        require(rear != N && front != N, "Queue is empty");

        if(rear == front) {
            emit Dequeue(queue[front]);
            rear = front = N;
        } else {
            emit Dequeue(queue[front]);
            front = (front + 1) % N;
        }
    }

    function display() external view returns (uint256[] memory) {
        if(front == N && rear == N) {
            return new uint256[](0);
        }

        uint256 length = rear >= front ? rear - front + 1 : N - front + rear + 1;
        uint256[] memory q = new uint256[](length);

        uint256 counter = 0;
        uint256 i = front;
        while(i != rear) {
            q[counter] = queue[i];
            i = (i + 1) % N;

            counter++;
        }
        q[counter] = queue[i];
        return q;
    }
}