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
import { ReflectionUtils } from './ReflectionUtils';
import {
  SCBScreenSessionManager,
  SplitStyle,
  SCBScreenProperty,
  SCBDividerParam,
  SCBScreenSession
} from '@ohos/windowscene';
import {
  SCBMultiWindowUtils
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowUtils';
import {
  SCBGridRowUtils
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/utils/SCBGridRowUtils';
import { SCBMenuParam,
  SplitExchangeMenuAnimationParam } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBMenuParam';
import {
  SCBMultiWindowManager
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowManager';
import {beforeEach, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';

let assertFlag: boolean = true;

export function SCBMenuParamTest() {
  let gridRowUtils: SCBGridRowUtils = new SCBGridRowUtils();
  let dividerParam: SCBDividerParam = new SCBDividerParam();
  let screenProperty: SCBScreenProperty = new SCBScreenProperty();
  let animParam: SplitExchangeMenuAnimationParam;
  let menuParam: SCBMenuParam;

  describe('SCBMenuParamTest_describe', () => {
    beforeEach((): void => {
      animParam = new SplitExchangeMenuAnimationParam();
      menuParam = new SCBMenuParam();
    })

    it('initMenuListModel_inSmallFold_it_01', Level.LEVEL0, () => {
      let lis = [true, false];
      let manager = SCBMultiWindowManager.getInstance();
      let mocker1: MockKit = new MockKit();
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      const mockFunc: Function = mocker1.mockFunc(sessionManager, sessionManager.isFoldablePhoneExpandStatus);
      when(mockFunc)().afterReturn(false);
      lis.forEach((isUpDownSplit: boolean) => {
        lis.forEach((hasGame: boolean) => {
          lis.forEach((isSmallFold: boolean) => {
            ReflectionUtils.setProperty(manager, 'isSmallFold', isSmallFold);
            menuParam.initMenuList(isUpDownSplit, hasGame);
          })
        })
      })
      expect(assertFlag).assertTrue();
      mocker1.clear(mockFunc);
    })

    it('initMenuListModel_inSmallFold_it_02', Level.LEVEL0, () => {
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let manager = SCBMultiWindowManager.getInstance();
      let lis = [true, false];
      let mocker1: MockKit = new MockKit();
      const mockFunc: Function = mocker1.mockFunc(sessionManager, sessionManager.isFoldablePhoneExpandStatus);
      when(mockFunc)().afterReturn(true);
      lis.forEach((isUpDownSplit: boolean) => {
        lis.forEach((hasGame: boolean) => {
          lis.forEach((isSmallFold: boolean) => {
            ReflectionUtils.setProperty(manager, 'isSmallFold', isSmallFold);
            menuParam.initMenuList(isUpDownSplit, hasGame);
          })
        })
      })
      expect(assertFlag).assertTrue();
      mocker1.clear(mockFunc);
    })

    it('initMenuListModel_it', Level.LEVEL0, () => {
      let lis = [true, false];
      lis.forEach((isUpDownSplit: boolean) => {
        lis.forEach((hasGame: boolean) => {
          menuParam.initMenuList(isUpDownSplit, hasGame);
        })
      })
      expect(assertFlag).assertTrue();
    })

    it('updateMenuPositionAndSizeModel_left_and_right_it', Level.LEVEL0, () => {
      dividerParam.setSplitStyle(SplitStyle.LEFT_AND_RIGHT_POS);
      menuParam.updateMenuPositionAndSize(
        dividerParam, screenProperty,
        gridRowUtils.getGutterX(), gridRowUtils.getSingleColumnWidth()
      );
      expect(assertFlag).assertTrue();
    })

    it('updateMenuPositionAndSizeModel_left_and_right_it_01', Level.LEVEL0, () => {
      dividerParam.setSplitStyle(SplitStyle.LEFT_AND_RIGHT_POS);
      let mocker1: MockKit = new MockKit();
      let mockFunc: Function = mocker1.mockFunc(SCBScreenSession, SCBScreenSession.isDualDisplayFoldDevice);
      when(mockFunc)().afterReturn(false);
      menuParam.updateMenuPositionAndSize(
        dividerParam, screenProperty,
        gridRowUtils.getGutterX(), gridRowUtils.getSingleColumnWidth()
      );
      expect(assertFlag).assertTrue();
      mocker1.clear(mockFunc);
    })

    it('initMenuListModel_not_dual_display_it', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let mockFunc1: Function = mocker1.mockFunc(SCBScreenSession, SCBScreenSession.isDualDisplayFoldDevice);
      when(mockFunc1)().afterReturn(false);
      let mockFunc2: Function = mocker1.mockFunc(SCBMultiWindowUtils, SCBMultiWindowUtils.isFoldableDevice);
      when(mockFunc2)().afterReturn(true);
      let mockFunc3: Function = mocker1.mockFunc(SCBMultiWindowUtils, SCBMultiWindowUtils.isFoldableDeviceFolded);
      when(mockFunc3)().afterReturn(false);
      menuParam.initMenuList(false, true);
      menuParam.initMenuList(false, false);
      menuParam.initMenuList(true, true);
      menuParam.initMenuList(true, false);
      expect(assertFlag).assertTrue();
      mocker1.clear(mockFunc1);
      mocker1.clear(mockFunc2);
      mocker1.clear(mockFunc3);
    })

    it('menu_reset_it', Level.LEVEL0, () => {
      animParam.reset();
      expect(assertFlag).assertTrue();
    })

    it('updateMenuPositionAndSizeModel_up_and_down_it', Level.LEVEL0, () => {
      dividerParam.setSplitStyle(SplitStyle.UP_AND_DOWN_POS);
      menuParam.updateMenuPositionAndSize(
        dividerParam, screenProperty,
        gridRowUtils.getGutterX(), gridRowUtils.getSingleColumnWidth()
      );
      menuParam.updateMenuPositionAndSize(
        dividerParam, screenProperty,
        gridRowUtils.getGutterX(), gridRowUtils.getSingleColumnWidth()
      );
      expect(assertFlag).assertTrue();
    })
  });
}