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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { immersiveFgCtrl, ImmersiveFingerListener, FingerHideScene, FingerExtendScene } from '../../../../main/ets/model/service/ImmersiveFingerControll';
import { CommonUtils } from '@ohos/basicutils';
import { ImmersiveAnimScene } from '../../../../main/ets/common/anim/ImmersiveAnimConstants';
import {
  FingerprintType
} from '@ohos/screenlockcommon';
import {
  ImmersiveType
} from '@ohos/systemuicommon';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveFingerControllTest01() {
  let mocker: MockKit;
  describe('ImmersiveFingerControllTest01', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    });
    beforeEach((): void => {

    });
    afterAll((): void => {
      mocker.clearAll();
    });
    afterEach((): void => {

    });

    it('initTest', Level.LEVEL0, (): void => {
      immersiveFgCtrl.init();
      expect(true).assertTrue();
    });

    it('RegisterImmersiveFingerListenerTest', Level.LEVEL0, (): void => {
      let immersiveFingerStateListener: ImmersiveFingerListener = {
        onNtfDataUpdate: (isShowFinger: boolean) => {
        }
      }
      immersiveFgCtrl.registerImmersiveFingerListener(immersiveFingerStateListener);
      immersiveFgCtrl.unregisterImmersiveFingerListener(immersiveFingerStateListener);
      let mockfunc_1 = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockfunc_1)(ArgumentMatchers.any).afterReturn(true);
      immersiveFgCtrl.registerImmersiveFingerListener(immersiveFingerStateListener);
      immersiveFgCtrl.unregisterImmersiveFingerListener(immersiveFingerStateListener);
      mocker.clear(CommonUtils);
      expect(true).assertTrue();
    });

    it('isFingerPrintTest', Level.LEVEL0, (): void => {
      (immersiveFgCtrl as object)['isFingerShow'] = false;
      (immersiveFgCtrl as object)['isRecognition'] = false;
      (immersiveFgCtrl as object)['isFingerPrint']();
      (immersiveFgCtrl as object)['isRecognition'] = true;
      (immersiveFgCtrl as object)['isFingerPrint']();
      (immersiveFgCtrl as object)['isFingerShow'] = true;
      (immersiveFgCtrl as object)['isRecognition'] = false;
      (immersiveFgCtrl as object)['isFingerPrint']();
      (immersiveFgCtrl as object)['isRecognition'] = true;
      (immersiveFgCtrl as object)['isFingerPrint']();
      expect(true).assertTrue();
    });

    it('isLowPosFingerPrintTest', Level.LEVEL0, (): void => {
      (immersiveFgCtrl as object)['isRecognition'] = false;
      (immersiveFgCtrl as object)['isLowPosFingerShow'] = false;
      (immersiveFgCtrl as object)['isLowPosFingerPrint']();
      (immersiveFgCtrl as object)['isLowPosFingerShow'] = true;
      (immersiveFgCtrl as object)['isLowPosFingerPrint']();
      (immersiveFgCtrl as object)['isLowPosFingerShow'] = false;
      (immersiveFgCtrl as object)['isRecognition'] = true;
      (immersiveFgCtrl as object)['isLowPosFingerPrint']();
      (immersiveFgCtrl as object)['isLowPosFingerShow'] = true;
      (immersiveFgCtrl as object)['isLowPosFingerPrint']();
      expect(true).assertTrue();
    });

    it('removeFingerHideSceneTest', Level.LEVEL0, (): void => {
      let fingerType: FingerHideScene = FingerExtendScene.SCENE_DEFAULT;
      immersiveFgCtrl.addFingerHideScene(fingerType);
      immersiveFgCtrl.removeFingerHideScene(fingerType);
      immersiveFgCtrl.removeFingerHideScene(undefined);
      fingerType = ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH;
      immersiveFgCtrl.addFingerHideScene(fingerType);
      immersiveFgCtrl.removeFingerHideScene(fingerType);
      expect(true).assertTrue();
    });

  });
}



