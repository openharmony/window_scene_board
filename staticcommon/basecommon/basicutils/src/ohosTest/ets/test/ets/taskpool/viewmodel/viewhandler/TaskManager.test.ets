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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { AfterFullType, BaseTask } from '../../../../../../../main/ets/taskpool/model/BaseTask';
import { TaskExecutor } from '../../../../../../../main/ets/taskpool/viewmodel/viewdata/TaskExecutor';
import { TaskManager } from '../../../../../../../main/ets/taskpool/viewmodel/viewhandler/TaskManager';
import { taskpool } from '@kit.ArkTS';
import { TaskCallBack } from '../../../../../../../main/ets/taskpool/model/TaskCallBack';

export default function TaskManagerTest() {
  describe('TaskManagerTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });

    it('cancel_should_call_callback_onCancel_when_task_is_not_null', 0, () => {
      let taskManager: TaskManager = new TaskManager();
      let task: TaskExecutor = new TaskExecutor();
      task.task = {} as taskpool.Task;
      task.taskName = 'testTask';
      let baseTask = new BaseTask();
      baseTask.taskType = 'testType';
      taskManager.pool = baseTask;
      expect(taskManager.cancel(task) === undefined).assertTrue();
    });

    it('cancel_should_do_nothing_when_task_is_null', 0, () => {
      let taskManager: TaskManager = new TaskManager();
      let task: TaskExecutor = new TaskExecutor();
      task.task = undefined;
      expect(taskManager.cancel(task) === undefined).assertTrue();
    });

    it('checkTask_should_reject_when_callBack_is_undefined', 0, () => {
      let taskManager: TaskManager = new TaskManager();
      let taskCallBack: TaskCallBack = {
        onCheckFail: () => {
        },
        onCancel: () => {
        },
        onException: () => {
        },
        onFinish: () => {
        }
      };
      taskManager.callBack(taskCallBack);
      let reject: Function = () => {
      };
      let result: boolean = (taskManager as object)['checkTask'](reject);
      expect(result).assertEqual(true);
    });

    it('checkTask_should_reject_when_pool_is_undefined', 0, () => {
      let taskManager: TaskManager = new TaskManager();
      let taskCallBack: TaskCallBack = {
        onCheckFail: () => {
        },
        onCancel: () => {
        },
        onException: () => {
        },
        onFinish: () => {
        }
      };
      taskManager.callBack(taskCallBack);
      taskManager.pool = undefined;
      let reject: Function = () => {
      };
      let result: boolean = (taskManager as object)['checkTask'](reject);
      expect(result).assertEqual(true);
    });

    it('checkTask_should_reject_when_afterFull_is_error', 0, () => {
      let taskManager: TaskManager = new TaskManager();
      let taskCallBack: TaskCallBack = {
        onCheckFail: () => {
        },
        onCancel: () => {
        },
        onException: () => {
        },
        onFinish: () => {
        }
      };
      taskManager.callBack(taskCallBack);
      taskManager.pool = new BaseTask();
      taskManager.pool.afterFull = AfterFullType.CHECK_FAIL + 1;
      let reject: Function = () => {
      };
      let result: boolean = (taskManager as object)['checkTask'](reject);
      expect(result).assertEqual(true);
    });

    it('checkTask_should_reject_when_maxInstance_is_zero', 0, () => {
      let taskManager: TaskManager = new TaskManager();
      let taskCallBack: TaskCallBack = {
        onCheckFail: () => {
        },
        onCancel: () => {
        },
        onException: () => {
        },
        onFinish: () => {
        }
      };
      taskManager.callBack(taskCallBack);
      taskManager.pool = new BaseTask();
      taskManager.pool.afterFull = 1;
      taskManager.pool.maxInstance = 0;
      let reject: Function = () => {
      };
      let result: boolean = (taskManager as object)['checkTask'](reject);
      expect(result).assertEqual(true);
    });

    it('checkTask_should_reject_when_runningTasks_is_full_and_afterFull_is_CHECK_FAIL', 0, () => {
      let taskManager: TaskManager = new TaskManager();
      let taskCallBack: TaskCallBack = {
        onCheckFail: () => {
        },
        onCancel: () => {
        },
        onException: () => {
        },
        onFinish: () => {
        }
      };
      taskManager.callBack(taskCallBack);
      taskManager.pool = new BaseTask();
      taskManager.pool.afterFull = AfterFullType.CHECK_FAIL;
      taskManager.pool.maxInstance = 1;
      taskManager.runningTasks.add(new TaskExecutor());
      let reject: Function = () => {
      };
      let result: boolean = (taskManager as object)['checkTask'](reject);
      expect(result).assertEqual(false);
    });

    it('atc_should_ignore_when_runningTasks_is_full_and_afterFull_is_IGNORE', 0, () => {
      let taskManager: TaskManager = new TaskManager();
      taskManager.pool = new BaseTask();
      taskManager.pool.maxInstance = 1;
      taskManager.pool.afterFull = AfterFullType.IGNORE;
      taskManager.runningTasks.add(new TaskExecutor());
      let reject: Function = () => {
      };
      let result: boolean = (taskManager as object)['checkTask'](reject);
      expect(result).assertEqual(true);
    });

  });
}
