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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { LayoutPolicyHelper } from '../../../../../main/ets/layout/LayoutPolicyHelper';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  AvailableBound,
  SCBDividerParam,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBSessionRect} from '@ohos/windowscene';
import { ReflectionUtils } from '../ReflectionUtils';

let layoutPolicyHelper: LayoutPolicyHelper;
let screenProperty: SCBScreenProperty;
let sceneSession: SCBSceneSession;

export function LayoutPolicyHelperTest() {
  describe('LayoutPolicyHelperTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      layoutPolicyHelper = LayoutPolicyHelper.getInstance();
      proxyImpl = {
        resizeAfterStatusChangeIfNeed: (containerSession: SCBSceneContainerSession | null,
          screenProperty: SCBScreenProperty): void =>{
        },
        getVirtualKeyboardRegion: (): SCBSessionRect =>{
          return new SCBSessionRect(8, 8, 8, 8);
        },
        useLongSideForFoldMachine: (screenProperty: SCBScreenProperty): boolean =>{
          return true;
        },
        getCompatibleModeAvailableWorkspaceHeight: (sceneSession: SCBSceneSession, screenProperty: SCBScreenProperty,
          isFoldOperation: boolean): number =>{
          return 8;
        },
        getAvailableBoundInFoldMachine: (sceneSession: SCBSceneSession, screenProperty: SCBScreenProperty,
          isMax: boolean, isFoldOperation: boolean): AvailableBound =>{
          return new AvailableBound(8, 8);
        },
        refreshCompatibleFullScreenSizeForFoldMachine: (sceneSession: SCBSceneSession,
          screenProperty: SCBScreenProperty): void =>{
        },
        splitContainerTransitionInAnimate: (containerSession: SCBSceneContainerSession,
          screenProperty: SCBScreenProperty): void =>{
        },
        restoreCompatibleScale: (scbContainerSession: SCBSceneContainerSession,
          screenProperty: SCBScreenProperty): void =>{
        },
        updateRelocationMenuIfNeed: (sceneSession: SCBSceneSession | null): void =>{
        },
        getFoldCreaseRegion: (): SCBSessionRect =>{
          return new SCBSessionRect(8, 8, 8, 8);
        },
        isFoldScreen: (screenId: number): boolean =>{
          return true;
        },
        isVirtualKeyboardEnabled: (): boolean =>{
          return true;
        },
        isScreenHalfFolded: (): boolean =>{
          return true;
        },
        getFoldScreenId: (): number =>{
          return 8;
        },
        isUnfoldedVerticalState: (screenId?: number): boolean =>{
          return true;
        },
        handleCalculateMaxRectInFoldIfNeeded: (sceneSession: SCBSceneSession, screenProperty: SCBScreenProperty,
          rect: SCBSessionRect): boolean => {
          rect.setRectNum(50, 50, 400, 400);
          return true;
        },
        getSplitInitialRectIfNeeded: (isSplitPrimary: boolean, topThreshold: number, bottomThreshold: number,
          rect: SCBSessionRect, screenProperty: SCBScreenProperty): boolean => {
          return true;
        }
      };
      prepareData();
    })
    beforeEach(() => {
    })
    afterEach(() => {

    })
    afterAll(() => {

    });
    calculatePrimaryWidthBySplitMinWidthTest();
    getRatioTest();
    calculateMaxRectTest();
  });
}
function prepareData() {
  let testSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
  let testSession = SCBSceneSessionManager.getInstance().requestSceneSession(testSceneInfo);
  sceneSession = new SCBSceneSession(testSession, testSceneInfo);
  screenProperty = new SCBScreenProperty();
  screenProperty.screenId = 100;
  screenProperty.width = 1920;
  screenProperty.height = 1080;
}

function calculatePrimaryWidthBySplitMinWidthTest() {
  it('calculatePrimaryWidthBySplitMinWidthTest_01', Level.LEVEL0, async (done: Function) => {
    let testSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let testSession = SCBSceneSessionManager.getInstance().requestSceneSession(testSceneInfo);
    let session: SCBSceneSession = new SCBSceneSession(testSession, testSceneInfo);
    let screenProperty = new SCBScreenProperty();
    screenProperty.width = 3120;
    screenProperty.height = 1755;
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
    let dividerParam: SCBDividerParam = new SCBDividerParam();
    dividerParam.primary.minWidth = 815;
    dividerParam.secondary.minWidth = 815;
    containerSession.dividerParam = dividerParam;
    let sessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(sessionManager, sessionManager.getCurrentDensityDpi);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(258);
    let primaryWidth = 1315;
    let secondaryWidth = 1782;
    let result = layoutPolicyHelper.calculatePrimaryWidthBySplitMinWidth(containerSession, screenProperty,
      primaryWidth, secondaryWidth);
    expect(result).assertEqual(1315);
    primaryWidth = 1100;
    secondaryWidth = 1997;
    result = layoutPolicyHelper.calculatePrimaryWidthBySplitMinWidth(containerSession, screenProperty,
      primaryWidth, secondaryWidth);
    expect(result).assertEqual(258 / 160 * 815);
    primaryWidth = 1997;
    secondaryWidth = 1100;
    result = layoutPolicyHelper.calculatePrimaryWidthBySplitMinWidth(containerSession, screenProperty,
      primaryWidth, secondaryWidth);
    expect(result).assertEqual(1997 - 258 / 160 * 815 + 1100);
    done();
  });
}

function getRatioTest() {
  it('getRatioTest_01', Level.LEVEL0, async (done: Function) => {
    expect(layoutPolicyHelper.getRatio(0, 0)).assertEqual(0);
    expect(layoutPolicyHelper.getRatio(1, 1)).assertEqual(0.5);
    done();
  });
}
