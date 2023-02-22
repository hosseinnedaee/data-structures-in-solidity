// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../contracts/CircularQueueArrays.sol";

contract CircularQueueArraysTest is Test {

    event Dequeue(uint256 value);

    CircularQueueArrays public circularQueueArrays;

    uint256 N;
    
    function setUp() public {
        circularQueueArrays = new CircularQueueArrays();

        N = circularQueueArrays.N();
    }

    function testEnqueue() public {
        uint256 x = 10;
        circularQueueArrays.enqueue(x);
        assertEq(circularQueueArrays.queue(0), x);
    }

    function testDequeue() public {
        uint256 x = 10;
        circularQueueArrays.enqueue(x);
        assertEq(circularQueueArrays.queue(0), x);

        vm.expectEmit(false, false, false, true);
        emit Dequeue(x);
        circularQueueArrays.dequeue();
    }

    function testEnqueueRevertWithQueueIsFull() public {
        for(uint256 i = 1; i <= N; i++) { // enqueue: 10,20,30,40,50
            circularQueueArrays.enqueue(i * 10);
        }

        uint256 extra = 60;
        vm.expectRevert(bytes("Queue is full"));
        circularQueueArrays.enqueue(extra);
    }

    function testDequeueRevertWithQueueIsEmpty() public {
        vm.expectRevert(bytes("Queue is empty"));
        circularQueueArrays.dequeue();
    }

    function testDisplay() public {
        uint256[] memory array = new uint256[](N);
        for(uint256 i = 1; i <= N; i++) { // enqueue: 10,20,30,40,50
            array[i - 1] = i * 10;
            circularQueueArrays.enqueue(array[i - 1]);
        }

        assertEq(circularQueueArrays.display(), array);
    }

    function testCombinationOfEnqueueAndDequeue() public {
        // enqueue 10
        // enqueue 20
        // enqueue 30
        // enqueue 40
        // enqueue 50
        // dequeue
        // dequeue
        // enqueue 60
        // enqueue 70

        circularQueueArrays.enqueue(10); // 10
        circularQueueArrays.enqueue(20); // 10,20
        circularQueueArrays.enqueue(30); // 10,20,30
        circularQueueArrays.enqueue(40); // 10,20,30,40
        circularQueueArrays.enqueue(50); // 10,20,30,40,50

        circularQueueArrays.dequeue(); // 20,30,40,50
        circularQueueArrays.dequeue(); // 30,40,50

        circularQueueArrays.enqueue(60); // 30,40,50,60
        circularQueueArrays.enqueue(70); // 30,40,50,60,70


        uint256[] memory array = new uint256[](5);
        array[0] = 30;
        array[1] = 40;
        array[2] = 50;
        array[3] = 60;
        array[4] = 70;
        assertEq(circularQueueArrays.display(), array);
    }

}
