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
import { Task } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowTask';
import { describe, expect, it, Level } from '@ohos/hypium';

export default function multiWindowTaskTest() {
  describe('multiWindowTaskTest_describe', () => {
    setHandlerTest_func();
    obtainTest_func();
    cancelTest_func();
    submitTest_func();
    runDirectTest_func();
    findTest_func();
    postTest_func();

  });
}
function setHandlerTest_func() {
  it('setHandler_it', Level.LEVEL0, () => {
    let task = Task.obtain('test');
    let flag: number[] = [0];
    task.setHandler(() => {
      flag[0] = 1;
    });
    task.runDirect();
    expect(flag[0]).assertEqual(1);
  });
}

function obtainTest_func() {
  it('obtain_reuse_it', Level.LEVEL0, () => {
    let flag: number[] = [0];
    let oTask = Task.obtain('test', () => {
      flag[0] = 2;
    });
    let task = Task.post('test', () => {
      flag[0] = 1;
    });
    expect(oTask).assertEqual(task);
    task.runDirect();
    expect(flag[0]).assertEqual(2);
  });

  it('obtain_without_callback_it', Level.LEVEL0, () => {
    let task = Task.obtain('test');
    expect(Boolean(task)).assertTrue();
  });

  it('obtain_with_callback_it', Level.LEVEL0, () => {
    let flag: number[] = [0];
    let task = Task.obtain('test', () => {
      flag[0] = 1;
    });
    expect(Boolean(task)).assertTrue();
    task.runDirect();
    expect(flag[0]).assertEqual(1);
  });
}

function cancelTest_func() {
  it('task_cancel_failed_it', Level.LEVEL0, () => {
    let task = Task.obtain('test');
    expect(task.cancel()).assertFalse();
  });

  it('task_cancel_success_it', Level.LEVEL0, () => {
    let task = Task.post('test', () => {
    });
    expect(task.cancel()).assertTrue();
  });

  it('cancel_success_it', Level.LEVEL0, () => {
    let task = Task.post('test', () => {
    });
    expect(Task.cancel('test')).assertTrue();
    expect(task.info().search('-1') === -1).assertFalse();
  });

  it('cancel_failed_it', Level.LEVEL0, () => {
    expect(Task.cancel('test')).assertFalse();
  });
}

function submitTest_func() {
  it('submit_it', Level.LEVEL0, () => {
    let flag: number[] = [0];
    let task = Task.obtain('test_submit', () => {
      flag[0] = 1;
    });
    let fTask = Task.find('test_submit');
    expect(fTask).assertUndefined();
    task.submit();
    fTask = Task.find('test_submit');
    expect(fTask !== undefined).assertTrue();
    expect(fTask?.info().search('test_submit') === -1).assertFalse();
    expect(task.cancel()).assertTrue();
    task.runDirect();
    expect(flag[0]).assertEqual(1);
  });
}

function runDirectTest_func() {
  it('runDirect_it', Level.LEVEL0, () => {
    let flag: number[] = [0];
    let task = Task.post('test', () => {
      flag[0] = 1;
    });
    task.runDirect();
    expect(task.info().search('-1') === -1).assertFalse();
    expect(flag[0]).assertEqual(1);
  });
}

function findTest_func() {
  it('find_it', Level.LEVEL0, () => {
    let task = Task.post('test_find', () => {
    });
    let fTask = Task.find('test_find');
    expect(fTask).assertEqual(task);
    task.cancel();
  });

  it('find_undefined_it', Level.LEVEL0, () => {
    let task = Task.find('test_find_undefined');
    expect(task).assertUndefined();
  });
}



function postTest_func() {
  it('post_it', Level.LEVEL0, () => {
    let flag: number[] = [0];
    let task = Task.post('test_post', () => {
      flag[0] = 1;
    });
    let fTask = Task.find('test_post');
    expect(fTask !== undefined).assertTrue();
    expect(fTask?.info().search('test_post') === -1).assertFalse();
    expect(task.cancel()).assertTrue();
    task.runDirect();
    expect(flag[0]).assertEqual(1);
  });
}
