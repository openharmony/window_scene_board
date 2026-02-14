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
  TestType,
  Size,
  Level,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium';
import {
  NeedRenderTranslate,
  RecentViewParam,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBScreenProperty} from '@ohos/windowscene';
import { RecentScroll } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentScroll';
import { RecentScrollHelper } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentScrollHelper';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { recentLayoutConfigInstance } from '@ohos/recents';
import { RecentLayoutManager } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/common/RecentLayoutManager';
import { recentRuntimeInstance } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentRuntimeModel';
import screenSessionManager from '@ohos.screenSessionManager';
import { recentDisplayManager } from '@ohos/recents/src/main/ets/TsIndex';

export default function RecentScrollTest() {
  describe('RecentScrollTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    let screenProp: screenSessionManager.ScreenProperty = {
      rotation: 1,
      bounds: {
        left: 1,
        top: 1,
        width: 40,
        height: 200,
        radius: 1,
      },
      fakeBounds: {
        left: 0,
        top: 0,
        width: 0,
        height: 0,
        radius: 0
      },
      isFakeInUse: false,
      rsId: 0,
    };
    scbScreenProperty.update(screenProp);
    let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
    let recentScroll: RecentScroll = new RecentScroll(scenePanelManager);
    let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
    let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    let scbSceneContainer: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
    let recentLayoutConfig = recentLayoutConfigInstance;
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));

    it('RecentScroll_test_onScrollStart_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      recentScroll.onScrollStart();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      expect((recentScroll as object)['preOffsetX']).assertEqual(0);
    })

    it('RecentScroll_test_onScrollStart_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.onScrollStart();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      expect((recentScroll as object)['preOffsetX']).assertEqual(0);
    })

    it('RecentScroll_test_initForPerformance_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.initForPerformance();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_playChainAnimation_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList.clear();
      recentScroll.onScroll(0, 0);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_playChainAnimation_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      recentRuntimeInstance.init(totalContainerSessionList);
      recentScroll.onScroll(0, 0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_playSingleRowChainAnimation_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 1;
      recentRuntimeInstance.containerCountsShowInRecent = 9;
      (recentScroll as object)['playSingleRowChainAnimation'](1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_playSingleRowChainAnimation_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 10;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      (recentScroll as object)['playSingleRowChainAnimation'](1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_playSingleRowChainAnimation_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = -1;
      recentRuntimeInstance.containerCountsShowInRecent = -1;
      (recentScroll as object)['playSingleRowChainAnimation'](1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_playMultiRowChainAnimation_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 1;
      recentRuntimeInstance.containerCountsShowInRecent = 9;
      (recentScroll as object)['playMultiRowChainAnimation'](1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_playMultiRowChainAnimation_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 10;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      (recentScroll as object)['playMultiRowChainAnimation'](1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_playMultiRowChainAnimation_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = -1;
      recentRuntimeInstance.containerCountsShowInRecent = -1;
      (recentScroll as object)['playMultiRowChainAnimation'](1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_singleRowChainAnimationBoundary_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 1;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      let mocker: MockKit = new MockKit();
      let isScrollRightForward: Function = mocker.mockFunc(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
      when(isScrollRightForward)().afterReturn(true);
      (recentScroll as object)['singleRowChainAnimationBoundary'](1, 1, 1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
      mocker.ignoreMock(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
    })

    it('RecentScroll_test_singleRowChainAnimationBoundary_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 1;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      let mocker: MockKit = new MockKit();
      let isScrollRightForward: Function = mocker.mockFunc(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
      when(isScrollRightForward)().afterReturn(true);
      (recentScroll as object)['singleRowChainAnimationBoundary'](1, 5, 9);
      expect(recentScroll.isInterruptFling).assertEqual(false);
      mocker.ignoreMock(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
    })

    it('RecentScroll_test_singleRowChainAnimationBoundary_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 1;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      let mocker: MockKit = new MockKit();
      let isScrollRightForward: Function = mocker.mockFunc(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
      when(isScrollRightForward)().afterReturn(true);
      (recentScroll as object)['singleRowChainAnimationBoundary'](1, 0, 5);
      expect(recentScroll.isInterruptFling).assertEqual(false);
      mocker.ignoreMock(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
    })

    it('RecentScroll_test_singleRowChainAnimationBoundary_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 1;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      let mocker: MockKit = new MockKit();
      let isScrollRightForward: Function = mocker.mockFunc(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
      when(isScrollRightForward)().afterReturn(false);
      (recentScroll as object)['singleRowChainAnimationBoundary'](1, 1, 1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
      mocker.ignoreMock(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
    })

    it('RecentScroll_test_singleRowChainAnimationBoundary_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 1;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      let mocker: MockKit = new MockKit();
      let isScrollRightForward: Function = mocker.mockFunc(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
      when(isScrollRightForward)().afterReturn(false);
      (recentScroll as object)['singleRowChainAnimationBoundary'](1, 5, 9);
      expect(recentScroll.isInterruptFling).assertEqual(false);
      mocker.ignoreMock(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
    })

    it('RecentScroll_test_singleRowChainAnimationBoundary_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 1;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      let mocker: MockKit = new MockKit();
      let isScrollRightForward: Function = mocker.mockFunc(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
      when(isScrollRightForward)().afterReturn(false);
      (recentScroll as object)['singleRowChainAnimationBoundary'](1, 0, 5);
      expect(recentScroll.isInterruptFling).assertEqual(false);
      mocker.ignoreMock(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
    })

    it('RecentScroll_test_multiRowChainAnimationBoundary_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 1;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      let mocker: MockKit = new MockKit();
      let isScrollRightForward: Function = mocker.mockFunc(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
      when(isScrollRightForward)().afterReturn(true);
      (recentScroll as object)['multiRowChainAnimationBoundary'](1, 1, 1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
      mocker.ignoreMock(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
    })

    it('RecentScroll_test_multiRowChainAnimationBoundary_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 1;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      let mocker: MockKit = new MockKit();
      let isScrollRightForward: Function = mocker.mockFunc(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
      when(isScrollRightForward)().afterReturn(true);
      (recentScroll as object)['multiRowChainAnimationBoundary'](1, 1, 1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
      mocker.ignoreMock(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
    })

    it('RecentScroll_test_multiRowChainAnimationBoundary_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 1;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      let mocker: MockKit = new MockKit();
      let isScrollRightForward: Function = mocker.mockFunc(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
      when(isScrollRightForward)().afterReturn(false);
      (recentScroll as object)['multiRowChainAnimationBoundary'](1, 5, 0);
      expect(recentScroll.isInterruptFling).assertEqual(false);
      mocker.ignoreMock(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
    })

    it('RecentScroll_test_multiRowChainAnimationBoundary_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 1;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      let mocker: MockKit = new MockKit();
      let isScrollRightForward: Function = mocker.mockFunc(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
      when(isScrollRightForward)().afterReturn(false);
      (recentScroll as object)['multiRowChainAnimationBoundary'](1, 0, 5);
      expect(recentScroll.isInterruptFling).assertEqual(false);
      mocker.ignoreMock(RecentScrollHelper, RecentScrollHelper.isScrollRightForward);
    })

    it('RecentScroll_test_getAutoCenterScrollOffsetX_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      (recentScroll as object)['getAutoCenterScrollOffsetX'](1, 1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_getAutoCenterScrollOffsetX_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      (recentScroll as object)['getAutoCenterScrollOffsetX'](1, 1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_getAutoCenterOffsetXSingleRow_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isScreenVertical: Function = mocker.mockFunc(recentDisplayManager, recentDisplayManager.isScreenVertical);
      when(isScreenVertical)().afterReturn(false);
      expect((recentScroll as object)['getAutoCenterOffsetXSingleRow'](1, 1)).assertLess(150);
      mocker.ignoreMock(recentDisplayManager, recentDisplayManager.isScreenVertical);
    })

    it('RecentScroll_test_getAutoCenterOffsetXSingleRow_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.recentTaskWidth = 1;
      let mocker: MockKit = new MockKit();
      let isScreenVertical: Function = mocker.mockFunc(recentDisplayManager, recentDisplayManager.isScreenVertical);
      when(isScreenVertical)().afterReturn(true);
      expect((recentScroll as object)['getAutoCenterOffsetXSingleRow'](-5, 8)).assertEqual(9);
      mocker.ignoreMock(recentDisplayManager, recentDisplayManager.isScreenVertical);
    })

    it('RecentScroll_test_getAutoCenterOffsetXSingleRow_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.recentTaskWidth = 1;
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      let mocker: MockKit = new MockKit();
      let isScreenVertical: Function = mocker.mockFunc(recentDisplayManager, recentDisplayManager.isScreenVertical);
      when(isScreenVertical)().afterReturn(true);
      expect((recentScroll as object)['getAutoCenterOffsetXSingleRow'](5, 1)).assertEqual(3);
      mocker.ignoreMock(recentDisplayManager, recentDisplayManager.isScreenVertical);
    })

    it('RecentScroll_test_getAutoCenterOffsetXSingleRow_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.recentTaskWidth = 1;
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      let mocker: MockKit = new MockKit();
      let isScreenVertical: Function = mocker.mockFunc(recentDisplayManager, recentDisplayManager.isScreenVertical);
      when(isScreenVertical)().afterReturn(true);
      expect((recentScroll as object)['getAutoCenterOffsetXSingleRow'](-5, 1)).assertEqual(-1);
      mocker.ignoreMock(recentDisplayManager, recentDisplayManager.isScreenVertical);
    })

    it('RecentScroll_test_getDiffThresholdForHorizontal_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.recentTaskWidth = 1;
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      (recentScroll as object)['touchDownOffsetX'] = 0;
      expect((recentScroll as object)['getDiffThresholdForHorizontal'](1)).assertLess(2);
    })

    it('RecentScroll_test_getDiffThresholdForHorizontal_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.recentTaskWidth = 1;
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      (recentScroll as object)['touchDownOffsetX'] = 1;
      expect((recentScroll as object)['getDiffThresholdForHorizontal'](1)).assertEqual(0);
    })

    it('RecentScroll_test_getAutoCenterOffsetXMultiRow_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.recentTaskWidth = 1;
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      (recentScroll as object)['touchDownOffsetX'] = 1;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function = mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)().afterReturn(1);
      expect((recentScroll as object)['getAutoCenterOffsetXMultiRow'](5, 1)).assertLess(4);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
    })

    it('RecentScroll_test_getAutoCenterOffsetXMultiRow_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.recentTaskWidth = 1;
      recentScroll.recentMargin = 1;
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      (recentScroll as object)['multiRowPadding'] = 1;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function = mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)().afterReturn(3);
      expect((recentScroll as object)['getAutoCenterOffsetXMultiRow'](10, -4)).assertEqual(0);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
    })

    it('RecentScroll_test_getAutoCenterOffsetXMultiRow_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.recentTaskWidth = 0;
      recentScroll.recentMargin = 1;
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      (recentScroll as object)['multiRowPadding'] = -8;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function = mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)().afterReturn(3);
      expect((recentScroll as object)['getAutoCenterOffsetXMultiRow'](5, -20)).assertNaN();
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
    })

    it('RecentScroll_test_autoCenter_1_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
    })

    it('RecentScroll_test_autoCenter_1_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(-10);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(0);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(10);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(1000);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_09', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(100);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_10', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(-100);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_11', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(20);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_12', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_13', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_14', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_15', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_16', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_17', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_18', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_19', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_1_20', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_onScroll_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentRuntimeInstance.init(totalContainerSessionList);
      recentRuntimeInstance.autoCenterColumn = 1;
      recentScroll.onScroll(1000, 0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_onScroll_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.touchContainerIndex = 5;
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      recentRuntimeInstance.init(totalContainerSessionList);
      recentScroll.onScroll(0, 0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_onScroll_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.touchContainerIndex = 5;
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      recentRuntimeInstance.init(totalContainerSessionList);
      recentRuntimeInstance.autoCenterColumn = 5;
      recentScroll.onScroll(1000, 0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_onScroll_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.touchContainerIndex = 5;
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      recentRuntimeInstance.init(totalContainerSessionList);
      recentRuntimeInstance.autoCenterColumn = 5;
      recentScroll.onScroll(-1000, 0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_onScroll_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.touchContainerIndex = 0;
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentRuntimeInstance.init(totalContainerSessionList);
      recentRuntimeInstance.autoCenterColumn = 3;
      recentScroll.onScroll(0, 0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_onScroll_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.touchContainerIndex = 0;
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentRuntimeInstance.autoCenterColumn = 5;
      recentRuntimeInstance.init(totalContainerSessionList);
      recentScroll.onScroll(500, 200);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })


    it('RecentScroll_test_autoCenter_02_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
    })

    it('RecentScroll_test_autoCenter_02_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(-10);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(0);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(10);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(1000);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_09', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(100);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_10', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(-100);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_11', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(20);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_12', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_13', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_14', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_15', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_16', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_17', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_18', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_19', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_02_20', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_currentOffsetX_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let currentOffset: Function = mocker.mockFunc(recentScroll, recentScroll.scroller.currentOffset);
      when(currentOffset)().afterReturn(10);
      let currentOffsetX = recentScroll.currentOffsetX;
      mocker.ignoreMock(recentScroll, recentScroll.scroller.currentOffset);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_scrollToImmediately_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.scrollToImmediately(0);
      expect(recentScroll.isInterruptFling).assertEqual(true);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
    })

    it('RecentScroll_test_autoCenter_copy3_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(-10);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(0);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(10);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(1000);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_09', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(100);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_10', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(-100);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_11', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(20);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_12', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_13', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_14', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_15', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_16', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_17', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_18', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_19', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy3_20', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })
    it('RecentScroll_test_updateAutoCenterIndex_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let recentMargin: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(recentMargin)().afterReturn(40);
      let recentTaskWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthAndSpace);
      when(recentTaskWidth)().afterReturn(250);
      let multiRowPadding: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getMultiRowPadding);
      when(multiRowPadding)().afterReturn(10);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      recentScroll.updateAutoCenterColumn(1);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthAndSpace);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getMultiRowPadding);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_updateAutoCenterIndex_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let recentMargin: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(recentMargin)().afterReturn(40);
      let recentTaskWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthAndSpace);
      when(recentTaskWidth)().afterReturn(250);
      let multiRowPadding: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getMultiRowPadding);
      when(multiRowPadding)().afterReturn(10);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.updateAutoCenterColumn(1);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthAndSpace);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getMultiRowPadding);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('multiRowChainAnimation_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let containerSessionList: SCBSceneContainerSessionArray = totalContainerSessionList;
      containerSessionList.add(scbSceneContainer);
      containerSessionList.add(scbSceneContainer);
      let mocker: MockKit = new MockKit();
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(containerSessionList);
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
    })

    it('RecentScroll_test_chainAnimation_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.chainAnimation(1, 1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_chainAnimation_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.chainAnimation(1, 0);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_chainAnimation_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.chainAnimation(0, 0);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_chainAnimation_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.chainAnimation(0, 1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_chainAnimation_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.chainAnimation(2, 4);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('onScrollStop_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.onScrollStop();
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_touchDownEvent_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.touchDownEvent();
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_autoCentered_001', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(-10);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_002', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(0);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_003', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(10);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_004', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(1000);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_005', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(100);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_006', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(100);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
    })

    it('RecentScroll_test_autoCenter_copy1_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(-10);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(0);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(10);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(1000);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_09', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(100);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_10', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(-100);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_11', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(20);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_12', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_13', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_14', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_15', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_16', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_17', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_18', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_19', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy1_20', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
    })

    it('RecentScroll_test_autoCenter_copy_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(-10);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(0);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(10);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(1000);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_09', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(100);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_10', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(-100);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_11', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(20);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_12', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_13', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_14', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_15', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_16', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_17', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_18', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_19', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_20', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCenter_copy_21', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_new_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_new_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_new_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_new_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_new_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(-10);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_new_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(0);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_new_07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(10);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_new_08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(1000);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_new_09', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(100);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_new_10', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(-100);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_new_11', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(20);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_new_12', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(30);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })


    it('RecentScroll_test_autoCentered_new_13', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      recentScroll.autoCentered(1000);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_new_14', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(-1000);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_autoCentered_new_15', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      let isScreenVertical: Function = mocker.mockFunc(recentDisplayManager, recentDisplayManager.isScreenVertical);
      when(isScreenVertical)().afterReturn(false);
      recentRuntimeInstance.init(totalContainerSessionList);
      recentScroll.autoCentered(-1000);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      mocker.ignoreMock(recentDisplayManager, recentDisplayManager.isScreenVertical);
    })

    it('RecentScroll_test_autoCentered_new_16', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      let isScreenVertical: Function = mocker.mockFunc(recentDisplayManager, recentDisplayManager.isScreenVertical);
      when(isScreenVertical)().afterReturn(false);
      recentRuntimeInstance.init(totalContainerSessionList);
      recentScroll.autoCentered(1000);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      mocker.ignoreMock(recentDisplayManager, recentDisplayManager.isScreenVertical);
    })

    it('RecentScroll_test_autoCentered_new_17', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray(2);
      let totalContainerSessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

      let mocker: MockKit = new MockKit();
      let getWidthSpace: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      when(getWidthSpace)().afterReturn(40);
      let getSceneContainerSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)().afterReturn(totalContainerSessionList1);
      let getFloatingSessionList: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(getFloatingSessionList)().afterReturn(totalContainerSessionList2);
      let getCardWidth: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      when(getCardWidth)().afterReturn(1);
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.autoCentered(20);
      recentScroll.onScroll(0, 0);
      expect(recentScroll).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getWidthSpace);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionList);
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getCardWidth);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentScroll_test_initForPerformance_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      recentScroll.initForPerformance();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_enter_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      recentScroll.initForEnterRecent();
      expect(recentScroll).not().assertUndefined();
    })

    it('RecentScroll_test_enter_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      recentScroll.initForEnterRecent();
      expect(recentScroll).not().assertUndefined();
    })

    it('RecentScroll_test_updateFrameTime_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.updateFrameTime(Number.NaN);
      expect(recentScroll).not().assertUndefined();
    })

    it('RecentScroll_test_playSingleRowChainAnimation_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.isInterruptFling = false;
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 10;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      recentScroll.updateFrameTime(Number.NaN);
      (recentScroll as object)['playSingleRowChainAnimation'](1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_playMultiRowChainAnimation_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 10;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      recentScroll.updateFrameTime(Number.NaN);
      (recentScroll as object)['playMultiRowChainAnimation'](1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_singleRowChainAnimationBoundary_07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 10;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      recentScroll.updateFrameTime(Number.NaN);
      (recentScroll as object)['singleRowChainAnimationBoundary'](1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_singleRowChainAnimationBoundary_08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 10;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      recentScroll.updateFrameTime(Number.NaN);
      (recentScroll as object)['singleRowChainAnimationBoundary'](-1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_multiRowChainAnimationBoundary_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 10;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      recentScroll.updateFrameTime(Number.NaN);
      (recentScroll as object)['multiRowChainAnimationBoundary'](1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_multiRowChainAnimationBoundary_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 10;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      recentScroll.updateFrameTime(Number.NaN);
      (recentScroll as object)['multiRowChainAnimationBoundary'](-1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_updateOneFrameTime_0`6`', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.updateOneFrameTime();
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_updateContainerSessionInScroller_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 10;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      (recentScroll as object)['updateContainerSessionInScroller'](1);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_onScroll_07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.init(totalContainerSessionList);
      recentScroll.isInterruptFling = true;
      (recentScroll as object)['isScrollFollowing']  = true;
      recentScroll.onScroll(100, 0);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_flingOnScroll_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.isInterruptFling = false;
      recentRuntimeInstance.init(totalContainerSessionList);
      recentScroll.isUseMouse  = false;
      (recentScroll as object)['isScrollTrailing']  = true;
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      recentScroll.flingOnScroll(0, 0);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_flingOnScroll_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.isInterruptFling = false;
      recentRuntimeInstance.init(totalContainerSessionList);
      recentScroll.isUseMouse  = false;
      (recentScroll as object)['isScrollTrailing']  = true;
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      recentScroll.flingOnScroll(0, 0);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_flingOnScroll_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.init(totalContainerSessionList);
      (recentScroll as object)['isScrollTrailing']  = false;
      recentScroll.flingOnScroll(0, 0);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_flingOnScroll_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.init(totalContainerSessionList);
      (recentScroll as object)['isScrollTrailing']  = false;
      recentScroll.flingOnScroll(1, 0);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_ifNeedChainAnimation_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.notRemovingSessionList[0].needRenderTranslate = new NeedRenderTranslate();
      recentRuntimeInstance.notRemovingSessionList[0].needRenderTranslate.setTranslateX(0);
      recentRuntimeInstance.notRemovingSessionList[0].needRenderTranslate.setTranslateY(0);
      recentRuntimeInstance.autoCenterColumn = 0;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      (recentScroll as object)['ifNeedChainAnimation'](0);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_ifNeedChainAnimation_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.notRemovingSessionList[0].needRenderTranslate = new NeedRenderTranslate();
      recentRuntimeInstance.notRemovingSessionList[0].needRenderTranslate.setTranslateX(0);
      recentRuntimeInstance.notRemovingSessionList[0].needRenderTranslate.setTranslateY(0);
      recentRuntimeInstance.autoCenterColumn = 0;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      (recentScroll as object)['ifNeedChainAnimation'](1000);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_trailingOnScroll_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 10;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      (recentScroll as object)['trailingOnScroll'](0);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_trailingOnScroll_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 10;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      (recentScroll as object)['trailingOnScroll'](0);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_playTrailingAnimationMultiRow_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 10;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      (recentScroll as object)['playTrailingAnimationMultiRow']();
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_playTrailingAnimationSingleRow_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 10;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      (recentScroll as object)['playTrailingAnimationSingleRow']();
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_setTrailingTranslateXIfNeeded_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 10;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      (recentScroll as object)['setTrailingTranslateXIfNeeded'](totalContainerSessionList[0]);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_setTrailingTranslateXIfNeeded_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.autoCenterColumn = 10;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      (recentScroll as object)['setTrailingTranslateXIfNeeded'](undefined);
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_requestFocusForSession_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentScroll.requestFocusForSession();
      expect(recentScroll.isInterruptFling).assertEqual(false);
    })

    it('RecentScroll_test_isInScrollFling_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentScroll as object)['autoCenteredOffsetX']  = -1;
      recentScroll.isInScrollFling();
      expect(recentScroll).not().assertUndefined();
    })

    it('RecentScroll_test_isInScrollFling_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentScroll as object)['autoCenteredOffsetX']  = 100;
      (recentScroll as object)['scrollWidth']  = 0;
      let mocker: MockKit = new MockKit();
      let currentOffset: Function = mocker.mockFunc(recentScroll, recentScroll.scroller.currentOffset);
      when(currentOffset)().afterReturn(0);
      mocker.ignoreMock(recentScroll, recentScroll.scroller.currentOffset);
      recentScroll.recentTaskWidth = 1000;
      recentScroll.isInScrollFling();
      expect(recentScroll).not().assertUndefined();
    })

    it('RecentScroll_test_isInScrollFling_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentScroll as object)['autoCenteredOffsetX']  = -100;
      (recentScroll as object)['scrollWidth']  = 0;
      let mocker: MockKit = new MockKit();
      let currentOffset: Function = mocker.mockFunc(recentScroll, recentScroll.scroller.currentOffset);
      when(currentOffset)().afterReturn(0);
      mocker.ignoreMock(recentScroll, recentScroll.scroller.currentOffset);
      recentScroll.recentTaskWidth = 1000;
      recentScroll.isInScrollFling();
      expect(recentScroll).not().assertUndefined();
    })

    it('RecentScroll_test_isInScrollFling_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentScroll as object)['autoCenteredOffsetX']  = 100;
      (recentScroll as object)['scrollWidth']  = 1000;
      let mocker: MockKit = new MockKit();
      let currentOffset: Function = mocker.mockFunc(recentScroll, recentScroll.scroller.currentOffset);
      when(currentOffset)().afterReturn(100);
      mocker.ignoreMock(recentScroll, recentScroll.scroller.currentOffset);
      recentScroll.recentTaskWidth = 1000;
      recentScroll.isInScrollFling();
      expect(recentScroll).not().assertUndefined();
    })
  })
}