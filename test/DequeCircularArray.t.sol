// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../contracts/DequeCircularArray.sol";

contract DequeCircularArrayTest is Test {

    DequeCircularArray public dequeCircularArray;

    event Dequeue(uint256 value);

    uint256 public constant N = 5;

    function setUp() public {
        dequeCircularArray = new DequeCircularArray();
    }

    function testEnqueueFront() public {
        dequeCircularArray.enqueueFront(10);

        assertEq(dequeCircularArray.deque(0), 10);
    }

    function testEnqueueFrontTwice() public {
        dequeCircularArray.enqueueFront(10);
        dequeCircularArray.enqueueFront(20);

        assertEq(dequeCircularArray.deque(0), 10);
        assertEq(dequeCircularArray.deque(N - 1), 20);
    }

    function testEnqueueFrontRevertWithQueueIsFull() public {
        dequeCircularArray.enqueueFront(10);
        dequeCircularArray.enqueueFront(20);
        dequeCircularArray.enqueueFront(30);
        dequeCircularArray.enqueueFront(40);
        dequeCircularArray.enqueueFront(50);

        vm.expectRevert(bytes("Queue is full"));
        dequeCircularArray.enqueueFront(60);
    }

    function testEnqueueRear() public {
        dequeCircularArray.enqueueRear(10);

        assertEq(dequeCircularArray.deque(0), 10);
    }

    function testEnqueueRearTwice() public {
        dequeCircularArray.enqueueRear(10);
        dequeCircularArray.enqueueRear(20);

        assertEq(dequeCircularArray.deque(0), 10);
        assertEq(dequeCircularArray.deque(1), 20);
    }

    function testEnqueueRearRevertWithQueueIsFull() public {
        dequeCircularArray.enqueueRear(10);
        dequeCircularArray.enqueueRear(20);
        dequeCircularArray.enqueueRear(30);
        dequeCircularArray.enqueueRear(40);
        dequeCircularArray.enqueueRear(50);

        vm.expectRevert(bytes("Queue is full"));

        dequeCircularArray.enqueueRear(60);
    }

    function testDequeueFront() public {
        dequeCircularArray.enqueueFront(10);

        dequeCircularArray.enqueueRear(20);

        vm.expectEmit(true, true, true, true);
        emit Dequeue(10);

        dequeCircularArray.dequeueFront();
    }

    function testDequeueFrontRevertWithQueueIsEmpty() public {
        vm.expectRevert(bytes("Queue is empty"));
        dequeCircularArray.dequeueFront();
    }

    function testDequeueRear() public {
        dequeCircularArray.enqueueFront(10);

        dequeCircularArray.enqueueRear(20);

        vm.expectEmit(true, true, true, true);
        emit Dequeue(20);

        dequeCircularArray.dequeueRear();
    }
    
    function testDequeueRearRevertWithQueueIsEmpty() public {
        vm.expectRevert(bytes("Queue is empty"));
        dequeCircularArray.dequeueRear();
    }

    function testDisplay() public {
        dequeCircularArray.enqueueFront(10); // 10, -, -, -, -
        dequeCircularArray.enqueueFront(20); // 10, -, -, -, 20

        dequeCircularArray.enqueueRear(30); // 10, 30, -, -, 20
        dequeCircularArray.enqueueRear(40); // 10, 30, 40, -, 20
        dequeCircularArray.enqueueRear(50); // 10, 30, 40, 50, 20

        // 10, 30, 40, 50 <- rear, 20 <- front

        uint256[] memory array = new uint256[](5);
        array[0] = 20;
        array[1] = 10;
        array[2] = 30;
        array[3] = 40;
        array[4] = 50;

        assertEq(dequeCircularArray.display(), array);
    }

    function testGetFront() public {
        dequeCircularArray.enqueueFront(10);
        dequeCircularArray.enqueueFront(20);

        assertEq(dequeCircularArray.getFront(), 20);
    }

    function testGetRear() public {
        dequeCircularArray.enqueueRear(10);
        dequeCircularArray.enqueueRear(20);

        assertEq(dequeCircularArray.getRear(), 20);
    }

    function testCombinationOfEnqueueFrontEnqueueRearDequeueFrontDequeueRear() public {
        dequeCircularArray.enqueueFront(10); // 10, -, -, -, -
        dequeCircularArray.enqueueFront(20); // 10, -, -, -, 20
        
        dequeCircularArray.enqueueRear(30); // 10, 30, -, -, 20
        dequeCircularArray.enqueueRear(40); // 10, 30, 40, -, 20

        dequeCircularArray.dequeueFront(); // 10, 30, 40, -, -
        dequeCircularArray.dequeueRear(); // 10, 30, -, -, -

        dequeCircularArray.enqueueFront(50); // 10, 30, -, -, 50
        dequeCircularArray.enqueueFront(60); // 10, 30, -, 60, 50
        dequeCircularArray.enqueueRear(70); // 10, 30, 70, 60, 50

        // 10, 30, 70 <- Rear, 60 <- Front, 50

        uint256[] memory array = new uint256[](5);
        array[0] = 60;
        array[1] = 50;
        array[2] = 10;
        array[3] = 30;
        array[4] = 70;

        assertEq(dequeCircularArray.display(), array);
    }
}

