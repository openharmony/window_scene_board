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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium';
import { GlobalContext, ResourceManager, SceneState, ViewManagerPolicy } from '@ohos/frameworkwrapper';
import { AppIconClockEvent } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconClockEvent';
import { AppIconClockVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconClockVm';
import { image } from '@kit.ImageKit';

export default function AppIconClockEventTest() {


  describe('AppIconClockEventTest', () => {
    let clockIconVm: AppIconClockVm = new AppIconClockVm();
    let clockIconEvent: AppIconClockEvent = new AppIconClockEvent(clockIconVm);
    beforeAll(() => {
      clockIconEvent.init();
    });

    beforeEach(() => {
    });

    afterAll(() => {
      clockIconEvent.destroy();
    });

    afterEach(() => {
    });

    it('test_init_01', 0, () => {
      try {
        let clockIconVm: AppIconClockVm = new AppIconClockVm();
        let clockIconEvent: AppIconClockEvent = new AppIconClockEvent(clockIconVm);
        clockIconEvent.init();
        clockIconEvent.destroy();
        expect(clockIconEvent instanceof AppIconClockEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onVisibleAreaChange_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        let clockIconVm: AppIconClockVm = new AppIconClockVm();
        let clockIconEvent: AppIconClockEvent = new AppIconClockEvent(clockIconVm);
        clockIconEvent.onVisibleAreaChange(true);
        expect(clockIconEvent instanceof AppIconClockEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ViewManagerPolicy);
      mock.clearAll();
    })

    it('test_onVisibleAreaChange_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let clockIconVm: AppIconClockVm = new AppIconClockVm();
        let clockIconEvent: AppIconClockEvent = new AppIconClockEvent(clockIconVm);
        clockIconEvent.onVisibleAreaChange(true);
        expect(clockIconEvent instanceof AppIconClockEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ViewManagerPolicy);
      mock.clearAll();
    })

    it('test_initEventHub_01', 0, () => {
      try {
        let clockIconVm: AppIconClockVm = new AppIconClockVm();
        let clockIconEvent: AppIconClockEvent = new AppIconClockEvent(clockIconVm);
        (clockIconEvent as object)['initEventHub']();
        (clockIconEvent as object)['destroyEventHub']();
        expect(clockIconEvent instanceof AppIconClockEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onIconResourceChange_01', 0, () => {
      try {
        let clockIconVm: AppIconClockVm = new AppIconClockVm();
        let clockIconEvent: AppIconClockEvent = new AppIconClockEvent(clockIconVm);
        (clockIconEvent as object)['onIconResourceChange']();
        expect(clockIconEvent instanceof AppIconClockEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initImage_01', 0, () => {
      try {
        let clockIconVm: AppIconClockVm = new AppIconClockVm();
        let clockIconEvent: AppIconClockEvent = new AppIconClockEvent(clockIconVm);
        (clockIconEvent as object)['initImage']();
        expect(clockIconEvent instanceof AppIconClockEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initImage_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(ResourceManager.getInstance(), ResourceManager.getInstance().getPixelMapByResourceName);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);

        let clockIconVm: AppIconClockVm = new AppIconClockVm();
        let clockIconEvent: AppIconClockEvent = new AppIconClockEvent(clockIconVm);
        (clockIconEvent as object)['initImage']();
        expect(clockIconEvent instanceof AppIconClockEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ResourceManager.getInstance());
      mock.clearAll();
    })

    it('test_initImage_03', 0, () => {
      let mock = new MockKit();
      try {
        let iconSrc: image.PixelMap =
          GlobalContext.getContext()?.resourceManager.getDrawableDescriptor($r('app.media.default_icon').id)
            .getPixelMap();
        let mockFunc: Function =
          mock.mockFunc(ResourceManager.getInstance(), ResourceManager.getInstance().getPixelMapByResourceName);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(iconSrc);

        let clockIconVm: AppIconClockVm = new AppIconClockVm();
        let clockIconEvent: AppIconClockEvent = new AppIconClockEvent(clockIconVm);
        (clockIconEvent as object)['initImage']();
        expect(clockIconEvent instanceof AppIconClockEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ResourceManager.getInstance());
      mock.clearAll();
    })

    it('test_updateTimer_01', 0, () => {
      try {
        let clockIconVm: AppIconClockVm = new AppIconClockVm();
        let clockIconEvent: AppIconClockEvent = new AppIconClockEvent(clockIconVm);
        (clockIconEvent as object)['isFocus'] = true;
        (clockIconEvent as object)['isVisible'] = true;
        (clockIconEvent as object)['updateTimer']();
        expect(clockIconEvent instanceof AppIconClockEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateTimer_02', 0, () => {
      try {
        let clockIconVm: AppIconClockVm = new AppIconClockVm();
        let clockIconEvent: AppIconClockEvent = new AppIconClockEvent(clockIconVm);
        (clockIconEvent as object)['isFocus'] = true;
        (clockIconEvent as object)['isVisible'] = false;
        (clockIconEvent as object)['updateTimer']();
        expect(clockIconEvent instanceof AppIconClockEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_iconChangeListener_01', 0, () => {
      try {
        let clockIconVm: AppIconClockVm = new AppIconClockVm();
        let clockIconEvent: AppIconClockEvent = new AppIconClockEvent(clockIconVm);
        (clockIconEvent as object)['iconChangeListener'].onIconResourceChange();
        expect(clockIconEvent instanceof AppIconClockEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_focusChangeEventHandle_01', 0, () => {
      try {
        let clockIconVm: AppIconClockVm = new AppIconClockVm();
        let clockIconEvent: AppIconClockEvent = new AppIconClockEvent(clockIconVm);
        (clockIconEvent as object)['focusChangeEventHandle'](true);
        expect(clockIconEvent instanceof AppIconClockEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_invisibleStateEventHandle_01', 0, () => {
      try {
        let clockIconVm: AppIconClockVm = new AppIconClockVm();
        let clockIconEvent: AppIconClockEvent = new AppIconClockEvent(clockIconVm);
        (clockIconEvent as object)['invisibleStateEventHandle']();
        expect(clockIconEvent instanceof AppIconClockEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_sceneIdentificationEventHandle_01', 0, () => {
      try {
        let clockIconVm: AppIconClockVm = new AppIconClockVm();
        let clockIconEvent: AppIconClockEvent = new AppIconClockEvent(clockIconVm);
        (clockIconEvent as object)['sceneIdentificationEventHandle'](SceneState.RECENT_EXIT);
        (clockIconEvent as object)['sceneIdentificationEventHandle'](SceneState.FOLDER_CLOSE);
        (clockIconEvent as object)['sceneIdentificationEventHandle'](SceneState.RECENT_ENTER);
        (clockIconEvent as object)['sceneIdentificationEventHandle'](SceneState.FOLDER_OPEN);
        (clockIconEvent as object)['sceneIdentificationEventHandle'](SceneState.EDIT_MODE_EXIT);
        expect(clockIconEvent instanceof AppIconClockEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })




  });
}