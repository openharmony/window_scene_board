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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { AppItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { AppIconViewEvent } from '../../../../main/ets/default/viewmodel/AppIconViewEvent';
import { AppIconItemData } from '../../../../main/ets/default/viewmodel/OuterEditCenterObservedData';

/**
 * AppIconViewEvent 单元测试用例
 */
export function AppIconViewEventTest() {
  describe('AppIconViewEventTest', (): void => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_initData_1', Level.LEVEL0, () => {
      const topEvent: AppIconViewEvent = new AppIconViewEvent();
      let topAnimateData: AppIconItemData = new AppIconItemData();
      topEvent.initData(topAnimateData);
      expect(topEvent).not().assertNull();
    })

    it('long_press_handler', Level.LEVEL0, () => {
      const topEvent: AppIconViewEvent = new AppIconViewEvent();
      topEvent.longPressHandler(0);
      expect(topEvent).not().assertNull();
    })

    it('on_drag_start', Level.LEVEL0, () => {
      const topEvent: AppIconViewEvent = new AppIconViewEvent();

      let event: DragEvent = {
        getWindowX: (() => {
          return 0;
        }),
        getWindowY: (() => {
          return 0;
        }),
      } as DragEvent;
      let appItem: AppItemInfo = new AppItemInfo();

      let dragItemInfo: DragItemInfo = topEvent.onDragStart(event, appItem, 1);
      expect(dragItemInfo).not().assertNull();
      expect(dragItemInfo.extraInfo).not().assertNull();
    })

    it('on_touch_1', Level.LEVEL0, () => {
      const topEvent: AppIconViewEvent = new AppIconViewEvent();
      let event: TouchEvent = {
        type: TouchType.Down
      } as TouchEvent;
      topEvent.onTouch(event);
      expect(topEvent).not().assertNull();
    })

    it('on_touch_2', Level.LEVEL0, () => {
      const topEvent: AppIconViewEvent = new AppIconViewEvent();
      let event: TouchEvent = {
        type: TouchType.Up
      } as TouchEvent;
      topEvent.onTouch(event);
      expect(topEvent).not().assertNull();
    })

    it('on_click', Level.LEVEL0, () => {
      const topEvent: AppIconViewEvent = new AppIconViewEvent();
      let event: ClickEvent = {} as  ClickEvent;
      topEvent.startItemClickAnim('xxx.xxx.xxx');
      expect(topEvent).not().assertNull();
    })
  })
}