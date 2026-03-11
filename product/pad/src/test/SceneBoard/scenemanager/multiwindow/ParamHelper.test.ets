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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { afterEach, describe, expect, it, Level } from '@ohos/hypium';
import { ParamHelper } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/utils/ParamHelper';

class TestParam {
  public tag: string;
  constructor(tag: string) {
    this.tag = tag;
  }
}

class TestParamHelper extends ParamHelper<TestParam> {
  creatParam(tag: string): TestParam {
    return new TestParam(tag);
  }
}

const TAG = 'paramHelperTest';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
let helper = new TestParamHelper(log)

export function paramHelperTest() {
  describe('paramHelperTest_001', () => {
    afterEach(() => {
      helper.clear();
    })
    it('getTest_001', Level.LEVEL0, () => {
      let param = helper.get('test');
      expect(param).assertUndefined();
      let param2 = helper.obtain('test');
      let param3 = helper.get('test');
      expect(param3).assertEqual(param2);
    });
    it('deleteTest_001', Level.LEVEL0, () => {
      let param = helper.obtain('test');
      expect(helper.record.size).assertEqual(1);
      helper.delete(param.tag);
      expect(helper.record.size).assertEqual(0);
    });
    it('obtainTest_001', Level.LEVEL0, () => {
      let param = helper.obtain('test');
      expect(param.tag).assertEqual('test');
      let param2 = helper.obtain('test');
      expect(param2).assertEqual(param)
    });
    it('deleteMatchTest_001', Level.LEVEL0, () => {
      helper.obtain('test_1');
      helper.obtain('test_2');
      helper.obtain('t_test');
      expect(helper.record.size).assertEqual(3);
      helper.deleteMatch('^test_.*');
      expect(helper.record.size).assertEqual(1);
    });
    it('clearTest_001', Level.LEVEL0, () => {
      helper.obtain('test_1');
      helper.obtain('test_2');
      helper.obtain('t_test');
      expect(helper.record.size).assertEqual(3);
      helper.clear();
      expect(helper.record.size).assertEqual(0);
    });
  });
}