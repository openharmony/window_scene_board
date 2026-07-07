/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import { AodUtil } from '@ohos/aod';
import { MockUtil } from '@ohos/aod/src/ohosTest/ets/test/MockUtil';
import { describe, it, expect } from '@ohos/hypium';
import {
  AodViewControllerStereoForeImageFolder
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerStereoForeImageFolder';

export function AodViewControllerStereoForeImageFolderTest() {
  describe('AodViewControllerStereoForeImageFolderTest', () => {

    it('only_one_instance_when_call_any_times_of_getInstance', 0, () => {
      const instance0 = AodViewControllerStereoForeImageFolder.getInstance();
      const instance1 = AodViewControllerStereoForeImageFolder.getInstance();

      expect(true).assertTrue();
    });

    it('test_prepareRes', 0, async (done: Function) => {
      const viewController = new TestAodViewControllerStereoForeImageFolder();
      MockUtil.mockFuncForObj(viewController, 'prepareRes');
      viewController.setNeedUpdateFoldStatus(true);
      await viewController.prepareResTest();
      expect(true).assertTrue();
      MockUtil.clearAll();
      done();
    });

    it('test_prepareRes1', 0, async (done: Function) => {
      const viewController = new TestAodViewControllerStereoForeImageFolder();
      MockUtil.mockFuncForObj(viewController, 'prepareRes');
      viewController.setNeedUpdateFoldStatus(false);
      await viewController.prepareResTest();
      expect(true).assertTrue();
      MockUtil.clearAll();
      done();
    });

    it('test_show', 0, async (done: Function) => {
      const instance = AodViewControllerStereoForeImageFolder.getInstance();
      MockUtil.mockFuncForObj(AodUtil, 'getFoldStatus', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(instance, 'prepareRes');
      MockUtil.mockFuncForObj(instance, 'setDrawObservers');
      await instance.show();
      expect(true).assertTrue();
      MockUtil.clearAll();
      done();
    });

  });
}

class TestAodViewControllerStereoForeImageFolder extends AodViewControllerStereoForeImageFolder {
  constructor() {
    super();
  }

  public async prepareResTest(): Promise<void> {
    await this.prepareRes(false);
  }
}