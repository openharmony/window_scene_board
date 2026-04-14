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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import {
  AppIconContainerTouchEvent,
  AppIconContainerTouchEventParam
} from '../../../../../../../main/ets/launchericon/viewmodel/AppIconContainerTouchEvent';
import { AppItemInfo, CommonConstants } from '../../../../../../../main/ets/TsIndex';
import { AppIconData } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconData';

export function AppIconContainerTouchEventTest() {
  let event: TouchEvent = {
    type: TouchType.Down,
    touches: [],
    changedTouches: [],
    stopPropagation: (): void => {
    },
    getHistoricalPoints: (): HistoricalPoint[] => {
      throw new Error('Function not implemented.');
    },
    preventDefault: (): void => {
    },
    target: {area: {
      width: 1,
      height: 1,
      position: {},
      globalPosition: {},
    }},
    timestamp: 0,
    source: SourceType.Unknown,
    pressure: 0,
    tiltX: 0,
    tiltY: 0,
    sourceTool: SourceTool.Unknown
  };

  describe('AppIconContainerTouchEventTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initContainerTouchParam', 0, () => {
      let inValidParam: AppIconContainerTouchEventParam = AppStorage.get('AppIconContainerTouchEventTestInvalidKey') as
        AppIconContainerTouchEventParam;
      let inValidAppItemInfo: AppItemInfo = AppStorage.get('AppIconContainerTouchEventTestInvalidKey') as AppItemInfo;
      let inValidIconData: AppIconData = new AppIconData();
      let ret = new AppIconContainerTouchEvent().initContainerTouchParam(inValidParam);
      expect(ret).not().assertTrue();

      let ret2 = new AppIconContainerTouchEvent().initContainerTouchParam({
        itemInfo: inValidAppItemInfo,
        iconData: inValidIconData
      });
      expect(ret2).not().assertTrue();

      let ret3 = new AppIconContainerTouchEvent().initContainerTouchParam({
        itemInfo: new AppItemInfo(),
        iconData: new AppIconData()
      });
      expect(ret3).not().assertTrue();
    });

    it('onTouch1', 0, () => {
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };

      let mocker: MockKit = new MockKit();

      let inValidEvent: TouchEvent = AppStorage.get('AppIconContainerTouchEventTestInvalidKey') as TouchEvent;
      new AppIconContainerTouchEvent().initContainerTouchParam({
        itemInfo: new AppItemInfo(),
        iconData: new AppIconData()
      }).onTouch(inValidEvent);
      expect(called).assertFalse();

      event.type = TouchType.Cancel;
      called = false;
      new AppIconContainerTouchEvent().initContainerTouchParam({
        itemInfo: new AppItemInfo(),
        iconData: new AppIconData()
      }).onTouch(event);
      expect(called).assertFalse();

      event.type = CommonConstants.TOUCH_TYPE_DOWN;
      let inValidItemInfo: AppItemInfo = AppStorage.get('AppIconContainerTouchEventTestInvalidKey') as AppItemInfo;
      called = false;
      new AppIconContainerTouchEvent().initContainerTouchParam({
        itemInfo: inValidItemInfo,
        iconData: new AppIconData()
      }).onTouch(event);
      expect(called).assertFalse();
      mocker.clearAll();
    });

    it('onTouch2', 0, () => {
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };

      let mocker: MockKit = new MockKit();
      let mockFunPreloadApp: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().preloadApp);
      when(mockFunPreloadApp)(ArgumentMatchers.any).afterAction(action);

      event.type = CommonConstants.TOUCH_TYPE_DOWN;
      new AppIconContainerTouchEvent().initContainerTouchParam({
        itemInfo: new AppItemInfo(),
        iconData: new AppIconData()
      }).onTouch(event);
      expect(called).assertFalse();

      when(mockFunIsSupportAppType)(ArgumentMatchers.any).afterReturn(true);
      new AppIconContainerTouchEvent().initContainerTouchParam({
        itemInfo: new AppItemInfo(),
        iconData: new AppIconData()
      }).onTouch(event);
      expect(called).assertFalse();

      when(mockFunIsSupportDeliver)(ArgumentMatchers.any).afterReturn(true);
      new AppIconContainerTouchEvent().initContainerTouchParam({
        itemInfo: new AppItemInfo(),
        iconData: new AppIconData()
      }).onTouch(event);
      expect(called).assertTrue();

      mocker.clear(SCBSceneSessionManager.getInstance());
      mocker.clearAll();
    });
  });
}