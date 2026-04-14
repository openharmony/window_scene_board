/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { CustomPromise } from '@ohos/frameworkwrapper/src/main/ets/base/CustomPromise';
import { DomainName, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { SystemUICommonUtil, TimeoutError } from '../../../main/ets/utils/SystemUICommonUtil';
import { TraceUtil } from '@ohos/basicutils/src/main/ets/utils/TraceUtil';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { TaskQueue } from '../../../main/ets/utils/TaskQueue';

export default function TaskQueueTest() {
  describe('getExceptionTaskQueue_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_task_exception_when_task_queue_has_exception', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockTaskQueue: TaskQueue = new TaskQueue('testQueue', 1);
      let mockException: Error = new Error('test exception');
      when(mocker.mockFunc(mockTaskQueue, mockTaskQueue.getExceptionInfo))(ArgumentMatchers.any)
        .afterReturn(mockException);

      let result: TaskException[] = TaskQueue.getExceptionTaskQueue();
      expect(result.length).assertEqual(1);
      expect(result[0].message).assertEqual('test exception');

      mocker.ignoreMock(mockTaskQueue, mockTaskQueue.getExceptionInfo);
    });

    it('should_return_empty_task_exception_when_task_queue_has_no_exception', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockTaskQueue: TaskQueue = new TaskQueue('testQueue', 1);
      when(mocker.mockFunc(mockTaskQueue, mockTaskQueue.getExceptionInfo))(ArgumentMatchers.any).afterReturn(null);

      let result: TaskException[] = TaskQueue.getExceptionTaskQueue();
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(mockTaskQueue, mockTaskQueue.getExceptionInfo);
    });

    it('should_return_task_exception_when_task_queues_has_mixed_exception', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockTaskQueue1: TaskQueue = new TaskQueue('testQueue1', 1);
      let mockException1: Error = new Error('test exception 1');
      when(mocker.mockFunc(mockTaskQueue1, mockTaskQueue1.getExceptionInfo))(ArgumentMatchers.any)
        .afterReturn(mockException1);

      let mockTaskQueue2: TaskQueue = new TaskQueue('testQueue2', 1);
      when(mocker.mockFunc(mockTaskQueue2, mockTaskQueue2.getExceptionInfo))(ArgumentMatchers.any).afterReturn(null);

      let result: TaskException[] = TaskQueue.getExceptionTaskQueue();
      expect(result.length).assertEqual(1);
      expect(result[0].message).assertEqual('test exception 1');

      mocker.ignoreMock(mockTaskQueue1, mockTaskQueue1.getExceptionInfo);
      mocker.ignoreMock(mockTaskQueue2, mockTaskQueue2.getExceptionInfo);
    });

    it('should_return_task_exception_when_task_queue_has_exception', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockTaskQueue: TaskQueue = new TaskQueue('testQueue', 1);
      let mockException: Error = new Error('test exception');
      when(mocker.mockFunc(mockTaskQueue, mockTaskQueue.getExceptionInfo))(ArgumentMatchers.any)
        .afterReturn(mockException);

      let result: TaskException[] = TaskQueue.getExceptionTaskQueue();
      expect(result.length).assertEqual(1);
      expect(result[0].message).assertEqual('test exception');

      mocker.ignoreMock(mockTaskQueue, mockTaskQueue.getExceptionInfo);
    });

    it('should_return_empty_task_exception_when_task_queue_has_no_exception', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockTaskQueue: TaskQueue = new TaskQueue('testQueue', 1);
      when(mocker.mockFunc(mockTaskQueue, mockTaskQueue.getExceptionInfo))(ArgumentMatchers.any).afterReturn(null);

      let result: TaskException[] = TaskQueue.getExceptionTaskQueue();
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(mockTaskQueue, mockTaskQueue.getExceptionInfo);
    });

    it('should_return_task_exception_when_task_queues_has_mixed_exception', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockTaskQueue1: TaskQueue = new TaskQueue('testQueue1', 1);
      let mockException1: Error = new Error('test exception 1');
      when(mocker.mockFunc(mockTaskQueue1, mockTaskQueue1.getExceptionInfo))(ArgumentMatchers.any)
        .afterReturn(mockException1);

      let mockTaskQueue2: TaskQueue = new TaskQueue('testQueue2', 1);
      when(mocker.mockFunc(mockTaskQueue2, mockTaskQueue2.getExceptionInfo))(ArgumentMatchers.any).afterReturn(null);

      let result: TaskException[] = TaskQueue.getExceptionTaskQueue();
      expect(result.length).assertEqual(1);
      expect(result[0].message).assertEqual('test exception 1');

      mocker.ignoreMock(mockTaskQueue1, mockTaskQueue1.getExceptionInfo);
      mocker.ignoreMock(mockTaskQueue2, mockTaskQueue2.getExceptionInfo);
    });

    it('should_log_info_and_unfreeze_when_freeze_reason_exists', 0, async () => {
      let taskqueue: TaskQueue = new TaskQueue('testQueue', 10);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockShowWarn: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      let mockUnfreeze: Function = mocker.mockFunc(taskqueue, taskqueue.unfreeze);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();

      taskqueue.freeze(TaskQueueFrozenReason.OTHERS);
      expect(taskqueue.isFreeze).assertTrue();
      expect(taskqueue.freezeReasonMap.size).assertEqual(1);

      await SystemUICommonUtil.sleep(100);

      expect(taskqueue.isFreeze).assertFalse();
      expect(taskqueue.freezeReasonMap.size).assertEqual(0);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showWarn);
      mocker.ignoreMock(taskqueue, taskqueue.unfreeze);
    });

    it('should_log_info_and_set_timeout_when_freeze_reason_does_not_exist', 0, async () => {
      let taskqueue: TaskQueue = new TaskQueue('testQueue', 10);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockShowWarn: Function = mocker.mockFunc(logHelper, logHelper.showWarn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      taskqueue.freeze(TaskQueueFrozenReason.NO_NETWORK);
      expect(taskqueue.isFreeze).assertTrue();
      expect(taskqueue.freezeReasonMap.size).assertEqual(1);

      await SystemUICommonUtil.sleep(100);

      expect(taskqueue.isFreeze).assertTrue();
      expect(taskqueue.freezeReasonMap.size).assertEqual(1);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_log_info_when_unfreezing_with_reason', 0, () => {
      let taskqueue: TaskQueue = new TaskQueue('testQueue', 1);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      taskqueue.unfreeze(TaskQueueFrozenReason.ASSERT);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_clear_timeout_when_reason_is_in_freezeReasonMap', 0, () => {
      let taskqueue: TaskQueue = new TaskQueue('testQueue', 1);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      taskqueue.freezeReasonMap.set(TaskQueueFrozenReason.ASSERT, 123);
      taskqueue.unfreeze(TaskQueueFrozenReason.ASSERT);

      expect(taskqueue.freezeReasonMap.has(TaskQueueFrozenReason.ASSERT)).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_run_task_when_isFreeze_is_true_and_freezeReasonMap_is_empty', 0, () => {
      let taskqueue: TaskQueue = new TaskQueue('testQueue', 1);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      taskqueue.freezeReasonMap.set(TaskQueueFrozenReason.ASSERT, 123);
      taskqueue.unfreeze(TaskQueueFrozenReason.ASSERT);

      expect(taskqueue.isFreeze).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_run_task_when_isFreeze_is_false_and_freezeReasonMap_is_not_empty', 0, () => {
      let taskqueue: TaskQueue = new TaskQueue('testQueue', 1);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      taskqueue.isFreeze = false;
      taskqueue.freezeReasonMap.set(TaskQueueFrozenReason.ASSERT, 123);
      taskqueue.unfreeze(TaskQueueFrozenReason.ASSERT);

      expect(taskqueue.isFreeze).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_run_task_when_freezeReasonMap_is_empty_and_isFreeze_is_false', 0, () => {
      let taskqueue: TaskQueue = new TaskQueue('testQueue', 1);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      taskqueue.isFreeze = false;
      taskqueue.freezeReasonMap.clear();
      taskqueue.unfreeze(TaskQueueFrozenReason.ASSERT);

      expect(taskqueue.isFreeze).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_run_task_when_freezeReasonMap_is_not_empty_and_isFreeze_is_true', 0, () => {
      let taskqueue: TaskQueue = new TaskQueue('testQueue', 1);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      taskqueue.isFreeze = true;
      taskqueue.freezeReasonMap.set(TaskQueueFrozenReason.ASSERT, 123);
      taskqueue.unfreeze(TaskQueueFrozenReason.ASSERT);

      expect(taskqueue.isFreeze).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_task_and_run_immediately_when_tasks_is_empty', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockRun: Function = mocker.mockFunc(TaskQueue.prototype, TaskQueue.prototype.run);
      when(mockRun)().afterReturn(new CustomPromise<void>(() => {
      }));

      let taskqueue: TaskQueue = new TaskQueue('testQueue', 10);
      let task: TaskItem<void> = new TaskItem(DomainName.JS, 'testTask', () => {
      });
      taskqueue.add(task);

      expect(taskqueue['tasks'].length).assertEqual(1);
      mocker.ignoreMock(TaskQueue.prototype, TaskQueue.prototype.run);
    });

    it('should_add_task_and_run_after_interval_when_tasks_is_not_empty', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockRun: Function = mocker.mockFunc(TaskQueue.prototype, TaskQueue.prototype.run);
      when(mockRun)().afterReturn(new CustomPromise<void>(() => {
      }));

      let taskqueue: TaskQueue = new TaskQueue('testQueue', 10, 1000);
      let task1: TaskItem<void> = new TaskItem(DomainName.JS, 'testTask1', () => {
      });
      let task2: TaskItem<void> = new TaskItem(DomainName.JS, 'testTask2', () => {
      });
      taskqueue.add(task1);
      taskqueue.add(task2);

      expect(taskqueue['tasks'].length).assertEqual(2);
      mocker.ignoreMock(TaskQueue.prototype, TaskQueue.prototype.run);
    });

    it('should_stop_running_when_tasks_length_is_zero', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      let taskqueue: TaskQueue = new TaskQueue('testQueue', 10);
      taskqueue.tasks = [];
      await taskqueue.run();

      mocker.ignoreMock(LogHelper, LogHelper.showWarn);
    });

    it('should_stop_running_when_runningCount_is_greater_than_or_equal_to_concurrent', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      let taskqueue: TaskQueue = new TaskQueue('testQueue', 10);
      taskqueue.tasks = [new TaskItem(), new TaskItem()];
      taskqueue.runningCount = 10;
      await taskqueue.run();

      mocker.ignoreMock(LogHelper, LogHelper.showWarn);
    });

    it('should_stop_running_when_isFreeze_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      let taskqueue: TaskQueue = new TaskQueue('testQueue', 10);
      taskqueue.tasks = [new TaskItem()];
      taskqueue.runningCount = 5;
      taskqueue.isFreeze = true;
      await taskqueue.run();

      mocker.ignoreMock(LogHelper, LogHelper.showWarn);
    });

    it('should_execute_task_and_update_runningCount', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockExecuteTask: Function = mocker.mockFunc(TaskQueue.prototype, TaskQueue.prototype.executeTask);
      when(mockExecuteTask)([ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber]).afterReturn(new CustomPromise());

      let taskqueue: TaskQueue = new TaskQueue('testQueue', 10);
      taskqueue.tasks = [new TaskItem()];
      taskqueue.runningCount = 0;
      taskqueue.runningTasks = new Set();
      await taskqueue.run();

      expect(taskqueue.runningCount).assertEqual(1);
      mocker.ignoreMock(TaskQueue.prototype, TaskQueue.prototype.executeTask);
    });

    it('should_execute_task_and_update_runningTasks', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockExecuteTask: Function = mocker.mockFunc(TaskQueue.prototype, TaskQueue.prototype.executeTask);
      when(mockExecuteTask)([ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber]).afterReturn(new CustomPromise());

      let taskqueue: TaskQueue = new TaskQueue('testQueue', 10);
      taskqueue.tasks = [new TaskItem()];
      taskqueue.runningCount = 0;
      taskqueue.runningTasks = new Set();
      await taskqueue.run();

      expect(taskqueue.runningTasks.has(taskqueue.tasks[0])).assertTrue();
      mocker.ignoreMock(TaskQueue.prototype, TaskQueue.prototype.executeTask);
    });

    it('should_execute_task_and_update_task_startTime', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockExecuteTask: Function = mocker.mockFunc(TaskQueue.prototype, TaskQueue.prototype.executeTask);
      when(mockExecuteTask)([ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber]).afterReturn(new CustomPromise());

      let taskqueue: TaskQueue = new TaskQueue('testQueue', 10);
      taskqueue.tasks = [new TaskItem()];
      taskqueue.runningCount = 0;
      taskqueue.runningTasks = new Set();
      await taskqueue.run();

      expect(taskqueue.tasks[0].startTime).assertLarger(0);
      mocker.ignoreMock(TaskQueue.prototype, TaskQueue.prototype.executeTask);
    });

    it('should_execute_task_and_call_executeTask_with_times', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockExecuteTask: Function = mocker.mockFunc(TaskQueue.prototype, TaskQueue.prototype.executeTask);
      when(mockExecuteTask)([ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber]).afterReturn(new CustomPromise());

      let taskqueue: TaskQueue = new TaskQueue('testQueue', 10);
      taskqueue.tasks = [new TaskItem()];
      taskqueue.runningCount = 0;
      taskqueue.runningTasks = new Set();
      await taskqueue.run();

      expect(mockExecuteTask).assertCalledWith(taskqueue.tasks[0], 0);
      mocker.ignoreMock(TaskQueue.prototype, TaskQueue.prototype.executeTask);
    });

    it('should_execute_task_and_call_executeTask_recursively', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockExecuteTask: Function = mocker.mockFunc(TaskQueue.prototype, TaskQueue.prototype.executeTask);
      when(mockExecuteTask)([ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber]).afterReturn(new CustomPromise());

      let taskqueue: TaskQueue = new TaskQueue('testQueue', 10);
      taskqueue.tasks = [new TaskItem()];
      taskqueue.runningCount = 0;
      taskqueue.runningTasks = new Set();
      await taskqueue.run();

      expect(mockExecuteTask).assertCalledRecursively();
      mocker.ignoreMock(TaskQueue.prototype, TaskQueue.prototype.executeTask);
    });

    it('should_execute_task_and_call_sleep_when_interval_is_greater_than_zero', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockExecuteTask: Function = mocker.mockFunc(TaskQueue.prototype, TaskQueue.prototype.executeTask);
      when(mockExecuteTask)([ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber]).afterReturn(new CustomPromise());

      let taskqueue: TaskQueue = new TaskQueue('testQueue', 10, 1000);
      taskqueue.tasks = [new TaskItem()];
      taskqueue.runningCount = 0;
      taskqueue.runningTasks = new Set();
      await taskqueue.run();

      expect(SystemUICommonUtil.sleep).assertCalledWith(1000);
      mocker.ignoreMock(TaskQueue.prototype, TaskQueue.prototype.executeTask);
    });

    it('should_execute_task_and_update_runningCount_recursively', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockExecuteTask: Function = mocker.mockFunc(TaskQueue.prototype, TaskQueue.prototype.executeTask);
      when(mockExecuteTask)([ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber]).afterReturn(new CustomPromise());

      let taskqueue: TaskQueue = new TaskQueue('testQueue', 10);
      taskqueue.tasks = [new TaskItem()];
      taskqueue.runningCount = 0;
      taskqueue.runningTasks = new Set();
      await taskqueue.run();

      expect(taskqueue.runningCount).assertEqual(0);
      mocker.ignoreMock(TaskQueue.prototype, TaskQueue.prototype.executeTask);
    });
    it('should_resolve_task_result_when_action_returns_void', 0, async () => {
      let taskqueue: TaskQueue = new TaskQueue('testQueue', 1);
      let task: TaskItem<void> = new TaskItem<void>('testTask', () => {
        return;
      });
      let mocker: MockKit = new MockKit();
      let mockResultPromise: CustomPromise<void> = new CustomPromise<void>();
      let mockTask: TaskItem<void> = new TaskItem<void>('testTask', () => {
        return;
      });
      mockResultPromise.resolve();
      task.resultPromise = mockResultPromise;
      await taskqueue.executeTask(task);
      expect(task.resultPromise.isResolved()).assertTrue();
    });

    it('should_resolve_task_result_when_action_returns_value', 0, async () => {
      let taskqueue: TaskQueue = new TaskQueue('testQueue', 1);
      let task: TaskItem<string> = new TaskItem<string>('testTask', () => {
        return 'testResult';
      });
      let mocker: MockKit = new MockKit();
      let mockResultPromise: CustomPromise<string> = new CustomPromise<string>();
      let mockTask: TaskItem<string> = new TaskItem<string>('testTask', () => {
        return 'testResult';
      });
      mockResultPromise.resolve('testResult');
      task.resultPromise = mockResultPromise;
      await taskqueue.executeTask(task);
      expect(task.resultPromise.isResolved()).assertTrue();
    });

    it('should_reject_task_result_when_action_throws_error', 0, async () => {
      let taskqueue: TaskQueue = new TaskQueue('testQueue', 1);
      let task: TaskItem<void> = new TaskItem<void>('testTask', () => {
        throw new Error('testError');
      });
      let mocker: MockKit = new MockKit();
      let mockResultPromise: CustomPromise<void> = new CustomPromise<void>();
      let mockTask: TaskItem<void> = new TaskItem<void>('testTask', () => {
        throw new Error('testError');
      });
      mockResultPromise.reject(new Error('testError'));
      task.resultPromise = mockResultPromise;
      await taskqueue.executeTask(task);
      expect(task.resultPromise.isRejected()).assertTrue();
    });

    it('should_reject_task_result_when_action_returns_promise_reject', 0, async () => {
      let taskqueue: TaskQueue = new TaskQueue('testQueue', 1);
      let task: TaskItem<void> = new TaskItem<void>('testTask', () => {
        return new Promise((resolve, reject) => {
          reject(new Error('testError'));
        });
      });
      let mocker: MockKit = new MockKit();
      let mockResultPromise: CustomPromise<void> = new CustomPromise<void>();
      let mockTask: TaskItem<void> = new TaskItem<void>('testTask', () => {
        return new Promise((resolve, reject) => {
          reject(new Error('testError'));
        });
      });
      mockResultPromise.reject(new Error('testError'));
      task.resultPromise = mockResultPromise;
      await taskqueue.executeTask(task);
      expect(task.resultPromise.isRejected()).assertTrue();
    });
  });
}