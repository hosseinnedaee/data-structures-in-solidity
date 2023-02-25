// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract DequeCircularArray {
    
    event Dequeue(uint256 value);

    uint256 public constant N = 5;

    uint256[N] public deque;

    uint256 public front = N;
    uint256 public rear = N;

    function enqueueFront(uint256 x) external {
        require(!((front == rear + 1) || (front == 0 && rear == N - 1)), "Queue is full");

        if(front == rear && front == N) {
            front = rear = 0;
            deque[front] = x;
        } else if(front == 0) {
            front = N - 1;
            deque[front] = x;
        } else {
            front--;
            deque[front] = x;
        }
    }

    function enqueueRear(uint256 x) external {
        require(!((front == rear + 1) || (front == 0 && rear == N - 1)), "Queue is full");

        if(front == rear && front == N) {
            front = rear = 0;
            deque[rear] = x;
        } else if(rear == N - 1) {
            rear = 0;
            deque[rear] = x;
        } else {
            rear++;
            deque[rear] = x;
        }
    }

    function dequeueFront() external {
        require(front != rear && front != N, "Queue is empty");

        if(front == rear) {
            emit Dequeue(deque[front]);
            front = rear = N;
        } else if(front == N - 1) {
            emit Dequeue(deque[front]);
            front = 0;
        } else {
            emit Dequeue(deque[front]);
            front++;
        }
    }

    function dequeueRear() external {
        require(front != rear && front != N, "Queue is empty");

        if(front == rear) {
            emit Dequeue(deque[rear]);
            front = rear = N;
        } else if(rear == 0) {
            emit Dequeue(deque[rear]);
            rear = N - 1;
        } else {
            emit Dequeue(deque[rear]);
            rear--;
        }
    }

    function display() external view returns (uint256[] memory) {
        if(rear == front && rear == N) {
            return new uint256[](0);
        }
        uint256 length = front <= rear ? front - rear + 1 : N - front + rear + 1;

        uint256[] memory array = new uint256[](length);

        uint256 current = 0;
        uint256 i = front;
        do {
            array[current++] = deque[i];
            i = (i + 1) % N;
        } while (i != rear + 1);

        return array;
    }

    function getFront() external view returns(uint256) {
        require(!(front == rear && front == N), "Queue is empty");
        return deque[front];
    }

    function getRear() external view returns(uint256 ret) {
        require(!(front == rear && front == N), "Queue is empty");
        return deque[rear];
    }
}