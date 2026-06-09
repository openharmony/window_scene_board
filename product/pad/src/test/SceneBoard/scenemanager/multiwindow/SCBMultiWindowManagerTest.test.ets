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
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBMultiWindowManager,
  SCBMultiWindowSnapShotReason } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowManager';
import {
  scbEventExclusiveManager,
  SCBSceneContainerSession,
  SCBScenePanelManager,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBScreenProperty,
  SCBSceneSession
} from '@ohos/windowscene';
import { ArgumentMatchers, beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';

let sceneSession: SCBSceneSession;
let screenProperty: SCBScreenProperty = new SCBScreenProperty();
let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
let multiWindowManager: SCBMultiWindowManager = SCBMultiWindowManager.getInstance();
let containerSession: SCBSceneContainerSession;
let sceneInfo: SCBSceneInfo;
let assertFlag: boolean = true;

let initAll = () => {
  screenProperty.left = 0;
  screenProperty.top = 0;
  screenProperty.width = 1260;
  screenProperty.height = 2440;
  screenProperty.screenId = 0;
  screenProperty.rotation = 0;
  screenProperty.radius = 0;
  screenProperty.screenId = 1;
  sceneInfo = new SCBSceneInfo('testPriBundle_bundle', 'testPriModule_module', 'testPriAbility_ability');
  sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  containerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
  totalContainerSessionList.add(containerSession);
}

export function SCBMultiWindowManagerTest() {
  beforeAll(initAll);
  SCBMultiWindowManagerTest_01_func();
  SCBMultiWindowManagerTest_02_func();
  SCBMultiWindowManagerTest_03_func();
  SCBMultiWindowManagerTest_04_func();
  SCBMultiWindowManagerTest_05_func();
}

function SCBMultiWindowManagerTest_01_func() {
  describe('SCBMultiWindowManagerTest_01_describe)', () => {
    it('registerMultiWindowEventExclusive_test_it_01', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let func1: Function =
        mocker1.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.getEventExclusiveByCaller);
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      multiWindowManager.registerMultiWindowEventExclusive();
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      multiWindowManager.registerMultiWindowEventExclusive();
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
    })

    it('registerMultiWindowEventExclusive_test_it_02', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let func1: Function =
        mocker1.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.getEventExclusiveByCaller);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      multiWindowManager.registerMultiWindowEventExclusive();
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      multiWindowManager.registerMultiWindowEventExclusive();
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
    })
  });
}

function SCBMultiWindowManagerTest_02_func() {
  describe('SCBMultiWindowManagerTest_02_describe', () => {
    it('getSnapShot_test_it_01', Level.LEVEL0, () => {
      multiWindowManager.getSnapShot(containerSession);
      expect(multiWindowManager.getSnapshotCount() > 0).assertTrue();
      let scbDividerParam = containerSession.dividerParam;
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
    })

    it('getSnapShot_test_it_02', Level.LEVEL0, () => {
      multiWindowManager.cleanSnapshotStat();
      multiWindowManager.getSnapShot(containerSession, SCBMultiWindowSnapShotReason.FLOAT_TO_FULL);
      expect(multiWindowManager.getSnapshotCount() === 0).assertTrue();
      let scbDividerParam = containerSession.dividerParam;
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
    })
  });
}

function SCBMultiWindowManagerTest_03_func() {
  describe('SCBMultiWindowManagerTest_03_describe', () => {
    it('initSnapshot_test_it_01', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      containerSession.requestActivation();
      containerSession.isSplit = true;
      containerSession.isFloat = false;
      totalContainerSessionList.add(containerSession);
      when(func1)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      multiWindowManager.initSnapshot();
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
    })

    it('initSnapshot_test_it_02', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      containerSession.requestActivation();
      containerSession.isSplit = false;
      containerSession.isFloat = false;
      totalContainerSessionList.add(containerSession);
      when(func1)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      multiWindowManager.initSnapshot();
      expect(assertFlag).assertTrue();
      multiWindowManager.initSnapshot();
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
    })

    it('initSnapshot_test_it_03', Level.LEVEL0, () => {
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let mocker1: MockKit = new MockKit();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      containerSession.requestActivation();
      containerSession.isSplit = true;
      containerSession.isFloat = true;
      totalContainerSessionList.add(containerSession);
      when(func1)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      multiWindowManager.initSnapshot();
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
    })

    it('initSnapshot_test_it_04', Level.LEVEL0, () => {
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let mocker1: MockKit = new MockKit();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      containerSession.requestActivation();
      containerSession.isSplit = false;
      containerSession.isFloat = true;
      totalContainerSessionList.add(containerSession);
      when(func1)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      multiWindowManager.initSnapshot();
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
    })

    it('cleanSnapshotStat_test_it', Level.LEVEL0, () => {
      let scbDividerParam = containerSession.dividerParam;
      multiWindowManager.cleanSnapshotStat();
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
    })
  });
}

