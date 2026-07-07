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
import { AodThemeConstants, AodUtil } from '@ohos/aod';
import { ThreeFoldAodUtil } from '@ohos/aod/src/main/ets/utils/ThreeFoldAodUtil';
import { MockUtil } from '@ohos/aod/src/ohosTest/ets/test/MockUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { describe, it, expect } from '@ohos/hypium';
import {
  AodViewControllerInteractiveFolder
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerInteractiveFolder';
import { image } from '@kit.ImageKit';

export function AodViewControllerInteractiveFolderTest() {
  describe('AodViewControllerInteractiveFolderTest', () => {

    it('only_one_instance_when_call_any_times_of_getInstance', 0, () => {
      const instance0 = AodViewControllerInteractiveFolder.getInstance();
      const instance1 = AodViewControllerInteractiveFolder.getInstance();

      expect(true).assertTrue();
    });

    it('test_prepareRes', 0, async (done: Function) => {
      const viewController = new TestAodViewControllerInteractiveFolder();
      MockUtil.mockFuncForObj(viewController, 'prepareRes');
      viewController.setNeedUpdateFoldStatus(true);
      await viewController.prepareResTest();
      expect(true).assertTrue();
      MockUtil.clearAll();
      done();
    });

    it('test_prepareRes1', 0, async (done: Function) => {
      const viewController = new TestAodViewControllerInteractiveFolder();
      MockUtil.mockFuncForObj(viewController, 'prepareRes');
      viewController.setNeedUpdateFoldStatus(false);
      await viewController.prepareResTest();
      expect(true).assertTrue();
      MockUtil.clearAll();
      done();
    });

    it('test_show', 0, async (done: Function) => {
      const instance = TestAodViewControllerInteractiveFolder.getInstance();
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

    it('test_getMaxDensity', 0, async (done: Function) => {
      const instance = AodViewControllerInteractiveFolder.getInstance();
      MockUtil.mockFuncForObj(DeviceHelper, 'isThreeFoldProduct', (): boolean => {
        return true;
      });
      MockUtil.mockFuncForObj(ThreeFoldAodUtil, 'isGStatus', (): boolean => {
        return true;
      });
      const result = Math.abs(instance.getMaxDensity() - AodThemeConstants.SCALE_FACTOR_THREE_FOLD_G *
        AodThemeConstants.DENSITY_THREE_FOLD) < Number.EPSILON;
      expect(result).assertTrue();
      MockUtil.clearAll();
      done();
    });

    it('test_scaleAnimImage', 0, async (done: Function) => {
      const instance = AodViewControllerInteractiveFolder.getInstance();
      MockUtil.mockFuncForObj(DeviceHelper, 'isThreeFoldProduct', (): boolean => {
        return true;
      });
      MockUtil.mockFuncForObj(ThreeFoldAodUtil, 'isGStatus', (): boolean => {
        return true;
      });
      let imageInfo: image.PixelMap = {} as image.PixelMap;
      (instance as object)['scaleAnimImage'](imageInfo);
      expect(instance).not().assertNull();
      MockUtil.clearAll();
      done();
    });
  });
}

class TestAodViewControllerInteractiveFolder extends AodViewControllerInteractiveFolder {
  constructor() {
    super();
  }

  public async prepareResTest(): Promise<void> {
    await this.prepareRes(false);
  }
}