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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {
  UIExceptionCaller,
  UIExceptionDetection, UIExceptionType } from '../../../../../main/ets/recent/UIExceptionDetection';
import { UIExceptionParams } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/ReportParams';

export function UIExceptionDetectionTest() {
  describe('UIExceptionDetectionTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('backgroundBlurExceptionDetection_test_01', 0, (): void => {
      let exceptionDetection = new UIExceptionDetection();
      exceptionDetection.unRegisterUIExceptionCallback(UIExceptionType.BACKGROUND_BLUR);
      exceptionDetection.backgroundBlurExceptionDetection(UIExceptionCaller.UNLOCK_TO_HOME);
      expect(exceptionDetection).not().assertUndefined();
    })

    it('backgroundBlurExceptionDetection_test_02', 0, (): void => {
      let exceptionDetection = new UIExceptionDetection();
      exceptionDetection.registerUIExceptionCallback(UIExceptionType.BACKGROUND_BLUR, {
        exceptionDetection: (): boolean => {
          return true;
        },
        exceptionRestore: (): void => {
          return;
        },
        getExceptionParams: (): UIExceptionParams => {
          return {};
        }
      });
      exceptionDetection.backgroundBlurExceptionDetection(UIExceptionCaller.UNLOCK_TO_HOME);
      expect(exceptionDetection).not().assertUndefined();
    })

    it('clearAllIconExceptionDetection_test_01', 0, (): void => {
      let exceptionDetection = new UIExceptionDetection();
      exceptionDetection.unRegisterUIExceptionCallback(UIExceptionType.CLEAR_ALL_ICON);
      exceptionDetection.clearAllIconExceptionDetection(UIExceptionCaller.UNLOCK_TO_HOME);
      expect(exceptionDetection).not().assertUndefined();
    })

    it('clearAllIconExceptionDetection_test_02', 0, (): void => {
      let exceptionDetection = new UIExceptionDetection();
      exceptionDetection.registerUIExceptionCallback(UIExceptionType.CLEAR_ALL_ICON, {
        exceptionDetection: (): boolean => {
          return true;
        },
        exceptionRestore: (): void => {
          return;
        },
        getExceptionParams: (): UIExceptionParams => {
          return {};
        }
      });
      exceptionDetection.clearAllIconExceptionDetection(UIExceptionCaller.UNLOCK_TO_HOME);
      expect(exceptionDetection).not().assertUndefined();
    })

    it('restoreUIException_test_01', 0, (): void => {
      let exceptionDetection = new UIExceptionDetection();
      (exceptionDetection as object)['isBlurException'] = true;
      (exceptionDetection as object)['isClearAllIconException'] = true;
      exceptionDetection.restoreUIException();
      expect(exceptionDetection).not().assertUndefined();
    })

    it('registerUIExceptionCallback_test_01', 0, (): void => {
      let exceptionDetection = new UIExceptionDetection();
      exceptionDetection.registerUIExceptionCallback(UIExceptionType.CLEAR_ALL_ICON, {
        exceptionDetection: (): boolean => {
          return true;
        },
        exceptionRestore: (): void => {
          return;
        },
        getExceptionParams: (): UIExceptionParams => {
          return {};
        }
      });
      exceptionDetection.registerUIExceptionCallback(UIExceptionType.CLEAR_ALL_ICON, {
        exceptionDetection: (): boolean => {
          return true;
        },
        exceptionRestore: (): void => {
          return;
        },
        getExceptionParams: (): UIExceptionParams => {
          return {};
        }
      })
      expect(exceptionDetection).not().assertUndefined();
    })
  })
}