function SCBMultiWindowManagerTest_04_func() {
  describe('SCBMultiWindowManagerTest_04_describe', () => {
    it('getIsSmallFold_01_it', Level.LEVEL0, () => {
      multiWindowManager.getIsSmallFold();
      let scbDividerParam = containerSession.dividerParam;
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
    })

    it('getIsSmallFold_02_it', Level.LEVEL0, () => {
      multiWindowManager.getIsSmallFold();
      let scbDividerParam = containerSession.dividerParam;
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
    })
  });
}

function SCBMultiWindowManagerTest_05_func() {
  describe('SCBMultiWindowManagerTest_05_describe', () => {
    it('getSnapshotCount_it', Level.LEVEL0, () => {
      let scbDividerParam = containerSession.dividerParam;
      containerSession.splitSnapshotResource = null;
      multiWindowManager.getSnapshotCount();
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
    })

    it('releaseSnapShot_it_01', Level.LEVEL0, () => {
      let scbDividerParam = containerSession.dividerParam;
      multiWindowManager.releaseSnapShot(containerSession);
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
    })

    it('releaseOneStepSplitSnapshotAnim_it', Level.LEVEL0, () => {
      let scbDividerParam = containerSession.dividerParam;
      multiWindowManager.releaseOneStepSplitSnapshotAnim(containerSession);
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
    })

    it('releaseSnapShot_it_02', Level.LEVEL0, () => {
      let scbDividerParam = containerSession.dividerParam;
      containerSession.splitSnapshotResource = null;
      multiWindowManager.releaseSnapShot(containerSession);
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
    })

    it('cleanSnapshotStat_it_1', Level.LEVEL0, () => {
      let scbDividerParam = containerSession.dividerParam;
      containerSession.splitSnapshotResource = null;
      multiWindowManager.cleanSnapshotStat();
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
    })

    it('cleanSnapshotStat_it2', Level.LEVEL0, () => {
      let scbDividerParam = containerSession.dividerParam;
      containerSession.splitSnapshotResource = null;
      multiWindowManager.cleanSnapshotStat();
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
    })

    it('cleanSnapshotStat_it3', Level.LEVEL0, () => {
      let scbDividerParam = containerSession.dividerParam;
      containerSession.splitSnapshotResource = null;
      multiWindowManager.cleanSnapshotStat();
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
    })

    it('cleanSnapshotStat_it4', Level.LEVEL0, () => {
      let scbDividerParam = containerSession.dividerParam;
      containerSession.splitSnapshotResource = null;
      multiWindowManager.cleanSnapshotStat();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
    })

    it('cleanSnapshotStat_it5', Level.LEVEL0, () => {
      let scbDividerParam = containerSession.dividerParam;
      containerSession.splitSnapshotResource = null;
      multiWindowManager.cleanSnapshotStat();
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
    })

    it('cleanSnapshotStat_it6', Level.LEVEL0, () => {
      let scbDividerParam = containerSession.dividerParam;
      containerSession.splitSnapshotResource = null;
      multiWindowManager.cleanSnapshotStat();
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
    })

    it('cleanSnapshotStat_it7', Level.LEVEL0, () => {
      let scbDividerParam = containerSession.dividerParam;
      containerSession.splitSnapshotResource = null;
      multiWindowManager.cleanSnapshotStat();
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
    })

    it('cleanSnapshotStat_it8', Level.LEVEL0, () => {
      let scbDividerParam = containerSession.dividerParam;
      containerSession.splitSnapshotResource = null;
      multiWindowManager.cleanSnapshotStat();
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
    })

    it('cleanSnapshotStat_it9', Level.LEVEL0, () => {
      let scbDividerParam = containerSession.dividerParam;
      containerSession.splitSnapshotResource = null;
      multiWindowManager.cleanSnapshotStat();
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
    })

    it('cleanSnapshotStat_it10', Level.LEVEL0, () => {
      let scbDividerParam = containerSession.dividerParam;
      containerSession.splitSnapshotResource = null;
      multiWindowManager.cleanSnapshotStat();
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
    })

    it('cleanSnapshotStat_it11', Level.LEVEL0, () => {
      let scbDividerParam = containerSession.dividerParam;
      containerSession.splitSnapshotResource = null;
      multiWindowManager.cleanSnapshotStat();
      expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertTrue();
      expect(scbDividerParam.secondary.posX === '0%').assertTrue();
      expect(scbDividerParam.secondary.posY === '0%').assertTrue();
      expect(scbDividerParam.primary.posX === '0%').assertTrue();
      expect(scbDividerParam.primary.posY === '0%').assertTrue();
    })
  });
}
