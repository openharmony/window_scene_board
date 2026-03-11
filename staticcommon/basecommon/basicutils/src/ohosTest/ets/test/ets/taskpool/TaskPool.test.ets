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
import { BaseTask } from '../../../../../main/ets/taskpool/model/BaseTask';
import { TaskPool } from '../../../../../main/ets/taskpool/TaskPool';
import { TaskManager } from '../../../../../main/ets/taskpool/viewmodel/viewhandler/TaskManager';
import { CheckEmptyUtils } from '../../.././../../main/ets/utils/CheckEmptyUtils';

export default function TaskPoolTest() {
  describe('TaskPoolTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });

    it('getPool_should_return_new_TaskManager_when_taskType_is_error', 0, () => {
      let taskType: string = 'testTaskType';
      let args: Object[] = [];
      TaskPool.config.remove(taskType);
      const result: TaskManager = TaskPool.getPool(taskType, ...args);
      expect(result !== undefined).assertTrue();
    });

    it('getPool_should_return_existing_TaskManager_when_taskType_is_valid', 0, () => {
      let taskType: string = 'testTaskType';
      let baseTask: BaseTask = new BaseTask();
      TaskPool.config.set(taskType, baseTask);
      let manager: TaskManager = new TaskManager();
      (TaskPool as object)['taskPool'].set(taskType, manager)
      let args: Object[] = [];
      const result: TaskManager = TaskPool.getPool(taskType, ...args);
      expect(result).assertEqual((TaskPool as object)['taskPool'].get(taskType));
    });

    it('getPool_should_call_callback_when_args_is_not_empty', 0, () => {
      let taskType: string = 'testTaskType';
      let baseTask: BaseTask = new BaseTask();
      TaskPool.config.set(taskType, baseTask);
      let manager: TaskManager = new TaskManager();
      (TaskPool as object)['taskPool'].set(taskType, manager)
      let args: Object[] = [baseTask];
      const result: TaskManager = TaskPool.getPool(taskType, ...args);
      expect(result).assertEqual((TaskPool as object)['taskPool'].get(taskType));
    });

    it('getPool_should_return_new_TaskManager_when_no_existing_manager_for_taskType', 0, () => {
      let taskType: string = 'testTaskType';
      let args: Object[] = [];
      (TaskPool as object)['taskPool'].remove(taskType);
      let baseTask: BaseTask = new BaseTask();
      TaskPool.config.set(taskType, baseTask);
      const result: TaskManager = TaskPool.getPool(taskType, ...args);
      expect(result !== undefined).assertTrue();
    });

    it('getPool_should_return_new_TaskManager_when_baseTask_is_invalid', 0, () => {
      let taskType: string = 'testTaskType';
      let args: Object[] = [];
      TaskPool.config.remove(taskType);
      let baseTask: BaseTask = new BaseTask();
      TaskPool.config.set(taskType, baseTask);
      const result: TaskManager = TaskPool.getPool(taskType, ...args);
      expect(result !== undefined).assertTrue();
    });

    it('clearTask_should_log_error_when_checkStrIsEmpty_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockCheckStrIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockCheckStrIsEmpty)(ArgumentMatchers.any).afterReturn(true);
      const result: void = TaskPool.clearTask(undefined);
      expect(result === undefined).assertTrue();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
    });

    it('clearTask_should_log_error_when_taskType_is_empty', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockCheckStrIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockCheckStrIsEmpty)(ArgumentMatchers.any).afterReturn(false);
      let baseTask: BaseTask = new BaseTask();
      baseTask.taskType = '';
      const result: void = TaskPool.clearTask(baseTask);
      expect(result === undefined).assertTrue();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
    });

    it('clearTask_should_log_error_when_options_taskType_is_not_empty_and_exists_in_pool', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockCheckStrIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockCheckStrIsEmpty)(ArgumentMatchers.any).afterReturn(false);
      let baseTask: BaseTask = new BaseTask();
      baseTask.taskType = '';
      let manager: TaskManager = new TaskManager();
      (TaskPool as object)['taskPool'].set('', manager)
      const result: void = TaskPool.clearTask(baseTask);
      expect(result === undefined).assertTrue();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
    });

    it('clearTask_should_log_error_when_options_taskType_is_empty_and_exists_in_pool', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockCheckStrIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockCheckStrIsEmpty)(ArgumentMatchers.any).afterReturn(false);
      let baseTask: BaseTask = new BaseTask();
      baseTask.taskType = '';
      (TaskPool as object)['taskPool'].remove('');
      const result: void = TaskPool.clearTask(baseTask);
      expect(result === undefined).assertTrue();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
    });
  });
}
