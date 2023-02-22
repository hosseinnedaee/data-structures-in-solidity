// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../contracts/CircularQueueLinkedList.sol";

contract CircularQueueLinkedListTest is Test {

    event Dequeue(uint256 value);

    CircularQueueLinkedList public circularQueueLinkedList;

    function setUp() public {
        circularQueueLinkedList = new CircularQueueLinkedList();
    }

    function testEnqueue() public {
        uint256 x = 10;
        circularQueueLinkedList.enqueue(x); // 10

        bytes32 rear = circularQueueLinkedList.rear();

        (uint256 data, ) =  circularQueueLinkedList.nodes(rear);

        assertEq(data, x);
    }

    function testDequeueWhenOnlyOneNodeExist() public {
        uint256 x = 10;
        circularQueueLinkedList.enqueue(x); // 10

        vm.expectEmit(false, false, false, true);
        emit Dequeue(x);
        circularQueueLinkedList.dequeue();
    }

    function testDequeueWhenManyNodesExist() public {
        circularQueueLinkedList.enqueue(10); // 10
        circularQueueLinkedList.enqueue(20); // 10, 20
        circularQueueLinkedList.enqueue(30); // 10, 20, 30

        vm.expectEmit(false, false, false, true);
        emit Dequeue(10);
        circularQueueLinkedList.dequeue();
    }

    function testDequeueRevertWithQueueIsEmpty() public {
        vm.expectRevert(bytes("Queue is empty"));
        circularQueueLinkedList.dequeue();
    }

    function testPeek() public {
        circularQueueLinkedList.enqueue(10); // 10
        circularQueueLinkedList.enqueue(20); // 10, 20
        circularQueueLinkedList.enqueue(30); // 10, 20, 30

        circularQueueLinkedList.dequeue(); //  20, 30
        circularQueueLinkedList.dequeue(); //  30

        circularQueueLinkedList.enqueue(40); // 30, 40
        circularQueueLinkedList.enqueue(50); // 30, 40, 50

        assertEq(circularQueueLinkedList.peek(), 30);
    }

    function testDisplay() public {
        uint256[] memory values = new uint256[](10);
        for(uint256 i = 1; i <= values.length; i++) { // 10, 20, 30, 40, 50, 60, 70, 80, 90, 100
            values[i - 1] = i * 10;
            circularQueueLinkedList.enqueue(values[i - 1]);
        }

        assertEq(circularQueueLinkedList.display(), values);
    }

    function testCombinationOfEnqueueAndDequeue() public {
        circularQueueLinkedList.enqueue(10); // 10
        circularQueueLinkedList.enqueue(20); // 10, 20
        circularQueueLinkedList.enqueue(30); // 10, 20, 30
        circularQueueLinkedList.enqueue(40); // 10, 20, 30, 40

        circularQueueLinkedList.dequeue(); // 20, 30, 40
        circularQueueLinkedList.dequeue(); // 30, 40

        circularQueueLinkedList.enqueue(50); // 30, 40, 50
        circularQueueLinkedList.enqueue(60); // 30, 40, 50, 60

        uint256[] memory values = new uint256[](4);
        values[0] = 30;
        values[1] = 40;
        values[2] = 50;
        values[3] = 60;

        assertEq(circularQueueLinkedList.display(), values);
    }
}