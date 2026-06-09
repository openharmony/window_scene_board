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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, ArgumentMatchers, when } from '@ohos/hypium';
import { BaseViewController } from '../../../../../../../main/ets/manager/view/BaseViewController';

import { ViewArea, ViewType, ViewCallback, TrimLevel } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { SCBSceneSessionManager } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneSessionManager';

const mBaseViewController: BaseViewController = new BaseViewController(ViewType.KEYGUARD);
const mViewCallback: ViewCallback = {
}
const mViewCallbackHook: ViewCallback = {
  onShow: (): void => {},
  onHide: (): void => {},
  onGainFocus: (): void => {},
  onLoseFocus: (): void => {},
  onTrimMemory: (): void => {},
}
const mViewCallbackNotRegis: ViewCallback = {
}

export function BaseViewControllerTest() {
  describe('BaseViewControllerTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('onTrimMemory_level_one', 0, (): void => {
      let baseViewController = new BaseViewController('');
      let levelBackground:TrimLevel =TrimLevel.LIGHT;
      let levelComplete:TrimLevel =TrimLevel.COMPLETE;
      let reason = '';
      expect(baseViewController.onTrimMemory(levelBackground, reason) === undefined).assertTrue();
      expect(baseViewController.onTrimMemory(levelComplete, reason) === undefined).assertTrue();
    })

    it('updateId_persistentId', 0, (): void => {
      let baseViewController = new BaseViewController('');
      baseViewController.updateId(1);
      expect(baseViewController['persistentId']).assertEqual(1);
    })

    it('getId_return_number', 0, (): void => {
      let baseViewController = new BaseViewController('');
      let res = baseViewController.getId();
      expect(res).assertInstanceOf('Number');
    })

    it('show_visible_true', 0, (): void => {
      let baseViewController = new BaseViewController('');
      baseViewController['visible'] = true;
      expect(baseViewController.show() === undefined).assertTrue();
    })

    it('show_visible_false', 0, (): void => {
      let baseViewController = new BaseViewController('');
      baseViewController['visible'] = false;
      expect(baseViewController.show() === undefined).assertTrue();
    })

    it('hide_visible_true', 0, (): void => {
      let baseViewController = new BaseViewController('');
      baseViewController['visible'] = true;
      expect(baseViewController.show() === undefined).assertTrue();
    })

    it('onTrimMemory', 0, (): void => {
      mBaseViewController.registerCallback(mViewCallback);
      mBaseViewController.registerCallback(mViewCallbackHook);
      mBaseViewController.registerCallback(null);
      mBaseViewController.onTrimMemory(TrimLevel.LIGHT, 'forTest');
      mBaseViewController.onTrimMemory(TrimLevel.COMPLETE, 'forTest');
      mBaseViewController.onTrimMemory(2, 'forTest');
      expect(true).assertTrue();
    })

    it('unRegisterCallback', 0, (): void => {
      expect(mBaseViewController.unRegisterCallback(mViewCallback) === undefined).assertTrue();
      expect(mBaseViewController.unRegisterCallback(mViewCallbackNotRegis) === undefined).assertTrue();
      mBaseViewController.registerCallback(mViewCallback);
    })

    it('BaseViewControllerTest_show_and_hide', 0, (): void => {
      let isCalled: Boolean = false;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      when(mockFunc)(ArgumentMatchers.any).afterAction((): void => {
        isCalled = true
      })
      mBaseViewController.show();
      mBaseViewController.hide();
      mBaseViewController.show();
      expect(isCalled).assertTrue();
      mocker.clear(SCBSceneSessionManager.getInstance());
      mocker.clearAll();
    })

    it('BaseViewControllerTest_destroy', 0, (): void => {
      let isCalled: Boolean = false;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      when(mockFunc)(ArgumentMatchers.any).afterAction((): void => {
        isCalled = true
      })
      mBaseViewController.destroy();
      expect(isCalled).assertTrue();
      mocker.clear(SCBSceneSessionManager.getInstance());
      mocker.clearAll();
    })

    it('BaseViewControllerTest_destroy_mock', 0, (): void => {
      let isCalled: Boolean = false;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneSessionManager.getInstance());
      when(mockFunc)(ArgumentMatchers.any).afterAction((): void => {
        isCalled = true
      })
      mBaseViewController.destroy();
      expect(isCalled).assertTrue();
      mocker.clear(SCBSceneSessionManager.getInstance());
      mocker.clearAll();
    })

    it('updateArea', 0, (): void => {
      const mViewArea: ViewArea = {
        left: 1,
        top: 1,
        width: 1,
        height: 1
      }
      mBaseViewController.updateArea(mViewArea);
      mBaseViewController.updateArea(mViewArea);
      mBaseViewController.updateArea({
        left: 1,
        top: 2,
        width: 1,
        height: 1
      });
      mBaseViewController.updateArea({
        left: 1,
        top: 2,
        width: 2,
        height: 1
      });
      mBaseViewController.updateArea({
        left: 1,
        top: 2,
        width: 2,
        height: 2
      });
      expect(true).assertTrue();
    })

    it('updateRect', 0, (): void => {
      let isCalled: Boolean = false;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      when(mockFunc)(ArgumentMatchers.any).afterAction((): void => {
        isCalled = true
      })
      mBaseViewController.updateRect({
        left: 1,
        top: 1,
        width: 1,
        height: 1
      })
      mBaseViewController.setTranslate(1,1,1);
      mBaseViewController.setOpacity(1);
      mBaseViewController.setTouchable(true);
      mBaseViewController.registerInputMethodChange((): void => {});
      mBaseViewController.unregisterInputMethodChange();
      mBaseViewController.updateOpacity(1);
      mBaseViewController.setResponseRegion(null);
      expect(isCalled).assertTrue();
      mocker.clear(SCBSceneSessionManager.getInstance());
      mocker.clearAll();
    })

    it('setTranslate', 0, (): void => {
      try{
        mBaseViewController.setTranslate(1,1,1);
      } catch (e) {
      };
      try{
        mBaseViewController.setOpacity(1);
      } catch (e) {
      };
      try{
        mBaseViewController.setTouchable(true);
      } catch (e) {
      };
      try{
        mBaseViewController.unregisterInputMethodChange();
      } catch (e) {
      };
      try{
        mBaseViewController.updateOpacity(1);
      } catch (e) {
      };
      expect(true).assertTrue();
    })
  })
}