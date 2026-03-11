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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { windowManager } from '../../../../../../main/ets/manager/WindowManager';
import window from '@ohos.window';

export function WindowManagerTest() {
  describe('WindowManagerTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_getWindowWidth_should_return_true', Level.LEVEL0, (): void => {
      let screenW: number = windowManager.getWindowWidth();
      let res: boolean = screenW > 0;
      expect(res).assertTrue();
    })

    it('test_getWindowHeight_should_return_true', Level.LEVEL0, (): void => {
      let screenH: number = windowManager.getWindowHeight();
      let res: boolean = screenH > 0;
      expect(res).assertTrue();
    })

    it('test_isSplitWindowMode', Level.LEVEL0, (): void => {
      expect(windowManager.isSplitWindowMode(100))
        .assertTrue();
      expect(windowManager.isSplitWindowMode(101))
        .assertTrue();
      expect(windowManager.isSplitWindowMode(1))
        .assertFalse();
    })

    it('test_isSplitWindowMode_should_return', Level.LEVEL0, (): void => {
      let res: boolean = windowManager.isSplitWindowMode(100);
      expect(res).assertTrue();
      res = windowManager.isSplitWindowMode(101);
      expect(res).assertTrue();

      res = windowManager.isSplitWindowMode(102);
      expect(res).assertFalse();
    })

    it('test_findWindow_should_return', Level.LEVEL0, (): void => {
      let win1 = getLastWindow();
      windowManager.hideWindowStatusBar('EntryView');
      windowManager.showWindowStatusBar('EntryView');
      windowManager.hideWindowStatusBar(null);
      windowManager.showWindowStatusBar(null);
      let win2 = getLastWindow();
      expect(win1?.isWindowShowing()).assertEqual(win2?.isWindowShowing());
    })

    it('test_hideWindow_should_return', Level.LEVEL0, (): void => {
      let win1 = getLastWindow();
      windowManager.hideWindow(win1?.getWindowProperties().id.toString());
      let win2 = getLastWindow();
      if (win1 && win2) {
        expect(win1?.getWindowProperties().id).not().assertEqual(win2?.getWindowProperties().id);
      } else {
        expect(win2).assertNull();
      }
    })

    it('test_minimizeAllApps_should_return', Level.LEVEL0, (): void => {
      let win1 = getLastWindow();
      windowManager.minimizeAllApps();
      let win2 = getLastWindow();
      if (win1 && win2) {
        expect(win1?.getWindowProperties().id).not().assertEqual(win2?.getWindowProperties().id);
      } else {
        expect(win2).assertNull();
      }
    })

    it('WindowManager_getWindowHeight_test02', 0, (): void => {
      (windowManager as object)['mDisplayData'] = (windowManager as object)['getWindowDisplayData']();
      let result = windowManager.getWindowWidth();
      expect(result).not().assertUndefined();
    })

    it('WindowManager_getWindowHeight_test02', 0, (): void => {
      (windowManager as object)['mDisplayData'] = (windowManager as object)['getWindowDisplayData']();
      let result = windowManager.getWindowHeight();
      expect(result).not().assertUndefined();
    })
  })
}

function getLastWindow(): window.Window | null {
  let windowClass: window.Window | null = null;
  try {
    window.getLastWindow(GlobalContext.getContext()).then((data) => {
      windowClass = data;
      console.info('Succeeded in obtaining the top window. Data: ' + JSON.stringify(data));
    }).catch((err: object) => {
      console.error('Failed to obtain the top window. Cause: ' + JSON.stringify(err));
    })
  } catch (exception) {
    console.error('Failed to obtain the top window. Cause: ' + JSON.stringify(exception));
  }
  return windowClass;
}