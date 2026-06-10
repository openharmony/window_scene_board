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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { ImmersivePanelState } from '../../../../../../main/ets/viewmodel/viewdata/ImmersivePanelState';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersivePanelStateTest() {
  describe('ImmersivePanelStateTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_PanelStateAssign', Level.LEVEL0, (): void => {
      let panelState: ImmersivePanelState = new ImmersivePanelState();
      panelState.height = 10;
      panelState.height = '10';
      panelState.paddingTop = 100;
      panelState.paddingTop = '100vp';
      panelState.paddingBottom = 100;
      panelState.marginTop = 100;
      panelState.marginTop = '100vp';
      panelState.listBottomPadding = 100;
      panelState.listAlign = Alignment.Bottom;
      panelState.listAlign = Alignment.Top;
      expect(panelState).not().assertNull();
    });

  });
}