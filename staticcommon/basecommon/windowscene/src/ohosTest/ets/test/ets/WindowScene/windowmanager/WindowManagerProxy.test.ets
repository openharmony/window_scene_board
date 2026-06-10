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
import { describe, expect, it, Level } from '@ohos/hypium';
import { windowMgr } from '../../../../../../main/ets/windowmanager/WindowManagerProxy';
import Window from '@ohos.window';

export default function WindowManagerProxyTest() {
  WindowManagerProxyTest01();
  WindowManagerProxyTest02();
  WindowManagerProxyTest03();
}

function WindowManagerProxyTest01() {
  describe('WindowManagerProxyTest_01', () => {
    let rect: Window.Rect = {
      left: 10,
      top: 10,
      width: 10,
      height: 10
    }
    it('getActiveInputMethodRect01', Level.LEVEL0, (): void => {
      windowMgr.setInputMethodActiveCache(1, false);
      let rect = windowMgr.getActiveInputMethodRect();
      expect(rect).assertUndefined();

      windowMgr.setInputMethodActiveCache(1, true);
      rect = windowMgr.getActiveInputMethodRect();
    })

    it('updateWindowPosition01', Level.LEVEL0, (): void => {
      windowMgr.updateWindowPosition("windowNameTest", null);

      windowMgr.updateWindowPosition("windowNameTest", rect);
      windowMgr.updateWindowPosition("windowNameTest", rect);
    })
    it('getWindowPosition01', Level.LEVEL0, (): void => {
      windowMgr.getWindowPosition("windowNameTest2");

      windowMgr.getWindowPosition("windowNameTest");
    })
    it('checkPositionChange01', Level.LEVEL0, (): void => {
      let targetRect: Window.Rect = {
        left: 10,
        top: 10,
        width: 10,
        height: 20
      }
      windowMgr.updateWindowPosition("windowNameTest", targetRect);
      targetRect.width = 20;
      windowMgr.updateWindowPosition("windowNameTest", targetRect);
      targetRect.top = 20;
      windowMgr.updateWindowPosition("windowNameTest", targetRect);
      targetRect.left = 20;
      windowMgr.updateWindowPosition("windowNameTest", targetRect);
    })
  })
}

function WindowManagerProxyTest02() {
  describe('WindowManagerProxyTest_02', () => {
    it('setWindowBgColor01', Level.LEVEL0, (): void => {
      windowMgr.setWindowBgColor("windowNameTest3", "#000000");
      windowMgr.setWindowBgColor("windowNameTest", "#000000");
    })
    it('setWindowAnim01', Level.LEVEL0, (): void => {
      windowMgr.setWindowAnim("windowNameTest3", null);
      windowMgr.setWindowAnim("windowNameTest", null);
    })
    it('getWindowAnimPivot01', Level.LEVEL0, (): void => {
      windowMgr.getWindowAnimPivot("windowNameTest4");
      windowMgr.getWindowAnimPivot("windowNameTest");
    })
    it('startBindWinAnimOnFrame01', Level.LEVEL0, () => {
      windowMgr.startBindWinAnimOnFrame("windowNameTest4");
      windowMgr.startBindWinAnimOnFrame("windowNameTest");
    });
    it('isShowing01', Level.LEVEL0, () => {
      windowMgr.isShowing("windowNameTest4");
      windowMgr.isShowing("windowNameTest");
    });
    it('isCreated01', Level.LEVEL0, () => {
      windowMgr.isCreated("windowNameTest4");
      windowMgr.isCreated("windowNameTest");
    });
    it('showWindowCallback01', Level.LEVEL0, () => {
      windowMgr.showWindowCallback("windowNameTest4");
      windowMgr.showWindowCallback("windowNameTest");
      windowMgr.hideWindowCallback("windowNameTest4");
      windowMgr.hideWindowCallback("windowNameTest");
      windowMgr.canDestroyWindow("SysUI_Dropdown");
      windowMgr.hideWindowCallback("SysUI_Dropdown");
    });
    it('updateDestroyWindowFlag01', Level.LEVEL0, () => {
      windowMgr.updateDestroyWindowFlag("windowNameTest4", true);
      windowMgr.updateDestroyWindowFlag("windowNameTest", true);
    });
    it('showWindowWithAnim01', Level.LEVEL0, () => {
      windowMgr.showWindowWithAnim("windowNameTest4", true);
      windowMgr.showWindowWithAnim("windowNameTest", true);
      windowMgr.showWindowWithAnim("windowNameTest4", false);
      windowMgr.showWindowWithAnim("windowNameTest", false);
    });
  })
}


function WindowManagerProxyTest03() {
  describe('WindowManagerProxyTest_03', () => {
    it('hideWindowWithAnim01', Level.LEVEL0, () => {
      windowMgr.hideWindowWithAnim("windowNameTest4");
      windowMgr.hideWindowWithAnim("windowNameTest");
    });
    it('getViewType01', Level.LEVEL0, () => {
      windowMgr.getViewType("windowNameTest4");
      windowMgr.getViewType("SysUI_StatusBar");
    });
  })
}